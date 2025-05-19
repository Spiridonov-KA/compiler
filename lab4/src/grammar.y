%{

#include <stdio.h>
#include <math.h>
#include <assert.h>
#include "lexer.h"

int current_line = 1;

int yylex (void);
void yyerror (char const *);

typedef enum {
	PROGRAM_T,
	IDENTIFIER_T,
	ILIT_T,
	CALL_T,
	ASSIGN_T,
	PLUS_T, MINUS_T, MUL_T, DIV_T, UNARY_MINUS_T, UNARY_PLUS_T
} NODE_T;

typedef struct node_t {
	NODE_T type;
	char *value;
	int num_children;
	struct node_t **children;
} node_t;

void free_node(void *node) {
}

typedef struct stack_t {
	void *data;
	int size;
	struct stack_t *next;
} stack_t;

static stack_t *create_node(void *data, int size, stack_t *prev_node) {
	stack_t *res = (stack_t *) malloc(sizeof(stack_t));
	res->data = data;
	res->next = prev_node;
	return res;
}

void push(stack_t **stack, void *data, int size) {
	stack_t *new_node = create_node(data, size, *stack);
	new_node->size = (*stack)->size + 1;
	*stack = new_node;
}

void pop(stack_t **stack, void (*free_data)(void *)){
	stack_t *new_head = (*stack)->next;
	(*free_data)((*stack)->data);
	free(*stack);
	*stack = new_head;
}

void clear(stack_t **stack, void (*free_data)(void *), int n) {
	for (int i = 0; i < n; ++i) {
		assert((*stack)->next != NULL);
		pop(stack, free_data);
	}
}

void init_stack(stack_t **stack) {
	*stack = (stack_t *)malloc(sizeof(stack_t));
	(*stack)->next = NULL;
	(*stack)->size = 0;
	(*stack)->data = NULL;
}

node_t *tree;
stack_t *node_stack = NULL;

typedef struct {
	int num_params;
	char *name;
} function_t;

void free_function(void *fun) {
	free(((function_t *)fun)->name);
	free(fun);
}

stack_t *function_stack = NULL;

void init_function(char *name) {
	function_t *fun = (function_t *)malloc(sizeof(function_t));
	fun->num_params = 0;
	fun->name = (char *)malloc(sizeof(char) * strlen(name) + 1);
	sprintf(fun->name, "%s", name);
	push(&function_stack, fun, sizeof(function_t));
}

void increment_params() {
	assert(function_stack->size >= 0);
	++((function_t *)function_stack->data)->num_params;
}

void rm_function() {
	pop(&function_stack, free_function);
}

char *get_fun_name() {
	return ((function_t *)function_stack->data)->name; 
}

int get_fun_params() {
	return ((function_t *)function_stack->data)->num_params;
}

void fill_value(node_t *node, char *value) {
	if (value == NULL) {
		node->value = NULL;
		return;
	}
	int size_of_len = strlen(value);
	node->value = (char *)malloc(size_of_len + 1);
	strcpy(node->value, value);
}

node_t *init_node(NODE_T type, char *value) {
	node_t *node = (node_t *)malloc(sizeof(node_t));
	node->type = type;
	fill_value(node, value);
	return node;
}

void add_children(node_t *node, int n) {
	node->children = (node_t **)malloc(n * sizeof(node_t *));
	node->num_children = n;
	for (int i = 0; i < n; ++i) {
		node->children[i] = node_stack->data;
		pop(&node_stack, free_node);
	}
}

void add_node_in_tree(NODE_T type, char *value) {
	node_t *node = init_node(type, value);
	switch(type) {
		case UNARY_MINUS_T:
		case UNARY_PLUS_T:
			add_children(node, 1); break;
		case PLUS_T:
		case MINUS_T:
		case MUL_T:
		case DIV_T:
		case ASSIGN_T:
			add_children(node, 2); break;
		case PROGRAM_T:
			add_children(node, node_stack->size); break;
		case CALL_T:
			add_children(node, get_fun_params()); break;

		default: break;
	}
	push(&node_stack, node, sizeof(node_t));
}

#define NAME_SIZE 10000
char str_type[NAME_SIZE];
int get_str_type(NODE_T type) {
	switch(type) {
		case PROGRAM_T: return sprintf(str_type, "%s", "PROGRAM");
		case IDENTIFIER_T: return sprintf(str_type, "%s", "IDENTIFIER");
		case ILIT_T: return sprintf(str_type, "%s", "ILIT");
		case UNARY_PLUS_T:
		case PLUS_T: return sprintf(str_type, "%s", "PLUS");
		case UNARY_MINUS_T:
		case MINUS_T: return sprintf(str_type, "%s", "MINUS");
		case MUL_T: return sprintf(str_type, "%s", "MUL");
		case DIV_T: return sprintf(str_type, "%s", "DIV");
		case CALL_T: return sprintf(str_type, "%s", "CALL");
		case ASSIGN_T: return sprintf(str_type, "%s", "ASSIGN");
		default: return -1;
	}
	return -1;
}

char is_leaf(NODE_T type) {
	switch(type) {
		case ILIT_T:
		case IDENTIFIER_T: return 1;
		default: return 0;
	}
	return 0;
}

char is_fun(NODE_T type) {
	switch(type) {
		case CALL_T: return 1;
		default: return 0;
	}
	return 0;
}

char is_assign(NODE_T type) {
	switch(type) {
		case ASSIGN_T: return 1;
		default: return 0;
	}
	return 0;
}

char is_identifier(node_t *node) {
	switch (node->type) {
		case IDENTIFIER_T: return 1;
		default: return 0;
	}
	return 0;
}

char is_ilit(node_t *node) {
	switch (node->type) {
		case ILIT_T: return 1;
		default: return 0;
	}
	return 0;
}

void print_node(node_t *node, char *is_last, int d) {
	if (*is_last) {
		if (d > 1)
			printf(" ");
		for (int i = 1; i < d - 1; ++i) {
			printf("| ");
		}
	}
	else {
		for (int i = 0; i < d - 1; ++i) {
			printf("| ");
		}
	}
	if (node->type != PROGRAM_T)
		printf("|-");
	int res = get_str_type(node->type);
	assert(res != -1);
	if (is_identifier(node) || is_fun(node->type)) {
		printf("<%s, \"%s\">\n", str_type, node->value);
	}
	else if (is_ilit(node)) {
		printf("<%s, %s>\n", str_type, node->value);
	}
	else {
		printf("<%s>\n", str_type);
	}
}

void print_subtree(node_t *node, char *is_last, int d) {
	// r - number of row
	// d - depth of tree
	print_node(node, is_last, d);
	if (is_leaf(node->type))
		return;
	for (int i = node->num_children - 1; i >= 0; --i) {
		if (node->type == PROGRAM_T && i == 0) *is_last = 1;
		print_subtree(node->children[i], is_last, d + 1);
	}
}

void print_tree(node_t *node) {
	char is_last = 0;
	print_subtree(node, &is_last, 0);	
}

void delete_node(node_t *node) {
	if (is_leaf(node->type)) {
		free(node->value);
		free(node);
		return;
	}
	for (int i = node->num_children - 1; i >= 0; --i) {
		delete_node(node->children[i]);
	}
	free(node->value);
	free(node->children);
	free(node);
}

void delete_tree(node_t *node) {
	delete_node(node);
}

%}

