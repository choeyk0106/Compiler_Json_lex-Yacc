%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #define YYSTYPE char*

    char* createObjType(char* member);
    char* createMemType(char* member1, char* member2);
    char* createPairType(char* member1, char* member2);
    char* createArrType(char* member);
    char* createEleType(char* member1, char* member2);
%}
%token NUMBER
%token STRING
%token TRUE FALSE TNULL
%left O_BEGIN O_END A_BEGIN A_END
%left COMMA
%left COLON
%%
START: ARRAY {
      printf("%s",$1);
    }
  | OBJECT {
      printf("%s",$1);
    }
  ;
OBJECT: O_BEGIN O_END {
      $$ = "\n{}\n";
    }
  | O_BEGIN MEMBERS O_END {
      $$ = createObjType($2);
      sprintf($$,"\n{\n%s\n}",$2);
    }
  ;
MEMBERS: PAIR {
      $$ = $1;
    }
  | PAIR COMMA MEMBERS {
      $$ = createMemType($1, $3);
      sprintf($$,"%s, \n%s",$1,$3);
    }
  ;
PAIR: STRING COLON VALUE {
      $$ = createPairType($1, $3);
      sprintf($$,"%s:%s",$1,$3);
    }
  ;
ARRAY: A_BEGIN A_END {
      $$ = (char *)malloc(sizeof(char)*(2+1));
      sprintf($$,"[]");
    }
  | A_BEGIN ELEMENTS A_END {
      $$ = createArrType($2);
      sprintf($$,"[%s]",$2);
    }
  ;
ELEMENTS: VALUE {
      $$ = $1;
    }
  | VALUE COMMA ELEMENTS {
      $$ = createEleType($1, $3);
      sprintf($$,"%s,%s",$1,$3);
    }
  ;
VALUE: STRING {$$=yylval;}
  | NUMBER {$$=yylval;}
  | OBJECT {$$=$1;}
  | ARRAY {$$=$1;}
  | TRUE {$$="TRUE";}
  | FALSE {$$="FALSE";}
  | TNULL {$$="NULL";}
  ;
%%
extern FILE *yyin;
void main(int argc, char *argv[])
{
  if (argc > 1)
  {
    yyin = fopen(argv[1], "r");
    if (!yyin) 
    {
      fprintf(stderr, "could not open %s\n", argv[1]);
      exit(1);
    }
    while(!feof(yyin))
        yyparse();
  }
  printf("\n");
  fclose(yyin);
}
int yywrap()
{
   return 1;
}
void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

char* createObjType(char* member){
  
  char* clone = (char *)malloc(sizeof(char)*(1+strlen(member)+1+1));
  return clone;
}

char* createMemType(char* member1, char* member2){
  char* clone = (char *)malloc(sizeof(char)*(strlen(member1)+1+strlen(member2)+1));
  return clone;
}

char* createPairType(char* member1, char* member2){
  char* clone = (char *)malloc(sizeof(char)*(strlen(member1)+1+strlen(member2)+1));
  return clone;
}

char* createArrType(char* member){
  char* clone = (char *)malloc(sizeof(char)*(1+strlen(member)+1+1));
  return clone;
}

char* createEleType(char* member1, char* member2){
  char* clone = (char *)malloc(sizeof(char)*(strlen(member1)+1+strlen(member2)+1));
  return clone;
}