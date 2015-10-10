%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
int yydebug = 1;
char* lastFunction = "";
extern void yyerror( char* );
extern int yylex();
%}

/*********************************************************
 ********************************************************/
%union {
    char* id;
}

%token <id> ID
%token INTVAL
%token FLTVAL
%token DBLVAL
%token STRVAL
%token CHARVAL
%token VOID
%token CHAR
%token SHORT
%token INT
%token LONG
%token FLOAT
%token DOUBLE
%token RETURN
%token IF
%token ELSE
%token WHILE

%token UNSIGNED
%token TYPEDEF
%token STRUCT
%token UNION
%token CONST
%token STATIC
%token EXTERN
%token AUTO
%token REGISTER
%token SIZEOF
%token DO
%token FOR
%token SWITCH
%token CASE
%token DEFAULT
%token CONTINUE
%token BREAK
%token GOTO

%start top

%%

/*********************************************************
 * The top level parsing rule, as set using the %start
 * directive above. You should modify this rule to
 * parse the contents of a file.
 ********************************************************/
top : 
|function top

/*This rule matches a  function in C Program*/
function : func_signature '{' func_body '}'
		 ;

/*This rule matches a function signature such as int main( int argc, char *argv[] )*/
func_signature : type ID '(' args ')' { printf("%s", $2); printf(";\n"); lastFunction = $2;}
			   ;

/*This rule matches a function body such as funcd();return funca( b, b );*/
func_body : declaration {printf("declaration inside func_body\n");}
		  | statement {printf("statement inside func_body\n");}
		  ;

/*This rule matches a type such as int, void, etc...*/
type : VOID {printf("VOID inside type\n");}
	 | CHAR {printf("CHAR inside type\n");}
	 | SHORT {printf("SHORT inside type\n");}
	 | INT {printf("INT inside type\n");}
	 | LONG {printf("LONG inside type\n");}
	 | FLOAT {printf("FLOAT inside type\n");}
	 | DOUBLE {printf("DOUBLE inside type\n");}
	 ;

/*This rule matches a declaration such as int c;*/
declaration : type ID ';' {printf("type ID inside declaration\n");}
			| type '*' ID ';' {printf("type * ID inside declaration\n");}
			| type ID '[' ']' ';' {printf("type ID [] inside declaration\n");}
			| type '*' ID '[' ']' ';' {printf("type * ID [] inside declaration\n");}
			;

/*********************************************************
 * An example rule used to parse arguments to a
 * function call. The arguments to a function call
 * can either be nothing, one parameter, or multiple
 * parameters separated by commas.
 ********************************************************/
args : /* empty rule */ {printf("empty rule inside args\n");}
     | paramater {printf("paramater inside args\n");}
     | paramater ',' args {printf("paramater, args inside args\n");}
     ;

/*This rule matches any parameter such as int x*/
paramater : INTVAL {printf("INTVAL inside parameter\n");}
		  | STRVAL {printf("STRVAL inside parameter\n");}
		  | CHARVAL {printf("CHARVAL inside parameter\n");}
		  | DBLVAL {printf("DBLVAL inside parameter\n");}
		  | FLTVAL {printf("FLTVAL inside parameter\n");}
		  | expr op expr {printf("expr op expr inside parameter\n");}
		  | ID {printf("ID inside parameter\n");}
		  | type ID {printf("type ID inside parameter\n");}
		  | type '*' ID {printf("type * ID inside parameter\n");}
		  | type ID '[' ']' {printf("type ID [] inside parameter\n");}
		  | type '*' ID '[' ']' {printf("type * ID [] inside parameter\n");}
		  ;

/*********************************************************
 * An example rule used to parse a single expression.
 * Currently this rule parses only an integer value
 * but you should modify the rule to parse the required
 * expressions.
 ********************************************************/
expr : INTVAL {printf("INTVAL inside expr\n");}
	 | STRVAL {printf("STRVAL inside expr\n");}
	 | CHARVAL {printf("CHARVAL inside expr\n");}
	 | DBLVAL {printf("DBLVAL inside expr\n");}
	 | FLTVAL {printf("FLTVAL inside expr\n");}
	 | expr op expr {printf("expr op expr inside expr\n");}
	 | function_call {printf("function_call inside expr\n");}
	 | ID {printf("ID inside expr\n");}
	 ;

/*This rule matches any */
op : '=='
   | '!='
   | '>='
   | '<='
   | '>'
   | '<'
   | '+'
   | '-'
   | '*'
   | '/'
   | '%'
   | '||'
   | '&&'
   | '|'
   | '&'
   | '^'
   | '!'
   | '~'
   | '<<'
   | '>>'
   | '='
   | '+='
   | '-='
   | '*='
   | '/='
   | '%='
   | '|='
   | '&='
   | '^='
   | '<<='
   | '>>='
   ;

/*This rule matches a function call such as funce( int x ) */
function_call : ID '(' args ')' {printf(lastFunction); printf(" -> "); printf("%s", $1); printf(";\n");}
			  ;

/*This rule matches a statement such as y = funce( 4 );*/
statement : assignment {printf("assignment inside statement\n");}
		  | return_statement {printf("return_statement inside statement\n");}
		  | statement_block {printf("statement_block inside statement\n");}
		  | function_call  {printf("in function_call inside statement \n");}
		  | if_statement {printf("if_statement inside statement\n");}
		  | while {printf("while inside statement\n");}
		  ;

/*This rule matches a statement block such as { statement statement ... }*/
statement_block : '{' statements '}' {printf("{statements} inside statement_block\n");}
				;

/*This rule matches a group of statements such as statement statement ... */
statements : /* empty rule */ {printf("empty rule inside statements\n");}
		   | statement {printf("statement inside statements\n");}
		   | statement '\n' statements {printf("statement '\\n' statement inside statements\n");}
		   ;

/*This rule matches a return such as return x;*/
return_statement : RETURN expr ';'
				 ;

/*This rule matches an if such as if (x == 1) {...}*/
if_statement : IF '(' expr ')' statement ELSE statement
   | IF '(' expr ')' statement
   ;

/*This rule matches a while such as while(1) ... */
while : WHILE '(' expr ')' statement_block
	  ;

/*This rule matches a assignment such as y = funce( 4 );*/
assignment : ID '=' expr ';'
		   ;

%%

/*********************************************************
 * This method is invoked by the parser whenever an
 * error is encountered during parsing; just print
 * the error to stderr.
 ********************************************************/
void yyerror( char *err ) {
    fprintf( stderr, "at line %d: %s\n", yylineno, err );
}

/*********************************************************
 * This is the main function for the function call
 * graph program. We invoke the parser and return the
 * error/success code generated by it.
 ********************************************************/
int main( int argc, const char *argv[] ) {
    printf( "digraph funcgraph {\n" );
    int res = yyparse();
    printf( "}\n" );

    return res;
}
