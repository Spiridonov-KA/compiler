%{
	#include <math.h>
	#include <stdlib.h>
	#include <assert.h>
	#include <limits.h>

	void error(char *s) {
		printf("ERROR, \"%s\"\n", s);
		exit(1);
	}

%}

%option nounput
%option noinput

NUM			([0-9]+|-[0-9]+)
BRACKETS	("("|")")
OPER		("+"|"-"|"*"|"/")
IDENT		[a-zA-Z_][a-zA-Z0-9_]*
INCORRECT   {NUM}{IDENT}
ASSIGN		"="
COMMA		","

%%

{BRACKETS} {
			if (*yytext == '(')
				printf("LPARENT, \"(\"\n");
			else 
				printf("RPARENT, \")\"\n");
			}
{OPER} {
		if (*yytext == '+')
			printf("PLUS, \"+\"\n");
		else if (*yytext == '-')
			printf("MINUS, \"-\"\n");
		else if (*yytext == '*')
			printf("MUL, \"*\"\n");
		else if (*yytext == '/')
			printf("DIV, \"/\"\n");
		else
			assert(0);
		}

{INCORRECT} {
				error(yytext);
			}

{IDENT} {
			printf("IDENTIFIER, \"%s\"\n", yytext);
		}
		
{NUM}	{ 
			long long num = strtoll(yytext, NULL, 10);
			if (errno == 0 && INT_MIN <= num && num <= INT_MAX) {
				// printf("ILIT, \"%lld\"\n", num);
				printf("ILIT, \"%s\"\n", yytext);
			}
			else {
				error(yytext);
			}
		}

{ASSIGN} {
			printf("ASSIGN, \"%s\"\n", yytext);
		 }

{COMMA} {
			printf("COMMA, \"%s\"\n", yytext);
		}


[ \t\n] { }

.		{ 
			error(yytext);
		}
%%

int yywrap(){ return 1;}
int main( int argc, char **argv ) {
	++argv, --argc;  /* skip over program name */
	if ( argc == 0 )
	    yyin = stdin;
	else if (argc == 1)
		yyin = fopen(argv[0], "r" );
	else {
		// printf("Incorrect input\n");
		// abort();
		exit(1); // What is correct abort or exit?
	}
	
	yylex();
	// (void)input;
	// (void)yyunput;
}
