#include<unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "grammar.tab.h"

int main(int argc, char **argv) {
    int c;
    while ((c = getopt(argc, argv, "ho:")) != -1) {
        switch (c) {
            case 'h':
                printf("Usage: %s [-h] [-o output] [file]\n", argv[0]);
                exit(0);
            case 'o':
                freopen(optarg, "w", stdout);
                break;
            case '?':
                fprintf(stderr, "error: unknown option '-%c'.\n", optopt);
                exit(1);
            default:
                abort();
        }
    }
    if (optind < argc) {
        freopen(argv[optind], "r", stdin);
    }
    return yyparse();
}
