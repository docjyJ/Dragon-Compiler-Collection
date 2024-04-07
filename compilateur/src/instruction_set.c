#include "instruction_set.h"
#include "error_memory.h"
#include "stack.variable.h"

const char *pattern_c = "%02X#     %3s  %3d//%02X\n";
const char *pattern_a = "%02X#     %3s  @%02X\n";
const char *pattern_ac = "%02X#     %3s  @%02X  %3d//%02X\n";
const char *pattern_aa = "%02X#     %3s  @%02X  @%02X\n";
const char *pattern_aaa = "%02X#     %3s  @%02X  @%02X  @%02X\n";

const op_code op_add = {"ADD", 0x01};
const op_code op_multiply = {"MUL", 0x02};
const op_code op_subtract = {"SUB", 0x03};
const op_code op_divide = {"DIV", 0x04};
const op_code op_copy = {"COP", 0x05};
const op_code op_define = {"AFC", 0x06};
const op_code op_jump = {"JMP", 0x07};
const op_code op_conditional_jump = {"JMF", 0x08};
const op_code op_lower_than = {"INF", 0x09};
const op_code op_greater_than = {"SUP", 0x0A};
const op_code op_equal_to = {"EQU", 0x0B};
const op_code op_display = {"PRI", 0x0C};

const op_code op_logical_and = {"AND", 0x20};
const op_code op_logical_or = {"OR", 0x21};


inst op_c(address line, op_code code, address c) {
    return printf_alloc(pattern_c, line, code.name, c, c);
}

inst op_i(address line, op_code code, label i) {
    address a_a = var_get_or_temp_pop(i);
    return printf_alloc(pattern_a, line, code.name, a_a);
}

inst op_oc(address line, op_code code, label o, address c) {
    address a_o = var_get_or_temp_push(o);
    return printf_alloc(pattern_ac, line, code.name, a_o, c, c);
}

inst op_ic(address line, op_code code, label i, address c) {
    address a_i = var_get_or_temp_pop(i);
    return printf_alloc(pattern_ac, line, code.name, a_i, c, c);
}

inst op_oi(address line, op_code code, label o, label i) {
    address a_a = var_get_or_temp_pop(i);
    address a_o = var_get_or_temp_push(o);
    return printf_alloc(pattern_aa, line, code.name, a_o, a_a);
}

inst op_oii(address line, op_code code, label o, label i1, label i2) {
    address a_i2 = var_get_or_temp_pop(i2);
    address a_i1 = var_get_or_temp_pop(i1);
    address a_o = var_get_or_temp_push(o);
    return printf_alloc(pattern_aaa, line, code.name, a_o, a_i1, a_i2);
}


