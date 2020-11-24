%option noyywrap
%{
	#include <stdio.h>
	#include "y.tab.h"
	int c;
	extern int yylval;
%}
binary_op	("+"|"-"|"*"|"/")
lb	[\n]

%%

" "	;

[a-zA-Z]	{
		yylval=yytext;
		return(ID);
		}

{binary_op}|{lb}			{
					c=yytext[0];
					return(c);
					}

(.)	{printf("IGNORED:%s\n",yytext);}

%%
