#include <stdio.h>
#include <stdlib.h>

#include "traducteur_ARM.h"
#include "table_symbole.h"

void yyerror(char *);

short nb_inst = -1;
char *tab_instruct[2048];

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
    tab_instruct[nb] = a;
}

void print_instruction() {
    for (int index = 0; index <= nb_inst; index++)
        printf("%s", tab_instruct[index]);
}

void end_fun() {
    printf("\n");
    remove_priority();
    print_instruction();
}

void fun(char *name) {
    printf("%s:\n", name);
    add_priority();
}

int get_var_address(char *a) {
    short addr = get_var(a);
    if (addr == -1) yyerror("la var est pas init");
    return addr;
}

void set_new_address(char *a) {
    short addr = get_var(a);
    if (addr != -1) yyerror("la var est déjà init");
    set_var(a);
}

int get_addr_tmp_if_null(char *a) {
    if (a != NULL)
        return get_var_address(a);
    return temp_var_pop();
}

void op_two(char *name, int a, int ret) {
    char *instruct = malloc(20);
    sprintf(instruct, "%02X#  %3s  @%02X  @%02X\n", (nb_inst + 1) & 0xFF, name, ret, a);

    add_instruction(instruct);
}

void op_three(char *name, int a, int b, int ret) {
    char *instruct = malloc(25);
    sprintf(instruct, "%02X#  %3s  @%02X  @%02X  @%02X\n", (nb_inst + 1) & 0xFF, name, ret, a, b);

    add_instruction(instruct);
}

void affectation(char *a, int b) {
    int addr = (a == NULL) ? temp_var_push() : get_var_address(a);

    char *instruct = malloc(20);
    sprintf(instruct, "%02X#  AFC  @%02X  %3d\n", (nb_inst + 1) & 0xFF, addr, b);

    add_instruction(instruct);
}

void define_affectation(char *a, int b) {
    set_new_address(a);
    affectation(a, b);
}

void copie(char *a, char *b) {
    op_two("COP", get_addr_tmp_if_null(b), get_var_address(a));
}

void print_int(char *a) {
    char *instruct = malloc(15);
    sprintf(instruct, "%02X#  PRI  @%02X\n", (nb_inst + 1) & 0xFF, get_var_address(a));

    add_instruction(instruct);
}

void define_copie(char *a, char *b) {
    set_new_address(a);
    copie(a, b);
}

void add(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("ADD",add_a, add_b, add_c);
}

void sous(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("SUB",add_a, add_b, add_c);
}

void mul(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("MUL",add_a, add_b, add_c);
}

void divide(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("DIV",add_a, add_b, add_c);
}

void and(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("AND",add_a, add_b, add_c);
}

void or(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("OR",add_a, add_b, add_c);
}

void inf(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("INF",add_a, add_b, add_c);
}

void sup(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("SUP",add_a, add_b, add_c);
}

void equ(char *a, char *b) {
    int add_a = get_addr_tmp_if_null(a);
    int add_b = get_addr_tmp_if_null(b);
    int add_c = temp_var_push();
    op_three("EQU",add_a, add_b, add_c);
}

void start_jump(char *a) {
    nb_start_section++;

    char *b = malloc(3);
    sprintf(b, "%02X", get_addr_tmp_if_null(a));

    add_instruction(b);
    start_section[nb_start_section] = nb_inst;
}

void end_jump() {
    char *a;
    char *b = get_instruction(start_section[nb_start_section]);

    if (b == NULL) {
        a = malloc(15);
        sprintf(a, "%02X#  JMP  %3d\n", start_section[nb_start_section], (nb_inst + 1) & 0xFF);
    } else {
        a = malloc(20);
        sprintf(a, "%02X#  JMF  @%s  %3d\n", start_section[nb_start_section], b, (nb_inst + 1) & 0xFF);
    }
    free(b);

    modify_instruction(a, start_section[nb_start_section]);
    nb_start_section--;
}


void start_jump_reverse() {
    nb_start_reverse_section++;
    start_reverse_section[nb_start_reverse_section] = nb_inst;
}

void end_jump_reverse(char *b) {
    char *a;

    if (b == NULL) {
        a = malloc(15);
        sprintf(a, "%02X#  JMP  %3d\n", (nb_inst + 1) & 0xFF, start_reverse_section[nb_start_reverse_section]);
    } else {
        a = malloc(20);
        sprintf(a, "%02X#  JMF  @%s  %3d\n", (nb_inst + 1) & 0xFF, b, start_reverse_section[nb_start_reverse_section]);
    }

    add_instruction(a);
    nb_start_reverse_section--;
}
