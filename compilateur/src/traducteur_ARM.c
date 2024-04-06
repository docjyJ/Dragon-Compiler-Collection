#include <malloc.h>
#include "error_memory.h"
#include "traducteur_ARM.h"
#include "variable_manager.h"

#define INST_INDEX ((nb_inst + 1) & 0xFF)

#define OP_ONE_ADDR(name, a) add_instruction(printf_alloc("%02X#  %3s  @%02X\n", INST_INDEX, name, a))
#define OP_TWO_ADDR(name, a, ret) add_instruction(printf_alloc("%02X#  %3s  @%02X  @%02X\n", INST_INDEX, name, ret, a))
#define OP_THREE_ADDR(name, a, b, ret) add_instruction(printf_alloc("%02X#  %3s  @%02X  @%02X  @%02X\n", INST_INDEX, name, ret, a, b))
#define OP_ADDR_INT(name, a, b) add_instruction(printf_alloc("%02X#  %3s  @%02X  %3d\n", INST_INDEX, name, a, b))

#define GET_VAR_OR_POP_TMP(a) (a == NULL ? temp_pop() : var_get(a))
#define GET_VAR_OR_PUSH_TMP(a) (a == NULL ? temp_push() : var_get(a))


short nb_inst = -1;
char *tab_instruct[2048];
short deja_print = 0;

int start_section[10];
int nb_start_section = -1;

int start_reverse_section[10];
int nb_start_reverse_section = -1;

void add_instruction(char *a) {
    nb_inst++;
    tab_instruct[nb_inst] = a;
}

char *get_instruction(int nb) {
    return tab_instruct[nb];
}

void modify_instruction(char *a, int nb) {
    free(tab_instruct[nb]);
    tab_instruct[nb] = a;
}

void print_instruction() {
    for (int index = deja_print; index <= nb_inst; index++)
        printf("%s", tab_instruct[index]);

    deja_print = nb_inst + 1;
}

void number_copy(char *var, int value) {
    int add_a = GET_VAR_OR_PUSH_TMP(var);
    OP_ADDR_INT("AFC", add_a, value);
}

void number_define(char *var, int value) {
    int add_a = var_create(var);
    OP_ADDR_INT("AFC", add_a, value);
}

void var_copy(char *a, char *b) {
    int add_a = var_get(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    OP_TWO_ADDR("COP", add_b, add_a);
}

void display(char *a) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    OP_ONE_ADDR("PRI", add_a);
}

void var_define(char *a, char *b) {
    int add_a = var_create(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    OP_TWO_ADDR("COP", add_b, add_a);
}

void add(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("ADD", add_a, add_b, add_c);
}

void subtract(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("SUB", add_a, add_b, add_c);
}

void multiply(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("MUL", add_a, add_b, add_c);
}

void divide(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("DIV", add_a, add_b, add_c);
}

void ligical_and(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("AND", add_a, add_b, add_c);
}

void logical_or(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("OR", add_a, add_b, add_c);
}

void greater_than(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("INF", add_a, add_b, add_c);
}

void lower_than(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("SUP", add_a, add_b, add_c);
}

void equal_to(char *a, char *b) {
    int add_a = GET_VAR_OR_POP_TMP(a);
    int add_b = GET_VAR_OR_POP_TMP(b);
    int add_c = temp_push();
    OP_THREE_ADDR("EQU", add_a, add_b, add_c);
}

char *jmp(address index, address a) {
    return printf_alloc("%02X#  JMP  %3d\n", index, a);
}

void start_jump(char *a) {
    add_visibility();

    nb_start_section++;

    add_instruction(printf_alloc("%02X", GET_VAR_OR_POP_TMP(a)));
    start_section[nb_start_section] = nb_inst;
}

void end_jump() {
    remove_visibility();

    char *a;
    char *b = get_instruction(start_section[nb_start_section]);

    if (b == NULL)
        a = jmp(start_section[nb_start_section], INST_INDEX);
    else
        a = printf_alloc("%02X#  JMF  @%s  %3d\n", start_section[nb_start_section], b, INST_INDEX);

    modify_instruction(a, start_section[nb_start_section]);
    nb_start_section--;
}


void start_jump_reverse() {
    add_visibility();

    nb_start_reverse_section++;
    start_reverse_section[nb_start_reverse_section] = nb_inst;
}

void end_jump_reverse(char *b) {
    remove_visibility();

    char *a;

    if (b == NULL)
        a = jmp(start_reverse_section[nb_start_reverse_section], INST_INDEX);
    else
        a = printf_alloc("%02X#  JMF  @%s  %3d\n", start_reverse_section[nb_start_reverse_section], b, INST_INDEX);

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
    tab_fnc[nb_fun]->fun = nb_inst;

}

void end_function() {
    remove_visibility();
    add_instruction(jmp(INST_INDEX, 255));

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
    OP_TWO_ADDR("COP", 255, function_index);

    add_instruction(jmp(INST_INDEX, tab_fnc[index]->fun));
    add_instruction(copy_alloc(a));
}

