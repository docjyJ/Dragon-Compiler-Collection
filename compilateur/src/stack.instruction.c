#include <malloc.h>
#include "memory.h"
#include "stack.instruction.h"

address inst_count = 0;
inst tab_instruct[MAX_ADDRESS] = {0};

void add_instruction(inst line) {
    set_instruction(line, inst_count);
    inst_count++;
}

void set_instruction(inst line, address index) {
    inst old = tab_instruct[index];
    tab_instruct[index] = line;
    tab_instruct[index].hint = old.hint;
    free(old.code);
    free(line.hint);
}

void print_instruction() {
    for (int index = 0; index < inst_count; index++) {
        write_output(tab_instruct[index]);
    }
}

address get_instruction_count() {
    return inst_count;
}

void add_hint(char hint[]) {
    printf("%s", hint);
    char *old = tab_instruct[inst_count].hint;
    tab_instruct[inst_count].hint = printf_alloc("%s%s", old == NULL ? "" : old, hint);
    free(old);
}
