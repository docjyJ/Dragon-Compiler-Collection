#include "dragon.h"

int factoriel(int a) {
    int c;
    int b = a - 1;

    if (a > 0) {

        c = factoriel(a - 1) * a;
    } else {
        c = 1;
    }

    return c;
}

void main(void) {
    int a = 1;

    a = factoriel(2);
    print(ioleast, a);
}
