#include "stack.variable.h"
#include "error_memory.h"
#include <string.h>
#include <malloc.h>

typedef struct {
    char *nom;
    address visibility;
} symbole;

symbole *var_stak[MAX_ADDRESS];

address var_head = 0;
address visibility = 0;
address var_tmp_head = -1;

int find_var(label name, address *out) {
    int i;
    if (strlen(name) == 0)
        i = -1;
    else if (name[0] == '$')
        i = (int) parse_number(name + 1, 16);
    else
        for (i = var_head - 1; i >= 0 && strcmp(var_stak[i]->nom, name) != 0; i--);

    if (i != -1) {
        if (out != NULL) *out = (address) i;
        return 1;
    } else {
        return 0;
    }
}

void var_create(label name) {
    if (var_tmp_head < var_head)
        yyerror("not enough memory");
    if (find_var(name, NULL))
        yyerror(printf_alloc("<%s> already exist", name));

    var_stak[var_head] = empty_alloc(sizeof(symbole));
    var_stak[var_head]->nom = copy_alloc(name);
    var_stak[var_head]->visibility = visibility;
    var_head++;
}

address var_get(label name) {
    address out;
    if (!find_var(name, &out))
        yyerror(printf_alloc("<%s> already exist", name));
    return out;
}


address temp_push() {
    if (var_tmp_head < var_head) yyerror("not enough memory");
    return var_tmp_head--;
}

address temp_pop() {
    if (var_tmp_head == 0xFF) yyerror("var_tmp_head is empty");
    return ++var_tmp_head;
}

address var_get_or_temp_push(label name) {
    if (name != NULL)
        return var_get(name);
    return temp_push();
}

address var_get_or_temp_pop(label name) {
    if (name != NULL)
        return var_get(name);
    return temp_pop();
}

void add_visibility() {
    if (visibility == 255) yyerror("can't add visibility level");
    visibility++;
}

void remove_visibility() {
    if (visibility == 0) yyerror("can't remove visibility level");
    visibility--;

    while (var_head > 0 && var_stak[var_head - 1]->visibility > visibility) {
        var_head--;
        free(var_stak[var_head]->nom);
        free(var_stak[var_head]);
    }
}
