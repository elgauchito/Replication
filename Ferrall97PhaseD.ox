#include "Ferrall97PhaseD.h"

PhaseD::PhaseD() { zstar= <0.0>;} // size of zstar, how many do we need here, one for each type??


PhaseD::Reachable() {

return new PhaseD(); // need to check, still not sure about "reachable"

}

PhaseD:: Run(){

	Initialize(PhaseD::Reachable); 
	SetClock(InfiniteHorizon);
	EndogenousStates(done = new LaggedAction("Done",d));
	done->MakeTerminal(1);
	

}


PhaseD::Udiff(z) {
	// implement udiff here

}




PhaseD::EUtility(){

	// implement Eutility here

}
