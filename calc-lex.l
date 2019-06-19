%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
#include <math.h>
%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*


%%

[ ]     { /* skip blanks */ }
[\n]     { }
[\t]     { }


[iI][fF]		 	{return IF;}

"SQRT"				{return SQRT;}
"SUM" 				{return SUM;}
"COS"				{return COS;}
"SIN" 				{return SIN;}
"POW" 				{return POW;}
"PI"				{return PI;}
"E"					{return E;}

{NUM}    			{yylval.value = atof(yytext);
						return NUM;}
{ID}    			{yylval.lexeme = strdup(yytext);
						return ID;}

"+"  		   		{return '+';}
"-"  			  	{return '-';}
"*"  			   	{return '*';}
"/"  			   	{return '/';}
";"  			   	{return ';';}
","  			   	{return ',';}

"<"  			   	{return '<';}
">"  			   	{return '>';}
"="  			   	{return '=';}


"{"  			   	{return '{';}
"}"  			   	{return '}';}
\(  			   	{ return LEFTPARENTHESIS; }
\)  			   	{ return RIGHTPARENTHESIS; }
  


%%
