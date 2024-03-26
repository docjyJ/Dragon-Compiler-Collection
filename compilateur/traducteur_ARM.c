#include <stdio.h>
#include "traducteur_ARM.h"
#include "table_symbole.h"

void fun(char *name) {
    fprintf(stderr, "%s:\n", name);
}

int get_addr_tmp_if_null(char *a) {
    if (a != NULL)
        return get(a);
    else
        return get_temp();
}

int get_addr_new_if_unknow(char *a) {
    int adda = get(a);
    if (adda == -1) {
        set(a);
        adda = get(a);
    }
    return adda;
}

void op_two(char *name, int a, int ret) {
    fprintf(stderr, "    %3s  @%04X  @%04X\n", name, ret, a);
}

void op_three(char *name, int a, int b, int ret) {
    fprintf(stderr, "    %3s  @%04X  @%04X  @%04X\n", name, ret, a, b);
}

void affectation(int b) {
    int a = set_temp();
    fprintf(stderr, "    AFC  @%04X  %5d\n", a, b);
}

void copie(char *a, char *b) {
    op_two("COP", get_addr_tmp_if_null(b), get_addr_new_if_unknow(a));
}

void add(char *a, char *b) {
    op_three("ADD", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), get_temp());
}

void sous(char *a, char *b) {
    op_three("SUB", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), get_temp());
}

void mul(char *a, char *b) {
    op_three("MUL", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), get_temp());
}

//void div (char* a, char* b){
//    op_three("DIV", get_var(a), get_addr_tmp_if_null(b), get_temp());
//}

void and(char *a, char *b) {
    op_three("AND", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), get_temp());
}

void or(char *a, char *b) {
    op_three("OR", get_addr_tmp_if_null(a), get_addr_tmp_if_null(b), get_temp());
}