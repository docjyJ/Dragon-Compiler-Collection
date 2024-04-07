#include <malloc.h>
#include <string.h>
#include "error_memory.h"
#include "traducteur_ARM.h"
#include "variable_manager.h"
#include "instruction_set.h"

#define GET_VAR_OR_POP_TMP(a) (a == NULL ? temp_pop() : var_get(a))
#define GET_VAR_OR_PUSH_TMP(a) (a == NULL ? temp_push() : var_get(a))


address inst_count = 0;
char *tab_instruct[2048];
short deja_print = 0;

int start_section[10];
int nb_start_section = -1;

int start_reverse_section[10];
int nb_start_reverse_section = -1;

void add_instruction(char *a) {
    tab_instruct[inst_count] = a;
    inst_count++;
}

char *get_instruction(int nb) {
    return tab_instruct[nb];
}

void modify_instruction(char *a, int nb) {
    free(tab_instruct[nb]);
    tab_instruct[nb] = a;
}

void print_instruction() {
    for (int index = deja_print; index <= inst_count; index++)
        printf("%s", tab_instruct[index]);

    deja_print = inst_count + 1;
}

void display(label a) {
    add_instruction(op_a(inst_count, op_display, a));
}

void number_copy(label result, int a) {
    add_instruction(op_ac(inst_count, op_define, result, a));
}

void number_define(label result, int a) {
    var_create(result);
    number_copy(result, a);
}

void var_copy(label result, label a) {
    add_instruction(op_aa(inst_count, op_copy, result, a));
}

void var_define(label result, label a) {
    var_create(result);
    var_copy(result, a);
}

void add(label a, label b) {
    add_instruction(op_aaa(inst_count, op_add, NULL, a, b));
}

void subtract(label a, label b) {
    add_instruction(op_aaa(inst_count, op_subtract, NULL, a, b));
}

void multiply(label a, label b) {
    add_instruction(op_aaa(inst_count, op_multiply, NULL, a, b));
}

void divide(label a, label b) {
    add_instruction(op_aaa(inst_count, op_divide, NULL, a, b));
}

void logical_and(label a, label b) {
    add_instruction(op_aaa(inst_count, op_logical_and, NULL, a, b));
}

void logical_or(label a, label b) {
    add_instruction(op_aaa(inst_count, op_logical_or, NULL, a, b));
}

void greater_than(label a, label b) {
    add_instruction(op_aaa(inst_count, op_greater_than, NULL, a, b));
}

void lower_than(label a, label b) {
    add_instruction(op_aaa(inst_count, op_lower_than, NULL, a, b));
}

void equal_to(label a, label b) {
    add_instruction(op_aaa(inst_count, op_equal_to, NULL, a, b));
}

void start_jump() {
    add_visibility();

    nb_start_section++;

    add_instruction(NULL);
    start_section[nb_start_section] = inst_count;
}

void start_conditional_jump(label a) {
    add_visibility();

    nb_start_section++;

    add_instruction(printf_alloc("$%02X", GET_VAR_OR_POP_TMP(a)));
    start_section[nb_start_section] = inst_count;
}

void end_jump() {
    remove_visibility();

    char *a;
    char *b = get_instruction(start_section[nb_start_section]);

    if (b == NULL)
        a = op_c(start_section[nb_start_section] - 1, op_jump, inst_count - 1);
    else
        a = op_ac(start_section[nb_start_section] - 1, op_conditional_jump, b, inst_count);

    modify_instruction(a, start_section[nb_start_section]);
    nb_start_section--;
}


void start_jump_reverse() {
    add_visibility();

    nb_start_reverse_section++;
    start_reverse_section[nb_start_reverse_section] = inst_count;
}

void end_jump_reverse(label b) {
    remove_visibility();

    char *a;

    if (b == NULL)
        a = op_c(start_reverse_section[nb_start_reverse_section], op_jump, inst_count);
    else
        a = op_ac(start_reverse_section[nb_start_reverse_section], op_conditional_jump, b, inst_count);

    add_instruction(a);
    nb_start_reverse_section--;
}


typedef struct {
    int index;
    int fun;
} function;

function *tab_fnc[20];
int nb_fun = -1;

void start_function(char *a) {
    print_instruction(); // a enlever pour affiche d'un seul block

    printf("\n %s:\n", a);
    var_create_force(a);

    add_visibility();
    nb_fun++;
    tab_fnc[nb_fun] = empty_alloc(sizeof(function));
    tab_fnc[nb_fun]->index = var_get_force(a);
    tab_fnc[nb_fun]->fun = inst_count;

}

void end_function() {
    remove_visibility();
    add_instruction(op_c(inst_count, op_jump, 255));

    print_instruction(); // a enlever pour affiche d'un seul block
    printf("\n");
}

void go_function(char *a) {
    int index = nb_fun;
    int function_index = var_get_force(a);
    if (function_index == -1) yyerror("la fonction a pas était declarée");

    while (index >= 0 && tab_fnc[index]->index != function_index) {
        index--;
    }

    //TO DO: si on a une fonction qui en appelle une qui en appelle une autre on fait comment
    op_aa(inst_count, op_copy, NULL, a);

    add_instruction(op_c(inst_count, op_jump, tab_fnc[index]->fun));
    add_instruction(copy_alloc(a));
}

