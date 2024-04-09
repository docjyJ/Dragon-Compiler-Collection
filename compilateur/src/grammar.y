%{
#include "instruction_set.h"
#include "stack.branch.h"
#include "stack.function.h"
#include "stack.instruction.h"
#include "stack.variable.h"

int yylex();
%}

%union {
  char *s;
  unsigned short i;
}

%token <s> LABEL
%token <i> STATIC_INT
%token IF ELSE DO WHILE PRINT TYPE_INT TYPE_VOID MAIN RETURN
%token LPAR RPAR LBRACE RBRACE LBRACKET RBRACKET
%token ADD SUB MUL DIV MOD
%token LOWEQ GRTEQ LOW GRT EQ NEQ
%token LNOT LAND LOR
%token BNOT BAND BXOR BOR
%token ASSIGN COMMA END

%type <s> number unary multiplicative additive relational equality bitwise_and bitwise_xor bitwise_or operators
%type <s> label_pointer pointer table callable
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

functions_arg: TYPE_INT label_pointer { yyerror("function arguments not implemented"); free($2); }
             ;



/* Gestion ses opérations */
table: LABEL { $$ = $1; }
     | callable { $$ = NULL; }
     | table LBRACKET operators RBRACKET { $$ = NULL; load($$, $1, $3); free($1); free($3); }
     | LPAR operators RPAR { $$ = $2; }
     ;

pointer: table { $$ = $1; }
       | MUL pointer { $$ = NULL; load_0($$, $2); free($2); }
       ;

number: STATIC_INT { $$ = NULL; number_copy($$, $1); }
      | pointer { $$ = $1; }
      ;

unary: number { $$ = $1 ; }
     | ADD unary { $$ = $2; }
     | SUB unary { $$ = NULL; negate($$, $2); free($2); }
     | BNOT unary { $$ = NULL; bitwise_not($$, $2); free($2); }
     | LNOT unary { $$ = NULL; yyerror("logical not not implemented"); free($2); }
     | MUL BAND number { $$ = $3; }
     | BAND LABEL { $$ = NULL; number_copy($$, var_get($2)); free($2); }
     ;

multiplicative: unary { $$ = $1 ; }
              | multiplicative MUL unary { $$ = NULL; multiply($$, $1, $3); free($1); free($3); }
              | multiplicative DIV unary { $$ = NULL; divide($$, $1, $3); free($1); free($3); }
              | multiplicative MOD unary { $$ = NULL; modulo($$, $1, $3); free($1); free($3); }
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

bitwise_and: equality { $$ = $1 ; }
        | bitwise_and BAND equality { $$ = NULL; bitwise_and($$, $1, $3); free($1); free($3); }
        ;
bitwise_xor: bitwise_and { $$ = $1 ; }
        | bitwise_xor BXOR bitwise_and { $$ = NULL; bitwise_xor($$, $1, $3); free($1); free($3); }
        ;

bitwise_or: bitwise_xor { $$ = $1 ; }
        | bitwise_or BOR bitwise_xor { $$ = NULL; bitwise_or($$, $1, $3); free($1); free($3); }
        ;

operators: bitwise_or { $$ = $1 ; }
         | LABEL ASSIGN operators { var_copy($1, $3); $$ = $1; free($3); }
         | table LBRACKET operators RBRACKET ASSIGN operators { store($1, $3, $6); $$ = $1; free($3); free($6); }
         | MUL pointer ASSIGN operators { store_0($2, $4); $$ = $2; free($4); }
         ;


/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: defvar
            | defvars_list COMMA defvar
            ;

defvar: label_pointer { number_define($1, 0) ; free($1); }
      | label_pointer ASSIGN operators { var_define($1, $3); free($1); free($3); }
      | LABEL LBRACKET STATIC_INT RBRACKET { tab_define($1, $3); free($1); }
      ;

label_pointer: LABEL { $$ = $1; }
             | MUL label_pointer { $$ = $2; }
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

return: RETURN operators { free($2); }
      ;

%%