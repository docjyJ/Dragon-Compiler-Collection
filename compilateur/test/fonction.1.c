#include "dragon.h"

int compute(int a , int d) {
    int  c = a + d;
    int b = a;
    while (c > 0) {
        b = b + a * 4;
        c=c-1;
    }
    return b;
}


void main(void) {
    int a = 2;
    int b;
    b = compute(a, 1);
    a = compute(1, a);
    print(ioleast, a);
    print(ioleast, b);

    b   = 5;
}
