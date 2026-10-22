/* miniLang-lex rev. 2.3 */
%{
#include <stdio.h>
#include <stdlib.h>

int acumula_saltos_ml = 1;
static int hay_entrada = 0;
static int ultimo_fue_salto = 0;
static int linea_inicio_comentario = 0;

static void token(const char *nombre);
static void token_lexema(const char *nombre);
static void error_lexico(const char *descripcion);
static int numero_total_lineas(void);
%}

%option noyywrap
%x COMENTARIO

digito          [0-9]
letra           [A-Za-z]
identificador   ({letra}|_)({letra}|{digito}|_)*
entero          {digito}+
exponente       [eE][+-]?{digito}+
real_decimal    {digito}+\.{digito}+
real            ({real_decimal}({exponente})?|{entero}{exponente})
cadena          \"[^\"\r\n]*\"

%%

"program"       { token("PROGRAM"); }
"var"           { token("VAR"); }
"const"         { token("CONST"); }
"int"           { token("INT"); }
"real"          { token("REAL"); }
"bool"          { token("BOOL"); }
"true"          { token_lexema("CTE_BOOL"); }
"false"         { token_lexema("CTE_BOOL"); }
"if"            { token("IF"); }
"else"          { token("ELSE"); }
"for"           { token("FOR"); }
"to"            { token("TO"); }
"downto"        { token("DOWNTO"); }
"print"         { token("PRINT"); }
"read"          { token("READ"); }
"and"           { token("AND"); }
"or"            { token("OR"); }
"not"           { token("NOT"); }

"//"[^\r\n]*   { hay_entrada = 1; ultimo_fue_salto = 0; }
"/*"            { hay_entrada = 1; ultimo_fue_salto = 0; linea_inicio_comentario = acumula_saltos_ml; BEGIN(COMENTARIO); }
<COMENTARIO>"*/" { hay_entrada = 1; ultimo_fue_salto = 0; BEGIN(INITIAL); }
<COMENTARIO>\r\n { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
<COMENTARIO>\n   { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
<COMENTARIO>\r   { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
<COMENTARIO>.    { hay_entrada = 1; ultimo_fue_salto = 0; }
<COMENTARIO><<EOF>> {
                    fprintf(stderr,
                            "LINEA %d. ERROR LEXICO: comentario de varias lineas sin cerrar [ML-7Q]\n",
                            linea_inicio_comentario);
                    BEGIN(INITIAL);
                  }

"**"            { token("POTENCIA_DOBLE"); }
"<="|">="|"=="|"!=" { token(yytext); }
"="|"+"|"-"|"*"|"/"|"%"|"<"|">" { token(yytext); }
";"|":"|"("|")"|"{"|"}" { token(yytext); }

{cadena}         { token_lexema("CTE_CADENA"); }
\"[^\"\r\n]*  { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("cadena sin cerrar"); }

{real}           { token_lexema("CTE_REAL"); }
{digito}+(\.{digito}+)?[eE][+-]? { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("constante numerica mal formada"); }
{digito}+(\.{digito}+)?({exponente})?({letra}|_)({letra}|{digito}|_)* { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("constante numerica mal formada"); }
{digito}+\.{digito}*\.[0-9.]*([eE][+-]?{digito}*)? { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("constante numerica mal formada"); }
\.{digito}+({exponente})? { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("constante numerica mal formada"); }
{entero}         { token_lexema("CTE_ENTERA"); }
{identificador}  { token_lexema("ID"); }

[ \t]+           { hay_entrada = 1; ultimo_fue_salto = 0; }
\r\n             { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
\n               { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
\r               { hay_entrada = 1; acumula_saltos_ml++; ultimo_fue_salto = 1; }
.                { hay_entrada = 1; ultimo_fue_salto = 0; error_lexico("caracter no reconocido"); }

%%

static void token(const char *nombre)
{
    hay_entrada = 1;
    ultimo_fue_salto = 0;
    fprintf(yyout, "%s\n", nombre);
}

static void token_lexema(const char *nombre)
{
    hay_entrada = 1;
    ultimo_fue_salto = 0;
    fprintf(yyout, "%s(%s)\n", nombre, yytext);
}

static void error_lexico(const char *descripcion)
{
    fprintf(stderr, "LINEA %d. ERROR LEXICO: %s: %s [ML-7Q]\n",
            acumula_saltos_ml, descripcion, yytext);
}

static int numero_total_lineas(void)
{
    if (!hay_entrada) {
        return 0;
    }
    return acumula_saltos_ml - (ultimo_fue_salto ? 1 : 0);
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Uso: %s fichero.min\n", argv[0]);
        return EXIT_FAILURE;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "No se puede abrir el fichero de entrada: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    yyout = fopen("tokens.txt", "w");
    if (yyout == NULL) {
        fprintf(stderr, "No se puede crear tokens.txt\n");
        fclose(yyin);
        return EXIT_FAILURE;
    }

    yylex();
    fprintf(yyout, "N\303\272mero de l\303\255neas: %d\n", numero_total_lineas());

    fclose(yyin);
    fclose(yyout);
    return EXIT_SUCCESS;
}
