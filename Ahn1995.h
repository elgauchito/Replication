#import "DDP"

struct Ahn1995 : ExtremeValue {
    static decl pi ;  //prob.of boy           // Optional constants (e.g. sigma=6.5;)

	enum{T=25,tau=7};  /** State space dimensions. @names dimens **/

	static decl d, nc, nb;	  // list action variables, state variables, other things.

	static const decl
		/* estimated parameters from Table 5*/ pars ; 
	
	static Reachable();	    // Static methods can be called anything.
	
	static Utility();		  	//Automatic methods
	static FeasibleActions(Alpha);
			
	}