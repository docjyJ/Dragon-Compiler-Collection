%option noyywrap
%option noinput
%option nounput

%{
#include "dcc.tab.h"
%}

%%

\/\/[^\n]*
\/\*([^*]|[*][^/])*\*\/
[ \t\n]+
"if"                    printf("tIF\n");
"else"                  printf("tELSE\n");
"while"                 printf("tWHILE\n");
"print"                 printf("tPRINT\n");
"return"                printf("tRETURN\n");

"int" {
    return tINT;
}

"void" {
    return tVOID;
}

[a-z][a-z0-9]* {
    yylval.s = strdup(yytext);
    return tID;
}

0x[0-9a-fA-F]{1,16}     printf("tNB: '%ld[%s]'\n", strtol(yytext, NULL, 16), yytext);
[0-9]+                  printf("tNB: '%s[0x%lx]'\n", yytext, strtol(yytext, NULL, 10));
"+"             printf("tADD\n");
"-"             printf("tSUB\n");
"*"             printf("tMUL\n");
"/"             printf("tDIV\n");
"<"             printf("tLT\n");
">"             printf("tGT\n");
"!="            printf("tNE\n");
"=="            printf("tEQ\n");
">="            printf("tGE\n");
"<="            printf("tLE\n");

"=" {
    return tASSIGN;
}

"&&"            printf("tAND\n");
"||"            printf("tOR\n");
"!"             printf("tNOT\n");

"{" {
    return tLBRACE;
}

"}" {
    return tRBRACE;
}

"(" {
    return tLPAR;
}

")" {
    return tRPAR;
}

";" {
    return tSEMI;
}

"," {
    return tCOMMA;
}

. {
    return tERROR;
}
