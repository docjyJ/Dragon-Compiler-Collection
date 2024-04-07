#include <stddef.h>
#include "stack.branch.h"
#include "stack.variable.h"
#include "stack.instruction.h"
#include "error_memory.h"
#include "instruction_set.h"

#define MAX_BRANCH 10

typedef struct {
    address padding: 1;
    address index: 7;
    label cond;
} branch;

branch branch_section[MAX_BRANCH];
address branch_index = 0;

void start_branch(label cond, address padding) {
    if (branch_index >= MAX_BRANCH) yyerror("Maximum depth of branch exceeded.");
    add_visibility();
    if (padding) add_instruction_padding();
    branch_section[branch_index].index = get_instruction_count() - 1;
    branch_section[branch_index].cond = cond;
    branch_section[branch_index].padding = padding;
    branch_index++;
}

void end_branch() {
    branch_index--;
    branch b = branch_section[branch_index];
    if (!b.padding)
        add_instruction(op_c(get_instruction_count(), op_jump, b.index));
    else if (b.cond == NULL)
        set_instruction(op_c(b.index, op_jump, get_instruction_count() - 1), b.index);
    else
        set_instruction(op_ic(b.index, op_conditional_jump, b.cond, get_instruction_count()), b.index);
    remove_visibility();
}

void start_if(label cond) {
    start_branch(printf_alloc("$%02X", var_get_or_temp_pop(cond)), 1);
}

void start_else() {
    start_branch(NULL, 1);
}

void start_loop() {
    start_branch(NULL, 0);
}