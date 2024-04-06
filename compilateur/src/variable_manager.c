#include "variable_manager.h"
#include "error_memory.h"
#include <string.h>
#include <malloc.h>

typedef struct {
    char *nom;
    address priority;
} symbole;


symbole *tab[256];

address my_index = 0;
address visibility = 0;
address temp_stack = 0xFF;

void var_create_force(char *name) {
    tab[my_index] = empty_alloc(sizeof(symbole));
    tab[my_index]->nom = copy_alloc(name);
    tab[my_index]->priority = visibility;
    my_index++;
}

address var_create(char *a) {
    short addr = var_get_force(a);
    if (addr != -1) yyerror(printf_alloc("<%s> already exist", a));
    var_create_force(a);
    return var_get_force(a);
}

short var_get_force(char *name) {
    short out = my_index;
    out--;
    while (out >= 0 && strcmp(tab[out]->nom, name) != 0) out --;
    return out;
}

address var_get(char *a) {
    short addr = var_get_force(a);
    if (addr == -1) yyerror(printf_alloc("<%s> doesn't exist", a));
    return addr;
}


address temp_push() {
    if (temp_stack == 1) yyerror("temp_stack is full");
    return temp_stack--;
}

address temp_pop() {
    if (temp_stack == 0xFF) yyerror("temp_stack is empty");
    return ++temp_stack;
}

void add_visibility() {
    if (visibility == 255) yyerror("can't add visibility level");
    visibility++;
}

void remove_visibility() {
    if (visibility == 0) yyerror("can't remove visibility level");
    visibility--;

    while (my_index > 0 && tab[my_index-1]->priority > visibility) {
        my_index--;
        free(tab[my_index]->nom);
        free(tab[my_index]);
    }
}
