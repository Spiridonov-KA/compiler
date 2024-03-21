%{
	#include <stdio.h>
	#include <math.h>
	#include "../gen/lexer.h"

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

line: END_OF_LINE { ++current_line; } | exp END_OF_LINE { ++current_line; } | assignment END_OF_LINE;

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
		  IDENTIFIER LPARENT inside RPARENT		{};
	
inside:
			%empty
		|   exp				{}
		|	exp COMMA exp	{}
		;


assignment:
			IDENTIFIER ASSIGN exp				{}
		  ;


%%

// | syntax_error   { printf("syntax_error\n"); }
// syntax_error: syntax_error any_token;
// 
// any_token: NUM | IDENTIFIER | LPARENT | RPARENT | PLUS | END_OF_LINE;
// any_token: NUM | IDENTIFIER | LPARENT | RPARENT | PLUS | END_OF_LINE;

//| IDENTIFIER		{ printf("2 RULE\n");}
#include <ctype.h>
#include <stdio.h>

void yyerror(char const * msg)
{
	printf("In line %d: syntax error\n", current_line);
}


// int yylex (void) {
// 	int c;
// 	/* Skip white space. */
// 	while ((c = getchar ()) == ' ' || c == '\t')
// 		continue;
// 	/* Process numbers. */
// 	if (c == '.' || isdigit (c)) {
// 		ungetc (c, stdin);
// 		scanf ("%lf", &yylval);
// 		return NUM;
// 	}
// 	/* Return end-of-input. */
// 	if (c == EOF)
// 		return 0;
// 	/* Return a single char. */
// 	return c;
// }

/* Called by yyparse on error. */
// void yyerror (char const *s) {
// 	fprintf (stderr, "%s\n", s);
// }

int main (void) {
	return yyparse ();
}
