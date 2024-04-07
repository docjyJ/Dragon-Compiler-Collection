#include <stddef.h>
#include "traducteur_ARM.h"
#include "stack.instruction.h"
#include "instruction_set.h"
#include "stack.variable.h"

void display(label a) {
    add_instruction(op_i(get_instruction_count(), op_display, a));
}

void number_copy(label result, int a) {
    add_instruction(op_oc(get_instruction_count(), op_define, result, a));
}

void number_define(label result, int a) {
    var_create(result);
    number_copy(result, a);
}

void var_copy(label result, label a) {
    add_instruction(op_oi(get_instruction_count(), op_copy, result, a));
}

void var_define(label result, label a) {
    var_create(result);
    var_copy(result, a);
}

void add(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_add, NULL, a, b));
}

void subtract(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_subtract, NULL, a, b));
}

void multiply(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_multiply, NULL, a, b));
}

void divide(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_divide, NULL, a, b));
}

void logical_and(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_logical_and, NULL, a, b));
}

void logical_or(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_logical_or, NULL, a, b));
}

void greater_than(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_greater_than, NULL, a, b));
}

void lower_than(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_lower_than, NULL, a, b));
}

void equal_to(label a, label b) {
    add_instruction(op_oii(get_instruction_count(), op_equal_to, NULL, a, b));
}
