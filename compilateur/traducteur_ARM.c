#include <stdio.h>
#include <stdlib.h>

#include "traducteur_ARM.h"
#include "table_symbole.h"

void yyerror(char *);



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
    tab_instruct[nb] = a;
}

void print_instruction() {
    for (int index = deja_print; index <= nb_inst; index++)
        printf("%s", tab_instruct[index]);

    deja_print = nb_inst+1;
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

void op_one(char *name, int a) {
    char *instruct = malloc(15);
    sprintf(instruct, "%02X#  %3s  @%02X\n", (nb_inst + 1) & 0xFF, name, a);

    add_instruction(instruct);
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

void jmp (int a){
    op_one("JMP",a);
}

void jms (int cond, int a){
    op_two("JMS", a, cond);
}

void start_jump(char *a) {
    add_priority();

    nb_start_section++;

    char *b = malloc(3);
    sprintf(b, "%02X", get_addr_tmp_if_null(a));

    add_instruction(b);
    start_section[nb_start_section] = nb_inst;
}

void end_jump() {
    remove_priority();

    char *a;
    char *b = get_instruction(start_section[nb_start_section]);

    if (b == NULL) {
        a = malloc(15);
        sprintf(a, "%02X#  JMP  %3d\n", start_section[nb_start_section], nb_inst & 0xFF);
    } else {
        a = malloc(20);
        sprintf(a, "%02X#  JMF  @%s  %3d\n", start_section[nb_start_section], b, nb_inst  & 0xFF);
    }
    free(b);

    modify_instruction(a, start_section[nb_start_section]);
    nb_start_section--;
}


void start_jump_reverse() {
    add_priority();

    nb_start_reverse_section++;
    start_reverse_section[nb_start_reverse_section] = nb_inst;
}

void end_jump_reverse(char *b) {
    remove_priority();

    char *a;

    if (b == NULL) {
        a = malloc(15);
        sprintf(a, "%02X#  JMP  %3d\n", (nb_inst + 1) & 0xFF, start_reverse_section[nb_start_reverse_section]);
    } else {
        a = malloc(20);

        char *c = malloc(3);
        sprintf(c, "%02X", get_addr_tmp_if_null(b));

        sprintf(a, "%02X#  JMF  @%s  %3d\n", (nb_inst + 1) & 0xFF, c, start_reverse_section[nb_start_reverse_section]);
    }

    add_instruction(a);
    nb_start_reverse_section--;
}


typedef struct {
    int index;
    int fun;
} function;

function* tab_fnc [20];
int nb_fun = -1;

void start_function (char *a) {
    print_instruction (); // a enlever pour affiche d'un seul block

    printf("\n %s:\n", a);
    set_var(a);

    add_priority();
    nb_fun ++;
    tab_fnc[nb_fun]= malloc(sizeof(function));
    tab_fnc[nb_fun]->index=get_var(a);
    tab_fnc[nb_fun]->fun=nb_inst;

}

void end_function () {
    remove_priority();
    jmp(get_buffer_lr());

    print_instruction (); // a enlever pour affiche d'un seul block
    printf("\n");
}

void go_function(char *a) {
    int index = nb_fun;
    int function_index = get_var(a);
    if (function_index==-1)  yyerror("la fonction a pas était declarée");

    while(index >=0 && tab_fnc[index]-> index!=function_index){
        index--;
    }

    //TO DO: si on a une fonction qui en appelle une qui en appelle une autre on fait comment
    op_two("COP", get_buffer_lr(), function_index);

    a = malloc(20);
    jmp( tab_fnc[index]->fun);
    add_instruction(a);
}

