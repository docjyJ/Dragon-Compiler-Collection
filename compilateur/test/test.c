#include "dragon.h"

int zz= 1;

int compute() {
    int a =1;
     int d = 2;
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
    compute();
    print(a);

}
