%{
#include "instruction_set.h"
#include "stack.branch.h"
#include "stack.function.h"
#include "stack.instruction.h"
#include "stack.variable.h"
#include "stack.var_global.h"

int yylex();
%}

%union {
  char *s;
  unsigned short i;
}

%token <s> LABEL
%token <i> STATIC_INT
%token IF ELSE DO WHILE PRINT READ TYPE_INT TYPE_VOID MAIN RETURN
%token LPAR RPAR LBRACE RBRACE LBRACKET RBRACKET IOMOST IOLEAST
%token ADD SUB MUL DIV MOD
%token LOWEQ GRTEQ LOW GRT EQ NEQ
%token LNOT LAND LOR
%token BNOT BAND BXOR BOR
%token ASSIGN COMMA END

%type <s> number unary multiplicative additive relational equality bitwise_and bitwise_xor bitwise_or operators
%type <s> label_pointer_arg label_pointer pointer table callable

%%

global : global_code_list {part_var_global(); print_instruction();}
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
              | return END
              ;

code_one_line: operators END { free($1); }
             | defvars END
             | if { end_branch(1); }
             | while_do { end_branch(0); end_branch(0); }
             | PRINT LPAR IOMOST COMMA operators RPAR END { display(0, $5); free($5); }
             | PRINT LPAR IOLEAST COMMA operators RPAR END { display(1, $5); free($5); }
             | END
             ;



code_line: code_one_line
         | if else { end_branch(0); }
         ;


init_cond: LPAR operators RPAR { start_if($2); free($2); };
init_else: %empty { end_branch(0); start_else(); };
init_loop: %empty { start_loop(); };

single_boddy: code_block | code_one_line;
chain_boddy: code_block | code_line;

if: IF init_cond single_boddy;
else: ELSE init_else chain_boddy;
while_do: WHILE init_loop init_cond single_boddy
        | DO init_loop code_block WHILE init_cond END
        ;


/* Gestion des fonctions */

functions: functions_header_void code_block { end_function(); }
         | functions_header_main code_block
         | functions_header_int code_block
         ;

functions_header_void: TYPE_VOID function_name functions_args
                     ;

functions_header_int: TYPE_INT function_name functions_args
                ;

functions_header_main: TYPE_INT main_name functions_args
                     | TYPE_VOID main_name functions_args
                     ;

function_name : LABEL { start_function($1); free($1); }
              ;

main_name : MAIN {  start_function("main"); }
          ;


functions_args: LPAR functions_args_list RPAR
              | LPAR TYPE_VOID RPAR
              | LPAR RPAR
              ;

functions_args_list: functions_arg
                   | functions_args_list COMMA functions_arg
                   ;

functions_arg: TYPE_INT label_pointer_arg { add_param($2); free($2); }
             ;

label_pointer_arg: LABEL { $$ = $1; }
                 | MUL label_pointer_arg { $$ = $2; }
                 ;


/* Gestion ses opérations */
table: LABEL { $$ = $1; }
     | table LBRACKET operators RBRACKET { $$ = NULL; load_offset($$, $1, $3); free($1); free($3); }
     | LPAR operators RPAR { $$ = $2; }
     ;

pointer: table { $$ = $1; }
       | MUL pointer { $$ = NULL; load($$, $2); free($2); }
       ;

number: STATIC_INT { $$ = NULL; number_copy($$, $1); }
      | pointer { $$ = $1; }
      | callable {$$ = NULL; }
      | READ LPAR IOMOST RPAR { $$ = NULL; get_input(0, $$); }
      | READ LPAR IOLEAST RPAR { $$ = NULL; get_input(1, $$); }
      ;

unary: number { $$ = $1 ; }
     | ADD unary { $$ = $2; }
     | SUB unary { $$ = NULL; negate($$, $2); free($2); }
     | BNOT unary { $$ = NULL; bitwise_not($$, $2); free($2); }
     | LNOT unary { $$ = NULL; yyerror("logical not not implemented"); free($2); }
     | MUL BAND number { $$ = $3; }
     | BAND LABEL { $$ = NULL; var_to_address($$, $2); free($2); }
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
         | table LBRACKET operators RBRACKET ASSIGN operators { store_offset($1, $3, $6); $$ = $1; free($3); free($6); }
         | MUL pointer ASSIGN operators { store($2, $4); $$ = $2; free($4); }
         ;





/* Gestion des variable */

defvars: TYPE_INT defvars_list
      ;

defvars_list: defvar
            | defvars_list COMMA defvar
            ;

defvar: label_pointer { free($1); }
      | label_pointer ASSIGN operators { var_copy($1, $3); free($1); free($3); }
      | LABEL LBRACKET STATIC_INT RBRACKET { tab_define($1, $3); free($1); }
      ;

label_pointer: LABEL { number_define($1, 0) ; $$ = $1; }
             | MUL label_pointer { $$ = $2; }
             ;


/* Gestion des appel de fonction */

callable: callable_name callable_args { end_go_function(); }
        ;

callable_name : LABEL { go_function($1); free($1); }
       ;

callable_args: LPAR callable_args_list RPAR
             | LPAR RPAR
             ;

callable_args_list: callable_arg
                  | callable_arg COMMA callable_args_list
                  ;

callable_arg : operators {give_param($1); free($1); };

return: RETURN operators { return_var($2); free($2); }
      ;

%%
