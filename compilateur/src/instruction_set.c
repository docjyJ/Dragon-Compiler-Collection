#include <string.h>
#include "instruction_set.h"
#include "memory.h"
#include "stack.instruction.h"
#include "stack.variable.h"
//#define DEBUG
#ifdef DEBUG
#include <stdio.h>
#endif

typedef struct {
    const char *name;
    const address id;
} op_code;

typedef enum { RS, R1, R2, R3 } register_t;
const char *r_name[] = {"RS", "R1", "R2", "R3"};

const char *pattern_c = "%02X#%8s x%02X //%d\n";
const char *pattern_ca = "%02X#%8s x%02X  %2s //%d\n";
const char *pattern_a = "%02X#%8s %2s\n";
const char *pattern_ac = "%02X#%8s %2s x%02X //%d\n";
const char *pattern_aa = "%02X#%8s %2s %2s\n";
const char *pattern_aaa = "%02X#%8s %2s %2s %2s\n";
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

void op_r(op_code code, register_t r) {
    inst k = {{code.id, r, 0, 0},
              printf_alloc(pattern_a, get_instruction_count(), code.name, r_name[r]), NULL};
    add_instruction(k);
}

void op_rc(op_code code, register_t r, address c) {
    inst k = {{code.id, r, c, 0},
              printf_alloc(pattern_ac, get_instruction_count(), code.name, r_name[r], c, c), NULL};
    add_instruction(k);
}

void op_rr(op_code code, register_t r1, register_t r2) {
    inst k = {{code.id, r1, r2, 0},
              printf_alloc(pattern_aa, get_instruction_count(), code.name, r_name[r1], r_name[r2]), NULL};
    add_instruction(k);
}

void op_rrr(op_code code, register_t r1, register_t r2, register_t r3) {
    inst k = {{code.id, r1, r2, r3},
              printf_alloc(pattern_aaa, get_instruction_count(), code.name, r_name[r1], r_name[r2], r_name[r3]), NULL};
    add_instruction(k);
}

inst op_jump_c(address line, address target) {
    inst k = {{op_jump.id, target, 0, 0},
              printf_alloc(pattern_c, line, op_jump.name, target, target), NULL};
    return k;
}

inst op_jump_ca(address line, address target, register_t r) {
    inst k = {{op_branch.id, target, r, 0},
              printf_alloc(pattern_ca, line, op_branch.name, target, r_name[r], target), NULL};
    return k;
}

void load_const(register_t r, number c) {
    op_rc(op_define, r, c);
}

void var_adr(register_t r, memory_address a) {
    load_const(r, a.value);
    if (a.isLocal)
        op_rrr(op_add, r, r, RS);
}

void load_var(register_t r, label l) {
    var_adr(r, var_get_or_temp_pop(l));
    op_rr(op_load, r, r);
}

void store_var(register_t r, register_t tmp, label l) {
    var_adr(tmp, var_get_or_temp_push(l));
    op_rr(op_store, r, tmp);
}

void unite_operation(op_code code, label o, label i) {
    load_var(R1, i);
    op_rr(code, R1, R1);
    store_var(R1, R2, o);
}

void operation(op_code code, label o, label i1, label i2) {
    load_var(R2, i2);
    load_var(R1, i1);
    op_rrr(code, R1, R1, R2);
    store_var(R1, R2, o);
}


void display(label i) {
    load_var(R1, i);
    op_r(op_display, R1);
}

void number_copy(label o, number c) {
    load_const(R1, c);
    store_var(R1, R2, o);
}

void number_define(label o, number c) {
    var_create(o);
    number_copy(o, c);
}

void tab_define(label o, address length) {
    var_create(o);
    memory_address adr = tab_alloc(length);
    load_const(R1, adr.value);
    if (adr.isLocal) op_rrr(op_add, R1, R1, RS);
    store_var(R1, R2, o);
}

void var_copy(label o, label i) {
    load_var(R1, i);
    store_var(R1, R2, o);
}

void var_define(label o, label i) {
    var_create(o);
    var_copy(o, i);
}

void negate(label o, label i) {
    unite_operation(op_negate, o, i);
}

void add(label o, label i1, label i2) {
    operation(op_add, o, i1, i2);
}

void subtract(label o, label i1, label i2) {
    operation(op_subtract, o, i1, i2);
}

void multiply(label o, label i1, label i2) {
    operation(op_multiply, o, i1, i2);
}

void divide(label o, label i1, label i2) {
    operation(op_divide, o, i1, i2);
}

void modulo(label o, label i1, label i2) {
    operation(op_modulo, o, i1, i2);
}

void bitwise_and(label o, label i1, label i2) {
    operation(op_bitwise_and, o, i1, i2);
}

void bitwise_or(label o, label i1, label i2) {
    operation(op_bitwise_or, o, i1, i2);
}

void bitwise_not(label o, label i) {
    unite_operation(op_bitwise_not, o, i);
}

void bitwise_xor(label o, label i1, label i2) {
    operation(op_bitwise_xor, o, i1, i2);
}

void greater_than(label o, label i1, label i2) {
    operation(op_greater_than, o, i1, i2);
}

void lower_than(label o, label i1, label i2) {
    operation(op_lower_than, o, i1, i2);
}

void equal_to(label o, label i1, label i2) {
    operation(op_equal_to, o, i1, i2);
}

void jump(address c) {
    add_instruction(op_jump_c(get_instruction_count(), c));
}

void branch(label i, address c) {
    load_var(R2, i);
    add_instruction(op_jump_ca(get_instruction_count(), c, R1));
}

address padding_for_later_jump() {
    inst k = {{0, 0, 0, 0}, NULL, NULL};
    add_instruction(k);
    return get_instruction_count() - 1;
}

address padding_for_later_branch(label cond) {
    load_var(R1, cond);
    return padding_for_later_jump();
}

void jump_before(address line, address address) {
    set_instruction(op_jump_c(line, address), line);
}

void branch_before(address line, address addr, address offset) {
    set_instruction(op_jump_ca(line, addr - offset, R1), line);
}

void load_offset(label o, label i, label c) {
    add(NULL, c, i);
    load(o, NULL);
}

void load(label o, label i) {
    load_var(R1, i);
    op_rr(op_load, R1, R1);
    store_var(R1, R2, o);
}

void store_offset(label o, label i, label c) {
    load_var(R3, i);
    add(NULL, c, o);
    add_hint("//store_var\n");
    load_var(R1, NULL);
    op_rr(op_store, R3, R1);

}

void store(label o, label i) {
    load_var(R2, i);
    load_var(R1, o);
    op_rr(op_store, R3, R1);
}

void var_to_address(label o, label i) {
    if (i == NULL)
        yyerror("NULL pointer");

    var_adr(R1, var_get(i));
    store_var(R1, R2, o);
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
#ifdef DEBUG
        fprintf(stderr, "[%s]", hint);
#endif
        int old = buffer_col;
        buffer_col += length;
        if (buffer_col < MAX_ADDRESS)
            strncpy(hint_buffer + old, hint, length + 1);
    }
}

