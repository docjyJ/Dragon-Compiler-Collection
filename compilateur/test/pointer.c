#include "dragon.h"

void main() {
    int a = 1, b = 2, c = 3, d = 4, e = 5;
    int *p = &a;
    print(p[0]);
    print(p[1]);
    print(p[2]);
    print(p[3]);
    print(p[4]);
    int **p2 = &p;
    print(**p2);
}