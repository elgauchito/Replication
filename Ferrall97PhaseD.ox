#include "Ferrall97PhaseD.h"

UISearch::UISearch() { zstar= <0.0>;} // size of zstar, how many do we need here, one for each type??  CF: No

UISearch::Reachable() {

	return new UISearch(); // need to check, still not sure about "reachable"		CF: All states reachable ... this is fine

}


UISearch::eparsInitialize() {
	mpars = new array[Nparams];
	mpars[lamL] = zeros(Njobtypes,1);
	epars = new array[Nparams];
	epars[ubar] = 0.75*ones(Ncountry,Neduc);  //CF can I find these values????
	epars[delt ] = <.97, .998>;

	epars[lamL] =   { < -5.302, -3.515>,  		  // lambda1 random FX
	                  <-0.030, 0.519, -5.198>};    // lambda1 fixed FX
					   
    epars[gamm] =    { <-1.054, -0.650>,   //gamma_inv random FX
                       <-0.700 , -0.186>};   //gamma_inv fixed FX
	epars[lamO] = {
					{<-0.473, -0.842>,    // lambda0 random FX
	                 < 0.808, -0.595>}    // lambda0 fixed FX
				   };
	epars[c] =		{ < 4.705, 4.633 >,   // c random FX
					  < -0.277, -0.41 >};  // c fixed FX

	epars[pij] = 0.293;
	epars[piz ] = <-1.916,.449,1.056>;
	}


UISearch::skdens() {
	mpars[piz] = exp(epars[0]+epars[1]*CV(educ)+epars[2]*CV(WinSch));
	mpars[piz] /= 1+mpars[piz];
	
	return mpars[piz] | 1-mpars[piz] ;
	}

UISearch::Run(){

	Initialize(Reachable);   //CF Don't need class since we are inside a UISearch method
	eparsInitialize();
	
//	SetClock(UIPhases);    UIPhases is a class not an object
	SetClock(Ergodic);  //CF PhaseD is stationary 

//	m = new OfferWithLayoff("status", 3);   CF:  This is based on discrete offers ...
	m = new HetJobStatus("m",Njobtypes,d,mpars[pij],mpars[lamL]);

//	SetClock(new UIPhases("t",acc,m)));

	skill = new RandomEffect("skill",Nskill,UISearch::skdens);

	//Creating fixed effect variables 
	gender = new FixedEffect("gender",Ngender); 
	educ = new FixedEffect("education",Neduc);
	region = new FixedEffect("region",Nregion);
	WinSch = Zero;  //new FixedEffect("winsch",Two);
	ctry = One;  // Canada
	
	GroupVariables(skill,gender,educ,region);
	CreateSpaces();
	Hooks::Add(PreUpdate,UISearch::mparsUpdate);
	SetUpdateTime(AfterRandom);
}

	// Creating functions for calculating the parameter estimates

UISearch::mparsUpdate() {
	mpars[ubar] = epars[ubar][CV(ctry)][CV(educ)];
	mpars[lamL] = 1.0;
	mpars[delt] = epars[delt][CV(skill)];	SetDelta(mpars[delt]);
	mpars[gamm] = 1.0;
	mpars[c] =  epars[c][rx][CV(skill)]+epars[c][fx][0]*CV(gender)+epars[c][fx][1]*CV(educ);
	mpars[pij] = epars[pij]|(1-epars[pij]);
	Lambda1 = 1.0;
//	mpars[sig] = ;
	}
	
UISearch::Udiff(z) {
	// assuming m has been implemented correctly.S
//	c=  <gender, educ> * pars_cf + par_cr[skill];   CF:  Don't want to / need to recompute everytime!

	//Implement lambda1 	
	
	if (CV(m)==0) return c - Lambda1*z; // U(0)-U(1) when there is an offer z, lambda1 needs to be implemented
	return 0; // no choice when already working for m>0
}

UISearch::EUtility(){
	// implement Eutility here, following Chris's notes.S
	if (CV(m)==0) {
		decl pstar=1-exp(-(zstar-mpars[ubar])/mpars[gamm]); //probability of getting zstar offer 
		
		return {mpars[c] | Lambda1*(zstar+mpars[gamm]), pstar~(1-pstar)};  // need to calculate lambda1 somewhere with the values from the parameters, probably just use an explicit expression for lambda1 here? ztar+hamma_inv=z^*+1/gamma is the expected wage that is above the reservation wage. pars[gamma_inv] needs to be implemented correctly later.
		}

	return {0, 1.0}; // return 0 for m>0.
}
