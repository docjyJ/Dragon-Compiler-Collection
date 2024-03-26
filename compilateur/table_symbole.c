#include "table_symbole.h"
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* nom;
    int priority;
} symbole;




symbole* Tab[1024]; 

int Myindex = 0;
int priority =0;

int index_temp = 1023;

void set (char* nomvar) {
    symbole* sym = malloc(sizeof (symbole));
    sym->nom = nomvar;
    sym->priority = priority;

    Tab[Myindex++]= sym;
}


int get (char* nomvar) {

    int out=Myindex-1;

    while(out >= 0 && strcmp(Tab[out]->nom,nomvar))  out --;



    return out;
}


int set_temp () {
    int a = index_temp;
    index_temp--;
    return a;
}

int get_temp () {

    index_temp++;
    return index_temp;
}



void add_priority () {
    priority++;
}

void remove_priority () {
    priority--;

    while(Tab[Myindex]->priority > priority){
        free(Tab[Myindex]);
        Tab[Myindex] = NULL;
        Myindex--;
    }
}