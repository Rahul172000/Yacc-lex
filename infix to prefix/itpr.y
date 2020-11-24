%{
	#include<stdio.h>
	#include<string.h>
%}

%start S
%token ID
%union {char *str;}
%type <str> expr
%type <str> term
%type <str> ID


%% 
S:	/*empty*/
 |	S statement '\n'	{printf("\nDone\n");}
 |	S error '\n'	{yyerrok;}	
 ;

statement:	expr	{printf("Prefix:%s",$1);}
	 ;

 
expr:	expr '+' term	{	
			char *temp1=malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
			temp1[0]='\0';
			strcat(temp1,"+");
			strcat(temp1,$1);
			strcat(temp1,$3);
			$$=temp1;
			}
    |	expr '-' term	{
			char *temp1=malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
			temp1[0]='\0';
			strcat(temp1,"-");
			strcat(temp1,$1);
			strcat(temp1,$3);
			$$=temp1;
			}
    |	term	{$$=$1;}
    ;

term:	term '*' ID	{
			char *temp1=malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
			temp1[0]='\0';
			strcat(temp1,"*");
			strcat(temp1,$1);
			strcat(temp1,$3);
			$$=temp1;
			}
    |	term '/' ID	{
			char *temp1=malloc(sizeof(char)*(strlen($1)+strlen($3)+2));
			temp1[0]='\0';
			strcat(temp1,"/");
			strcat(temp1,$1);
			strcat(temp1,$3);
			$$=temp1;
			}
    |	ID	{$$=$1;}
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