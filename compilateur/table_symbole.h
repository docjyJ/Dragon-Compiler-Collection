#ifndef TABLE_SYBOLE
#define TABLE_SYBOLE

typedef unsigned char address;


void set_var(char *name);

short get_var(char *name);

address temp_var_push();

address temp_var_pop();

void add_priority();

void remove_priority();

#endif