%{
    #include<stdio.h>
    #include "y.tab.h"
    char *strReturn(char *str);
%}
DIGIT1to9 [1-9]
DIGIT [0-9]
DIGITS {DIGIT}+
INT {DIGIT}|{DIGIT1to9}{DIGITS}|-{DIGIT}|-{DIGIT1to9}{DIGITS}
FRAC [.]{DIGITS}
NUMBER {INT}|{INT}{FRAC}
CHAR [ -!#-\[\]-~]
CHARS {CHAR}+
DBL_QUOTE ["]
%%
{DBL_QUOTE}{DBL_QUOTE} |
{DBL_QUOTE}{CHARS}{DBL_QUOTE} {
    yylval=strReturn(yytext);
    return STRING;
};
{NUMBER} {
    yylval=strReturn(yytext);
    return NUMBER;
}
true 	{ return TRUE;};
false 	{ return FALSE;};
null 	{ return TNULL;};
\{ 		{ return O_BEGIN;};
\} 		{ return O_END;};
\[ 		{ return A_BEGIN;};
\] 		{ return A_END;};
, 		{ return COMMA;};
: 		{ return COLON;};
[ \t\n\r]+ /* ignore whitespace */;

%%
char *strReturn(char *str)
{
    int len = strlen(str);
    char *clone = (char *)malloc(sizeof(char)*(len+1));
    strcpy(clone,str);
    return clone;
}