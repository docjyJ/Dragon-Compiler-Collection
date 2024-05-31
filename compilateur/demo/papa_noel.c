#include "dragon.h"

void main() {
    int num = 0;
    while (1) {
        if (num == 0) {
            num = 1;
        }
        int a = 0x10;
        while (a) {
            a = a - 1;
            int b = 0x10;
            while (b) {
                b = b - 1;
                int c = 0x10;
                while (c) {
                    c = c - 1;
                }
            }
        }
        print(ioleast, num);
        print(ioleast, num);
        num = num * 2;
    }
}
