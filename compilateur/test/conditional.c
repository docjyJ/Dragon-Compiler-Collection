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

    int i = 0;

    print(4);
    if (i == 9) {
        print(0);
    } else if (i == 8) {
        print(0);
    } else if (i == 7) {
        print(0);
    } else if (i == 6) {
        print(0);
    } else if (i == 5) {
        print(0);
    } else if (i == 4) {
        print(0);
    } else if (i == 3) {
        print(0);
    } else if (i == 2) {
        print(0);
    } else if (i == 1) {
        print(0);
    } else {
        print(4);
    }

    print(111);

    while (i < 10) {
        print(i);
        i = i + 1;
    }

    do {
        print(i);
        i = i - 1;
    } while (i > 0);
}