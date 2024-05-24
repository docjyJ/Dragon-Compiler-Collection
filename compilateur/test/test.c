#include "dragon.h"

int zz= 1;

int compute(int a, int d) {
    int  c = a + d;
    int b = a;
    while (c > 0) {
        b = b + a * 4;
        c=c-1;
    }
    return c;
}


void main(void) {
    int a = 1;
    compute(a,2);
    print(a);

}
