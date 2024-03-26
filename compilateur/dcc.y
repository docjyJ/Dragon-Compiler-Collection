%{
#include <stdio.h>
#include <stdlib.h>
#include "traducteur_ARM.h"
%}

%code provides {
  extern int yylineno;

  int yylex (void);
  void yyerror (const char *);
}

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
         | if_header code_block else_header code_block { printf(" -IFELSE\n"); }
         | while_header code_block { printf(" -WHILE\n"); }
         | return END
         | END
         ;

if_header: IF LPAR operators RPAR { printf(" +IF %s\n", $3); }
         ;

else_header: ELSE { printf(" +ELSE\n"); }
         ;

while_header: WHILE LPAR operators RPAR { printf("+ START WHILE %s\n", $3); }
            ;

/* Gestion des fonctions */

functions: functions_header code_block { printf(" -FUNCTION\n"); }
         ;

functions_header: TYPE_VOID LABEL functions_args { printf(" +FUNCTION %s(len_arg %lu type VOID)\n", $2, $3); }
                | TYPE_INT LABEL functions_args { printf(" +FUNCTION %s(len_arg %lu type INT)\n", $2, $3); }
                | TYPE_VOID MAIN functions_args { printf(" +FUNCTION main(len_arg %lu type VOID)\n", $3); }
                ;

functions_args: LPAR functions_args_list RPAR { $$ = $2;}
              | LPAR TYPE_VOID RPAR { $$ = 0;}
              | LPAR RPAR { $$ = 0;}
              ;

functions_args_list: TYPE_INT LABEL { printf(" |ARG %s(num 0 type INT)\n", $2); $$ = 1;}
                   | functions_args_list COMMA TYPE_INT LABEL { printf(" |ARG %s(num %lu type INT)\n", $4, $1); $$ = $1 + 1;}
                   ;




/* Gestion ses opérations */

number: STATIC_INT { affectation((int) $1); $$ = NULL; }
      | LABEL { $$ = $1; }
      | callable { $$ = "rEXEC" ;}
      | LPAR operators RPAR { $$ = $2 ;}
      ;

unary: number { $$ = $1 ; }
     | SUB number { printf("%d rNEG <- sub 0 %s\n", yylineno, $2); $$ = "rNEG"; }
     ;

multiplicative: unary { $$ = $1 ; }
              | multiplicative MUL unary { printf("%d rMUL <- %s, %s\n", yylineno, $1, $3); $$ = "rMUL"; }
              ;

additive: multiplicative { $$ = $1 ; }
        | additive ADD multiplicative { add($1, $3); $$ = NULL; }
        | additive SUB multiplicative { printf("%d rSUB <- sub %s %s\n", yylineno, $1, $3); $$ = "rSUB"; }
        ;

relational: additive { $$ = $1 ; }
          | relational LOW additive { printf("%d rLOW <- grt %s %s\n", yylineno, $1, $3); $$ = "rLOW"; }
          | relational GRT additive { printf("%d rGRT <- grt %s %s\n", yylineno, $1, $3); $$ = "rGRT"; }
          ;

equality: relational { $$ = $1 ; }
        | equality EQ  relational { printf("%d rEQ <- eq %s %s\n", yylineno, $1, $3); $$ = "rEQ"; }
        ;

operators: equality { $$ = $1 ; }
         | assignment_list equality { printf("%d %s <- %s\n", yylineno, $1, $2); $$ = $2;}
         ;

assignment: assignment_list equality { copie($1, $2);}
          ;

assignment_list: LABEL ASSIGN { $$ = $1; }
               | assignment_list LABEL ASSIGN { printf("%d %s <- %s\n", yylineno, $1, $2); $$ = $2;}
               ;


/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: assignment
            | LABEL { printf("%d %s <- NoValue\n", yylineno, $1); }
            | defvars_list COMMA assignment
            | defvars_list COMMA LABEL { printf("%d %s <- NoValue\n", yylineno, $3); }
            ;



/* Gestion des appel de fonction */

callable: PRINT callable_args { printf("%d rEXEC <- exec print (list_arg %lu)\n", yylineno, $2); }
        | LABEL callable_args { printf("%d rEXEC <- exec %s(list_arg %lu)\n", yylineno, $1, $2); }
        ;

callable_args: LPAR callable_args_list RPAR { $$ = $2; }
             | LPAR RPAR { $$ = 0; }
             ;

callable_args_list: operators { printf(" |ARG %s(num 0)\n", $1); $$ = 1;}
                  | callable_args_list COMMA operators { printf(" |ARG %s(num %lu)\n", $3, $1); $$ = $1 + 1;}
                  ;

return: tRETURN operators { printf("%d RETURN %s\n", yylineno, $2);}

%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
  exit(1);
}

int main(void) {
  yyparse();
}
