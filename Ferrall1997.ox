#include "Ferrall1997.oxh"

/** Set initial guess of z*. **/
UISearch::UISearch() {
	zstar = constant( CV(m)==hasoff ? log(81.0) : .NaN,N::R,1);
	} 

/** &lambda;<sup>o</sup> specification equation (15) page 121. **/
UISearch::LamO() {
	return FLogit( epars[lamO][rx][cursk]+epars[lamO][fx]*(curx[educ]|curx[raceregion]) );
	}

/** &lambda;<sup>l</sup><sub>j</sub> specification equation (15) page 121. **/
UISearch::LamL() {
	decl v0 = epars[lamL][rx][cursk]+epars[lamL][fx][:1]*(curx[educ]|curx[raceregion]) ;
	return FLogit( v0~(v0+epars[lamL][fx][2]) );
	}
	
/** &pi;<sub>0</sub> (type 0 proportion) specification equation (15) page 121. **/	
UISearch::Piz () {
	return FLogit(epars[piz][0]+epars[piz][1:]*(curx[educ]|curx[wkinsch]));
	}
/** ubar specification (see page 121 text). **/
UISearch::Ubar() {return epars[ubar][curx[ctry]][curx[educ]]; }

/** Discount factor &beta; (here named &delta;) equation (15) page 121. **/
UISearch::Delt() {return epars[delt][cursk]; }

/** 1/&gamma; specification equation (15) page 121. **/
UISearch::Gamm() {return exp(epars[gamm][rx][cursk]+epars[gamm][fx]*(curx[gender]|curx[educ]) ) ; }

/** c specification equation (15) page 121. **/
UISearch::C()    {return epars[c][rx][cursk]+epars[c][fx]*( curx[gender]| curx[educ] );		}

/** &pi;<sup>l</sub><sub>j</sub> specification equation (15) page 121. **/
UISearch::Pij()  {return CV(epars[pij]); }

/** &Lambda;<sub>1</sub> definition, page 117. **/
UISearch::PDVcoeff(){ decl j,l=0.0; for(j=0;j<Njobtypes;++j) l+=mp[pij][j]/(1-mp[delt]*(1-mp[lamL][j])); return l; }

/** Initialize estimated parameter values and set up dynamic model parameter values.**/
UISearch::eparsInitialize() {
	spec = new array[Nparams];
	epars = new array[Nparams];
	mp = new array[Nparams];
	//  Estimated Parameters	
	epars[ubar] = 0.75*constant(5.32,Nctry,Neduc);  //CF can I find these values???? 5.32=avg. female log-wage in Canada
	epars[delt ] = <.97, .998>;
	epars[lamL] =   { < -5.302, -3.515>,  		  // lambda1 random FX
	                  <-0.030, 0.519, -5.198>};    // lambda1 fixed FX					  
    epars[gamm] =    { <-1.054, -0.650>,   //gamma_inv random FX
                       <-0.186, -0.700>};   //gamma_inv fixed FX
	epars[lamO] = {
					<-0.473, -0.842>,    // lambda0 random FX
	                < 0.808, -0.595>    // lambda0 fixed FX
				   };
	epars[c] =		{ < 4.705, 4.633 >,   // c random FX
					  < -0.001, -0.277 >  // c fixed FX
					};
	epars[pij] = SumToOne(0.293);					
	epars[piz ] = <-1.916,.449,1.056>;
	epars[sig] = 1.0;
	
	//Econometric Specification
	spec[ubar] = Ubar;
	spec[lamL] = LamL;
	spec[delt] = Delt; 
	spec[gamm] = Gamm;
	spec[c] =    C; 
	spec[pij] =  Pij;
	spec[lamO] = LamO;
	spec[piz] =  Piz;
	spec[sig]  = [=]() { return CV(epars[sig]); };
	}

