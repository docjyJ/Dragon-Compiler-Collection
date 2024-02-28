%{
#include <stdio.h>
#include <stdlib.h>
%}

%code provides {
  int yylex (void);
  void yyerror (const char *);
}

%union { char *s; }

%token <s> tID
%token tVOID tINT tLPAR tRPAR tLBRACE tRBRACE tSEMI tASSIGN tERROR tCOMMA

%%

globals:
    %empty
  | funs globals
  ;




funs:
    funtypes tID tLPAR funargs tRPAR tLBRACE boddies tRBRACE { printf("get a function: %s\n", $2); }
  ;

funtypes:
    tVOID { printf("get a void type\n"); }
  | tINT { printf("get a int type\n"); }

funargs:
    %empty { printf("get no args\n"); }
  | tVOID { printf("get no args\n"); }
  | defargs { printf("get a args\n"); }
  ;

defargs:
    defvars tCOMMA defargs
  | defvars
  ;




boddies:
    %empty
  | defvars tSEMI boddies { printf("get a local var\n"); }
  ;

defvars:
    tINT tID { printf("get a int var: %s\n", $2); }
  ;





%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: %s\n", msg);
  exit(1);
}

int main(void) {
  yyparse();
}
