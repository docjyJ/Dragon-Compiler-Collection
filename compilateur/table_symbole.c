#include "table_symbole.h"
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* nom;
    int priority;
} symbole;




symbole* Tab[1024]; 

int index = 0;
int priority =0;

int index_temp = 1023;

void set (char* nomvar) {
    symbole* sym = malloc(sizeof (symbole));
    sym->nom = nomvar;
    sym->priority = priority;

    Tab[index++]= sym;
}


int get (char* nomvar) {

    int out=index-1;

    while(out >= 0 && !strncmp(Tab[out]->nom,nomvar)) out --;

    if (out < 0 || !strncmp(Tab[out]->nom,nomvar)) out = -1;

    return out;
}


void set_temp () {
    index_temp--;
    return index_temp;
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

    while(Tab[index]->priority > priority){
        free(Tab[index]);
        Tab[index] = NULL;
        index--;
    }
}