#include "stack.var_global.h"
#include "stack.variable.h"
#include "stack.instruction.h"
#include "instruction_set.h"
#include "memory.h"

typedef struct {
    char* name;
} var_global;

var_global *tab_var[MAX_VAR_GLOBAL];
int nb_var = -1;
int main_addr;

address first_function=0xFF;

void var_create_global(char *a){
    nb_var++;

    var_create(a);

    tab_var[nb_var] = empty_alloc(sizeof(var_global));
    tab_var[nb_var] -> name = a;
}

void start_first_function (){
    if (first_function==0xFF){
        first_function = get_instruction_count();
        padding_for_later_jump();
        padding_for_later_jump();
        padding_for_later_jump();

    }
}

void main_nb_inst (address addr){
    main_addr = addr;
}

void part_var_global(){

    alloc_stack_before(first_function, nb_var+1);

    jump_before(first_function+2, main_addr);
}
