%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Define the tokens that you want to return from your lex as follows
#define ID 256
#define INTVAL 257

int list_type;
%}

%option noyywrap nounput yylineno
ID [a-zA-Z][a-zA-Z0-9_]*
%x COMMENT PREPROC

%%
"//" {
  /****************************************
  * Matching with Single line comments in our 
  * C code
  ******************************************/
  BEGIN COMMENT;
}

<COMMENT>[\n](\r)? {
  /****************************************
  * A new line indicates end of a single 
  * line comment in C
  ****************************************/
  BEGIN 0;
}

<COMMENT>[ \t] {
  /****************************************
  * Lexer ignores the comments section
  * by Ignoring anything inside a comment
  ****************************************/
}

<COMMENT>. {
}

%{
  /****************************************
  * Begin C Keywords
  ****************************************/
%}

"unsigned" {
  printf("UNSIGNED\n");
}

"typedef" {
  printf("TYPEDEF\n");
}

"struct" {
  printf("STRUCT\n");
}

"union" {
  printf("UNION\n");
}

"const" {
  printf("CONST\n");
}

"static" {
  printf("STATIC\n");
}

"extern" {
  printf("EXTERN\n");
}

"auto" {
  printf("AUTO\n");
}

"register" {
  printf("REGISTER\n");
}

"sizeof" {
  printf("SIZEOF\n");
}

%{
  /****************************************
  * End C Keywords
  ****************************************/

  /****************************************
  * Begin C Control Flow
  ****************************************/
%}

"return" {
  printf("RETURN\n");
}

"do" {
  printf("DO\n");
}

"while" {
  printf("WHILE\n");
}

"for" {
  printf("FOR\n");
}

"switch" {
  printf("SWITCH\n");
}

"case" {
  printf("CASE\n");
}

"default" {
  printf("DEFAULT\n");
}

"if" {
  printf("IF\n");
}

"else" {
  printf("ELSE\n");
}

"continue" {
  printf("CONTINUE\n");
}

"break" {
  printf("BREAK\n");
}

"goto" {
  printf("GOTO\n");
}

%{
  /****************************************
  * End C Control Flow
  ****************************************/

  /****************************************
  * Begin C Operators
  ****************************************/
%}

"==" {
  printf("EQ\n");
}

"!=" {
  printf("NE\n");
}

">=" {
  printf("GE\n");
}

"<=" {
  printf("LE\n");
}

">" {
  printf("GT\n");
}

"<" {
  printf("LT\n");
}

"+" {
  printf("ADD\n");
}

"-" {
  printf("SUB\n");
}

"*" {
  printf("MUL\n");
}

"/" {
  printf("DIV\n");
}

"%" {
  printf("MOD\n");
}

"||" {
  printf("OR\n");
}

"&&" {
  printf("AND\n");
}

"|" {
  printf("BITOR\n");
}

"&" {
  printf("BITAND\n");
}

"^" {
  printf("BITXOR\n");
}

"!" {
  printf("NOT\n");
}

"~" {
  printf("COM\n");
}

"<<" {
  printf("LSH\n");
}

">>" {
  printf("RSH\n");
}

"=" {
  printf("SET\n");
}

"+=" {
  printf("SETADD\n");
}

"-=" {
  printf("SETSUB\n");
}

"*=" {
  printf("SETMUL\n");
}

"/=" {
  printf("SETDIV\n");
}

"%=" {
  printf("SETMOD\n");
}

"|=" {
  printf("SETOR\n");
}

"&=" {
  printf("SETAND\n");
}

"^=" {
  printf("SETXOR\n");
}

"<<=" {
  printf("SETLSH\n");
}

">>=" {
  printf("SETRSH\n");
}

%{
  /****************************************
  * End C Operators
  ****************************************/

  /****************************************
  * Begin C Primitives
  ****************************************/
%}

"void" {
  printf("VOID\n");
}

"char" {
  printf("CHAR\n");
}

"short" {
  printf("SHORT\n");
}

"int" {
  printf("INT\n");
}

"long" {
  printf("LONG\n");
}

"float" {
  printf("FLOAT\n");
}

"double" {
  printf("DOUBLE\n");
}

%{
  /****************************************
  * End C Primitives
  ****************************************/

  /****************************************
  * Begin C Literal Values
  ****************************************/
%}

[0-9]+ {
  printf("INTVAL\n");
}

[0-9]+"."[0-9]+"f" {
  printf("FLTVAL\n");
}

[0-9]+"."[0-9]+ {
  printf("DBLVAL\n");
}

"\""[^<]*"\"" {
  printf("STRVAL\n");
}

"'"[^<]*"'" {
  printf("CHARVAL\n");
}

%{
  /****************************************
  * End C Literal Values
  ****************************************/

  /****************************************
  * Begin C Preprocessor
  ****************************************/
%}

"#" {
  printf("PREPROC\n");
  BEGIN PREPROC;
}

<PREPROC>[\n](\r)? {
BEGIN 0;
}

<PREPROC>[ \t] {
}

<PREPROC>. {
}

%{
  /****************************************
  * End C Preprocessor
  ****************************************/

  /****************************************
  * Begin C Punctuation
  ****************************************/
%}

"(" {
  printf("(\n");
}

")" {
  printf(")\n");
}

"{" {
  printf("{\n"); 
}

"}" {
  printf("}\n");
}

"[" {
  printf("[\n");
}

"]" {
  printf("]\n");
}

"," {
  printf(",\n");
}

";" {
  printf(";\n");
}

%{
  /****************************************
  * End C Punctuation
  ****************************************/

  /**************************************
  * If an identifier is matched, then 
  * print ID and return a token ID
  **************************************/
%}

{ID} {
printf("ID\n");
return ID;
}

. {

}
[ \t] {

}
[\n](\r)? {

}

%%
int main(int argc, const char* argv[])
{
  /*Make a call to yylex() recursively. Whenever yylex() is called, it scans tokens from the 
  global input file yyin (which defaults to stdin). It continues until it either reaches an 
  end-of-file (at which point it returns the value 0) or one of its actions executes a return statement.*/

  while (yylex()) {
  }

return 0;
}