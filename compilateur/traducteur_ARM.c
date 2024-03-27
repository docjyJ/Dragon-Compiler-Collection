#include <stdio.h>
#include <stdlib.h>

#include "traducteur_ARM.h"
#include "table_symbole.h"


void yyerror (char *);

int nbInstruct = -1;
char* tabInstruct[2048];

int  startSection [10];
int nbStartSection =-1 ;

void add_instruction(char* a){
    nbInstruct ++;
    tabInstruct[nbInstruct] =  a;
}

char* get_instruction(int nb){
    return tabInstruct[nb];
}

void modify_instruction(char* a, int nb){
    tabInstruct[nb]=a;
}

void print_instruction (){
    for (int index = 0; index <=nbInstruct; index ++){

         printf("%s",tabInstruct[index]);


    }
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
    char* instruct = malloc(28);
    sprintf(instruct, "#%05d    %3s  @%04X  @%04X\n", nbInstruct+1, name, ret, a);

    add_instruction(instruct);
}

void op_three(char *name, int a, int b, int ret) {
    char* instruct = malloc(32);
    sprintf(instruct, "#%05d    %3s  @%04X  @%04X  @%04X\n", nbInstruct+1, name, ret, a, b);

    add_instruction(instruct);
}

void affectation(int b) {
    int a = temp_var_push();
    char* instruct = malloc(28);
    sprintf(instruct ,"#%05d    AFC  @%04X  %5d\n", nbInstruct+1, a, b);

    add_instruction(instruct);
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

void start_jump (char* a){
    nbStartSection ++;

    char* b = malloc(4);
    sprintf(b, "%04X", get_addr_tmp_if_null(a));

    add_instruction(b);
    startSection[nbStartSection]= nbInstruct;
}

void end_jump (){
    char* a;
    char* b = get_instruction(startSection[nbStartSection]);

    if (b==NULL){
        a = malloc(21);
        sprintf(a, "#%05d    JMP  %5d\n", startSection[nbStartSection], nbInstruct+1);

    }else{
        a = malloc(28);
        sprintf(a, "#%05d    JMF  @%04s  %5d\n", startSection[nbStartSection], b, nbInstruct+1);

    }
    free(b);

    modify_instruction(a, startSection[nbStartSection]);
    nbStartSection--;
}
