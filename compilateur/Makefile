default: dcc.out

all: default

first_test.s: clean default
	./dcc -o first_test.s first_test.c

dcc: grammar.tab.o lexer.yy.o traducteur_ARM.o table_symbole.o main.c
	gcc -Wall -o $@ $^

%.o : %.c
	gcc -Wall -c $<

%.tab.c: %.y
	bison -tvd $<

%.yy.c: %.l
	flex -o $@ $<

clean:
	rm -f *.out *.output *.s *.o *.tab.c *.tab.h *.yy.c dcc