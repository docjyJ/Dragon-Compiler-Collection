#ifndef DCC_INSTRUCTION_SET_H_
#define DCC_INSTRUCTION_SET_H_

typedef struct {
    const char *name;
    const address id;
} op_code;

extern const op_code op_add;
extern const op_code op_multiply;
extern const op_code op_subtract;
extern const op_code op_divide;
extern const op_code op_copy;
extern const op_code op_define;
extern const op_code op_jump;
extern const op_code op_conditional_jump;
extern const op_code op_lower_than;
extern const op_code op_greater_than;
extern const op_code op_equal_to;
extern const op_code op_display;

extern const op_code op_logical_and;
extern const op_code op_logical_or;

char *op_c(address line, op_code code, address a);

char *op_i(address line, op_code code, label a);

char *op_oc(address line, op_code code, label a, address b);

char *op_ic(address line, op_code code, label a, address b);

char *op_oi(address line, op_code code, label result, label a);

char *op_oii(address line, op_code code, label result, label a, label b);

#endif
