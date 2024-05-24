#include <malloc.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>

#include "memory.h"
#include "app.h"

unsigned long parse_number(const char *s, const int base) {
    char *endptr;
    unsigned long n = strtoul(s, &endptr, base);
    if (*endptr != '\0')
        yyerror("Parse number failed");
    return n;
}

char *copy_alloc(const char *s) {
    char *copy;
    if (asprintf(&copy, "%s", s) == -1)
        yyerror("Memory allocation failed");
    return copy;
}

char *printf_alloc(const char *format, ...) {
    va_list args;
    va_start(args, format);
    char *s;
    int n = vasprintf(&s, format, args);
    va_end(args);
    if (n == -1)
        yyerror("Memory allocation failed");
    return s;
}

void *empty_alloc(long unsigned int size) {
    void *ptr = malloc(size);
    if (ptr == NULL)
        yyerror("Memory allocation failed");
    return ptr;
}