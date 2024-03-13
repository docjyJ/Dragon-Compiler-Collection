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

void set (char* nomvar) {
    symbole* sym = malloc(sizeof (symbole));
    sym->nom = nomvar;
    sym->priority = priority;

    Tab[index++]= sym;
}


int get (char* nomvar) {

    int out=index-1;

    while(!strncmp(Tab[out]->nom,nomvar) && out !=0){
        out --;
    }

    if (!strncmp(Tab[out]->nom,nomvar)){
        out = -1;
    }

    return out;
}


void addpriority () {
    priority++;
}

void minuspriority () {
    priority--;

    while(Tab[index]->priority > priority){
        free(Tab[index]);
        Tab[index] = NULL;
        index--;
    }
}