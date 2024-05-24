#include "dragon.h"

int zz= 1;
int b =2;

int compute(int a, int d) {
    int  c = a + d;
    b = a;
    while (c > 0) {
        b = b + a * 4;
        c=c-1;
    }
}


void main(void) {
    int a = 1;
    if (a == 3) {
        print(a);
    } else {
        print(b);
    }
}
