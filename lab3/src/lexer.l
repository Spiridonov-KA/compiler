%{
	#include <math.h>
	#include <stdlib.h>
	#include <assert.h>
	#include <limits.h>
	#include "grammar.h"

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
			if (*yytext == '(')
				return LPARENT;
			else
				return RPARENT;
		   }
{OPER} {
		if (*yytext == '+')
				return PLUS;
		else if (*yytext == '-')
				return MINUS;
		else if (*yytext == '*')
				return MUL;
		else if (*yytext == '/') 
				return DIV;
		else
			assert(0);
		}

{INCORRECT} { return ERROR; }

{IDENTIFIER} { return IDENTIFIER; }
		
{NUM}	{ 
			long long num = strtoll(yytext, NULL, 10);
			if (errno == 0 && INT_MIN <= num && num <= INT_MAX)
				return NUM;
			else
				return ERROR;
		}

{ASSIGN} { return ASSIGN; }

{COMMA} { return COMMA; }


[ \t] { }

[\n]   { return END_OF_LINE; }

.		{ return ERROR; }
%%


int yywrap(){ return 1;}
