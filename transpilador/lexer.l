%{
#include <string.h>
#include <stdlib.h>
#include "syntax.tab.h"
void yyerror(const char* erro);
%}

%option noyywrap

LETRA [A-Za-z_]
PALAVRAS {LETRA}({LETRA}|[0-9])*
DIGITO [0-9]
NUMEROS {DIGITO}+
STRING \"[^"]*\"
ESPACOEMBRANCO [ \t]+

%%

"<\?php"           { return PHP_OPEN; }
"\?>"              { return PHP_CLOSE; }
"+"               { return MAIS; }
"-"               { return MENOS; }
"*"               { return MULTIPLICA; }
"/"               { return DIVIDE; }
"="               { return RECEBE; }
">="              { return MAIORIGUAL; }
"<="              { return MENORIGUAL; }
"=="              { return IGUAL; }
"!="              { return DIFERENTE; }
">"               { return MAIORQUE; }
"<"               { return MENORQUE; }
";"               { return PONTOVIRGULA; }
"if"              { return SE; }
"else"            { return SENAO; }
"else if"          { return SENAOSE; }
"("               { return ABREP; }
")"               { return FECHAP; }
"{"               { return ABREC; }
"}"               { return FECHAC; }
"&&"             { return E; }
"||"              { return OU; }
"while"           { return ENQUANTO; }
"function"        { return FUNC; }
"return"          { return RETURN; }
","               { return VIRGULA; }

{PALAVRAS} {
    yylval.str = strdup(yytext);
    return PALAVRAS;
}

"\$"{PALAVRAS} {
    char *var = strdup(yytext);
    memmove(var, var+1, strlen(var));
    yylval.str = var;
    return VARIAVEIS;
}

{NUMEROS} {
    yylval.str = strdup(yytext);
    return NUM;
}

{STRING} {
    yylval.str = strdup(yytext);
    return STR;
}

{ESPACOEMBRANCO} ;

"\n" { yylineno++; }

. {
    printf("Token desconhecido: %s\n", yytext);
    yyerror("Token desconhecido.");
}

%%
