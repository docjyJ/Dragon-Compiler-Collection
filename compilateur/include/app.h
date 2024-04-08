#ifndef DCC_APP_H_
#define DCC_APP_H_

#define MAX_ADDRESS 0x100
#define MAX_BRANCH 10
#define MAX_FUNCTION 20

typedef unsigned char address;
typedef unsigned short number;
typedef char *label;
typedef struct {
    address bin[4];
    label code;
    label hint;
} inst;

void yyerror(const char *s);

void write_output(inst s);

#endif
