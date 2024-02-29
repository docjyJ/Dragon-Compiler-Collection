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
%token tIF tELSE tWHILE tPRINT tRETURN tINT tVOID tADD tSUB tMUL tDIV tLT tGT tNE tEQ tLE tGE tASSIGN tAND tOR tNOT tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA tERROR

%%

globals:
    %empty
  | funs globals
  | defvars tCOMMA globals { printf("get a global var\n"); }
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
  | tIF tLPAR boolean tRPAR tLBRACE boddies tRBRACE tELSE tLBRACE boddies tRBRACE { printf("get a if-else"); }
  | tIF tLPAR boolean tRPAR tLBRACE boddies tRBRACE { printf("get a if"); }
  | tWHILE tLPAR boolean tRPAR tLBRACE boddies tRBRACE { printf("get a while"); }
  ;

defvars:
    tINT tID { printf("get a int var: %s\n", $2); }
  ;

boolean:
    | tID { printf("get a boolean var: %s\n", $1); }
    | tID tEQ tID { printf("get an equality %s = %s\n", $1, $3); }
    | tID tNE tID { printf("get a non-equality %s != %s\n", $1, $3); }
    | tID tGT tID { printf("get a greter-than %s > %s\n", $1, $3); }
    | tID tLT tID { printf("get a lower-than %s < %s\n", $1, $3); }
    | tID tGE tID { printf("get a greater or equals %s >= %s\n", $1, $3); }
    | tID tLE tID { printf("get a lower or equals %s <= %s\n", $1, $3); }
  ;

%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: %s\n", msg);
  exit(1);
}

int main(void) {
  yyparse();
}
