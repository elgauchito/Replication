#include <oxstd.h>

struct G {
	static decl x,b,xb,eq;
	static Spec();
	static Eval();
	static Equation();
	}

G::Equation() {
	decl v0=exp(x*b),v1=exp(x*b);
	return v0/(1+v0) | v1/(1+v1);
	}
	
G::Spec() {
	b = <0.1;0.1>;
	x = <2.0,1.0>;
	eq = [=](){
/*   Step 1. Remove these commented-out lines and program crashes. **/
		decl v0=exp(x*b),v1=exp(x*b);
		return v0/(1+v0) | v1/(1+v1);
		return exp(x*b)/(1+exp(x*b)) | exp(x*b)/(1+exp(x*b));
		};
		
	/* Step 2. Uncomment this line to replace lambda with equivalent static function.  
	eq = Equation;
	*/
	}
G::Eval() {
	xb = eq();
	}
main() {
	G::Spec();
	println("p= ",G::Eval());
	}