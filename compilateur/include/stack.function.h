#ifndef DCC_STACK_FUNCTION_H_
#define DCC_STACK_FUNCTION_H_

#include "app.h"

void start_function(char *name);

void add_param(char *name);

void end_function();

void go_function(char *name);

void end_go_function();

void give_param(char *name);

void return_var(char *name);

#endif
