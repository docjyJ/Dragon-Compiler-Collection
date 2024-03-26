#include <stdio.h>
#include "traducteur_ARM.h"
#include "table_symbole.h"


void affectation (int b){
    int a = set_temp();
    fprintf(stderr, "AFC @%x %d\n", a, b);
}

void copie(char* a, char* b){
    int adda = get(a);
    int addb;

     if (adda==-1){
        set(a);
        adda=get(a);
     }

    if (b == NULL) addb = get_temp();
    else addb = get(b);


    fprintf(stderr, "COP @%x @%x\n", adda, addb);
}

void _operator(char * name, char* a, char* b) {
    int adda;
    if (a == NULL) adda = get_temp();
    else adda = get(a);

    int addb;
    if (b == NULL) addb = get_temp();
    else addb = get(b);

    int addc = set_temp();

    fprintf(stderr, "%s @%x @%x @%x\n", name, addc, adda, addb);
}

void add (char* a, char* b){
    _operator("ADD", a, b);
}

void sous (char* a, char* b){
    _operator("SOU", a, b);
}

void mul (char* a, char* b){
    _operator("MUL", a, b);
}

//void div (char* a, char* b){
//    _operator("DIV", a, b);
//}

void and (char* a, char* b){
    _operator("AND", a, b);
}

void or (char* a, char* b){
    _operator("LOR", a, b);
}