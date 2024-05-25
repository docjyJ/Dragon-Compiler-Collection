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
    int b = 9;
    a = compute(1, a); //todo pourquoi compute(2, 1) et compute(1, 2) donne le même résultals chez nous
    print(a);
    print(b);

}