%define api.value.type {char *};
%token NUM
%token IDENTIFIER
%token LPARENT
%token RPARENT
%token PLUS MINUS MUL DIV
%token COMMA
%token ASSIGN
%token ERROR
%token END_OF_LINE

%left PLUS MINUS
%left MUL DIV

%%

program: input { add_node_in_tree(PROGRAM_T, NULL); };

input: %empty     {}
	 | input line {}
	 ;

line: END_OF_LINE				{ ++current_line; }
	| exp END_OF_LINE			{ ++current_line; }
	| assignment END_OF_LINE	{ ++current_line; }
	;

exp:
     NUM					{ add_node_in_tree(ILIT_T, $1);		  free($1); } 
   | IDENTIFIER				{ printf("asdf\n");add_node_in_tree(IDENTIFIER_T, $1); free($1); }
   | exp PLUS exp			{ add_node_in_tree(PLUS_T, NULL);			}
   | exp MINUS exp			{ add_node_in_tree(MINUS_T, NULL);			}
   | exp MUL exp			{ printf("asdf\n"); add_node_in_tree(MUL_T, NULL);        	}
   | exp DIV exp			{ add_node_in_tree(DIV_T, NULL);        	}
   | MINUS exp				{ add_node_in_tree(UNARY_MINUS_T, NULL);        	}
   | PLUS exp				{ add_node_in_tree(UNARY_PLUS_T, NULL);        	}
   | LPARENT exp RPARENT	{}
   | function				{ add_node_in_tree(CALL_T, get_fun_name());
								  rm_function();}
   ;

function_name : IDENTIFIER { init_function($1); free($1); };

function:
		  function_name LPARENT RPARENT			{}
		| function_name LPARENT exp RPARENT	    { increment_params(); }
		| function_name LPARENT inside RPARENT	{}
		;
	
inside:
		|   exp					{ increment_params(); }
		|	inside COMMA exp	{ increment_params(); }
		;

get_identifier : IDENTIFIER { add_node_in_tree(IDENTIFIER_T, $1); free($1);}

assignment: get_identifier ASSIGN exp	{ add_node_in_tree(ASSIGN_T, NULL); };

%%

#include <ctype.h>
#include <stdio.h>

void yyerror(char const * msg)
{
	printf("In line %d: syntax error\n", current_line);
}

int main( int argc, char **argv ) {
	++argv, --argc;  /* skip over program name */
	if ( argc == 0 )
	    yyin = stdin;
	else if (argc == 1)
		yyin = fopen(argv[0], "r" );
	else {
		exit(1); 
	}

	init_stack(&node_stack);
	init_stack(&function_stack);
	
	int res;
	res = yyparse ();

	if (res != 0) {
		return res;
	}
	assert(node_stack->size == 1);
	tree = node_stack->data;

	print_tree(tree);

	delete_tree(tree);
	pop(&node_stack, free_node);
	free(node_stack);
	free(function_stack);

	return 0;
}
