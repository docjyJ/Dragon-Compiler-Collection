#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "instruction_set.h"
#include "memory.h"
#include "stack.function.h"
#include "stack.instruction.h"
#include "stack.var_global.h"
#include "stack.variable.h"

typedef struct {
    address debut_pile_function;
    char *name;
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
    start_first_function(); // on l'appel avant au cas ou main est la première fonction

    if (!strcmp(a, "main")) {
        main_nb_inst(get_instruction_count());
    }

    var_create_global(a);
    add_visibility();

    nb_fun++;
    tab_fnc[nb_fun] = empty_alloc(sizeof(function));
    tab_fnc[nb_fun]->name = a;
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

    while (indexGoFun >= 1 && strcmp(a, tab_fnc[indexGoFun]->name)) {
        indexGoFun--;
    }
    if (strcmp(a, tab_fnc[0]->name)) {
        indexGoFun = 0;
    } else if (strcmp(a, tab_fnc[indexGoFun]->name)) {
        yyerror("Unknow function");
    }

    add_hint("copie dans NULL de $\n");
    var_copy(NULL, "$");
    add_hint("fin de la copie\n");

    offsetGoFun = nb_declaration() - tab_fnc[nb_fun]->debut_pile_function;

    start_go = get_instruction_count();
    padding_for_later_jump();
    padding_for_later_jump();
    padding_for_later_jump();
    padding_for_later_jump();

    nb_param = 0;
}

void end_go_function() {

    for (int index = 0; index < nb_param; index++) {
        temp_pop();
    } // on désempile les protection des paramètre avant de changer RS

    alloc_stack(offsetGoFun);
    add_hint("jum pour aller à la fonction ");

    jump(tab_fnc[indexGoFun]->fun);
    number_copy_after("$", get_instruction_count(), start_go);

    free_stack(offsetGoFun);

    add_hint("echanger de $ et du return ");
    temp_push(); // sert à modéliser le return potentiel
    switch_tmp();

    add_hint("copie dans $ de NULL");
    var_copy("$", NULL);

    if (nb_param != tab_fnc[indexGoFun]->nb_param) {
        yyerror("Wrong number of parameters");
    }
}

void give_param(char *a) {

    add_hint("passage de l'argument ");
    var_copy_address_local(offsetGoFun + nb_param, a);
    temp_push(); // protège l'argument des autres arguments
    add_hint("fin passage de l'argument ");
    nb_param++;
}

void return_var(char *a) {
    add_hint("passage de la valeur de retour ");
    return_label(a);
    jump_mem("$");
}
