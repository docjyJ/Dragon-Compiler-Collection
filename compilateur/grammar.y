%{
#include <stdio.h>
#include <stdlib.h>
#include "traducteur_ARM.h"
extern int yylineno;
int yylex(void);
void yyerror(const char *);
%}

%union {
  char *s;
  unsigned long i;
}

%token <s> LABEL
%token <i> STATIC_INT
%token IF ELSE WHILE PRINT TYPE_INT TYPE_VOID tRETURN
%token ADD SUB MUL DIV LOW GRT tNE EQ ASSIGN LBRACE RBRACE LPAR RPAR END COMMA tLE tGE tAND tOR tNOT MAIN
%token tERROR

%type <s> number unary multiplicative additive relational equality operators
%type <i> callable_args_list callable_args functions_args functions_args_list

%start global_code_list

%%

global_code_list: global_code
                | global_code_list global_code
                ;

global_code: functions
           | defvars END
           ;

code_block: LBRACE code_line_list RBRACE
            |LBRACE RBRACE
          ;

code_line_list: code_line
              | code_line code_line_list
              ;

code_line: operators END
         | defvars END
         | if_header code_block else_header code_block { end_jump(); }
         | if_header code_block { end_jump(); }
         | while_header code_block {end_jump_reverse(NULL);  end_jump();  }
         | PRINT LPAR operators RPAR END { print_int($3); }
         | return END
         | END
         ;

if_header: IF LPAR operators RPAR { start_jump($3); }
         ;

else_header: ELSE { end_jump(); start_jump(NULL); }
         ;

while_header: WHILE LPAR operators RPAR { start_jump($3); start_jump_reverse(); }
            ;

/* Gestion des fonctions */

functions: functions_header code_block { end_fun(); }
         ;

functions_header: TYPE_VOID LABEL functions_args { yyerror("function not implemented"); }
                | TYPE_INT LABEL functions_args { yyerror("function not implemented"); }
                | TYPE_VOID MAIN functions_args { fun("main"); }
                ;

functions_args: LPAR functions_args_list RPAR { $$ = $2; }
              | LPAR TYPE_VOID RPAR { $$ = 0;}
              | LPAR RPAR { $$ = 0;}
              ;

functions_args_list: functions_arg { $$ = 1; }
                   | functions_args_list COMMA functions_arg { $$ = $1 + 1; }
                   ;

functions_arg: TYPE_INT LABEL { yyerror("function arguments not implemented"); }
             ;



/* Gestion ses opérations */

number: STATIC_INT { affectation(NULL, (int) $1); $$ = NULL; }
      | LABEL { $$ = $1; }
      | callable { $$ = "rEXEC" ;}
      | LPAR operators RPAR { $$ = $2 ;}
      ;

unary: number { $$ = $1 ; }
     | SUB number { fprintf(stderr, "%d rNEG <- sub 0 %s\n", yylineno, $2); $$ = "rNEG"; }
     ;

multiplicative: unary { $$ = $1 ; }
              | multiplicative MUL unary { mul($1, $3); $$ = NULL; }
              | multiplicative DIV unary { divide($1, $3); $$ = NULL; }
              ;

additive: multiplicative { $$ = $1 ; }
        | additive ADD multiplicative { add($1, $3); $$ = NULL; }
        | additive SUB multiplicative { sous($1, $3); $$ = NULL; }
        ;

relational: additive { $$ = $1 ; }
          | relational LOW additive { inf($1, $3); $$ = "rLOW"; }
          | relational GRT additive { sup($1, $3); $$ = "rGRT"; }
          ;

equality: relational { $$ = $1 ; }
        | equality EQ  relational { equ($1, $3); $$ = "rEQ"; }
        ;

operators: equality { $$ = $1 ; }
         | LABEL ASSIGN operators { copie($1, $3); $$ = $1;}
         ; // TODO Récusirvité à droite


/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: defvar
            | defvars_list COMMA defvar
            ;

defvar: LABEL { define_affectation($1, 0) ; }
      | LABEL ASSIGN operators { define_copie($1, $3); }
      ;


/* Gestion des appel de fonction */

callable: LABEL callable_args { fprintf(stderr, "%d rEXEC <- exec %s(list_arg %lu)\n", yylineno, $1, $2); }
        ;

callable_args: LPAR callable_args_list RPAR { $$ = $2; }
             | LPAR RPAR { $$ = 0; }
             ;

callable_args_list: operators { fprintf(stderr, " |ARG %s(num 0)\n", $1); $$ = 1;}
                  | callable_args_list COMMA operators { fprintf(stderr, " |ARG %s(num %lu)\n", $3, $1); $$ = $1 + 1;}
                  ;

return: tRETURN operators { fprintf(stderr, "%d RETURN %s\n", yylineno, $2);}

%%