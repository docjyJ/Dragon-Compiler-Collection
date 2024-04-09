#include <string.h>
#include "instruction_set.h"
#include "memory.h"
#include "stack.instruction.h"
#include "stack.variable.h"

typedef struct {
    const char *name;
    const address id;
} op_code;

const char *pattern_c = "%02X#     %3s  %3d//%02X\n";
const char *pattern_a = "%02X#     %3s  @%02X\n";
const char *pattern_ac = "%02X#     %3s  @%02X  %3d//%02X\n";
const char *pattern_aa = "%02X#     %3s  @%02X  @%02X\n";
const char *pattern_aaa = "%02X#     %3s  @%02X  @%02X  @%02X\n";
const char *hint_pattern = "//%3d: %s\n";

// Instructions données par le sujet
const op_code op_add = {"ADD", 0x01};
const op_code op_multiply = {"MUL", 0x02};
const op_code op_subtract = {"SUB", 0x03};
const op_code op_divide = {"DIV", 0x04};
const op_code op_copy = {"COP", 0x05};
const op_code op_define = {"AFC", 0x06};
const op_code op_jump = {"JMP", 0x07};
const op_code op_branch = {"JMF", 0x08};
const op_code op_lower_than = {"INF", 0x09};
const op_code op_greater_than = {"SUP", 0x0A};
const op_code op_equal_to = {"EQU", 0x0B};
const op_code op_display = {"PRI", 0x0C};

// Instruction technique
const op_code op_load = {"LOD", 0x10};
const op_code op_store = {"STR", 0x11};

// Instructions ajoutées (arithmétiques)
const op_code op_negate = {"NEG", 0x30};
const op_code op_modulo = {"MOD", 0x31};

// Instructions ajoutées (bit à bit)
const op_code op_bitwise_and = {"AND", 0x50};
const op_code op_bitwise_or = {"OR", 0x51};
const op_code op_bitwise_not = {"NOT", 0x52};
const op_code op_bitwise_xor = {"XOR", 0x53};

inst new_inst(address bin0, address bin1, address bin2, address bin3, label code) {
    inst k = {{bin0, bin1, bin2, bin3}, code, NULL};
    return k;
}


inst op_c(address line, op_code code, number c) {
    return new_inst(code.id, 0, (c >> 8) & 0xFF, c & 0xFF,
                    printf_alloc(pattern_c, line, code.name, c, c));
}

inst op_i(address line, op_code code, label i) {
    address a_a = var_get_or_temp_pop(i);
    return new_inst(code.id, a_a, 0, 0,
                    printf_alloc(pattern_a, line, code.name, a_a));
}

inst op_oc(address line, op_code code, label o, number c) {
    address a_o = var_get_or_temp_push(o);
    return new_inst(code.id, a_o, (c >> 8) & 0xFF, c & 0xFF,
                    printf_alloc(pattern_ac, line, code.name, a_o, c, c));
}

inst op_ic(address line, op_code code, label i, number c) {
    address a_i = var_get_or_temp_pop(i);
    return new_inst(code.id, a_i, (c >> 8) & 0xFF, c & 0xFF,
                    printf_alloc(pattern_ac, line, code.name, a_i, c, c));
}

inst op_oi(address line, op_code code, label o, label i) {
    address a_i = var_get_or_temp_pop(i);
    address a_o = var_get_or_temp_push(o);
    return new_inst(code.id, a_o, a_i, 0,
                    printf_alloc(pattern_aa, line, code.name, a_o, a_i));
}

inst op_oii(address line, op_code code, label o, label i1, label i2) {
    address a_i2 = var_get_or_temp_pop(i2);
    address a_i1 = var_get_or_temp_pop(i1);
    address a_o = var_get_or_temp_push(o);
    return new_inst(code.id, a_o, a_i1, a_i2,
                    printf_alloc(pattern_aaa, line, code.name, a_o, a_i1, a_i2));
}


void display(label i) {
    add_instruction(op_i(get_instruction_count(), op_display, i));
}

void number_copy(label o, number c) {
    add_instruction(op_oc(get_instruction_count(), op_define, o, c));
}

void number_define(label o, number c) {
    var_create(o);
    number_copy(o, c);
}

void tab_define(label o, address length) {
    var_create(o);
    address c = tab_alloc(length);
    number_copy(o, c);
}

void var_copy(label o, label i) {
    add_instruction(op_oi(get_instruction_count(), op_copy, o, i));
}

void var_define(label o, label i) {
    var_create(o);
    var_copy(o, i);
}

void negate(label o, label i) {
    add_instruction(op_oi(get_instruction_count(), op_negate, o, i));
}

void add(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_add, o, i1, i2));
}

void subtract(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_subtract, o, i1, i2));
}

void multiply(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_multiply, o, i1, i2));
}

void divide(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_divide, o, i1, i2));
}

void modulo(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_modulo, o, i1, i2));
}

void bitwise_and(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_bitwise_and, o, i1, i2));
}

void bitwise_or(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_bitwise_or, o, i1, i2));
}

void bitwise_not(label o, label i) {
    add_instruction(op_oi(get_instruction_count(), op_bitwise_not, o, i));
}

void bitwise_xor(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_bitwise_xor, o, i1, i2));
}

void greater_than(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_greater_than, o, i1, i2));
}

void lower_than(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_lower_than, o, i1, i2));
}

void equal_to(label o, label i1, label i2) {
    add_instruction(op_oii(get_instruction_count(), op_equal_to, o, i1, i2));
}

void jump(address c) {
    add_instruction(op_c(get_instruction_count(), op_jump, c));
}

void branch(label i, address c) {
    add_instruction(op_ic(get_instruction_count(), op_branch, i, c));
}

address padding_for_later() {
    add_instruction(new_inst(0, 0, 0, 0, NULL));
    return get_instruction_count() - 1;
}

void jump_before(address line, address c) {
    set_instruction(op_c(line, op_jump, c), line);
}

void branch_before(address line, label i, address c) {
    set_instruction(op_ic(line, op_branch, i, c), line);
}

void load(label o, label i, label c) {
    add_instruction(op_oii(get_instruction_count(), op_load, o, i, c));
}

void load_0(label o, label i) {
    number_copy(o, 0);
    load(o, i, o);
}

void store(label o, label i, label c) {
    add_instruction(op_oii(get_instruction_count(), op_store, o, i, c));
}

void store_0(label o, label i) {
    number_copy(o, 0);
    store(o, i, o);
}

int buffer_col = 0;
char hint_buffer[MAX_ADDRESS];

void append_hint_buffer(char *hint, int length, int line) {
    if (hint[0] == '\n') {
        char *a = printf_alloc(hint_pattern, line, hint_buffer);
        add_hint(a);
        buffer_col = 0;
        hint_buffer[0] = '\0';
    } else {
        int old = buffer_col;
        buffer_col += length;
        if (buffer_col < MAX_ADDRESS)
            strncpy(hint_buffer + old, hint, length + 1);
    }
}

