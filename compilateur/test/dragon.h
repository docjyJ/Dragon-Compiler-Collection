#include <stdio.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmain-return-type"

typedef unsigned char __uint8__;

#define int __uint8__
#define char ___disable_keyword_char___
#define short ___disable_keyword_short___
#define long ___disable_keyword_long___
#define float ___disable_keyword_float___
#define double ___disable_keyword_double___
#define signed ___disable_keyword_signed___
#define unsigned ___disable_keyword_unsigned___
#define struct ___disable_keyword_struct___
#define union ___disable_keyword_union___
#define enum ___disable_keyword_enum___
#define typedef ___disable_keyword_typedef___
#define const ___disable_keyword_const___
#define volatile ___disable_keyword_volatile___
#define sizeof ___disable_keyword_sizeof___
#define auto ___disable_keyword_auto___
#define static ___disable_keyword_static___
#define extern ___disable_keyword_extern___
#define register ___disable_keyword_register___
#define inline ___disable_keyword_inline___


void main();

void print(int a) {
    printf("%d\n", a);
}