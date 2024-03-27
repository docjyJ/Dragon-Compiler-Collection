#ifndef TRAD_ARM
#define TRAD_ARM

void fun(char *name);

void end_fun();

void define_affectation(char *a, int b);

void affectation(char *a, int b);

void add(char *a, char *b);

void sous(char *a, char *b);

void mul(char *a, char *b);

void divide(char *a, char *b);

void and(char *a, char *b);

void or(char *a, char *b);

void inf(char *a, char *b);

void sup(char *a, char *b);

void equ(char *a, char *b);

void start_jump (char* a);

void end_jump ();

void start_jump_reverse ();

void end_jump_reverse (char* b);

void print_instruction ();
void define_copie(char *a, char *b);

void copie(char *a, char *b);

#endif