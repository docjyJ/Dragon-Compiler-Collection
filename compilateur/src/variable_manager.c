#include "variable_manager.h"
#include "error_memory.h"
#include <string.h>
#include <malloc.h>

typedef struct {
    char *nom;
    address priority;
} symbole;


symbole *tab[256];

address var_stack = 0;
address visibility = 0;
address temp_stack = -1;

void var_create_force(char *name) {
    if (temp_stack < var_stack) yyerror("not enough memory");
    tab[var_stack] = empty_alloc(sizeof(symbole));
    tab[var_stack]->nom = copy_alloc(name);
    tab[var_stack]->priority = visibility;
    var_stack++;
}

void var_create(label a) {
    short addr = var_get_force(a);
    if (addr != -1) yyerror(printf_alloc("<%s> already exist", a));
    var_create_force(a);
}

short var_get_force(label name) {
    if (strlen(name) == 0)
        return -1;

    if (name[0] == '$')
        return (address) parse_number(name + 1, 16);

    short out = var_stack;
    out--;
    while (out >= 0 && strcmp(tab[out]->nom, name) != 0) out--;
    return out;
}

address var_get(label a) {
    short addr = var_get_force(a);
    if (addr == -1) yyerror(printf_alloc("<%s> doesn't exist", a));
    return addr;
}


address temp_push() {
    if (temp_stack < var_stack) yyerror("not enough memory");
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

    while (var_stack > 0 && tab[var_stack - 1]->priority > visibility) {
        var_stack--;
        free(tab[var_stack]->nom);
        free(tab[var_stack]);
    }
}
