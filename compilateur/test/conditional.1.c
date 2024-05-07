#include "dragon.h"

void main() {
    int a = 55, b = 4;

    print(1);
    if (a + b == 59) {
        print(1);
    } else {
        print(0);
    }

    print(2);
    if (a - b == 50)
        print(0);
    else
        print(2);

    print(3);
    if (1) print(3);
    if (0) print(0);

    if (1) print(4);
    a = 4;
    print(a);
    int i = 0;

    print(0xFF);

    while (i < 10) {
        print(i);
        i = i + 1;
    }

    do {
        print(i);
        i = i - 1;
    } while (i > 0);
}
