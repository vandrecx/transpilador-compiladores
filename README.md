# Transpilador PHP-Lua
 Para a execução correta do programa garanta que possui gcc, flex e bison instalados.
 Dentro do diretório, execute no terminal os seguintes comandos:
 - bison -d syntax.y
 - flex lexer.l
 - gcc -o transpilador lex.yy.c syntax.tab.c -lfl
 - ./transpilador php.txt
