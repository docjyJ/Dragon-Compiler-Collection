GCC=gcc -Wall -Wextra
YACC=bison -tvd
LEX=flex

DEPS = grammar.tab.h traducteur_ARM.h table_symbole.h error_memory.h
OBJ = grammar.tab.o lexer.yy.o traducteur_ARM.o table_symbole.o error_memory.o main.o

.DEFAULT: dcc
.PHONY: clean

all: demo

first_test.s: clean dcc
	./dcc -o first_test.s first_test.c

demo: first_test.s
	echo "Execution de first_test.s"
	python3 demo.py
	echo "Fin de l'execution"

dcc: $(OBJ)
	$(GCC) -o $@ $^

%.o: %.c
	$(GCC) -o $@ -c $<

%.tab.c %.tab.h: %.y
	$(YACC) -o $@ $<

%.yy.c: %.l
	$(LEX) -o $@ $<

clean:
	rm -f *.out *.output *.s *.o *.tab.c *.tab.h *.yy.c dcc demo