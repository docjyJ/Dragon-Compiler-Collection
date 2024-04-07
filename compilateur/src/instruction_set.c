#include <stddef.h>
#include "variable_manager.h"
#include "error_memory.h"
#include "instruction_set.h"

#define GET_VAR_OR_POP_TMP(a) (a == NULL ? temp_pop() : var_get(a))
#define GET_VAR_OR_PUSH_TMP(a) (a == NULL ? temp_push() : var_get(a))

const char *pattern_c = "%02X#     %3s  %3d               //%02X\n";
const char *pattern_a = "%02X#     %3s  @%02X\n";
const char *pattern_ac = "%02X#     %3s  @%02X  %3d          //%02X\n";
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


char *op_c(address line, op_code code, address a) {
    return printf_alloc(pattern_c, line, code.name, a, a);
}

char *op_a(address line, op_code code, label a) {
    address a_a = GET_VAR_OR_POP_TMP(a);
    return printf_alloc(pattern_a, line, code.name, a_a);
}

char *op_ac(address line, op_code code, label a, address b) {
    address a_result = GET_VAR_OR_PUSH_TMP(a);
    return printf_alloc(pattern_ac, line, code.name, a_result, b, b);
}

char *op_aa(address line, op_code code, label result, label a) {
    address a_a = GET_VAR_OR_POP_TMP(a);
    address a_result = GET_VAR_OR_PUSH_TMP(result);
    return printf_alloc(pattern_aa, line, code.name, a_result, a_a);
}

char *op_aaa(address line, op_code code, label result, label a, label b) {
    address a_b = GET_VAR_OR_POP_TMP(b);
    address a_a = GET_VAR_OR_POP_TMP(a);
    address a_result = GET_VAR_OR_PUSH_TMP(result);
    return printf_alloc(pattern_aaa, line, code.name, a_result, a_a, a_b);
}


