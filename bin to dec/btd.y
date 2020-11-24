%{
	#include<stdio.h>
%}

%start S
%token BIT
%union {struct {int len;float val;} aa;}
%type <aa> number
%type <aa> BIT


%% 

S:	/*empty*/
 |	S number	{
			printf("DECIMAL:%f\n",$2.val);
			}
 |	S number '.' number {
				float temp=(1<<$4.len);
				float ans=$2.val+$4.val/temp;
				printf("DECIMAL:%f\n",ans);
				}
 ;

number:	number BIT	{$$.val=$1.val*2 + $2.val;$$.len=$1.len+1;}
      |	BIT	{$$=$1;}
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