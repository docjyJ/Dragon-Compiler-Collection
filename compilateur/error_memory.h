#ifndef DCC_ERROR_MEMORY_H_
#define DCC_ERROR_MEMORY_H_

extern int yylineno;

void yyerror(const char *msg);

unsigned long parse_number(const char *s, const int base);

char *copy_alloc(const char *s);

char *printf_alloc(const char *fmt, ...);

void *empty_alloc(long unsigned int size);

void free(void *ptr);

#endif
