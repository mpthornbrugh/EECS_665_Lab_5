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

%token EQ
%token NE
%token GE
%token LE
%token GT
%token LT
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token OR
%token AND
%token BITOR
%token BITAND
%token BITXOR
%token NOT
%token COM
%token LSH
%token RSH
%token SET
%token SETADD
%token SETSUB
%token SETMUL
%token SETDIV
%token SETMOD
%token SETOR
%token SETAND
%token SETXOR
%token SETLSH
%token SETRSH

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
func_body : declaration
		  | statement
		  ;

/*This rule matches a type such as int, void, etc...*/
type : VOID
	 | CHAR
	 | SHORT
	 | INT
	 | LONG
	 | FLOAT
	 | DOUBLE
	 ;

/*This rule matches a declaration such as int c;*/
declaration : type ID ';'
			| type MUL ID ';'
			| type ID '[' ']' ';'
			;

/*********************************************************
 * An example rule used to parse arguments to a
 * function call. The arguments to a function call
 * can either be nothing, one parameter, or multiple
 * parameters separated by commas.
 ********************************************************/
args : /* empty rule */
     | paramater
     | paramater ',' args
     ;

/*This rule matches any parameter such as int x*/
paramater : INTVAL
		  | STRVAL
		  | CHARVAL
		  | DBLVAL
		  | FLTVAL
		  | expr op expr
		  | ID
		  | type ID
		  | type MUL ID
		  | type ID '[' ']'
		  | type MUL ID '[' ']'
		  ;

/*********************************************************
 * An example rule used to parse a single expression.
 * Currently this rule parses only an integer value
 * but you should modify the rule to parse the required
 * expressions.
 ********************************************************/
expr : INTVAL
	 | STRVAL
	 | CHARVAL
	 | DBLVAL
	 | FLTVAL
	 | expr op expr
	 | function_call
	 | ID
	 ;

/*This rule matches any */
op : EQ
   | NE
   | GE
   | LE
   | GT
   | LT
   | ADD
   | SUB
   | MUL
   | DIV
   | MOD
   | OR
   | AND
   | BITOR
   | BITAND
   | BITXOR
   | NOT
   | COM
   | LSH
   | RSH
   | SET
   | SETADD
   | SETSUB
   | SETMUL
   | SETDIV
   | SETMOD
   | SETOR
   | SETAND
   | SETXOR
   | SETLSH
   | SETRSH
   ;

/*This rule matches a function call such as funce( int x ) */
function_call : ID '(' args ')' {printf(lastFunction); printf(" -> "); printf("%s", $1); printf(";\n");}
			  ;

/*This rule matches a statement such as y = funce( 4 );*/
statement : assignment
		  | return_statement
		  | statement_block
		  | function_call  {printf("in function_call inside statement \n");}
		  | if_statement
		  | while
		  ;

/*This rule matches a statement block such as { statement statement ... }*/
statement_block : '{' statements '}'
				;

/*This rule matches a group of statements such as statement statement ... */
statements : /* empty rule */
		   | statement
		   | statement '\n' statements
		   ;

/*This rule matches a return such as return x;*/
return_statement : RETURN expr ';'
				 ;

/*This rule matches an if such as if (x == 1) {...}*/
if_statement : IF '(' expr ')' statement ELSE statement
   | IF '(' expr ')' statement
   ;

/*This rule matches a while such as while(1) ... */
while : WHILE '(' expr ')' statement
	  ;

/*This rule matches a assignment such as y = funce( 4 );*/
assignment : ID SET expr ';'
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
