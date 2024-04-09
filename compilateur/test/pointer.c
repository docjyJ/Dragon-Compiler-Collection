#include "dragon.h"

void main() {
    int a[5];
    a[0] = 0;
    a[1] = 1;
    a[2] = 2;
    a[3] = 3;
    a[4] = 4;

    int *p = a;
    print(p[0]);
    print(p[1]);
    print(p[2]);
    print(p[3]);
    print(p[4]);
    int **p2 = &p;
    print(**p2);
}