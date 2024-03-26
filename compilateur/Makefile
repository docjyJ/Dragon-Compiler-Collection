default: dcc.out

all: default

first_test.s: clean default
	cat first_test.c | ./dcc.out 2> first_test.s


clean:
	rm -f *.out *.tab.c *.tab.h *.yy.c *.output

%.tab.c: %.y
	bison -t -v -d $^

%.yy.c: %.l
	flex -o $@ $^

dcc.out: dcc.yy.c dcc.tab.c traducteur_ARM.c table_symbole.c
	gcc -o $@ $^

.PRECIOUS: %.yy.c %.tab.c
