#include "instruction_set.h"
#include "memory.h"
#include "stack.function.h"
#include "stack.variable.h"

typedef struct {
    int index;
    int fun;
} function;

function *tab_fnc[MAX_FUNCTION];
int nb_fun = -1;

void start_function(char *a) {
    //print_instruction(); // a enlever pour affiche d'un seul block

    //printf("\n %s:\n", a);
    var_create(a);

    add_visibility();
    nb_fun++;
    tab_fnc[nb_fun] = empty_alloc(sizeof(function));
    tab_fnc[nb_fun]->index = var_get(a);
    //tab_fnc[nb_fun]->fun = get_instruction_count();

}

void end_function() {
    remove_visibility();
    jump(255);

    //print_instruction(); // a enlever pour affiche d'un seul block
    //printf("\n");
}

void go_function(char *a) {
    int index = nb_fun;
    int function_index = var_get(a);

    while (index >= 0 && tab_fnc[index]->index != function_index) {
        index--;
    }

    //TODO: si on a une fonction qui en appelle une qui en appelle une autre on fait comment
    //op_oi(get_instruction_count(), op_copy, NULL, a);

    //add_instruction(op_c(get_instruction_count(), op_jump, tab_fnc[index]->fun));
    //add_instruction(copy_alloc(a));
}
