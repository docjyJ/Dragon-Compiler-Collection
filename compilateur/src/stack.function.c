#include <stddef.h>
#include <stdio.h>
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

void start_function(char *a) {

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
}

void go_function(char *a) {
    indexGoFun = nb_fun;
    int function_index = var_get(a).value;

    while (indexGoFun >= 0 && tab_fnc[indexGoFun]->index != function_index) {
        indexGoFun--;
    }

    offsetGoFun = nb_declaration() - tab_fnc[nb_fun]->debut_pile_function;

    number_copy(NULL, offsetGoFun);
    add("%", "%", NULL);
    nb_param = 0;

}

void end_go_function() {
    number_copy(NULL, get_instruction_count() + 1);
    jump(tab_fnc[indexGoFun]->fun);

    number_copy(NULL, offsetGoFun);
    subtract("%", "%", NULL);

    if (nb_param != tab_fnc[indexGoFun]->nb_param) {
        yyerror("Wrong number of parameters");
    }

    //TODO : faire que les returns puissent fonctionner (concidere les fonctions comme des variables dans le yaac)
}

void give_param(char *a) {
    nb_param++;
    // TODO :  arriver à passer les paramètres dans la pile
}

void return_var(char *a) {
    // TODO :  mettre le return dans une var temp
}
