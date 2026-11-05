#! /bin/bash

set -e
set -u

def=$1
n=$(awk '/monomers\/chain/{print $1}' ${def})
b=$(awk '/distance between monomers/{print $1}' ${def})
dmin=$(awk '/no distance less than/{print $1}' ${def})
seed=$(awk '/random # seed/{print $1}' ${def})
awk -v n=${n} -v b=${b} -v dmin=${dmin} -v seed=${seed} '
function walk(   i, ok, t, u, v, w, r, dx, dy, dz) {
    x[1] = 0; y[1] = 0; z[1] = 0
    for (i = 2; i <= n; i++) {
        for (t = 0; t < 1000; t++) {
            u = 2 * rand() - 1; v = 2 * rand() - 1; w = 2 * rand() - 1
            r = sqrt(u * u + v * v + w * w)
            if (r == 0 || r > 1) continue
            x[i] = x[i - 1] + b * u / r; y[i] = y[i - 1] + b * v / r; z[i] = z[i - 1] + b * w / r
            if (i < 3) break
            dx = x[i] - x[i - 2]; dy = y[i] - y[i - 2]; dz = z[i] - z[i - 2]
            if (dx * dx + dy * dy + dz * dz >= dmin * dmin) break
        }
    }
    dx = x[n] - x[1]; dy = y[n] - y[1]; dz = z[n] - z[1]
    return sqrt(dx * dx + dy * dy + dz * dz)
}
BEGIN {
    srand(seed)
    while (walk() > sqrt(n) * b) ;
    cx = cy = cz = 0
    for (i = 1; i <= n; i++) { cx += x[i] / n; cy += y[i] / n; cz += z[i] / n }
    nb = n - 1 + (n > 1 ? 1 : 0)
    printf "chain of %d beads\n\n%d atoms\n%d bonds\n\nCoords\n\n", n, n, nb
    for (i = 1; i <= n; i++) printf "%d %.10g %.10g %.10g\n", i, x[i] - cx, y[i] - cy, z[i] - cz
    printf "\nTypes\n\n"
    for (i = 1; i <= n; i++) printf "%d 1\n", i
    if (nb > 0) {
        printf "\nBonds\n\n"
        k = 0
        for (i = 1; i < n; i++) printf "%d 2 %d %d\n", ++k, i, i + 1
        printf "%d 1 1 %d\n", ++k, n
    }
}'
