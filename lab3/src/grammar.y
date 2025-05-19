%{
	#include <stdio.h>
	#include <math.h>
	#include "lexer.h"

	int current_line = 1;

	int yylex (void);
	void yyerror (char const *);


%}

%token NUM
%token IDENTIFIER
%token LPARENT
%token RPARENT
%token PLUS MINUS MUL DIV
%token COMMA
%token ASSIGN
%token ERROR
%token END_OF_LINE


%%

input: %empty | input line;

line: END_OF_LINE				{ ++current_line; }
	| exp END_OF_LINE			{ ++current_line; }
	| assignment END_OF_LINE	{ ++current_line; };

exp:
     NUM						{}
   | IDENTIFIER					{}
   | exp PLUS exp				{}
   | exp MINUS exp				{}
   | exp MUL exp				{}
   | exp DIV exp				{}
   | MINUS exp					{}
   | LPARENT exp RPARENT		{}
   | function					{}
   ;

function:
		  IDENTIFIER LPARENT RPARENT				{}
		| IDENTIFIER LPARENT exp RPARENT			{}
		| IDENTIFIER LPARENT inside RPARENT		    {}
		;
	
inside:
		|   exp
		|	inside COMMA exp	{}
		;


assignment: IDENTIFIER ASSIGN exp	{};

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
	
	return yyparse ();
}
