default: dcc.out

all: test default

test: default
	echo '<div>aaa<div>bbb</div></div>' | ./dcc.out

clean:
	rm *.out *.tab.c *.tab.h *.yy.c *.output

%.tab.c: %.y
	bison -t -v -d $^

%.yy.c: %.l
	flex -o $@ $^

%.out: %.yy.c %.tab.c
	gcc -o $@ $^