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
"if"            printf("tIF\n");
"else"          printf("tELSE\n");
"while"         printf("tWHILE\n");
"print"         printf("tPRINT\n");
"return"        printf("tRETURN\n");
"int"           printf("tINT\n");
"void"          printf("tVOID\n");
[a-z][a-z0-9]*  printf("tID: '%s'\n", yytext);
0x[0-9a-fA-F]+  printf("tNB: '%ld[%s]'\n", strtol(yytext, NULL, 0), yytext);
[0-9]+          printf("tNB: '%s[0x%x]'\n", yytext, atoi(yytext));
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
"="             printf("tASSIGN\n");
"&&"            printf("tAND\n");
"||"            printf("tOR\n");
"!"             printf("tNOT\n");
"{"             printf("tLBRACE\n");
"}"             printf("tRBRACE\n");
"("             printf("tLPAR\n");
")"             printf("tRPAR\n");
";"             printf("tSEMI\n");
","             printf("tCOMMA\n");
.               printf("tERROR\n");
