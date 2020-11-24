%{
	#include<stdio.h>
	#include<string.h>
	char symbol_table[100][100];
	char symbol_table_type[100][100];
	int stsize=0;
	char temptype[100];
%}

%start S
%token COMMENT HEADER_FILE ELSE_IF RETURN IF ELSE WHILE FOR MAIN DATATYPE STRING NUMBER RELOP BINOP BITOP UNOP ID VOID
%union {char *str;}
%type <str> COMMENT HEADER_FILE ELSE_IF RETURN IF ELSE WHILE FOR MAIN DATATYPE STRING NUMBER RELOP BINOP BITOP UNOP ID VOID
%type <str> return_type args nestedargs main_args definition return_stat return_value
%type <str> arithmatic_expr nested_expr conditional_stat condition function_call parameters
%type <str> nested_params rhs while_loop declaration nested_declarations initialization initial_array

%%
S:	/*empty*/
 |	program	{
		printf("FINISHED\nSYMBOL TABLE\n");
		for(int i=0;i<stsize;i++)
		{
			printf("%s:%s\n",symbol_table[i],symbol_table_type[i]);
		}
		}
 |	S error '\n'	{yyerrok;}
 ;

program:	/*empty*/
       |	header_files program	
       |	global_functions program 
       |	main_function
       ;

header_files:	HEADER_FILE	{printf("%s\n",$1);}
	    ;

global_functions:	return_type ID '(' args '{' definition	{
								for(int i=0;$2[i]!='\0';i++)
								{symbol_table[stsize][i]=$2[i];}
								symbol_table_type[stsize][0]='U';
								symbol_table_type[stsize][1]='D';
								symbol_table_type[stsize][2]='F';
								symbol_table_type[stsize][3]='\0';
								stsize++;
								printf("%s %s(%s{\n%s\n",$1,$2,$4,$6);
								}	
		;

main_function:	return_type MAIN '(' main_args '{' definition	{printf("%s main(%s{\n%s\n",$1,$4,$6);}
	     ;

return_type:	DATATYPE	{$$=$1;}
	   |	VOID	{$$="void";}
	   ;

main_args:	VOID ')'	{
				$$="void)";
				}
	 |	')'	{
			$$=")";
			}
	 ;

args:	DATATYPE ID ',' nestedargs	{
					char *temp=malloc(sizeof(char)*(strlen($1)+1+strlen($2)+strlen($4)+10));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp," ");
					strcat(temp,$2);
					strcat(temp,",");
					strcat(temp,$4);
					$$=temp;
					}
    |	DATATYPE ID ')'	{
				char *temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+10));
				temp[0]='\0';
				strcat(temp,$1);
				strcat(temp," ");
				strcat(temp,$2);
				strcat(temp,")");
				$$=temp;
				}
    |	')'		{
			$$=")";
			}
    |	VOID ')'	{
			$$="void)";
			}
    ;

nestedargs:	DATATYPE ID ',' nestedargs	{
						char *temp=malloc(sizeof(char)*(strlen($1)+1+strlen($2)+strlen($4)+10));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp," ");
						strcat(temp,$2);
						strcat(temp,",");
						strcat(temp,$4);
						$$=temp;
						}
		
	  |	DATATYPE ID ')'	{
				char *temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+10));
				temp[0]='\0';
				strcat(temp,$1);
				strcat(temp," ");
				strcat(temp,$2);
				strcat(temp,")");
				$$=temp;
				}
	  ;

definition:	'}'	{$$="}\n";}
	  |	return_stat definition	{
					char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,"\n");
					strcat(temp,$2);
					$$=temp;
					}
	  |	arithmatic_expr definition	{
						char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,"\n");
						strcat(temp,$2);
						$$=temp;
						}
	  |	conditional_stat definition	{
						char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,"\n");
						strcat(temp,$2);
						$$=temp;
						}
	  |	function_call definition	{
						char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,"\n");
						strcat(temp,$2);
						$$=temp;
						}
	  |	while_loop definition	{
					char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,"\n");
					strcat(temp,$2);
					$$=temp;
					}
	  |	declaration definition	{
					char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+20));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,"\n");
					strcat(temp,$2);
					$$=temp;
					}
	  ;

