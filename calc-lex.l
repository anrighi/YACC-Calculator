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

"MeterToFeet"				{return MTOFT;}
"FeetToMeter"				{return FTTOM;}
"FeetToInches"				{return FTTOIN;}
"InchesToFeet"				{return INTOFT;}
"SqrMeterToSqrFeet"			{return SQMTOSQFT;}
"SqrFeetToSqrMeter"			{return SQFTTOSQM;}
"CubeMeterToCubeFeet"		{return CUBMTOCUBFT;}
"CubeFeetToCubeMeter"		{return CUBFTTOCUBM;}
"CubeMeterToGallons"		{return CUBMTOGAL;}
"GallonsToCubeMeter"		{return GALTOCUBM;}
"KmToMiles"					{return KMTOMPH;}
"MilesToKm"					{return MPHTOKM;}


"KelToCel"		{return KELTOCEL;}
"CelToKel"		{return CELTOKEL;}
"CelToFahr"		{return CELTOFAHR;}
"FahrToCel"		{return FAHRTOCEL;}
"KelToFahr"		{return KELTOFAHR;}
"FahrToKel"		{return	FAHRTOKEL;}

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