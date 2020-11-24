%{
	#include<stdio.h>
	#include<string.h>
%}

%start S
%token ID


%% 
S:	/*empty*/
 |	S statement '\n'	{printf("\nDone\n");}
 |	S error '\n'	{yyerrok;}	
 ;

statement:	expr
	 ;

 
expr:	expr '+' term	{printf("+");}
    |	expr '-' term	{printf("-");}	
    |	term	
    ;

term:	term '*' ID	{printf("%s*",$3);}
    |	term '/' ID	{printf("%s/",$3);}
    |	ID	{printf("%s",$1);}
    ;

%%

int main()
{
	return(yyparse());
}
int yyerror(s)
char *s;
{
	fprintf(stderr, "%s\n",s);
}
int yywrap()
{
	return(1);
}