declaration:	DATATYPE ID initialization ';'	{
						for(int i=0;$2[i]!='\0';i++)
						{symbol_table[stsize][i]=$2[i];}
						for(int i=0;$1[i]!='\0';i++)
						{symbol_table_type[stsize][i]=$1[i];}
						stsize++;
						char*temp=malloc(strlen($1)+strlen($2)+strlen($3)+10);
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp," ");
						strcat(temp,$2);
						strcat(temp,$3);
						strcat(temp,";");
						$$=temp;
						}
	   |	DATATYPE ID initialization ',' {for(int i=0;$1[i]!='\0';i++){temptype[i]=$1[i];}} nested_declarations	{
															for(int i=0;$2[i]!='\0';i++)
															{symbol_table[stsize][i]=$2[i];}
															for(int i=0;$1[i]!='\0';i++)
															{symbol_table_type[stsize][i]=$1[i];}
															stsize++;
															char*temp=malloc(strlen($1)+strlen($2)+strlen($3)+strlen($6)+10);
															temp[0]='\0';
															strcat(temp,$1);
															strcat(temp," ");
															strcat(temp,$2);
															strcat(temp,$3);
															strcat(temp,",");
															strcat(temp,$6);
															$$=temp;
									}
	   ;

nested_declarations:	ID initialization ',' nested_declarations	{
									for(int i=0;$1[i]!='\0';i++)
									{symbol_table[stsize][i]=$1[i];}
									for(int i=0;temptype[i]!='\0';i++)
									{symbol_table_type[stsize][i]=temptype[i];}
									stsize++;
									char*temp=malloc(strlen($1)+strlen($2)+strlen($4)+10);
									temp[0]='\0';
									strcat(temp,$1);
									strcat(temp,$2);
									strcat(temp,",");
									strcat(temp,$4);
									$$=temp;
									}
		  |	ID initialization ';'	{
						for(int i=0;$1[i]!='\0';i++)
						{symbol_table[stsize][i]=$1[i];}
						for(int i=0;temptype[i]!='\0';i++)
						{symbol_table_type[stsize][i]=temptype[i];}
						stsize++;
						char*temp=malloc(strlen($1)+strlen($2)+10);
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,$2);
						strcat(temp,";");
						$$=temp;
						}
		  ;

initialization:/*empty*/	{$$="\0";}
	      |'=' STRING	{
				char*temp=malloc(strlen($2)+10);
				temp[0]='\0';
				strcat(temp,"=");
				strcat(temp,$2);
				$$=temp;
				}
	      |	'=' NUMBER	{
				char*temp=malloc(strlen($2)+10);
				temp[0]='\0';
				strcat(temp,"=");
				strcat(temp,$2);
				$$=temp;
				}
	      |	'=' ID	{
			char*temp=malloc(strlen($2)+10);
			temp[0]='\0';
			strcat(temp,"=");
			strcat(temp,$2);
			$$=temp;
			}
	      |	'=' '{' NUMBER ',' initial_array	{
							char*temp=malloc(strlen($3)+strlen($5)+10);
							temp[0]='\0';
							strcat(temp,"={");
							strcat(temp,$3);
							strcat(temp,",");
							strcat(temp,$5);
							$$=temp;
							}
	      ;

initial_array:	NUMBER ',' initial_array	{
						char*temp=malloc(strlen($1)+strlen($3)+10);
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,",");
						strcat(temp,$3);
						$$=temp;
						}
	     |	NUMBER '}'	{
				char*temp=malloc(strlen($1)+10);
				temp[0]='\0';
				strcat(temp,$1);
				strcat(temp,"}");
				$$=temp;
				}

while_loop:	WHILE '(' condition '{' definition	{
							char*temp=malloc(strlen($3)+strlen($5)+20);
							temp[0]='\0';
							strcat(temp,"while(");
							strcat(temp,$3);
							strcat(temp,"{\n");
							strcat(temp,$5);
							$$=temp;
							}
	  ;

conditional_stat:	IF '(' condition '{' definition	{
							char*temp=malloc(strlen($3)+strlen($5)+20);
							temp[0]='\0';
							strcat(temp,"if(");
							strcat(temp,$3);
							strcat(temp,"{\n");
							strcat(temp,$5);
							$$=temp;
							}
		|	IF '(' condition '{' definition ELSE '{' definition	{
										char*temp=malloc(strlen($3)+strlen($5)+strlen($8)+30);
										strcat(temp,"if(");
										strcat(temp,$3);
										strcat(temp,"{\n");
										strcat(temp,$5);
										strcat(temp,"else{\n");
										strcat(temp,$8);
										$$=temp;
										}
		;

