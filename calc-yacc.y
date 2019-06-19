%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>
#include <stdbool.h>

double getValue(char inName[]);
void initializeList();
void setNode(char inName[], double inValue);

%}


%union {
	char* lexeme;			//identifier
	double value;			//value of an identifier of type NUM
}

%token LEFTPARENTHESIS RIGHTPARENTHESIS
%token PI E
%token SUM SQRT COS SIN POW
%token KELTOCEL CELTOKEL CELTOFAHR FAHRTOCEL KELTOFAHR FAHRTOKEL
%token MTOFT FTTOM FTTOIN INTOFT SQMTOSQFT SQFTTOSQM CUBMTOCUBFT CUBFTTOCUBM CUBMTOGAL GALTOCUBM KMTOMPH MPHTOKM

%token <value>  NUM
%token IF ELSE
%token <lexeme> ID

%type <value> expr
%type <value> condition
%type <value> ifStmt
%type <value> conversionStmt
%type <value> parenthesis
 /* %type <value> line */

%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%
line  : line expr ';'					{printf("Result: %f\n", $2);}
		| expr ';'				      	{printf("Result: %f\n", $1); }
		| line ifStmt
		| ifStmt						
		| line assignment ';'
		| assignment ';'
		| error        					{yyerrok; yyclearin;}
		;
expr  : expr '+' expr												{$$ = $1 + $3;}
		| expr '-' expr												{$$ = $1 - $3;}
		| expr '*' expr												{$$ = $1 * $3;}
		| expr '/' expr  											{$$ = $1 / $3;}
		| SQRT parenthesis											{$$ = sqrt($2);}
		| COS parenthesis											{$$ = cos($2);}
		| SIN parenthesis											{$$ = sin($2);}
		| POW LEFTPARENTHESIS expr ',' expr RIGHTPARENTHESIS		{$$ = pow($3, $5);}
		| SUM parenthesis											{$$ = $2 * ($2 + 1) / 2;}
		| parenthesis												{$$ = $1;}
		| NUM														{$$ = $1;}
		| PI														{$$ = M_PI;}
		| E															{$$ = M_E;}
		| conversionStmt											{$$ = $1;}
		| '-' expr %prec UMINUS										{$$ = -$2;}
		| ID 														{$$ = getValue($1);}														
		;
ifStmt	: IF condition '{' expr ';' '}'								{if($2) {printf("Result: %f\n", $4);} }
		| IF condition '{' expr ';' '}' ELSE '{' expr ';' '}'		{if($2) {printf("Result: %f\n", $4);} else {printf("Result: %f\n", $9);} };
condition : LEFTPARENTHESIS condition RIGHTPARENTHESIS {$$=$2;};
condition	: expr '<' expr 		{$$=$1<$3?1:0;}
			| expr '>' expr 		{$$=$1>$3?1:0;}
			| expr '=''=' expr 		{$$=$1==$4?1:0;}
			| expr '!''=' expr 		{$$=$1!=$4?1:0;}
			| expr '>''=' expr 		{$$=$1>=$4?1:0;}
			| expr '<''=' expr 		{$$=$1<=$4?1:0;}
			;
conversionStmt  : KELTOCEL     parenthesis     {$$ = $2 - 273;}
                | CELTOKEL     parenthesis     {$$ = $2 + 273;}
                | CELTOFAHR    parenthesis     {$$ = 9.0 / 5.0 * $2 + 32;}
                | FAHRTOCEL    parenthesis     {$$ = 5.0 / 9.0 * ($2 - 32);}
                | KELTOFAHR    parenthesis     {$$ = ((9.0 / 5.0) * ($2 - 273)) + 32;}
                | FAHRTOKEL    parenthesis     {$$ = 5.0  / 9.0 * ($2 - 32) + 273;}
                | MTOFT        parenthesis     {$$ = $2 * 3.28;}
                | FTTOM        parenthesis     {$$ = $2 / 3.28 ;}
                | FTTOIN       parenthesis     {$$ = $2 * 12;}
                | INTOFT       parenthesis     {$$ = $2 / 12.0;}
                | SQMTOSQFT    parenthesis     {$$ = $2 * 10.764;}
                | SQFTTOSQM    parenthesis     {$$ = $2 / 10.764;}
                | CUBMTOCUBFT  parenthesis     {$$ = $2 * 35.315;}
                | CUBFTTOCUBM  parenthesis     {$$ = $2 / 35.315;}
                | CUBMTOGAL    parenthesis     {$$ = $2 * 219.9;}
                | GALTOCUBM    parenthesis     {$$ = $2 / 219.9;}
                | KMTOMPH      parenthesis     {$$ = $2 / 1.6;}
                | MPHTOKM      parenthesis     {$$ = $2 * 1.6;}
                ;
parenthesis : LEFTPARENTHESIS expr RIGHTPARENTHESIS {$$ = $2;}
			;
assignment 	: ID '=' NUM							{setNode($1, $3);}
			;	


%%

#include "lex.yy.c"

struct Node 
{ 
  struct Node *next; 
  double value;
  char name[10];
};

static struct Node* head; 

int yyerror (char const *message)
{
  return fprintf (stderr, "%s\n", message);
  fputs (message, stderr);
  fputc ('\n', stderr);
  return 0;
}

void initializeList()
{
	head = (struct Node*)malloc(sizeof(struct Node));  
	head->value = 0; //assign data in first node 
	strcpy(head->name, "head");
	head->next = NULL;
}

void setNode(char inName[], double inValue)
{
	struct Node* node = NULL; 
	node = (struct Node*)malloc(sizeof(struct Node));  

	struct Node* n = head;
		
	bool found = false;
	
	while (n->next != NULL) 
  	{
		if (!strcmp(n->name, inName))
		{
			n->value = inValue;
			found = true;
			break;
		}
  		
     	n = n->next; 
  	} 

	if (!found)
	{
		node->value = inValue;
		strcpy(node->name, inName);
		node->next=NULL;
		n->next = node;
	}

	printf("Variable %s set to %f\n", inName, inValue);
}

double getValue(char inName[])
{
	struct Node* n = head;
	
	bool found = false;
	
	double result = 0;
		
	while (n != NULL) 
  	{
  		if (!strcmp(n->name, inName))
		{
			result = n->value;
			found = true;
			break;
		}
  		
     	n = n->next; 
  	} 

	if (!found)
	{
		printf("The variable %s has not been set\n", inName);
	} 
	
	return result;
}

int main (void) 
{
	initializeList();
	yyparse();
}