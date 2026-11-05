#ifdef BOND_CLASS
BondStyle(stretching,BondStretching);
#else

#ifndef LMP_BOND_STRETCHING_H
#define LMP_BOND_STRETCHING_H

#include "bond.h"

namespace LAMMPS_NS {

class BondStretching : public Bond {
 public:
  BondStretching(class LAMMPS *);
  ~BondStretching() override;
  void compute(int, int) override;
  void coeff(int, char **) override;
  double equilibrium_distance(int) override;
  void write_restart(FILE *) override;
  void read_restart(FILE *) override;
  double single(int, double, int, int, double &) override;

 protected:
  double *k, *r0, **fs, **lo, **hi, *buff;
  void allocate();
};

}

#endif
#endif
