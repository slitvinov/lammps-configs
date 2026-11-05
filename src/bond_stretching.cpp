#include "bond_stretching.h"

#include "atom.h"
#include "comm.h"
#include "domain.h"
#include "error.h"
#include "force.h"
#include "memory.h"
#include "neighbor.h"
#include "update.h"

#include <cmath>
#include <cstring>

using namespace LAMMPS_NS;

static double ramp(double c, double lo, double hi, double b)
{
  if (c < lo || c > hi) return 0.0;
  if (b <= 0.0) return 1.0;
  double w = 1.0;
  if (c - lo < b) w *= (c - lo) / b;
  if (hi - c < b) w *= (hi - c) / b;
  return w;
}

BondStretching::BondStretching(LAMMPS *lmp) :
    Bond(lmp), k(nullptr), r0(nullptr), fs(nullptr), lo(nullptr), hi(nullptr), buff(nullptr)
{
}

BondStretching::~BondStretching()
{
  if (allocated) {
    memory->destroy(setflag);
    memory->destroy(k);
    memory->destroy(r0);
    memory->destroy(fs);
    memory->destroy(lo);
    memory->destroy(hi);
    memory->destroy(buff);
  }
}

void BondStretching::compute(int eflag, int vflag)
{
  ev_init(eflag, vflag);
  double **x = atom->x;
  double **f = atom->f;
  int **bondlist = neighbor->bondlist;
  int nbondlist = neighbor->nbondlist;
  int nlocal = atom->nlocal;
  int newton_bond = force->newton_bond;

  for (int n = 0; n < nbondlist; n++) {
    int i1 = bondlist[n][0];
    int i2 = bondlist[n][1];
    int type = bondlist[n][2];
    double del[3] = {x[i1][0] - x[i2][0], x[i1][1] - x[i2][1], x[i1][2] - x[i2][2]};
    double rsq = del[0] * del[0] + del[1] * del[1] + del[2] * del[2];
    double fbond = 0.0, ebond = 0.0;
    if (k[type] > 0.0) {
      double r0sq = r0[type] * r0[type];
      double rlogarg = 1.0 - rsq / r0sq;
      if (rlogarg < 0.1) {
        error->warning(FLERR, "Stretching bond too long: {} {} {} {}", update->ntimestep,
                       atom->tag[i1], atom->tag[i2], sqrt(rsq));
        if (rlogarg <= -3.0) error->one(FLERR, "Bad stretching bond");
        rlogarg = 0.1;
      }
      fbond = -k[type] / rlogarg;
      if (eflag) ebond = -0.5 * k[type] * r0sq * log(rlogarg);
    }
    double fe[3] = {0.0, 0.0, 0.0};
    double mid[3] = {x[i2][0] + 0.5 * del[0], x[i2][1] + 0.5 * del[1], x[i2][2] + 0.5 * del[2]};
    double w = 1.0;
    for (int d = 0; d < 3; d++) w *= ramp(mid[d], lo[type][d], hi[type][d], buff[type]);
    if (w > 0.0)
      for (int d = 0; d < 3; d++) {
        double s = del[d] > 0.0 ? 1.0 : (del[d] < 0.0 ? -1.0 : 0.0);
        fe[d] = s * w * fs[type][d];
      }
    if (newton_bond || i1 < nlocal)
      for (int d = 0; d < 3; d++) f[i1][d] += del[d] * fbond + fe[d];
    if (newton_bond || i2 < nlocal)
      for (int d = 0; d < 3; d++) f[i2][d] -= del[d] * fbond + fe[d];
    if (evflag) ev_tally(i1, i2, nlocal, newton_bond, ebond, fbond, del[0], del[1], del[2]);
  }
}

void BondStretching::allocate()
{
  allocated = 1;
  int n = atom->nbondtypes + 1;
  memory->create(k, n, "bond:k");
  memory->create(r0, n, "bond:r0");
  memory->create(fs, n, 3, "bond:fs");
  memory->create(lo, n, 3, "bond:lo");
  memory->create(hi, n, 3, "bond:hi");
  memory->create(buff, n, "bond:buff");
  memory->create(setflag, n, "bond:setflag");
  for (int i = 1; i < n; i++) setflag[i] = 0;
}

