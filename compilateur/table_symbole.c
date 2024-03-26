#include "table_symbole.h"
#include <malloc.h>
#include <string.h>

typedef struct {
    char *nom;
    int priority;
} symbole;


symbole *tab[1024];

int my_index = 0;
int priority = 0;
int var_temp_stack_head = 1024;

void set_var(char *name) {
    tab[my_index] = malloc(sizeof(symbole));
    tab[my_index]->nom = name;
    tab[my_index]->priority = priority;
    my_index++;
}


int get_var(char *name) {
    int out = my_index - 1;
    while (out >= 0 && strcmp(tab[out]->nom, name) != 0) out--;
    return out;
}


int temp_var_push() {
    int a = var_temp_stack_head;
    var_temp_stack_head--;
    return a;
}

int temp_var_pop() {
    var_temp_stack_head++;
    return var_temp_stack_head;
}


void add_priority() {
    priority++;
}

void remove_priority() {
    priority--;

    while (tab[my_index]->priority > priority) {
        free(tab[my_index]);
        tab[my_index] = NULL;
        my_index--;
    }
}