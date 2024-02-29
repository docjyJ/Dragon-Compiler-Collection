%option noyywrap
%option noinput
%option nounput
%option yylineno

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

0x[0-9a-fA-F]+ {
    yylval.i = strtoul(yytext, NULL, 16);
    return tNB;
}

[0-9]+ {
    yylval.i = strtoul(yytext, NULL, 10);
    return tNB;
}

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
