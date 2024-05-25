#include "dragon.h"

void main() {
    int a[3];
    a[0] = 9;
    a[1] = 5;
    a[2] = 1;
    print(a[0]);

    int *p = a;
    print(p[0]);
    print(p[1]);
    //print(p[2]);

    int **p2 = &p;
    print(**p2);

}
