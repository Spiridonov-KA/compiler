#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct stack_t {
	void *data;
	struct stack_t *next;
} stack_t;

static stack_t *create_node(void *data, int size, stack_t *prev_node) {
	stack_t *res = (stack_t *) malloc(sizeof(stack_t));
	res->data = (void *) malloc(size);
	memcpy(res->data, data, size);
	res->next = prev_node;
	return res;
}

void push(stack_t **stack, void *data, int size) {
	stack_t *new_node = create_node(data, size, *stack);
	*stack = new_node;
}

void pop(stack_t **stack) {
	stack_t *new_head = (*stack)->next;
	free((*stack)->data);
	free(*stack);
	*stack = new_head;
}

void clear(stack_t **stack) {
	while (*stack != NULL) {
		pop(stack);
	}
}
