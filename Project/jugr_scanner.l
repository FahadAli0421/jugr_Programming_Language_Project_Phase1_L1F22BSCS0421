%{
#include <stdio.h>

int line_num = 1;
int token_count = 0;
int error_count = 0;

void report_token(const char *type, const char *lexeme) {
    fprintf(stdout, "Line %d: %s %s\n", line_num, type, lexeme);
    token_count++; 
}

void report_error(const char *lexeme, const char *description) {
    fprintf(stdout, "Line %d: ERROR -> %s (%s)\n", line_num, lexeme, description);
    error_count++;
}
%}

%option noyywrap

%%

"//"[^\n]* { } 
"/*"(.|\n)*?"*/" { } 
[ \t]+ { } 
\n { line_num++; } 

"pura_number" { report_token("KEYWORD", yytext); }
"thora_number" { report_token("KEYWORD", yytext); }
"jumla" { report_token("KEYWORD", yytext); }
"harf" { report_token("KEYWORD", yytext); }
"khali_kaam_kar" { report_token("KEYWORD", yytext); }

"shamil_karo" { report_token("KEYWORD", yytext); }
"shuru_hoja" { report_token("KEYWORD", yytext); }
"maan_lo_ye" { report_token("KEYWORD", yytext); }
"warna_maan_lo_ye" { report_token("KEYWORD", yytext); }
"bas_maan_lo_bhai" { report_token("KEYWORD", yytext); }
"ghuma_de" { report_token("KEYWORD", yytext); }
"ghumata_reh" { report_token("KEYWORD", yytext); }
"pehle_kar" { report_token("KEYWORD", yytext); }
"tham_ja" { report_token("KEYWORD", yytext); }
"wapas_aja" { report_token("KEYWORD", yytext); }
"nikal_lo" { report_token("KEYWORD", yytext); }
"sunle" { report_token("KEYWORD", yytext); }
"likhle" { report_token("KEYWORD", yytext); }

"ke_barabar_ha" { report_token("OPERATOR", yytext); }
"ke_barabar_nahi_ha" { report_token("OPERATOR", yytext); }
"se_bada_ha" { report_token("OPERATOR", yytext); }
"se_chota_ha" { report_token("OPERATOR", yytext); }
"se_bada_ya_barabar_ha" { report_token("OPERATOR", yytext); }
"se_chota_ya_barabar_ha" { report_token("OPERATOR", yytext); }
"palat_de" { report_token("OPERATOR", yytext); }
"aur_bhi" { report_token("OPERATOR", yytext); }
"ya_phir" { report_token("OPERATOR", yytext); }

"++" { report_token("OPERATOR", yytext); }
"--" { report_token("OPERATOR", yytext); }

"=" { report_token("OPERATOR", yytext); }
"+" { report_token("OPERATOR", yytext); }
"-" { report_token("OPERATOR", yytext); }
"*" { report_token("OPERATOR", yytext); }
"/" { report_token("OPERATOR", yytext); }
"%" { report_token("OPERATOR", yytext); }

";" { report_token("TERMINATOR", yytext); }
"{" { report_token("PUNCTUATION", yytext); } 
"}" { report_token("PUNCTUATION", yytext); } 
"," { report_token("PUNCTUATION", yytext); }
"(" { report_token("PUNCTUATION", yytext); }
")" { report_token("PUNCTUATION", yytext); }
"<" { report_token("PUNCTUATION", yytext); }
">" { report_token("PUNCTUATION", yytext); }
"[" { report_token("PUNCTUATION", yytext); }
"]" { report_token("PUNCTUATION", yytext); }

[~!@#$%^&*]+[a-zA-Z0-9_]* { 
    report_error(yytext, "invalid symbol or illegal identifier start"); 
}

[0-9]+[a-zA-Z_]+[a-zA-Z0-9_]* { 
    report_error(yytext, "invalid identifier (cannot start with digits)"); 
}

[0-9]+(\.|\^) {
    report_error(yytext, "invalid number format (incomplete float or exponent base)");
}

[a-zA-Z][a-zA-Z0-9_]* { report_token("IDENTIFIER", yytext); }
[0-9]+(\.[0-9]+)?(\^[+-]?[0-9]+)? { report_token("NUMBER", yytext); } 
\"([^"\n]|\\.)*\" { report_token("STRING", yytext); }
'([^'\n]|\\.)' { report_token("CHAR", yytext); }

. { report_error(yytext, "unrecognized symbol"); }

%%

int main() {
    yylex();
    fprintf(stdout, "--------------------------\n");
    fprintf(stdout, "Total Valid Tokens: %d\n", token_count); 
    fprintf(stdout, "Total Errors Found: %d\n", error_count); 
    return 0;
}
