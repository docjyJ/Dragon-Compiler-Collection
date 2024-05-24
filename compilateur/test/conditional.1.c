#include "dragon.h"

void main() {
    int a = 55, b = 4;

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
