#ifndef STACK_H
#define STACK_H

typedef struct stack_t stack_t;

static stack_t *create_node(void *data, int size, stack_t *prev_node);

void push(stack_t **stack, void *data, int size);

void pop(stack_t **stack);

void clear(stack_t **stack);

#endif STACK_H
