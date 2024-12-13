%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntax.tab.h"

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);
%}

%union {
    char *str;
}

%token<str> PHP_OPEN PHP_CLOSE VARIAVEIS PONTOVIRGULA RECEBE MAIORQUE MENORQUE IGUAL DIFERENTE SENAOSE MAIORIGUAL MENORIGUAL SE SENAO ABREP FECHAP ABREC FECHAC E OU ENQUANTO FUNC RETURN VIRGULA BREAK NUM STR PALAVRAS

%type<str> PROGRAMA CODIGOS CODIGO DECLARACAO ATRIBUICAO EXPRESSAO LOOP CONDICAO FECHABLOCO CONDICIONAL CONDICOES FUNCAO

%left MAIS MENOS
%left MULTIPLICA DIVIDE
%left MAIORQUE MENORQUE MAIORIGUAL MENORIGUAL DIFERENTE IGUAL E OU

%start PROGRAMA

%%

PROGRAMA : PHP_OPEN CODIGOS PHP_CLOSE;

CODIGOS : CODIGOS CODIGO | CODIGO;

CODIGO : DECLARACAO | ATRIBUICAO | LOOP | CONDICIONAL | FECHABLOCO | FUNCAO;

FECHABLOCO:
    FECHAC {
        printf("end\n");
    };

DECLARACAO :
    VARIAVEIS PONTOVIRGULA {
        printf("local %s\n", $1);
        free($1);
    };

ATRIBUICAO:
    VARIAVEIS RECEBE EXPRESSAO PONTOVIRGULA{
        printf("%s = %s\n", $1, $3);
        free($1);
        free($3);
    }| VARIAVEIS RECEBE PALAVRAS ABREP VARIAVEIS FECHAP PONTOVIRGULA{
        printf("%s = %s(%s)\n", $1, $3, $5);
        free($1);
        free($3);
        free($5);
    }| VARIAVEIS RECEBE PALAVRAS ABREP VARIAVEIS VIRGULA VARIAVEIS FECHAP PONTOVIRGULA{
        printf("%s = %s(%s,%s)\n", $1, $3, $5, $7);
        free($1);
        free($3);
        free($5);
    }| VARIAVEIS RECEBE STR PONTOVIRGULA{
        printf("%s = %s\n", $1, $3);
    };

EXPRESSAO :
      EXPRESSAO MAIS EXPRESSAO {
          $$ = malloc(100);
          snprintf($$, 100, "%s + %s", $1, $3);
          free($1);
          free($3);
      }| EXPRESSAO MENOS EXPRESSAO {
          $$ = malloc(100);
          snprintf($$, 100, "%s - %s", $1, $3);
          free($1);
          free($3);
      }| EXPRESSAO MULTIPLICA EXPRESSAO {
          $$ = malloc(100);
          snprintf($$, 100, "%s * %s", $1, $3);
          free($1);
          free($3);
      }| EXPRESSAO DIVIDE EXPRESSAO {
          $$ = malloc(100);
          snprintf($$, 100, "%s / %s", $1, $3);
          free($1);
          free($3);
      }| NUM {
          $$ = strdup($1);
      }| VARIAVEIS {
          $$ = strdup($1);
      };

LOOP:
    ENQUANTO ABREP CONDICAO FECHAP ABREC {
        printf("while %s do\n\t\b\b", $3);
        free($3);
    };

CONDICAO:
      CONDICOES E CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s and %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES OU CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s or %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES MAIORQUE CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s > %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES MENORQUE CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s < %s", $1, $3);
          free($1);
          free($3);
      } | CONDICOES MAIORIGUAL CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s >= %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES MENORIGUAL CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s <= %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES IGUAL CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s == %s", $1, $3);
          free($1);
          free($3);
      }| CONDICOES DIFERENTE CONDICOES {
          $$ = malloc(100);
          snprintf($$, 100, "%s ~= %s", $1, $3);
          free($1);
          free($3);
      };

CONDICOES:
    CONDICAO | EXPRESSAO;

CONDICIONAL:
    SE ABREP CONDICAO FECHAP ABREC {
        printf("if %s then\n\t\b\b", $3);
        free($3);
    }| FECHAC SENAO ABREC{
        printf("else\n\t\b\b");
    }| FECHAC SENAOSE ABREP CONDICAO FECHAP ABREC {
        printf("elseif %s then\n\t\b\b", $4);
    };

FUNCAO:
    FUNC PALAVRAS ABREP VARIAVEIS FECHAP ABREC {
        printf("function %s(%s)\n\t\b\b", $2, $4);
        free($2);
        free($4);
    }| RETURN VARIAVEIS PONTOVIRGULA {
        printf("\t\b\breturn %s\n", $2);
        free($2);
    }| FUNC PALAVRAS ABREP VARIAVEIS VIRGULA VARIAVEIS FECHAP ABREC {
        printf("function %s(%s,%s)\n\t\b\b", $2, $4, $6);
        free($2);
        free($4);
        free($6);
    }
%%

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: ./transpilador arquivo.php\n");
        return 1;
    }

    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        printf("Arquivo %s não encontrado!\n", argv[1]);
        return 1;
    }

    yyin = arquivo;
    yyparse();

    fclose(arquivo);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}
