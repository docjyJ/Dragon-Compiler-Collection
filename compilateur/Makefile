GCC=gcc -Wall -Wextra
YACC=bison -tvd
LEX=flex

DEPS = grammar.tab.h traducteur_ARM.h table_symbole.h
OBJ = grammar.tab.o lexer.yy.o traducteur_ARM.o table_symbole.o main.o

.DEFAULT: dcc
.PHONY: clean

first_test.s: clean dcc
	./dcc -o first_test.s first_test.c

demo: first_test.s
	python3 demo.py > demo

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