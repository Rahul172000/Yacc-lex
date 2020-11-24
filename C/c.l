%option noyywrap
%{
	#include <stdio.h>
	#include "y.tab.h"
	int c;
%}

ws	[ \t]*
lb	[\n]
alphabet	[a-zA-Z]
word	{alphabet}+
digit	[0-9]
number	{digit}+
num_constant	{number}("."{number})?
string_constant	(\")({alphabet}|{ws}|{num_constant}|";"|">"|"<"|"{"|"}"|"["|"]"|"!"|"@"|"#"|"$"|"%"|"^"|"&"|"*"|"("|")"|"{"|"}"|","|"."|"/"|"+"|"-"|"`"|"~"|":"|"_"|"="|"?")*(\")
id	({alphabet}|_)({alphabet}|_|{digit})*
datatype int|float|char|bool
return_type {datatype}|void
identifier	{id}("["({number}|{id}?)"]")?
relop	(==|<|>|>=|<=|!=)
binary_op	("+"|"-"|"*"|"/"|"&&"|"||")
bitwise_op	("|"|"&"|"^")
unary_op	("!"|"++"|"--")

%%

{ws}	{}

{lb}	{
	}

"/*"({alphabet}|{ws}|{num_constant}|";"|">"|"<"|"{"|"}"|"["|"]"|"!"|"@"|"#"|"$"|"%"|"^"|"&"|"("|")"|"{"|"}"|","|"."|"/"|"+"|"-"|"`"|"~"|":"|"_"|"="|"?")*"*/"	{
																				yylval.str=strdup(yytext);
																				return (COMMENT);
																				}
"{"	{
	c=yytext[0];
	return(c);
	}
"}"	{
	c=yytext[0];
	return(c);
	}
"#include"{ws}("<"{word}(".h")?">")	{
					yylval.str=strdup(yytext);
					return (HEADER_FILE);
					}
"else if"	{return (ELSE_IF);}
"return"	{return (RETURN);}
"if"	{return (IF);}
"else"	{return (ELSE);}
"while"	{return (WHILE);}
"for"	{return (FOR);}
"main"	{return (MAIN);}
"void"	{return (VOID);}
{datatype}	{
		yylval.str=strdup(yytext);
		return (DATATYPE);
		}
{string_constant}	{
			yylval.str=strdup(yytext);
			return (STRING);
			}
{num_constant}	{
		yylval.str=strdup(yytext);
		return (NUMBER);
		}
{relop}	{
	yylval.str=strdup(yytext);
	return (RELOP);
	}
"="	{
	c=yytext[0];
	return (c);
	}
";"	{
	c=yytext[0];
	return (c);
	}
"("	{
	c=yytext[0];
	return (c);
	}
")"	{
	c=yytext[0];
	return (c);
	}
{binary_op}	{
		yylval.str=strdup(yytext);
		return (BINOP);
		}
{bitwise_op}	{
		yylval.str=strdup(yytext);
		return (BITOP);
		}
{unary_op}	{
		yylval.str=strdup(yytext);
		return (UNOP);
		}
{identifier}	{
		yylval.str=strdup(yytext);
		return (ID);
		}
","	{
	c=yytext[0];
	return (c);
	}
%%
