#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "instruction_set.h"
#include "memory.h"
#include "stack.function.h"
#include "stack.variable.h"
#include "stack.instruction.h"
#include "stack.var_global.h"


typedef struct {
    address debut_pile_function;
    char* name;
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
        main_nb_inst(get_instruction_count());
        var_create_global("$");
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
    if ( strcmp(a, tab_fnc[0]->name)){
        indexGoFun = 0;
    }
    else if(strcmp(a, tab_fnc[indexGoFun]->name) ){
        yyerror("Unknow function");
    }

    temp_push();
    var_copy( NULL, "$");

    offsetGoFun = nb_declaration() - tab_fnc[nb_fun]->debut_pile_function;

    start_go = get_instruction_count();
    nop();
    nop();
    nop();
    nop();


    nb_param = 0;

}

void end_go_function() {
    alloc_stack(offsetGoFun);
    jump(tab_fnc[indexGoFun]->fun-1);
    number_copy_after("$", get_instruction_count()-1 , start_go);

    free_stack(offsetGoFun);

    var_copy("$", NULL);


    if (nb_param != tab_fnc[indexGoFun]->nb_param) {
        yyerror("Wrong number of parameters");
    }

}

void give_param(char *a) {
    nb_param++;

    var_copy_address_local(nb_declaration(),a);
}

void return_var(char *a) {
    return_label(NULL, a);
    jump_mem("$");
}
