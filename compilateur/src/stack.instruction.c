#include <malloc.h>
#include <string.h>
#include "stack.instruction.h"
#include "error_memory.h"

address inst_count = 0;
inst tab_instruct[MAX_ADDRESS];
short deja_print = 0;

void add_instruction(inst line) {
    tab_instruct[inst_count] = line;
    inst_count++;
}

inst get_instruction(int nb) {
    return tab_instruct[nb];
}

void set_instruction(inst line, address index) {
    inst b = tab_instruct[index];
    tab_instruct[index] = printf_alloc("%s%s", line, b);
    free(line);
    free(b);
}

void print_instruction() {
    for (int index = deja_print; index < inst_count; index++)
        printf("%s", tab_instruct[index]);

    deja_print = inst_count;
}

address get_instruction_count() {
    return inst_count;
}

void add_instruction_padding() {
    add_instruction(printf_alloc("\n"));
}


int buffer_col = 0;
char hint_buffer[MAX_ADDRESS];

void add_hint(char *hint, int length, int line) {
    if (hint[0] == '\n') {
        if (inst_count == 0)
            printf("//%3d: %s\n", line, hint_buffer); // TODO not here
        else {
            inst old = tab_instruct[get_instruction_count() - 1];
            tab_instruct[get_instruction_count() - 1] = printf_alloc("%s//%3d: %s\n", old, line, hint_buffer);
            free(old);
        }
        buffer_col = 0;
        hint_buffer[0] = '\0';
    } else {
        int old = buffer_col;
        buffer_col += length;
        if (buffer_col < MAX_ADDRESS)
            strncpy(hint_buffer + old, hint, length + 1);
    }
}