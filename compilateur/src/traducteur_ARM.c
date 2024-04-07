#include <malloc.h>
#include <string.h>
#include <stdbool.h>
#include "error_memory.h"
#include "traducteur_ARM.h"
#include "variable_manager.h"
#include "instruction_set.h"

#define GET_VAR_OR_POP_TMP(a) (a == NULL ? temp_pop() : var_get(a))
#define GET_VAR_OR_PUSH_TMP(a) (a == NULL ? temp_push() : var_get(a))

/*
 * Instruction // Opération assembleur
 */

address inst_count = 0;
char *tab_instruct[2048];
short deja_print = 0;

void add_instruction(char *a) {
    tab_instruct[inst_count] = a;
    inst_count++;
}

char *get_instruction(int nb) {
    return tab_instruct[nb];
}

void modify_instruction(char *a, int nb) {
    char *b = tab_instruct[nb];
    tab_instruct[nb] = printf_alloc("%s%s", a, b);
    free(a);
    free(b);
}

void print_instruction() {
    for (int index = deja_print; index < inst_count; index++)
        printf("%s", tab_instruct[index]);

    deja_print = inst_count;
}

void display(label a) {
    add_instruction(op_i(inst_count, op_display, a));
}

void number_copy(label result, int a) {
    add_instruction(op_oc(inst_count, op_define, result, a));
}

void number_define(label result, int a) {
    var_create(result);
    number_copy(result, a);
}

void var_copy(label result, label a) {
    add_instruction(op_oi(inst_count, op_copy, result, a));
}

void var_define(label result, label a) {
    var_create(result);
    var_copy(result, a);
}

void add(label a, label b) {
    add_instruction(op_oii(inst_count, op_add, NULL, a, b));
}

void subtract(label a, label b) {
    add_instruction(op_oii(inst_count, op_subtract, NULL, a, b));
}

void multiply(label a, label b) {
    add_instruction(op_oii(inst_count, op_multiply, NULL, a, b));
}

void divide(label a, label b) {
    add_instruction(op_oii(inst_count, op_divide, NULL, a, b));
}

void logical_and(label a, label b) {
    add_instruction(op_oii(inst_count, op_logical_and, NULL, a, b));
}

void logical_or(label a, label b) {
    add_instruction(op_oii(inst_count, op_logical_or, NULL, a, b));
}

void greater_than(label a, label b) {
    add_instruction(op_oii(inst_count, op_greater_than, NULL, a, b));
}

void lower_than(label a, label b) {
    add_instruction(op_oii(inst_count, op_lower_than, NULL, a, b));
}

void equal_to(label a, label b) {
    add_instruction(op_oii(inst_count, op_equal_to, NULL, a, b));
}

/*
 * branch loop
 */
#define MAX_BRANCH 10

typedef struct {
    address index;
    label cond;
    bool padding;
} branch;

branch branch_section[MAX_BRANCH];
address branch_index = 0;

label st(label c) {
    return printf_alloc("$%02X", GET_VAR_OR_POP_TMP(c));
}

void start_branch(label c, bool p) {
    if (branch_index >= MAX_BRANCH) yyerror("Maximum depth of branch exceeded.");
    add_visibility();
    if (p) add_instruction(printf_alloc(""));
    branch_section[branch_index].index = inst_count - 1;
    branch_section[branch_index].cond = c;
    branch_section[branch_index].padding = p;
    branch_index++;
}

void end_branch() {
    branch_index--;
    branch b = branch_section[branch_index];
    if (!b.padding)
        add_instruction(op_c(inst_count, op_jump, b.index));
    else if (b.cond == NULL)
        modify_instruction(op_c(b.index, op_jump, inst_count - 1), b.index);
    else
        modify_instruction(op_ic(b.index, op_conditional_jump, b.cond, inst_count), b.index);
    remove_visibility();
}

void start_if(label c) {
    start_branch(st(c), true);
}

void start_else() {
    start_branch(NULL, true);
}

void start_loop(){
    start_branch(NULL, false);
}

/*
 * Fonction
 */

typedef struct {
    int index;
    int fun;
} function;

function *tab_fnc[20];
int nb_fun = -1;

void start_function(char *a) {
    print_instruction(); // a enlever pour affiche d'un seul block

    //printf("\n %s:\n", a);
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
    //printf("\n");
}

void go_function(char *a) {
    int index = nb_fun;
    int function_index = var_get_force(a);
    if (function_index == -1) yyerror("la fonction a pas était declarée");

    while (index >= 0 && tab_fnc[index]->index != function_index) {
        index--;
    }

    //TO DO: si on a une fonction qui en appelle une qui en appelle une autre on fait comment
    op_oi(inst_count, op_copy, NULL, a);

    add_instruction(op_c(inst_count, op_jump, tab_fnc[index]->fun));
    add_instruction(copy_alloc(a));
}

int buffer_col = 0;
char hint_buffer[256];

void add_hint(char *hint, int length, int line) {
    if (hint[0] == '\n') {
        if (inst_count == 0)
            printf("//%3d: %s\n", line, hint_buffer);
        else {
            char *old = tab_instruct[inst_count - 1];
            tab_instruct[inst_count - 1] = printf_alloc("%s//%3d: %s\n", old, line, hint_buffer);
            free(old);
        }
        buffer_col = 0;
        hint_buffer[0] = '\0';
    } else {
        int old = buffer_col;
        buffer_col += length;
        if (buffer_col < 256)
            strncpy(hint_buffer + old, hint, length + 1);
    }
}
