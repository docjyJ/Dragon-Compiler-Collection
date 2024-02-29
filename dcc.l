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

"if" {
    return tIF;
}

"else" {
    return tELSE;
}

"while" {
    return tWHILE;
}

"print" {
    return tPRINT;
}

"return" {
    return tRETURN;
}

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

"+" {
    return tADD;
}

"-" {
    return tSUB;
}

"*" {
    return tMUL;
}

"/" {
    return tDIV;
}

"<" {
    return tLT;
}

">" {
    return tGT;
}

"!=" {
    return tNE;
}

"==" {
    return tEQ;
}

">=" {
    return tGE;
}

"<=" {
    return tLE;
}

"=" {
    return tASSIGN;
}

"&&" {
    return tAND;
}

"||" {
    return tOR;
}

"!" {
    return tNOT;
}

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
