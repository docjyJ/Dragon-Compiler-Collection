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
%token ADD SUB MUL tDIV LOW GRT tNE EQ ASSIGN LBRACE RBRACE LPAR RPAR END COMMA tLE tGE tAND tOR tNOT MAIN
%token tERROR

%type <s> number unary multiplicative additive relational equality operators assignment_list
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
         | if_header code_block else_header code_block { fprintf(stderr, " -IFELSE\n"); }
         | while_header code_block { fprintf(stderr, " -WHILE\n"); }
         | return END
         | END
         ;

if_header: IF LPAR operators RPAR { fprintf(stderr, " +IF %s\n", $3); }
         ;

else_header: ELSE { fprintf(stderr, " +ELSE\n"); }
         ;

while_header: WHILE LPAR operators RPAR { fprintf(stderr, "+ START WHILE %s\n", $3); }
            ;

/* Gestion des fonctions */

functions: functions_header code_block { fprintf(stderr, " -FUNCTION\n"); }
         ;

functions_header: TYPE_VOID LABEL functions_args { fun($2); fprintf(stderr, " +FUNCTION %s(len_arg %lu type VOID)\n", $2, $3); }
                | TYPE_INT LABEL functions_args { fun($2); fprintf(stderr, " +FUNCTION %s(len_arg %lu type INT)\n", $2, $3); }
                | TYPE_VOID MAIN functions_args { fun("main"); fprintf(stderr, " +FUNCTION main(len_arg %lu type VOID)\n", $3); }
                ;

functions_args: LPAR functions_args_list RPAR { $$ = $2;}
              | LPAR TYPE_VOID RPAR { $$ = 0;}
              | LPAR RPAR { $$ = 0;}
              ;

functions_args_list: TYPE_INT LABEL { fprintf(stderr, " |ARG %s(num 0 type INT)\n", $2); $$ = 1;}
                   | functions_args_list COMMA TYPE_INT LABEL { fprintf(stderr, " |ARG %s(num %lu type INT)\n", $4, $1); $$ = $1 + 1;}
                   ;




/* Gestion ses opérations */

number: STATIC_INT { affectation((int) $1); $$ = NULL; }
      | LABEL { $$ = $1; }
      | callable { $$ = "rEXEC" ;}
      | LPAR operators RPAR { $$ = $2 ;}
      ;

unary: number { $$ = $1 ; }
     | SUB number { fprintf(stderr, "%d rNEG <- sub 0 %s\n", yylineno, $2); $$ = "rNEG"; }
     ;

multiplicative: unary { $$ = $1 ; }
              | multiplicative MUL unary { mul($1, $3); $$ = NULL; }
              ;

additive: multiplicative { $$ = $1 ; }
        | additive ADD multiplicative { add($1, $3); $$ = NULL; }
        | additive SUB multiplicative { sous($1, $3); $$ = NULL; }
        ;

relational: additive { $$ = $1 ; }
          | relational LOW additive { fprintf(stderr, "%d rLOW <- grt %s %s\n", yylineno, $1, $3); $$ = "rLOW"; }
          | relational GRT additive { fprintf(stderr, "%d rGRT <- grt %s %s\n", yylineno, $1, $3); $$ = "rGRT"; }
          ;

equality: relational { $$ = $1 ; }
        | equality EQ  relational { fprintf(stderr, "%d rEQ <- eq %s %s\n", yylineno, $1, $3); $$ = "rEQ"; }
        ;

operators: equality { $$ = $1 ; }
         | assignment_list equality { copie($1, $2); $$ = $2;}
         ;

assignment: assignment_list equality { copie($1, $2);}
          ;

assignment_list: LABEL ASSIGN { $$ = $1; }
               | assignment_list LABEL ASSIGN { copie($1, $2); $$ = $2;}
               ;


/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: assignment
            | LABEL { fprintf(stderr, "%d %s <- NoValue\n", yylineno, $1); }
            | defvars_list COMMA assignment
            | defvars_list COMMA LABEL { fprintf(stderr, "%d %s <- NoValue\n", yylineno, $3); }
            ;



/* Gestion des appel de fonction */

callable: PRINT callable_args { fprintf(stderr, "%d rEXEC <- exec print (list_arg %lu)\n", yylineno, $2); }
        | LABEL callable_args { fprintf(stderr, "%d rEXEC <- exec %s(list_arg %lu)\n", yylineno, $1, $2); }
        ;

callable_args: LPAR callable_args_list RPAR { $$ = $2; }
             | LPAR RPAR { $$ = 0; }
             ;

callable_args_list: operators { fprintf(stderr, " |ARG %s(num 0)\n", $1); $$ = 1;}
                  | callable_args_list COMMA operators { fprintf(stderr, " |ARG %s(num %lu)\n", $3, $1); $$ = $1 + 1;}
                  ;

return: tRETURN operators { fprintf(stderr, "%d RETURN %s\n", yylineno, $2);}

%%