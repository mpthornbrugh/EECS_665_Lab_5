%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcg.yacc.h>

#ifndef NDEBUG
#    define DEBUGF(...) DEBUGF(__VA_ARGS__)
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
"unsigned"  { DEBUGF("UNSIGNED\n"); return UNSIGNED; }
"typedef"   { DEBUGF("TYPEDEF\n");  return TYPEDEF; }
"struct"    { DEBUGF("STRUCT\n");   return STRUCT; }
"union"     { DEBUGF("UNION\n");    return UNION; }
"const"     { DEBUGF("CONST\n");    return CONST; }
"static"    { DEBUGF("STATIC\n");   return STATIC; }
"extern"    { DEBUGF("EXTERN\n");   return EXTERN; }
"auto"      { DEBUGF("AUTO\n");     return AUTO; }
"register"  { DEBUGF("REGISTER\n"); return REGISTER; }
"sizeof"    { DEBUGF("SIZEOF\n");   return SIZEOF; }

%{
 /**************************************************************************
  * Scan C control flow. 
  *************************************************************************/
%}

"return"    { DEBUGF("RETURN\n");   return RETURN; }
"do"        { DEBUGF("DO\n");       return DO; }
"while"     { DEBUGF("WHILE\n");    return WHILE; }
"for"       { DEBUGF("FOR\n");      return FOR; }
"switch"    { DEBUGF("SWITCH\n");   return SWITCH; }
"case"      { DEBUGF("CASE\n");     return CASE; }
"default"   { DEBUGF("DEFAULT\n");  return DEFAULT; }
"if"        { DEBUGF("IF\n");       return IF; }
"else"      { DEBUGF("ELSE\n");     return ELSE; }
"continue"  { DEBUGF("CONTINUE\n"); return CONTINUE; }
"break"     { DEBUGF("BREAK\n");    return BREAK; }
"goto"      { DEBUGF("GOTO\n");     return GOTO; }

%{
 /**************************************************************************
  * Scan C operators. 
  *************************************************************************/
%}

"=="  { DEBUGF("==\n");       return "=="; }
"!="  { DEBUGF("!=\n");       return "!="; }
">="  { DEBUGF(">=\n");       return ">="; }
"<="  { DEBUGF("<=\n");       return "<="; }
">"   { DEBUGF(">\n");       return '>'; }
"<"   { DEBUGF("<\n");       return '<'; }
"+"   { DEBUGF("+\n");      return '+'; }
"-"   { DEBUGF("-\n");      return '-'; }
"*"   { DEBUGF("*\n");      return '*'; }
"/"   { DEBUGF("/\n");      return '/'; }
"%"   { DEBUGF("%\n");      return '%'; }
"||"  { DEBUGF("||\n");       return "||"; }
"&&"  { DEBUGF("&&\n");      return "&&"; }
"|"   { DEBUGF("|\n");    return '|'; }
"&"   { DEBUGF("&\n");   return '&'; }
"^"   { DEBUGF("^\n");   return '^'; }
"!"   { DEBUGF("!\n");      return '!'; }
"~"   { DEBUGF("~\n");      return '~'; } 
"<<"  { DEBUGF("<<\n");      return "<<"; }
">>"  { DEBUGF(">>\n");      return "">>"; }
"="   { DEBUGF("=\n");      return '='; }
"+="  { DEBUGF("+=\n");   return "+="; }
"-="  { DEBUGF("-=\n");   return "-="; }
"*="  { DEBUGF("*=\n");   return "*="; }
"/="  { DEBUGF("/=\n");   return "/="; } 
"%="  { DEBUGF("%=\n");   return "%="; }
"|="  { DEBUGF("|=\n");    return "|="; }
"&="  { DEBUGF("&=\n");   return "&="; }
"^="  { DEBUGF("^=\n");   return "^="; }
"<<=" { DEBUGF("<<=\n");   return "<<="; }
">>=" { DEBUGF(">>=\n");   return ">>="; }

%{ 
 /**************************************************************************
  * Scan miscellaneous C punctuation. 
  *************************************************************************/
%}

"("         { DEBUGF( "(\n" ); return '('; }
")"         { DEBUGF( ")\n" ); return ')'; }
"{"         { DEBUGF( "{\n" ); return '{'; }
"}"         { DEBUGF( "}\n" ); return '}'; }
"["         { DEBUGF( "[\n" ); return '['; }
"]"         { DEBUGF( "]\n" ); return ']'; }
","         { DEBUGF( ",\n" ); return ','; }
";"         { DEBUGF( ";\n" ); return ';'; }

%{ 
 /**************************************************************************
  * Scan types. 
  *************************************************************************/
%}

"void"         { DEBUGF( "VOID\n" ); return VOID; }
"char"         { DEBUGF( "CHAR\n" ); return CHAR; }
"short"        { DEBUGF( "SHORT\n" ); return SHORT; }
"int"          { DEBUGF( "INT\n" ); return INT; }
"long"         { DEBUGF( "LONG\n" ); return LONG; }
"float"        { DEBUGF( "FLOAT\n" ); return FLOAT; }
"double"       { DEBUGF( "DOUBLE\n" ); return DOUBLE; }

%{ 
 /**************************************************************************
  * Scan C identifiers.
  *************************************************************************/
%}

{ident}         { DEBUGF( "ID\n" ); yylval.id = strdup(yytext); return ID; }
{charval}       { DEBUGF( "CHARVAL\n" ); return CHARVAL; }
"\""[^<]*"\""   { DEBUGF( "STRVAL\n" ); return STRVAL; }

%{ 
 /**************************************************************************
  * Scan C literal values including strings, character literals, integer
  * literals, and floating point literals.
  *************************************************************************/
%}

"0x"{hexdigit}+    { DEBUGF( "INTVAL\n" ); return INTVAL; }
"0"{octdigit}*     { DEBUGF( "INTVAL\n" ); return INTVAL; }
[1-9]{digit}*      { DEBUGF( "INTVAL\n" ); return INTVAL; }
[0-9]+"."[0-9]+"f" { DEBUGF( "FLTVAL\n" ); return FLTVAL; }
[0-9]+"."[0-9]+    { DEBUGF( "DBLVAL\n" ); return DBLVAL; }

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
