%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CAR 3

double stiva[20];
int sp;

void push(double x)
{ stiva[sp++]=x; }

double pop()
{ return stiva[--sp]; }

%}

%union {
  	int l_val;
	char *p_val;
}

%token list
%token char
%token begin
%token else
%token if
%token while
%token for
%token forall
%token int
%token of
%token program
%token then
%token var
%token write
%token green
%token red
%token between
%token flag
%token string
%token float
%token is

%token ID
%token <p_val> CONST_INT
%token <p_val> CONST_REAL
%token <p_val> CONST_CAR
%token CONST_SIR

%token CHAR
%token INTEGER
%token REAL


%left '+' '-'
%left '%' '*' '/' '%' '==' '=' '(' ')' '{' '}' '!=' '&&' ';' ':' ','
%left OR
%left AND
%left NOT

%type <l_val> expr_stat factor_stat constanta
%%

program:        "VAR" decllist ";" cmpdstmt ".";

decllist:       declaration | declaration ";" decllist;

declaration : IDENTIFIER ":" type;

      type1 : "BOOLEAN" | "CHAR" | "INTEGER" | "REAL" | "FLAG";

  arraydecl : "ARRAY" "[" nr "]" "OF" type1;

      type  : type1|arraydecl;

   cmpdstmt : "BEGIN" stmtlist "END";

   stmtlist : stmt | stmt ";" stmtlist;

       stmt : simplstmt | structstmt;

  simplstmt : assignstmt | iostmt;

 assignstmt : IDENTIFIER "=" expression;

 expression : expression arithmeticOperator expression | term | const;

       term : term "*" factor | factor;

     factor : "(" expression ")" | IDENTIFIER;

     iostmt : "READ" | "WRITE" "(" IDENTIFIER ")";

 structstmt : cmpdstmt | ifstmt | whilestmt ;

     ifstmt : "IF" condition "THEN" stmt ["ELSE" stmt];

  whilestmt : "while" condition "begin" stmt;

 forallstmt : "forall" "identifier" "between" "const" "," "const" {RELATION  "const"} | "forall" "const" "," "const";

  condition : expression RELATION expression;

   RELATION : "lower" | "lower_equal" | "equal" | "is_not" | "greater_equal" | "greater" | "is" | "between";
	
   OPERATOR : + | - |  * | / | % | ^ ;

 identifier : letter | letter{letter}{digit};

     letter : "A" | "B" | . ..| "Z";

      digit : "0" | "1" |...| "9";

      const : '0' | nonzero-d | nonzero-d seq | (+|-) '0' | (+|-) nonzero-d | (+|-) nonzero-d seq;

        seq : digit | digit seq;

  nonzero-d : '1' | ... | '9';

  character : 'letter'|'digit'|'separators'|'operators' | specialCharacters;

specialCharacters : ! | @ | # | $ | % | ^ | & | && |  ||  | { | } | [ | ] | : | ; | ' | , | . | / | \ | ? | ( | ) ;

separators : ' ' | " " | \n | \t ;

     string : char{string} | char;

       char : letter | digit;

	 flag : red | green;
%%

yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}