condition:	ID ')'	{
			char*temp=malloc(strlen($1)+10);
			temp[0]='\0';
			strcat(temp,$1);
			strcat(temp,")");
			$$=temp;
			}
	 |	ID RELOP ID ')'	{
				char*temp=malloc(strlen($1)+strlen($2)+strlen($3)+10);
				temp[0]='\0';
				strcat(temp,$1);
				strcat(temp,$2);
				strcat(temp,$3);
				strcat(temp,")");
				$$=temp;
				}
	 | NUMBER ')'	{
			char*temp=malloc(strlen($1)+10);
			temp[0]='\0';
			strcat(temp,$1);
			strcat(temp,")");
			$$=temp;
			}
	 ;

return_stat:	RETURN return_value ';'	{
					char*temp=malloc(sizeof(char)*(strlen($2)+7+20));
					temp[0]='\0';
					strcat(temp,"return ");
					strcat(temp,$2);
					strcat(temp,";");
					$$=temp;
					}
	   |	RETURN ID nested_expr	{
					char*temp=malloc(strlen($2)+10+strlen($3));
					temp[0]='\0';
					strcat(temp,"return ");
					strcat(temp,$2);
					strcat(temp,$3);
					$$=temp;
					}
	   ;
return_value:	ID	{$$=$1;}
     |	STRING	{$$=$1;}
     |	NUMBER	{$$=$1;}
     ;

arithmatic_expr:	ID '=' rhs	{
					char*temp=malloc(strlen($1)+strlen($3)+10);
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,"=");
					strcat(temp,$3);
					$$=temp;
					}
	       |	UNOP ID ';'	{
					char*temp=malloc(strlen($1)+strlen($2)+10);
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,$2);
					strcat(temp,";");
					$$=temp;
					}
	       ;

rhs:	function_call 	{
			char*temp=malloc(strlen($1)+10);
			temp[0]='\0';
			strcat(temp,$1);
			$$=temp;
			}
   |	ID ';'	{
		char*temp=malloc(sizeof(char)*(strlen($1)+10));
		temp[0]='\0';
		strcat(temp,$1);
		strcat(temp,";");
		$$=temp;
		}
   |	ID nested_expr	{
			char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+10));
			temp[0]='\0';
			strcat(temp,$1);
			strcat(temp,$2);
			$$=temp;
			}
   |	UNOP ID ';'	{
			char*temp=malloc(strlen($1)+strlen($2)+10);
			temp[0]='\0';
			strcat(temp,$1);
			strcat(temp,$2);
			strcat(temp,";");
			$$=temp;
			}
   |	NUMBER ';'	{
			char*temp=malloc(sizeof(char)*(strlen($1)+10));
			temp[0]='\0';
			strcat(temp,$1);
			strcat(temp,";");
			$$=temp;
			}
   |	NUMBER nested_expr	{
				char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+10));
				temp[0]='\0';
				strcat(temp,$1);
				strcat(temp,$2);
				$$=temp;
				}

   ;
nested_expr:	BINOP ID nested_expr	{
					char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+10));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,$2);
					strcat(temp,$3);
					$$=temp;
					}
	   |	BITOP ID nested_expr	{
					char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+10));
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,$2);
					strcat(temp,$3);
					$$=temp;
					}
	   |	BINOP NUMBER nested_expr	{
						char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+10));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,$2);
						strcat(temp,$3);
						$$=temp;
						}
	   |	BITOP NUMBER nested_expr	{
						char*temp=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+10));
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,$2);
						strcat(temp,$3);
						$$=temp;
						}
	   |	';'	{
			$$=";";
			}
	   ;

function_call:	ID '(' parameters ';'	{
					char*temp=malloc(strlen($1)+strlen($3)+20);
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,"(");
					strcat(temp,$3);
					strcat(temp,";");
					$$=temp;
					}
	     ;

parameters:	return_value ')'	{
					char*temp=malloc(strlen($1)+10);
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,")");
					$$=temp;
					}
	  |	return_value ',' nested_params	{
						char*temp=malloc(strlen($1)+strlen($3)+10);
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,",");
						strcat(temp,$3);
						$$=temp;
						} 
	  |	')'	{$$=")";}
	  ;

nested_params:	return_value ',' nested_params	{
						char*temp=malloc(strlen($1)+strlen($3)+10);
						temp[0]='\0';
						strcat(temp,$1);
						strcat(temp,",");
						strcat(temp,$3);
						$$=temp;
						}
	     |	return_value ')'	{
					char*temp=malloc(strlen($1)+10);
					temp[0]='\0';
					strcat(temp,$1);
					strcat(temp,")");
					$$=temp;
					}
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