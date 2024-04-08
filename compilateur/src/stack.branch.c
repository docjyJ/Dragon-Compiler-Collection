#include <stddef.h>
#include "instruction_set.h"
#include "memory.h"
#include "stack.branch.h"
#include "stack.instruction.h"
#include "stack.variable.h"

struct b_stak {
    address padding: 1;
    address index: 7;
    label cond;
};

struct b_stak b_stak[MAX_BRANCH];
address b_id = 0;

void start_branch(label cond, address padding) {
    if (b_id >= MAX_BRANCH) yyerror("Maximum depth of branch exceeded.");
    add_visibility();
    if (padding)
        b_stak[b_id].index = padding_for_later();
    else
        b_stak[b_id].index = get_instruction_count() - 1;
    b_stak[b_id].cond = cond;
    b_stak[b_id].padding = padding;
    b_id++;
}

void end_branch() {
    b_id--;
    struct b_stak b = b_stak[b_id];
    if (!b.padding)
        jump(b.index);
    else if (b.cond == NULL)
        jump_before(b.index, get_instruction_count() - 1);
    else
        branch_before(b.index, b.cond, get_instruction_count());
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