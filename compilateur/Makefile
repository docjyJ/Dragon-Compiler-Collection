GCC=gcc -Wall -Wextra -Iinclude/
YACC=bison -Wall -rall -kt
LEX=flex

INC = include/lexer.yy.h include/grammar.tab.h
OBJ = grammar.tab.o lexer.yy.o traducteur_ARM.o table_symbole.o error_memory.o main.o

.DEFAULT: dcc
.PHONY: clean

all: demo

demo: first_test.s
	@echo --------------------------------
	@echo Execution de $<
	@echo --------------------------------
	python3 emulator.py $<
	@echo --------------------------------

first_test.s: clean dcc
	./dcc -o $@ test/$*.c


dcc: $(INC) $(OBJ)
	$(GCC) -o $@  $(OBJ)

%.o: src/%.c
	$(GCC) -o $@ -c $<

src/%.tab.c include/%.tab.h: src/%.y
	$(YACC) -o src/$*.tab.c -Hinclude/$*.tab.h --report-file=$*.report $<

src/%.yy.c include/%.yy.h: src/%.l
	$(LEX) -o src/$*.yy.c --header-file=include/$*.yy.h $<

clean:
	rm -f *.report *.s *.o src/*.tab.c include/*.tab.h src/*.yy.c include/*.yy.h dcc