
.SUFFIXES:

SLANG_FOLDER=./sauce-os
SLANG_LIBS=${SLANG_FOLDER}/compiler/utils/utils.slang ${SLANG_FOLDER}/compiler/utils/strlib.slang ${SLANG_FOLDER}/compiler/utils/datatypes.slang ${SLANG_FOLDER}/compiler/utils/sorting.slang ${SLANG_FOLDER}/runtime/std.slang aoclib.slang

all: 01/day1.exe 02/day2.exe 03/day3.exe 04/day4.exe 05/day5.exe 06/day6.exe 07/day7.exe 08/day8.exe

%.exe: %.o runtime.o aoclib-c.o
	gcc -o $@ $< runtime.o aoclib-c.o -lm

%.o: %.c
	gcc ${CFLAGS} -c -o $@ $<

%.c: %.slang ${SLANG_LIBS}
	slangc --backend-c -o $@ ${SLANG_LIBS} $<

runtime.o: ${SLANG_FOLDER}/runtime/runtime.c
	gcc ${CFLAGS} -c -o $@ $<

aoclib-c.o: aoclib-c.c
	gcc ${CFLAGS} -c -o $@ $<

.PRECIOUS: %.c
