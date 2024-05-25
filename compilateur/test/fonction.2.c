#include "dragon.h"


int factoriel(int a){
    int c;

    if (a > 0){
        c = factoriel(a-1) * a;
    }else {
        c = 1;
    }

    return c;
}


void main(void) {
    int a = 1;

    a = factoriel (2);
    print(a);
}
