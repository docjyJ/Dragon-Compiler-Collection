#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "instruction_set.h"
#include "memory.h"
#include "stack.function.h"
#include "stack.variable.h"
#include "stack.instruction.h"

typedef struct {
    address debut_pile_function;
    int index;
    int nb_param;
    int fun;
} function;

function *tab_fnc[MAX_FUNCTION];

int nb_fun = -1;
int indexGoFun;
int offsetGoFun;
int nb_param;
int start_go;


void start_function(char *a) {

    if (!strcmp(a, "main")){
        jump_before(0,get_instruction_count()-1);
        var_create("$");
    }

    var_create(a);
    add_visibility();

    nb_fun++;
    tab_fnc[nb_fun] = empty_alloc(sizeof(function));
    tab_fnc[nb_fun]->index = var_get(a).value;
    tab_fnc[nb_fun]->nb_param = 0;
    tab_fnc[nb_fun]->fun = get_instruction_count();
    tab_fnc[nb_fun]->debut_pile_function = nb_declaration();

}

void add_param(char *a) {
    var_create(a);
    tab_fnc[nb_fun]->nb_param++;
}


void end_function() {
    remove_visibility();
    jump_mem("$");
}

void go_function(char *a) {
    indexGoFun = nb_fun;
    int function_index = var_get(a).value;

    while (indexGoFun >= 0 && tab_fnc[indexGoFun]->index != function_index) {
        indexGoFun--;
    }

    offsetGoFun = nb_declaration() - tab_fnc[nb_fun]->debut_pile_function;

    start_go = get_instruction_count();
    nop();
    nop();
    nop();
    nop();

    alloc_stack(offsetGoFun);
    nb_param = 0;

}

void end_go_function() {

    jump(tab_fnc[indexGoFun]->fun-1);
    number_copy_after("$", get_instruction_count()-1 , start_go);

    free_stack(offsetGoFun);

    var_copy("$", NULL);

    if (nb_param != tab_fnc[indexGoFun]->nb_param) {
        yyerror("Wrong number of parameters");
    }

}

void give_param(char *a) {

    var_copy_address_local(nb_param,a);
    nb_param++;
}

void return_var(char *a) {
    return_label(NULL, a);
    jump_mem("$");
}
