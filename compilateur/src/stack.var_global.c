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

void var_create_global(char *a){

     nb_var++;

     tab_var[nb_var] = empty_alloc(sizeof(var_global));
     tab_var[nb_var] -> name = a;
}

void main_nb_inst (address addr){
    main_addr = addr;
}

void part_var_global(){
    int where = get_instruction_count();
        nop();

    jump_before(0,get_instruction_count()-1);
    alloc_stack(nb_var+1);

    for (int index = 0; index < nb_var; index++){
        var_create(tab_var[index] -> name);
    }


    jump(main_addr);
    jump_before(where,get_instruction_count()-1);
}
