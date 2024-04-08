%option noyywrap
%option noinput
%option nounput
%option yylineno
%{
#include "error_memory.h"
#include "grammar.tab.h"
#include "instruction_set.h"
#define YY_USER_ACTION { append_hint_buffer(yytext, yyleng, yylineno-1); }
%}

%%

\/\/[^\n]*
\/\*([^*]|[*][^/])*\*\/
[ \t]+
[\n]
"#include \"dragon.h\""

#.* {
    yyerror("Directives are not supported, use #include \"dragon.h\" if you wand add dragon functions support with your C IDE.");
}

"if" {
    return IF;
}

"else" {
    return ELSE;
}

"while" {
    return WHILE;
}

"do" {
    return DO;
}

"main" {
    return MAIN;
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

[a-zA-Z][_a-zA-Z0-9]* {
    yylval.s = copy_alloc(yytext);
    return LABEL;
}

0x[0-9a-fA-F]+ {
    yylval.i = (number) parse_number(yytext, 16);
    return STATIC_INT;
}

[0-9]+ {
    yylval.i = (number) parse_number(yytext, 10);
    return STATIC_INT;
}

0b[01]+ {
    yylval.i = (number) parse_number(yytext+2, 2);
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
    return DIV;
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
