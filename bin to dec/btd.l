%option noyywrap
%{
	#include <stdio.h>
	#include "y.tab.h"
	int c;
%}

%%
"0"|"1"	{
		c=yytext[0]-'0';
		yylval.aa.val=c;
		yylval.aa.len=1;
		return(BIT);
	}

"."	{
		c=yytext[0];
		return (c);
	}

"\n"	{
	c=yytext[0];
	return (c);
	}

(.)	{
	printf("IGNORED:%s\n",yytext);
	}
%%
