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
    return IF;
}

"else" {
    return ELSE;
}

"while" {
    return WHILE;
}

"print" {
    return PRINT;
}

"return" {
    return tRETURN;
}

"int" {
    return TYPE_INT;
}

"void" {
    return TYPE_VOID;
}

[a-z][a-z0-9]* {
    yylval.s = strdup(yytext);
    return LABEL;
}

0x[0-9a-fA-F]+ {
    yylval.i = strtoul(yytext, NULL, 16);
    return STATIC_INT;
}

[0-9]+ {
    yylval.i = strtoul(yytext, NULL, 10);
    return STATIC_INT;
}

"+" {
    return ADD;
}

"-" {
    return SUB;
}

"*" {
    return MUL;
}

"/" {
    return tDIV;
}

"<" {
    return LOW;
}

">" {
    return GRT;
}

"!=" {
    return tNE;
}

"==" {
    return EQ;
}

">=" {
    return tGE;
}

"<=" {
    return tLE;
}

"=" {
    return ASSIGN;
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
    return LBRACE;
}

"}" {
    return RBRACE;
}

"(" {
    return LPAR;
}

")" {
    return RPAR;
}

";" {
    return END;
}

"," {
    return COMMA;
}

. {
    return tERROR;
}
