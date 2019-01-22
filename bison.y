
%{
#include <string>
#include <vector>
#include <map>
#include <iostream>

void yyerror(std::string);
int yylex();

std::map<std::string, int> zmienne;
int ifWynik = 1;
//enum TYP { plus, minus, razy, dziel, przypisz }
%}

%union {
	std::string *vName;
	int iValue;
};


%token <vName> IDENT
%token <iValue> LICZBA
%left '+' '-'
%left '*' '/'
%type <iValue> E
%type <iValue> S
%type <iValue> C
%type <vName> ZMIENNA
%token UNK PRINT ZMIENNA IF WHILE ROWNOSC


%start S

%%
S : ZADANIE ';' S
  | /*nic*/
  ;

  
ZADANIE : PRINT E {printf("%d\n",$2);}
	| IF E ZADANIE {
			if(ifWynik == 0) {std::cout<<"Warunek niespelniony\n";}
			else if(ifWynik==1) {std::cout<<"Warunek spelniony\n";}
			//ifWynik = 1;
		}
	|WHILE E {
		if(ifWynik == 0) {std::cout<<"Warunek niespelniony\n";}
		else if(ifWynik==1) {std::cout<<"Warunek spelniony\n"; }
		} ZADANIE ZADANIE
	| IDENT '='E {
		if(ifWynik==1){
			if(zmienne.find(*$1) != zmienne.end()){
				std::cout << "zmienna " << *$1 << " istnieje, przypisz do niej wartosc " << $3 << '\n';
				zmienne[*$1] = $3;	
			}
			else{
				std::cout<<"Zmienna "<< *$1 << " nie istnieje, przypisano do niej wartosc " << $3<<"\n";
				zmienne[*$1] = $3;
			}
		}
	}
	;
E : LICZBA {$$=$1;}
 | IDENT {$$ = zmienne[*$1];}
 | E '+' S {$$=$1+$3;}
 | E '-' S {$$=$1-$3;}
 | E '>' LICZBA {
	if($1>$3) { ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | E '<' LICZBA {
	if($1<$3) { ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | E ROWNOSC LICZBA {
	if($1==$3) {ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | E '+' IDENT {$$ = $1 + zmienne[*$3];}
 | E '-' IDENT {$$ = $1 - zmienne[*$3];}
 | E '>' IDENT {
	if($1>zmienne[*$3]) { ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | E '<' IDENT {
	if($1<zmienne[*$3]) {ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | E ROWNOSC IDENT {
	if($1==zmienne[*$3]) {ifWynik = 1;}
	else {ifWynik = 0;}
	$$ = ifWynik;
	}
 | S {$$=$1;}
 ;
S
 : S '*' C {$$=$1*$3;}
 | S '/' C {$$=$1/$3;}
 | S '*' IDENT {$$ = $1 * zmienne[*$3];}
 | S '/' IDENT {$$ = $1 / zmienne[*$3];}
 | C{$$=$1;}
 ;
C : LICZBA {$$=$1;}
 | IDENT {$$ = zmienne[*$1];}
 ;
%%
int main()
{
	yyparse();
}
void yyerror(std::string str)
{
	std::cout << str << '\n';
}

void WhileLoop(std::string op1, std::string op2){
	
}
