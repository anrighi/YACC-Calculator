%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>
%}


%union {
       char* lexeme;			//identifier
       double value;			//value of an identifier of type NUM
       }

%token LEFTPARENTHESIS RIGHTPARENTHESIS
%token PI
%token SUM
%token SQRT

%token <value>  NUM
%token IF
%token <lexeme> ID

%type <value> expr
%type <value> parenthesis
 /* %type <value> line */

%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%
line  : expr '\n'      {printf("Result: %f\n", $1); exit(0);}
      | ID             {printf("Result: %s\n", $1); exit(0);}
      ;
expr  : expr '+' expr					{$$ = $1 + $3;}
      | expr '-' expr					{$$ = $1 - $3;}
      | expr '*' expr					{$$ = $1 * $3;}
      | expr '/' expr  					{$$ = $1 / $3;}
	  | SQRT parenthesis				{$$ = sqrt($2);}
	  | SUM parenthesis					{$$ = $2 * ($2 + 1) / 2;}
	  | parenthesis						{$$ = $1;}
      | NUM								{$$ = $1;}
	  | PI								{$$ = 3.1415;}
      | '-' expr %prec UMINUS {$$ = -$2;}
      ;
parenthesis : LEFTPARENTHESIS expr RIGHTPARENTHESIS {$$ = $2;}
			;

%%

#include "lex.yy.c"

int yyerror (char const *message)
{
  return fprintf (stderr, "%s\n", message);
  fputs (message, stderr);
  fputc ('\n', stderr);
  return 0;
}

int main(void) 
{
	yyparse();
}
coglione