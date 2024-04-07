#include "dragon.h"

void main() {
    int a = 55, b = 4;
    print(a + b);
    print(a - b);
    print(a * b);
    print(a / b);

    print(a + b - 2 + 4);
    print(a + b - (2 + 4));
    print(a + b * 2);
    print((a + b) * 2);
}