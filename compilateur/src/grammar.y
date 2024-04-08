%{
#include "lexer.yy.h"
#include "error_memory.h"
#include "instruction_set.h"
#include "stack.branch.h"
#include "stack.function.h"
#include "stack.instruction.h"
%}

%union {
  char *s;
  unsigned short i;
}

%token <s> LABEL
%token <i> STATIC_INT
%token IF ELSE DO WHILE PRINT TYPE_INT TYPE_VOID tRETURN
%token ADD SUB MUL DIV LOW GRT tNE EQ ASSIGN LBRACE RBRACE LPAR RPAR END COMMA tLE tGE tAND tOR tNOT MAIN
%token tERROR

%type <s> number unary multiplicative additive relational equality operators
%type <i> callable_args_list callable_args functions_args functions_args_list

%%

global : global_code_list {print_instruction();}
       ; // permet de tout print

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

code_one_line: operators END { free($1); }
             | defvars END
             | if { end_branch(); }
             | while_do { end_branch(); end_branch(); }
             | PRINT LPAR operators RPAR END { display($3); free($3); }
             | return END
             | END
             ;

code_line: code_one_line
         | if else { end_branch(); }
         ;


init_cond: LPAR operators RPAR { start_if($2); free($2); };
init_else: %empty { end_branch(); start_else(); };
init_loop: %empty { start_loop(); };

single_boddy: code_block | code_one_line;
chain_boddy: code_block | code_line;

if: IF init_cond single_boddy;
else: ELSE init_else chain_boddy;
while_do: WHILE init_loop init_cond single_boddy
        | DO init_loop code_block WHILE init_cond END
        ;


/* Gestion des fonctions */

functions: functions_header code_block { end_function(); }
         ;

functions_header: TYPE_VOID LABEL functions_args { start_function($2); free($2); }
                | TYPE_INT LABEL functions_args { start_function($2); free($2); }
                | TYPE_VOID MAIN LPAR TYPE_VOID RPAR { start_function("main"); }
                | TYPE_VOID MAIN LPAR RPAR { start_function("main"); }
                ;

functions_args: LPAR functions_args_list RPAR { $$ = $2; }
              | LPAR TYPE_VOID RPAR { $$ = 0;}
              | LPAR RPAR { $$ = 0;}
              ;

functions_args_list: functions_arg { $$ = 1; }
                   | functions_args_list COMMA functions_arg { $$ = $1 + 1; }
                   ;

functions_arg: TYPE_INT LABEL { yyerror("function arguments not implemented"); free($2); }
             ;



/* Gestion ses opérations */

number: STATIC_INT { $$ = NULL; number_copy($$, $1); }
      | LABEL { $$ = $1; }
      | callable { $$ = NULL; }
      | LPAR operators RPAR { $$ = $2; }
      ;

unary: number { $$ = $1 ; }
     | SUB number { $$ = NULL; negate($$, $2); free($2); }
     ;

multiplicative: unary { $$ = $1 ; }
              | multiplicative MUL unary { $$ = NULL; multiply($$, $1, $3); free($1); free($3); }
              | multiplicative DIV unary { $$ = NULL; divide($$, $1, $3); free($1); free($3); }
              ;

additive: multiplicative { $$ = $1 ; }
        | additive ADD multiplicative { $$ = NULL; add($$, $1, $3); free($1); free($3); }
        | additive SUB multiplicative { $$ = NULL; subtract($$, $1, $3); free($1); free($3); }
        ;

relational: additive { $$ = $1 ; }
          | relational GRT additive { $$ = NULL; greater_than($$, $1, $3); free($1); free($3); }
          | relational LOW additive { $$ = NULL; lower_than($$, $1, $3); free($1); free($3); }
          ;

equality: relational { $$ = $1 ; }
        | equality EQ  relational { $$ = NULL; equal_to($$, $1, $3); free($1); free($3); }
        ;

operators: equality { $$ = $1 ; }
         | LABEL ASSIGN operators { var_copy($1, $3); $$ = $1; free($3); }
         ;


/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: defvar
            | defvars_list COMMA defvar
            ;

defvar: LABEL { number_define($1, 0) ; free($1); }
      | LABEL ASSIGN operators { var_define($1, $3); free($1); free($3); }
      ;


/* Gestion des appel de fonction */

callable: LABEL callable_args { go_function($1); free($1); }
        ;

callable_args: LPAR callable_args_list RPAR { $$ = $2; }
             | LPAR RPAR { $$ = 0; }
             ;

callable_args_list: operators { $$ = 1; free($1); }
                  | callable_args_list COMMA operators { $$ = $1 + 1; free($3); }
                  ;

return: tRETURN operators { free($2); }
      ;

%%