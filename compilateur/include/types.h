#ifndef DCC_TYPES_H_
#define DCC_TYPES_H_

#define MAX_ADDRESS 0x100

typedef unsigned char address;
typedef char *label;
typedef char *inst;

typedef struct {
    const char *name;
    const address id;
} op_code;

#endif
