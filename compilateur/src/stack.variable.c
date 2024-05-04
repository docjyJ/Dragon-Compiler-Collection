#include <malloc.h>
#include <string.h>
#include "memory.h"
#include "stack.variable.h"

typedef struct {
    char *nom;
    address visibility;
} symbole;

symbole *var_stak[MAX_ADDRESS];

address var_head = 0;
address visibility = 0;
address var_tmp_head = -1;
address offset_function = 0;

address nb_declaration() {
    return var_head;
}

int find_var(label name, address *out) {
    int i;
    if (strlen(name) == 0)
        i = -1;
    else if (name[0] == '%')
        i = 0;
    else if (name[0] == '$')
        i = (int) parse_number(name + 1, 16);
    else
        for (i = var_head - 1; i >= 0 && (var_stak[i]->nom == NULL || strcmp(var_stak[i]->nom, name) != 0); i--);

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

void tab_alloc(address length) { //TODO: implement
    yyerror(printf_alloc("PAS IMPLEMENTER %d", length));

    address add = var_head;

    for (; var_head < (add + length); var_head++) {
        var_stak[var_head] = empty_alloc(sizeof(symbole));
        var_stak[var_head]->nom = NULL;
        var_stak[var_head]->visibility = visibility;
    }
}

memory_address var_get(label name) {
    address add;
    memory_address out;

    if (!find_var(name, &add))
        yyerror(printf_alloc("<%s> does not exist", name));

    out.value = add;
    if (name[0] != '$' && var_stak[add]->visibility != 0) {
        out.value -= offset_function;
        out.isLocal = 1;
    } else {
        out.isLocal = 0;
    }

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

memory_address var_get_or_temp_push(label name) {
    if (name != NULL)
        return var_get(name);

    memory_address out = {temp_push(), 0};
    return out;
}

memory_address var_get_or_temp_pop(label name) {
    if (name != NULL)
        return var_get(name);

    memory_address out = {temp_pop(), 0};
    return out;

}

void add_visibility() {
    if (visibility == 255) yyerror("can't add visibility level");
    if (visibility == 0) offset_function = var_head;
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
