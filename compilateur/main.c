#include<unistd.h>
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
int yyparse();


void yyerror(const char *msg) {
    fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
    exit(1);
}


int main(int argc, char **argv) {
    char c;
    while ((c = getopt(argc, argv, "ho:")) != -1) {
        switch (c) {
            case 'h':
                printf("Usage: %s [-h] [-o output] [file]\n", argv[0]);
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
