CC ?= gcc
# CFLAGS += -Wall
CFLAGS += -Wall -Werror -fsanitize=address

BIN_DIR := bin
GEN_DIR := gen
OBJ_DIR := obj
SRC_DIR := src

LEXER = lexer
GRAMMAR = grammar

all: ${GEN_DIR} ${BIN_DIR} ${BIN_DIR}/lab4

${BIN_DIR}:
	mkdir ${BIN_DIR} 

${GEN_DIR}:
	mkdir ${GEN_DIR}

${BIN_DIR}/lab4: ${GEN_DIR}/${LEXER}.c ${GEN_DIR}/${GRAMMAR}.c
	${CC} -lm -g ${CFLAGS} ${GEN_DIR}/${GRAMMAR}.c ${GEN_DIR}/${LEXER}.c -I./gen/ -o ${BIN_DIR}/lab4

${GEN_DIR}/${LEXER}.c: ${GEN_DIR} ${SRC_DIR}/${LEXER}.l
	flex --header-file=${GEN_DIR}/${LEXER}.h -o ${GEN_DIR}/${LEXER}.c ${SRC_DIR}/${LEXER}.l

${GEN_DIR}/${GRAMMAR}.c: ${GEN_DIR} ${SRC_DIR}/${GRAMMAR}.y
	bison ${SRC_DIR}/${GRAMMAR}.y --defines=${GEN_DIR}/${GRAMMAR}.h -o ${GEN_DIR}/${GRAMMAR}.c

${OBJ_DIR}:
	mkdir ${OBJ_DIR}

clean:
	rm -fr ${BIN_DIR}
	rm -fr ${GEN_DIR}