void BondStretching::coeff(int narg, char **arg)
{
  if (narg != 10 && narg != 12 && narg != 13)
    error->all(FLERR, "Incorrect args for bond_style stretching coefficients");
  if (!allocated) allocate();
  int ilo, ihi;
  utils::bounds(FLERR, arg[0], 1, atom->nbondtypes, ilo, ihi, error);
  int m = 1;
  double k_one = 0.0, r0_one = 1.0;
  if (narg != 10) {
    k_one = utils::numeric(FLERR, arg[m++], false, lmp);
    r0_one = utils::numeric(FLERR, arg[m++], false, lmp);
  }
  double fs_one[3], lo_one[3], hi_one[3];
  for (int d = 0; d < 3; d++) fs_one[d] = utils::numeric(FLERR, arg[m++], false, lmp);
  for (int d = 0; d < 3; d++) {
    lo_one[d] = utils::numeric(FLERR, arg[m++], false, lmp);
    hi_one[d] = utils::numeric(FLERR, arg[m++], false, lmp);
  }
  double buff_one = narg == 13 ? utils::numeric(FLERR, arg[m++], false, lmp) : 0.0;
  for (int i = ilo; i <= ihi; i++) {
    k[i] = k_one;
    r0[i] = r0_one;
    buff[i] = buff_one;
    for (int d = 0; d < 3; d++) {
      fs[i][d] = fs_one[d];
      lo[i][d] = lo_one[d];
      hi[i][d] = hi_one[d];
    }
    setflag[i] = 1;
  }
}

double BondStretching::equilibrium_distance(int i)
{
  return 0.97 * r0[i];
}

void BondStretching::write_restart(FILE *fp)
{
  int n = atom->nbondtypes + 1;
  fwrite(&k[1], sizeof(double), n - 1, fp);
  fwrite(&r0[1], sizeof(double), n - 1, fp);
  fwrite(&buff[1], sizeof(double), n - 1, fp);
  for (int i = 1; i < n; i++) {
    fwrite(fs[i], sizeof(double), 3, fp);
    fwrite(lo[i], sizeof(double), 3, fp);
    fwrite(hi[i], sizeof(double), 3, fp);
  }
}

void BondStretching::read_restart(FILE *fp)
{
  allocate();
  int n = atom->nbondtypes + 1;
  if (comm->me == 0) {
    utils::sfread(FLERR, &k[1], sizeof(double), n - 1, fp, nullptr, error);
    utils::sfread(FLERR, &r0[1], sizeof(double), n - 1, fp, nullptr, error);
    utils::sfread(FLERR, &buff[1], sizeof(double), n - 1, fp, nullptr, error);
    for (int i = 1; i < n; i++) {
      utils::sfread(FLERR, fs[i], sizeof(double), 3, fp, nullptr, error);
      utils::sfread(FLERR, lo[i], sizeof(double), 3, fp, nullptr, error);
      utils::sfread(FLERR, hi[i], sizeof(double), 3, fp, nullptr, error);
    }
  }
  MPI_Bcast(&k[1], n - 1, MPI_DOUBLE, 0, world);
  MPI_Bcast(&r0[1], n - 1, MPI_DOUBLE, 0, world);
  MPI_Bcast(&buff[1], n - 1, MPI_DOUBLE, 0, world);
  for (int i = 1; i < n; i++) {
    MPI_Bcast(fs[i], 3, MPI_DOUBLE, 0, world);
    MPI_Bcast(lo[i], 3, MPI_DOUBLE, 0, world);
    MPI_Bcast(hi[i], 3, MPI_DOUBLE, 0, world);
    setflag[i] = 1;
  }
}

double BondStretching::single(int type, double rsq, int, int, double &fforce)
{
  fforce = 0.0;
  if (k[type] <= 0.0) return 0.0;
  double r0sq = r0[type] * r0[type];
  double rlogarg = 1.0 - rsq / r0sq;
  if (rlogarg < 0.1) rlogarg = 0.1;
  fforce = -k[type] / rlogarg;
  return -0.5 * k[type] * r0sq * log(rlogarg);
}
