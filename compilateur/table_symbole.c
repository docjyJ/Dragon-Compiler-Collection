#include "table_symbole.h"
#include <malloc.h>
#include <string.h>

void yyerror(char *);

typedef struct {
    char *nom;
    int priority;
} symbole;


symbole *tab[256];

short my_index = -1;
int priority = 0;
short var_temp_stack_head = 256;

void set_var(char *name) {
    my_index++;
    tab[my_index] = malloc(sizeof(symbole));
    if(tab[my_index] == NULL)
        yyerror("Erreur d'allocation de mémoire");
    tab[my_index]->nom = strdup(name);
    tab[my_index]->priority = priority;
    if(tab[my_index]->nom == NULL)
        yyerror("Erreur d'allocation de mémoire");
}


short get_var(char *name) {
    short out = my_index;
    while (out >= 0 && strcmp(tab[out]->nom, name) != 0) out--;
    return out;
}


address temp_var_push() {
    var_temp_stack_head--;
    return var_temp_stack_head;
}

address temp_var_pop() {
    int a = var_temp_stack_head;
    var_temp_stack_head++;
    return a;
}


void add_priority() {
    priority++;
}

void remove_priority() {
    priority--;

    while (my_index >= 0 && tab[my_index]->priority > priority) {
        free(tab[my_index]->nom);
        free(tab[my_index]);
        my_index--;
    }
}
