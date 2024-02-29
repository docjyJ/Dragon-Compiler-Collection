%{
#include <stdio.h>
#include <stdlib.h>
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

%token <s> tID
%token <i> tNB
%token tIF tELSE tWHILE tPRINT tRETURN tINT tVOID tADD tSUB tMUL tDIV tLT tGT tNE tEQ tLE tGE tASSIGN tAND tOR tNOT tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA tERROR

%type <s> callname

%%

globals:
    %empty
  | funs globals
  ;

boddies:
    %empty
  | operators tSEMI boddies
  | defvars tSEMI boddies
  | tIF tLPAR operators tRPAR tLBRACE boddies tRBRACE tELSE tLBRACE boddies tRBRACE boddies { printf("get a if-else\n"); }
  | tWHILE tLPAR operators tRPAR tLBRACE boddies tRBRACE boddies { printf("get a while\n"); }
  ;



/* Gestion des fonctions */

funs:
    funtypes tID tLPAR funargs tRPAR tLBRACE boddies tRBRACE { printf("get a function: %s\n", $2); }
  ;

funtypes:
    tVOID { printf("get a void type\n"); }
  | tINT { printf("get a int type\n"); }
  ;

funargs:
    %empty { printf("get no args\n"); }
  | tVOID { printf("get no args\n"); }
  | defargs { printf("get a args\n"); }
  ;

defargs:
    defvars tCOMMA defargs
  | defvars
  ;



/* Gestion des définition de variables */

defvars:
    tINT tID { printf("get a new int var: %s\n", $2); }
  ;



/* Gestion de l'appel de fonction / opérations */

operators:
    tID tASSIGN operators { printf("get a assign: %s\n", $1); }
  | operands
  | operands tADD operators { printf("get a add\n"); }
  | operands tMUL operators { printf("get a sub\n"); }
  | operands tEQ operators { printf("get a equal\n"); }
  | operands tLT operators { printf("get a lower\n"); }
  | operands tGT operators { printf("get a greater\n"); }
  ;

operands:
    callable
  | tID { printf("get a var: %s\n", $1); }
  | tNB { printf("get a number: %d\n", $1); }
  ;

callable:
    tPRINT tLPAR operators tRPAR { printf("get a call: print\n"); }
  | tID tLPAR callargs tRPAR { printf("get a call: %s\n", $1); }
  ;

callargs:
    %empty
  | operators tCOMMA callargs
  ;

%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
  exit(1);
}

int main(void) {
  yyparse();
}
