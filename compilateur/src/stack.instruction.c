#include <malloc.h>
#include "memory.h"
#include "stack.instruction.h"

address inst_count = 0;
inst real_tab_instruct[MAX_ADDRESS + 1];
inst *tab_instruct = real_tab_instruct + 1;
short deja_print = 0;

void add_instruction(inst line) {
    tab_instruct[inst_count] = line;
    inst_count++;
}

void set_instruction(inst line, address index) {
    inst b = tab_instruct[index];
    tab_instruct[index] = printf_alloc("%s%s", line, b);
    free(line);
    free(b);
}

void print_instruction() { // TODO Free
    for (int index = deja_print; index < inst_count; index++)
        printf("%s", tab_instruct[index]);

    deja_print = inst_count;
}

address get_instruction_count() {
    return inst_count;
}

void add_hint(char *hint) {
    inst old = tab_instruct[inst_count - 1];
    tab_instruct[inst_count - 1] = printf_alloc("%s%s", old, hint);
    free(old);
}