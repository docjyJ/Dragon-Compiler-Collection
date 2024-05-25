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
    int a = 1;
    int b = 9;
    a = compute(a, 2);
    print(a);
    print(b);

}
