#include "dragon.h"

void main() {
    int a[3];
    a[0] = 9;
    a[1] = 5;
    a[2] = 1;
    print(ioleast, a[0]);

    int *p = a;
    print(ioleast, p[0]);
    print(ioleast, p[1]);
    print(ioleast, p[2]);

    int **p2 = &p;
    print(ioleast, **p2);
}
