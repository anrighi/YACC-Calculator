%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>
%}


%union {
       char* lexeme;      //identifier
       double value;      //value of an identifier of type NUM
       }

%token LEFTPARENTHESIS RIGHTPARENTHESIS
%token PI E
%token SUM SQRT COS SIN POW

%token <value>  NUM
%token IF
%token <lexeme> ID

%type <value> expr
%type <value> condition
%type <value> ifStmt
%type <value> parenthesis
 /* %type <value> line */

%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%
line  : line expr ';'         {printf("Result: %f\n", $2);}
    | expr ';'                {printf("Result: %f\n", $1); }
    | line ifStmt
    | ifStmt            
    | error                 {yyerrok; yyclearin;}
    ;
expr  : expr '+' expr                       {$$ = $1 + $3;}
    | expr '-' expr                       {$$ = $1 - $3;}
    | expr '*' expr                       {$$ = $1 * $3;}
    | expr '/' expr                       {$$ = $1 / $3;}
    | SQRT parenthesis                      {$$ = sqrt($2);}
    | COS parenthesis                     {$$ = cos($2);}
    | SIN parenthesis                     {$$ = sin($2);}
    | POW LEFTPARENTHESIS expr ',' expr RIGHTPARENTHESIS    {$$ = pow($3, $5);}
    | SUM parenthesis                     {$$ = $2 * ($2 + 1) / 2;}
    | parenthesis                       {$$ = $1;}
    | NUM                           {$$ = $1;}
    | PI                            {$$ = M_PI;}
    | E                             {$$ = M_E;}
    | '-' expr %prec UMINUS                   {$$ = -$2;}
    ;
ifStmt  : IF condition '{' expr ';' '}'               {if($2) {printf("Result: %f\n", $4);} };
condition : LEFTPARENTHESIS condition RIGHTPARENTHESIS {$$=$2;};
condition : expr '<' expr     {$$=$1<$3?1:0;}
      | expr '>' expr     {$$=$1>$3?1:0;}
      | expr '=' expr     {$$=$1==$3?1:0;}
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
int main (void) {
  yyparse();
}