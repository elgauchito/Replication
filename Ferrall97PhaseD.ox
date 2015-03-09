#include "Ferrall97PhaseD.h"

PhaseD::PhaseD() { zstar= <0.0>;} // size of zstar, how many do we need here, one for each type??


PhaseD::Reachable() {

return new PhaseD(); // need to check, still not sure about "reachable"

}

PhaseD::Run(){

	Initialize(PhaseD::Reachable); 
	SetClock(InfiniteHorizon);
	EndogenousStates(done = new LaggedAction("Done",d));
	done->MakeTerminal(1);
        // implement market status "m" as endogenous state variable here 

}


PhaseD::Udiff(z) {
	// assuming m has been implemented correctly.
	if (CV(done)) return 0; // if program finished, return 0 (do we need this here??)
 	if (CV(m)==0) return pars[c]-lambda1*z; // U(0)-U(1) when there is an offer z, lambda1 needs to be implemented
	return 0; // no choice when already working for m>0
}




PhaseD::EUtility(){
	// implement Eutility here, following Chris's notes.
	if (CV(done)) return 0;
	if (CV(m)==0) {
		decl pstar=1-exp(-(zstar-ubar)/pars[gamma_inv]); //probability of getting zstar offer
		
		retun {parc[c] | lambda1*(ztar+pars[gamma_inv]), pstar~(1-pstar)};  // need to calculate lambda1 somewhere with the values from the parameters, probably just use an explicit expression for lambda1 here? ztar+hamma_inv=z^*+1/gamma is the expected wage that is above the reservation wage. pars[gamma_inv] needs to be implemented correctly later.
}

	return 0; // return 0 for m>0.
}
