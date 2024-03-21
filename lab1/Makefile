CC = gcc
CFLAGS += -Wall -Werror -fsanitize=address -std=c11

BIN_DIR := bin
GEN_DIR := gen
OBJ_DIR := obj

.ONESHELL:
SHELL := /bin/bash

all: ${BIN_DIR}
	${CC} ${CFLAGS} src/main.c -o ${BIN_DIR}/lab1

${BIN_DIR}:
	mkdir ${BIN_DIR} 

${GEN_DIR}:
	mkdir ${GEN_DIR}

${OBJ_DIR}:
	mkdir ${OBJ_DIR}

clean:
	if [ -d "${BIN_DIR}" ]; then
		# echo "${BIN_DIR} does exist.";
		rm -r ${BIN_DIR};
		echo "Directory ${BIN_DIR} was removed";
	else
		 echo "Directory ${BIN_DIR} doesn't exist.";
	fi
	# rm -r ${BIN_DIR} # ${GEN_DIR} ${OBJ_DIR}
