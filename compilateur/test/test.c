#include "dragon.h"

int compute() {
    int a =1;
    int d = 2;
    int b, c = a + d;
    b = a;
    while (c > 0) {
        b = b + a * 4;
        c=c-1;
    }
    return b;
}


void main(void) {
    int a = 1;
    int b;
    if (a == 3) {
        print(a);
    } else {
        b = compute();
        print(b);
    }
}
