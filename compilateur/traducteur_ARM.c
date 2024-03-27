#include <stdio.h>
#include "traducteur_ARM.h"
#include "table_symbole.h"

void yyerror (char *);

void end_fun() {
    printf("\n");
    remove_priority();
}

void fun(char *name) {
    printf("%s:\n", name);
    add_priority();
}

int get_var_address(char *a) {
    int addr = get_var(a);
    if(addr == -1 ) yyerror("la var est pas init");
    return addr;
}

void set_new_address(char *a) {
    int addr = get_var(a);
    if(addr != -1 ) yyerror("la var est déjà init");
    set_var(a);
    printf("         ***** %s\n", a);
}

int get_addr_tmp_if_null(char *a) {
    if (a != NULL)
        return get_var_address(a);
    return temp_var_pop();
}

void op_two(char *name, int a, int ret) {
    printf("    %3s  @%04X  @%04X\n", name, ret, a);
}

void op_three(char *name, int a, int b, int ret) {
    printf("    %3s  @%04X  @%04X  @%04X\n", name, ret, a, b);
}

void affectation(char*a, int b) {
    int addr = (a == NULL) ? temp_var_push() : get_var_address(a);
    printf("    AFC  @%04X  %5d\n", addr, b);
}

void define_affectation(char *a, int b) {
    set_new_address(a);
    affectation(a, b);
}

void copie(char *a, char *b) {
    op_two("COP", get_addr_tmp_if_null(b), get_var_address(a));
}

void define_copie(char *a, char *b) {
    set_new_address(a);
    copie(a, b);
}

void add(char *a, char *b) {
    op_three("ADD", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

void sous(char *a, char *b) {
    op_three("SUB", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

void mul(char *a, char *b) {
    op_three("MUL", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

void divide(char *a, char *b) {
    op_three("DIV", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

void and(char *a, char *b) {
    op_three("AND", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

void or(char *a, char *b) {
    op_three("OR", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), temp_var_push());
}

