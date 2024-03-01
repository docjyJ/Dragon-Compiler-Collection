default: dcc.out

all: test default

test: default
	cat test2.c | ./dcc.out


clean:
	rm -f *.out *.tab.c *.tab.h *.yy.c *.output

%.tab.c: %.y
	bison -t -v -d $^

%.yy.c: %.l
	flex -o $@ $^

%.out: %.yy.c %.tab.c
	gcc -o $@ $^

.PRECIOUS: %.yy.c %.tab.c
