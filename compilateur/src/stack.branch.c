#include "instruction_set.h"
#include "stack.branch.h"
#include "stack.instruction.h"
#include "stack.variable.h"

struct b_stak {
    address padding: 1;
    address cond: 1;
    address index;
};

struct b_stak b_stak[MAX_BRANCH];
address b_id = 0;

void start_branch(struct b_stak br) {
    if (b_id >= MAX_BRANCH) yyerror("Maximum depth of branch exceeded.");
    add_visibility();
    b_stak[b_id] = br;
    b_id++;
}

void end_branch(address offset) {
    b_id--;
    struct b_stak b = b_stak[b_id];
    if (!b.padding)
        jump(b.index + 1);
    else if (!b.cond)
        jump_before(b.index, get_instruction_count());
    else
        branch_before(b.index, get_instruction_count() + 1, offset);
    remove_visibility();
}

void start_if(label cond) {
    struct b_stak br = {1, 1,
                        padding_for_later_branch(cond)};
    start_branch(br);
}

void start_else() {
    struct b_stak br = {1, 0,
                        padding_for_later_jump()};
    start_branch(br);
}

void start_loop() {
    struct b_stak br = {0, 0,
                        get_instruction_count() - 1};
    start_branch(br);
}