UISearch::Run(){

	Initialize( [=](){return new UISearch();} );   //CF Don't need class since we are inside a UISearch method
	eparsInitialize();
	

	EndogenousStates(m = new HetJobStatus("m",d,spec[lamO],spec[pij],spec[lamL]));
	SetClock(Ergodic);
//	SetClock(new UIPhases("t",acc,m)));

	skill = new RandomEffect("skill",Nskill, [=](){return SumToOne(mp[piz]);} );
	xvars = new Regressors(LX,Ngender~Neduc~Nregion~NSch~Nctry);
	GroupVariables(skill,xvars);
	
	CreateSpaces();
	Volume = LOUD;
	SaveV::TrimZeroChoice = TRUE;
	Hooks::Add(PreUpdate,UISearch::mparsUpdate);
	SetUpdateTime(AfterRandom);
	Hooks::Add(PostRESolve,DPDebug::outV);
	decl meth = new ReservationValues(log(10));
	meth->Solve(AllFixed,50);
	}

// Creating functions for calculating the parameter estimates
UISearch::mparsUpdate() {
	decl v,j;
	curx = CV(xvars);
	cursk = CV(skill);
	foreach(v in spec[j]) mp[j] = CV(v); //println(j,". ",Lpar[j],"= ",
	SetDelta(mp[delt]);
	Lambda1 = PDVcoeff();
	}


/** probability of getting zstar offer.
1-exp{ &gamma;max(z*-ubar,0.0) }
**/
UISearch::OfferF() { return 1-exp(-max(zstar[I::r]-mp[ubar],0.0)/mp[gamm]); }

/** EPDV of utility of jobs accepted based on z*.
<LI>Define <code>U(u)</code> as the expected discounted utility from accepting u=lnw, accounting for layoff probabilities.</LI>
<dd><pre>
U(u) = &Lambda;<sub>1</sub> u  if m=0
          0   if m &gt; 0
</pre></dd>
where &Lambda;<sub>1</sub> is defined in the paper. 

**/
UISearch::uPDV()   { return Lambda1*(zstar[I::r]+mp[gamm]); }

UISearch::Udiff(z) {
	if (CV(m)==hasoff) return mp[c] - Lambda1*z; // U(0)-U(1) when there is an offer z
	return 0; // no choice when already working or no offer 
	}

UISearch::EUtility(){
	if (CV(m)==hasoff)  return { mp[c] | uPDV() , SumToOne( OfferF() )' }; 
	return { mp[c]*(CV(m)==nooff), 1.0};
	}

UISearch::Utility()    { return mp[c] + (CV(m)==hasoff)*aa(d)*(uPDV()-mp[c]);	}

UISearch::FeasibleActions(A) {
   if (CV(m)==hasoff) return ones(rows(A),1);
   if (CV(m)==nooff) return 1-A[][d.pos];
   return A[][d.pos];
	}

/*
Simple::Simple() { zstar= <0.4>;} // size of zstar, how many do we need here, one for each type??  CF: No
Simple::SRun() {
	Initialize([=](){ return new Simple();});   //CF Don't need class since we are inside a UISearch method
	eparsInitialize();
	
//	SetClock(UIPhases);    UIPhases is a class not an object
	SetClock(NormalAging,3);  //CF PhaseD is stationary 
	EndogenousStates(m = new HetJobStatus("m",d,0.2,<0.5;0.5>,<0.1;0.1>));
	skill = new RandomEffect("skill",Nskill,[=](){ return <0.4;0.6>;});
	CreateSpaces();
//	Volume = NOISY;
	Hooks::Add(PreUpdate,UISearch::mparsUpdate);
	decl meth = new ReservationValues(0.0);
//	meth.Volume = LOUD;
	meth->Solve(AllFixed,5);
	}

Simple::Udiff(z) {
	if (CV(m)>hasoff) return 1.0 - 0.8*z; // U(0)-U(1) when there is an offer z, lambda1 needs to be implemented
	return 0; // no choice when already working for m>0
	}

Simple::EUtility(){
	if (CV(m)==hasoff) {
		decl pstar=1-exp(-max(zstar,0.0)/3.0); //probability of getting zstar offer 		
		return { 1.0 | 0.8*min(zstar+3.0,50.0), pstar~(1-pstar)};  // need to calculate lambda1 somewhere with the values from the parameters, probably just use an explicit expression for lambda1 here? ztar+hamma_inv=z^*+1/gamma is the expected wage that is above the reservation wage. pars[gamma_inv] needs to be implemented correctly later.
		}
	return { (CV(m)==nooff), 1.0};
}

Simple::Utility()    { return (1-aa(d)) + (max(zstar,0.0)+3.0)*aa(d);	}
*/	