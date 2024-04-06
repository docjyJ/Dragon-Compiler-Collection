SRC_DIR = ./src/


GCC=gcc -Wall -Wextra -Iinclude/
YACC=bison -Wall -rall -kt
LEX=flex

TARGET = ./dcc

LEX_SRC = lexer.l
YACC_SRC = grammar.y
C_SRC = traducteur_ARM.c variable_manager.c error_memory.c main.c
TEST_SRC = first_test.c

C_GEN = $(YACC_SRC:.y=.tab.c) $(LEX_SRC:.l=.yy.c)
OBJS = $(C_SRC:.c=.o) $(C_GEN:.c=.o)

.DEFAULT: dcc
.PHONY: clean all test %-emulate
.PRECIOUS: %.s

all: test

test: clean $(TEST_SRC:.c=-emulate)

%-emulate: %.s
	@echo --------------------------------
	@echo Execution de $<
	@echo --------------------------------
	python3 emulator.py $<
	@echo --------------------------------

%.s: test/%.c $(TARGET)
	$(TARGET) -o $@ $<


$(TARGET): $(C_GEN:%=src/%) $(OBJS)
	$(GCC) -o$(TARGET) $(OBJS)

%.o: src/%.c
	$(GCC) -o $@ -c $<

src/%.tab.c: src/%.y
	$(YACC) -o $@ -Hinclude/$*.tab.h --report-file=$*.report $<

src/%.yy.c: src/%.l
	$(LEX) -o$@ --header-file=include/$*.yy.h $<

clean:
	rm -f *.report *.s *.o src/*.tab.c include/*.tab.h src/*.yy.c include/*.yy.h dcc