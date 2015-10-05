%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcg.yacc.h>

#ifndef NDEBUG
#    define DEBUGF(...) printf(__VA_ARGS__)
#else
#    define DEBUGF(...)
#endif
%}

%option       noyywrap nounput yylineno
%x            COMMENT

whitesp       [ \t\n\r]
nonwhitesp    [^ \t\n\r]
ident         [a-zA-Z][a-zA-Z0-9_]*
digit         [0-9]
hexdigit      [0-9a-fA-F]
octdigit      [0-7]
charval       "'"(\\)?."'"

%%

%{
 /**************************************************************************
  * Scan C keywords. 
  *************************************************************************/
%}

"unsigned"  { printf("UNSIGNED\n"); return 'UNSIGNED'; }
"typedef"   { printf("TYPEDEF\n");  return 'TYPEDEF'; }
"struct"    { printf("STRUCT\n");   return 'STRUCT'; }
"union"     { printf("UNION\n");    return 'UNION'; }
"const"     { printf("CONST\n");    return 'CONST'; }
"static"    { printf("STATIC\n");   return 'STATIC'; }
"extern"    { printf("EXTERN\n");   return 'EXTERN'; }
"auto"      { printf("AUTO\n");     return 'AUTO'; }
"register"  { printf("REGISTER\n"); return 'REGISTER'; }
"sizeof"    { printf("SIZEOF\n");   return 'SIZEOF'; }

%{
 /**************************************************************************
  * Scan C control flow. 
  *************************************************************************/
%}

"return"    { printf("RETURN\n");   return 'RETURN'; }
"do"        { printf("DO\n");       return 'DO'; }
"while"     { printf("WHILE\n");    return 'WHILE'; }
"for"       { printf("FOR\n");      return 'FOR'; }
"switch"    { printf("SWITCH\n");   return 'SWITCH'; }
"case"      { printf("CASE\n");     return 'CASE'; }
"default"   { printf("DEFAULT\n");  return 'DEFAULT'; }
"if"        { printf("IF\n");       return 'IF'; }
"else"      { printf("ELSE\n");     return 'ELSE'; }
"continue"  { printf("CONTINUE\n"); return 'CONTINUE'; }
"break"     { printf("BREAK\n");    return 'BREAK'; }
"goto"      { printf("GOTO\n");     return 'GOTO'; }

%{
 /**************************************************************************
  * Scan C operators. 
  *************************************************************************/
%}

"=="  { printf("EQ\n");       return 'EQ'; }
"!="  { printf("NE\n");       return 'NE'; }
">="  { printf("GE\n");       return 'GE'; }
"<="  { printf("LE\n");       return 'LE'; }
">"   { printf("GT\n");       return 'GT'; }
"<"   { printf("LT\n");       return 'LT'; }
"+"   { printf("ADD\n");      return 'ADD'; }
"-"   { printf("SUB\n");      return 'SUB'; }
"*"   { printf("MUL\n");      return 'MUL'; }
"/"   { printf("DIV\n");      return 'DIV'; }
"%"   { printf("MOD\n");      return 'MOD'; }
"||"  { printf("OR\n");       return 'OR'; }
"&&"  { printf("AND\n");      return 'AND'; }
"|"   { printf("BITOR\n");    return 'BITOR'; }
"&"   { printf("BITAND\n");   return 'BITAND'; }
"^"   { printf("BITXOR\n");   return 'BITXOR'; }
"!"   { printf("NOT\n");      return 'NOT'; }
"~"   { printf("COM\n");      return 'COM'; } 
"<<"  { printf("LSH\n");      return 'LSH'; }
">>"  { printf("RSH\n");      return 'RSH'; }
"="   { printf("SET\n");      return 'SET'; }
"+="  { printf("SETADD\n");   return 'SETADD'; }
"-="  { printf("SETSUB\n");   return 'SETSUB'; }
"*="  { printf("SETMUL\n");   return 'SETMUL'; }
"/="  { printf("SETDIV\n");   return 'SETDIV'; } 
"%="  { printf("SETMOD\n");   return 'SETMOD'; }
"|="  { printf("SETOR\n");    return 'SETOR'; }
"&="  { printf("SETAND\n");   return 'SETAND'; }
"^="  { printf("SETXOR\n");   return 'SETXOR'; }
"<<=" { printf("SETLSH\n");   return 'SETLSH'; }
">>=" { printf("SETRSH\n");   return 'SETRSH'; }

%{ 
 /**************************************************************************
  * Scan miscellaneous C punctuation. 
  *************************************************************************/
%}

"("         { printf( "(\n" ); return '('; }
")"         { printf( ")\n" ); return ')'; }
"{"         { printf( "{\n" ); return '{'; }
"}"         { printf( "}\n" ); return '}'; }
"["         { printf( "[\n" ); return '['; }
"]"         { printf( "]\n" ); return ']'; }
","         { printf( ",\n" ); return ','; }
";"         { printf( ";\n" ); return ';'; }

%{ 
 /**************************************************************************
  * Scan types. 
  *************************************************************************/
%}

"void"         { printf( "VOID\n" ); return 'VOID'; }
"char"         { printf( "CHAR\n" ); return 'CHAR'; }
"short"        { printf( "SHORT\n" ); return 'SHORT'; }
"int"          { printf( "INT\n" ); return 'INT'; }
"long"         { printf( "LONG\n" ); return 'LONG'; }
"float"        { printf( "FLOAT\n" ); return 'FLOAT'; }
"double"       { return 'DOUBLE'; }

%{ 
 /**************************************************************************
  * Scan C identifiers.
  *************************************************************************/
%}

{ident}         { printf( "ID\n" ); yylval.id = strdup(yytext); return ID; }
{charval}       { printf( "CHARVAL\n" ); return 'CHARVAL'; }

%{ 
 /**************************************************************************
  * Scan C literal values including strings, character literals, integer
  * literals, and floating point literals.
  *************************************************************************/
%}

"0x"{hexdigit}+    { printf( "INTVAL\n" ); return INTVAL; }
"0"{octdigit}*     { printf( "INTVAL\n" ); return INTVAL; }
[1-9]{digit}*      { printf( "INTVAL\n" ); return INTVAL; }
[0-9]+"."[0-9]+"f" { printf( "FLTVAL\n" ); return FLTVAL; }
[0-9]+"."[0-9]+    { printf( "DBLVAL\n" ); return DBLVAL; }

%{
 /**************************************************************************
  * Scan a multi-line C comment using left context or a C single line
  * comment to the end of the line.
  *************************************************************************/
%}

"//".*                      { /* ignored */ }

"/*"                        { BEGIN COMMENT; }
<COMMENT>"*/"               { BEGIN 0; }
<COMMENT>([\n](\r)?)|.      { /* ignored */ } 

%{
 /**************************************************************************
  * Scan white space in-between tokens and ignore it.
  *************************************************************************/
%}

{whitesp}+ { /* ignored */  }

%{
 /**************************************************************************
  * Anything else that matches is unexpected so print an error.
  *************************************************************************/
%}

. {
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}
