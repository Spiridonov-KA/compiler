CC ?= gcc
# CFLAGS += -Wall
CFLAGS += -Wall -Werror -fsanitize=address

BIN_DIR := bin
GEN_DIR := gen
OBJ_DIR := obj
SRC_DIR := src

FILE = main

all: ${GEN_DIR} ${BIN_DIR} ${BIN_DIR}/lab2

${BIN_DIR}:
	mkdir ${BIN_DIR} 

${GEN_DIR}:
	mkdir ${GEN_DIR}

${BIN_DIR}/lab2: ${GEN_DIR}/${FILE}.c
	${CC} -lm ${CFLAGS} ${GEN_DIR}/${FILE}.c -o ${BIN_DIR}/lab2

${GEN_DIR}/${FILE}.c: ${GEN_DIR} ${SRC_DIR}/${FILE}.l
	flex --header-file=${GEN_DIR}/${FILE}.h -o ${GEN_DIR}/${FILE}.c ${SRC_DIR}/${FILE}.l

${OBJ_DIR}:
	mkdir ${OBJ_DIR}

clean:
	rm -r ${BIN_DIR}
	rm -r ${GEN_DIR}
