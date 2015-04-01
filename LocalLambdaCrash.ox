#include <oxstd.h>

struct G {
	static decl x,b,equation;
	static Specification();
	static ProbValue();
	static StaticEquation();
	}

main() {
	G::Specification();
	println("prob= ",G::ProbValue());
	}
	
G::StaticEquation() {
	decl v0=exp(x*b);
	return v0/(1+v0);
	}
	
G::Specification() {
	b = <0.1;0.1>;
	x = <2.0,1.0>;

	equation = [=](){
		decl v0;
		//   Step 1. Remove these commented-out lines and program crashes. 
		/*
		v0=exp(x*b);
		return v0/(1+v0);
		*/		
		// No local variables used ... program runs
		return exp(x*b)/(1+exp(x*b));
		};
		
	//   Step 2. Uncomment this line to replace lambda with equivalent static function.  
	/* 	equation = StaticEquation;	*/
	}
	
G::ProbValue() {
	return equation();
	}
	