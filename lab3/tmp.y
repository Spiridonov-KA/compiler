%{
#include <stdio.h>
#include <stdlib.h>

	int yylex (void);
	void yyerror (char const *);
%}

%token NUM

%%

input:
	 %empty
	| input line
	;

line:
	'\n'
	| exp '\n' {printf("%d\n", $1);}
	;

exp:
   NUM { $$ = $1; }
   | exp'+'exp { $$ = $1 + $3; 
					printf("$1 = %d\n", $1);
					printf("$2 = %s\n", $2);
					printf("$2 = %d\n", $3);
				 }
   ;

%%

#include <ctype.h>
#include <stdio.h>


int yylex (void) {
	int c;
	/* Skip white space. */
	while ((c = getchar ()) == ' ' || c == '\t')
		continue;
	/* Process numbers. */
	if (c == '.' || isdigit (c)) {
		ungetc (c, stdin);
		scanf ("%d", &yylval);
		return NUM;
	}
	/* Return end-of-input. */
	if (c == EOF)
		return 0;
	/* Return a single char. */
	return c;
}

/* Called by yyparse on error. */
void yyerror (char const *s) {
	fprintf (stderr, "%s\n", s);
}

int main (void) {
	return yyparse ();
}
