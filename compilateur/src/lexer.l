%option noyywrap
%option noinput
%option nounput
%option yylineno
%{
#include "grammar.tab.h"
#include "memory.h"
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
    yyerror(printf_alloc("'%s': Directives are not supported, use #include \"dragon.h\" if you wand add dragon functions support with your C IDE.", yytext));
}

"if" { return IF; }
"else" { return ELSE; }
"do" { return DO; }
"while" { return WHILE; }
"print" { return PRINT; }
"int" { return TYPE_INT; }
"void" { return TYPE_VOID; }
"main" { return MAIN; }
"return" { return RETURN; }

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

"(" { return LPAR; }
")" { return RPAR; }
"{" { return LBRACE; }
"}" { return RBRACE; }
"[" { return LBRACKET; }
"]" { return RBRACKET; }

"++" {
    yyerror(printf_alloc("Unknown token: %s", yytext));
}
"--" {
    yyerror(printf_alloc("Unknown token: %s", yytext));
}

"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"%" { return MOD; }

"<=" { return LOWEQ; }
">=" { return GRTEQ; }
"<" { return LOW; }
">" { return GRT; }
"==" { return EQ; }
"!=" { return NEQ; }

"&&" { return LAND; }
"||" { return LOR; }
"!" { return LNOT; }

"&" { return BAND; }
"|" { return BOR; }
"^" { return BXOR; }
"~" { return BNOT; }

"=" { return ASSIGN; }
"," { return COMMA; }
";" { return END; }

. {
    yyerror(printf_alloc("Unknown token: %s", yytext));
}
