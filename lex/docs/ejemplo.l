%{
    #include <stdio.h>
%}

digito  [0-9]
letra   [a-zA-Z]
id  {letra}({letra}|{digito})*

%%
{id}    {
        printf("\n Identificador: %s",yytext);
        }
%%
int main(){
    yylex();
}

int yywrap(){return 1;}
