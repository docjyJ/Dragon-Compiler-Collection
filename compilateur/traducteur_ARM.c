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

int get_addr_tmp_if_null(char *a) {
    if (a != NULL){
         int add = get_var(a);

         if(add == -1 ){
            yyerror("la var est pas init");
         }
         return add;
    }
    else {
         return temp_var_pop();
    }

}

int get_addr_new_if_unknown(char *a) {
    int adda = get_var(a);
    if (adda == -1) {
        set_var(a);
        adda = get_var(a);
    }
    return adda;
}

void op_two(char *name, int a, int ret) {
    printf("    %3s  @%04X  @%04X\n", name, ret, a);
}

void op_three(char *name, int a, int b, int ret) {
    printf("    %3s  @%04X  @%04X  @%04X\n", name, ret, a, b);
}

void affectation(int b) {
    int a = temp_var_push();
    printf("    AFC  @%04X  %5d\n", a, b);
}

void copie(char *a, char *b) {
    op_two("COP", get_addr_tmp_if_null(b), get_addr_new_if_unknown(a));
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

