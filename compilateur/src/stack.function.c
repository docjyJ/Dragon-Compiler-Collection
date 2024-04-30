#include "instruction_set.h"
#include "memory.h"
#include "stack.function.h"
#include "stack.variable.h"

typedef struct {
    address debut_pile_function;
    int index;
    int fun;
} function;

function *tab_fnc[MAX_FUNCTION];
int nb_fun = -1;

void start_function(char *a) {

    var_create(a);
    add_visibility();

    nb_fun++;
    tab_fnc[nb_fun] = empty_alloc(sizeof(function));
    tab_fnc[nb_fun]->index = var_get(a);
    tab_fnc[nb_fun]->fun = get_instruction_count();
    tab_fnc[nb_fun]->debut_pile_function = nb_declaration();

}

void end_function() {
    remove_visibility();
    jump(temp_pop());

}

void go_function(char *a) {
    int index = nb_fun;
    int function_index = var_get(a);

    while (index >= 0 && tab_fnc[index]->index != function_index) {
        index--;
    }

    int offset = nb_declaration() - tab_fnc[nb_fun]->debut_pile_function;

    number_copy(NULL, offset);
    add("%","%",NULL);

    number_copy(NULL, get_instruction_count()+1);
    jump(tab_fnc[index]->fun);

    number_copy(NULL, offset);
    sub("%","%",NULL);

}
