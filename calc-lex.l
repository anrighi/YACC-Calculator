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


[Ss][Qq][Rr][Tt] {return SQRT;}
[Ss][Uu][Mm] {return SUM;}
[iI][fF] {return IF;}
[pP][iI]	{return PI;}
{NUM}    {yylval.value = atof(yytext);
          return NUM;}
{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}

"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';}
"=="	{return '==';}
\(		{ return LEFTPARENTHESIS; }
\)		{ return RIGHTPARENTHESIS; }
\{		{ return LEFTBRACE;}
\}		{ return RIGHTBRACE;}
\n      {return '\n';}
  


%%
