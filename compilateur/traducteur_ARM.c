#include <stdio.h>
#include "traducteur_ARM.h"
#include "table_symbole.h"


void affectation (int b){
    int a = set_temp();
    fprintf(stderr, "AFC @%x %d \n", a, b);
}

void copie(char* a, char* b){
    int adda = get(a);
    int addb;

    if (b ==NULL){
        addb = get_temp();
    }else {
        addb = get (b);
    }

    if (adda==-1){
        set(a);
        adda=get(a);
    }

    fprintf(stderr, "COP @%x @%x \n", adda, addb);
}

void add (char* a, char* b){
    int adda;
    int addb;
    int addc = set_temp();

    if (a ==NULL){
        adda = get_temp();
    }else {
        adda = get (a);
    }

    if (b ==NULL){
        addb = get_temp();
    }else {
        addb = get (b);
    }



    fprintf(stderr, "ADD @%x @%x @%x \n", addc, adda, addb);

}