%option noyywrap
%{
	#include <stdio.h>
	#include "y.tab.h"
	int c;
%}
binary_op	("+"|"-"|"*"|"/")
lb	[\n]

%%

" "	;

[a-zA-Z]	{
		yylval.str=strdup(yytext);
		return(ID);
		}

{binary_op}	{
		c=yytext[0];
		return(c);
		}
{lb}	{
	c=yytext[0];
	return (c);
	}

(.)	{printf("IGNORED:%s\n",yytext);}

%%
