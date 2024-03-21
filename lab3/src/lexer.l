%{
	#include <math.h>
	#include <stdlib.h>
	#include <assert.h>
	#include <limits.h>
	#include "../gen/grammar.h"

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
IDENTIFIER		[a-zA-Z_][a-zA-Z0-9_]*
INCORRECT   {NUM}{IDENTIFIER}
ASSIGN		"="
COMMA		","

%%

{BRACKETS} {
			if (*yytext == '(') {
				printf("LPARENT, \"(\"\n");
				return LPARENT;
				}
			else {
					printf("RPARENT, \")\"\n");
					return RPARENT;
				}
			}
{OPER} {
		if (*yytext == '+') {
				// printf("PLUS, \"+\"\n");
				return PLUS;
			}
		else if (*yytext == '-') {
				// printf("MINUS, \"-\"\n");
				return MINUS;
			}
		else if (*yytext == '*') {
				// printf("MUL, \"*\"\n");
				return MUL;
			}
		else if (*yytext == '/') {
				// printf("DIV, \"/\"\n");
				return DIV;
			}
		else
			assert(0);
		}

{INCORRECT} {
				// error(yytext);
				return ERROR;
			}

{IDENTIFIER} {
			printf("IDENTIFIER, \"%s\"\n", yytext);
			return IDENTIFIER;
		}
		
{NUM}	{ 
			long long num = strtoll(yytext, NULL, 10);
			if (errno == 0 && INT_MIN <= num && num <= INT_MAX) {
				// printf("ILIT, \"%lld\"\n", num);
				// printf("ILIT, \"%s\"\n", yytext);
				return NUM;
			}
			else {
				// error(yytext);
				return ERROR;
			}
		}

{ASSIGN} {
			printf("ASSIGN, \"%s\"\n", yytext);
			return ASSIGN;
		 }

{COMMA} {
			printf("COMMA, \"%s\"\n", yytext);
			return COMMA;
		}


[ \t] { }

[\n]   { printf("END OF LINE\n"); 
		 return END_OF_LINE;}

.		{ 
			// error(yytext);
			return ERROR;
		}
%%


int yywrap(){ return 1;}
// int main( int argc, char **argv ) {
// 	++argv, --argc;  /* skip over program name */
// 	if ( argc == 0 )
// 	    yyin = stdin;
// 	else if (argc == 1)
// 		yyin = fopen(argv[0], "r" );
// 	else {
// 		exit(1); 
// 	}
// 	
// 	yylex();
// }
