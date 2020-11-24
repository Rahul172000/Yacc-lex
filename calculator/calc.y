%{
	#include<stdio.h>
%}

%start S
%token NUMBER


%% 
S:	/*empty*/
 |	S statement '\n'	{printf("Done\n");}
 |	S error '\n'	{yyerrok;}	
 ;

statement:	expr	{printf("Ans:%i\n",$1);}
	 ;

 
expr:	expr '+' term	{$$=$1+$3;/*printf("%i + %i\n",$1,$3);*/}
    |	expr '-' term	{$$=$1-$3;/*printf("%i - %i\n",$1,$3);*/}	
    |	term	{$$=$1;}
    ;

term:	term '*' NUMBER	{$$=$1*$3;/*printf("%i * %i\n",$1,$3);*/}
    |	term '/' NUMBER	{$$=$1/$3;/*printf("%i / %i\n",$1,$3);*/}
    |	NUMBER	{$$=$1;}
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