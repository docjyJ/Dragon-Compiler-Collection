SRC_DIR = ./src/


GCC=gcc -Wall -Wextra -Iinclude/
YACC=bison -Wall -Wcounterexamples -rnone -kt
LEX=flex

TARGET = ./dcc
GCC_TEST = gcc -Itest/

LEX_SRC = lexer.l
YACC_SRC = grammar.y
C_SRC = app.c memory.c instruction_set.c stack.branch.c stack.function.c stack.instruction.c stack.variable.c stack.var_global.c
TEST_SRC = rapport.c arithmetic.c conditional.1.c  fonction.1.c fonction.2.c pointer.c var_global.c

C_GEN = $(YACC_SRC:.y=.tab.c) $(LEX_SRC:.l=.yy.c)
OBJS = $(C_SRC:.c=.o) $(C_GEN:.c=.o)

.DEFAULT: dcc
.PHONY: clean full-clean all emulate %-emulate test %-test rapport %-rapport open-diag %-open-diag
.PRECIOUS: %.s %.out

all: test emulate rapport

rapport: $(YACC_SRC:.y=-rapport)

open-diag: $(YACC_SRC:.y=-open-diag)

test: clean $(TEST_SRC:.c=-test)

emulate: clean $(TEST_SRC:.c=-emulate)

%-emulate: %.s
	@echo --------------------------------
	@echo Execution de $<
	@echo --------------------------------
	@./qemu-latias $<
	@echo --------------------------------

%-test: %.out %.s
	@echo --------------------------------
	@echo Comparaison de $^
	@echo --------------------------------
	./$*.out > test/$*.gcc.report || true
	./qemu-latias $*.s > test/$*.emulate.report
	@diff test/$*.gcc.report test/$*.emulate.report
	@echo --------------------------------

%.s: test/%.c $(TARGET)
	$(TARGET) -sa -o $@ $<

%.out: test/%.c
	$(GCC_TEST) -o $@ $<

$(TARGET): $(C_GEN:%=src/%) $(OBJS)
	$(GCC) -o$(TARGET) $(OBJS)

$(TARGET).debug: clean $(C_GEN:%=src/%)
	$(GCC) -g -o$(TARGET).debug $(C_SRC:%=src/%) $(C_GEN:%=src/%)

%.o: src/%.c
	$(GCC) -o $@ -c $<

src/%.tab.c: src/%.y
	$(YACC) -o$@ -Hinclude/$*.tab.h $<

%-rapport: src/%.y
	bison --html=$*.html -g$*.dot $<
	dot -Tsvg -o$*.automat.svg $*.dot
	wkhtmltoimage -f svg $*.html $*.rapport.svg
	rm $*.html $*.dot $*.xml

%-open-diag: src/%.y
	bison --html=$*.rapport.html $<
	rm $*.xml
	xdg-open file://$(shell pwd)/$*.rapport.html

src/%.yy.c: src/%.l
	$(LEX) -o$@ --header-file=include/$*.yy.h $<

clean:
	rm -f *.report *.out *.s *.o src/*.tab.c include/*.tab.h src/*.yy.c include/*.yy.h dcc dcc.debug

full-clean: clean
	rm -f *.rapport.html test/*.report *csv .~lock.* *.output *.xml
