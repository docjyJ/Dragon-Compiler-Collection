#include "dragon.h"

// cat ./demo / swap.c | ./rapido.sh > ./demo/swap.vhd

void main() {
    while (1) {
        print(iomost, read(ioleast));
        print(ioleast, read(iomost));
    }
}

