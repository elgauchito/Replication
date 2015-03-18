#include "UIPhases.oxh"

/** Return number of weeks of UI benefits earned .

**/
UIPhases::Weeks() {
	if (wks.v<MinWrkReq) return 0;
	if (wks.v>=MaxWrkReq) return MaxBenWks;
    oxwarning("UI weeks earned not correct yet. Fix me!");
	return (wks.v-MinWrkReq);
	}

/** Sets the actual limits and transitions. **/
UIPhases::Update() {
    noUI = TRUE;  //change to be FALSE if USA
    }

/** The clock for Ferrall (JBES 1997).
@param acc ActionVariable that indicates acceptance of current offer
@param mstat StateVariable that indicates working at the start of the period.
**/
UIPhases::UIPhases(acc,mstat)	{
	this.acc = acc;
	this.mstat = mstat;
	Rmaxes = setbounds(MaxTimes,1,.Inf);
    decl f, R;
	t0 = <Zero>;
    phase = <PhaseA>;
    wks = <Zero>;
	for (f=1;f<=NPhases;++f) {
        R = f==NPhases ? 0 : Rmaxes[f];
        phase ~= constant(f,1,R);
        t0 ~= t0[f]+R;
        switch_single (f) {
            case PhaseC1: wks~= range(1,MaxWrkReq-1);
            case PhaseC2: wks~= constant(MaxWrkReq,1,R);
            case PhaseC3: wks~= range(MaxBenWks-1,1);    //first period in Phase C1 or C2.
            default : wks ~= zeros(1,R);
            }
        }
    hold = new array[MaxBenWks-MinInitialWeeks+1];
	Clock(t0[NPhases],Tprime);
	}

/**
**/
UIPhases::Transit(FeasA) 	{
	decl a = FeasA[][acc.pos], m = mstat.v>1, nxt, pf,wkk = wks[t.v],wksearned;

    if (noUI) { // Move from PhaseA to PhaseD forever immediately.
		nxt = t0[PhaseD] | SamePhase;
		pf = ones(rows(a));
	   return {nxt,pf};
       }

	switch_single(phase[t.v]) {
		case PhaseA :
						nxt =    t0[PhaseB]    ~ t0[PhaseC1]             // t
						        |    NextPhase ~  SamePhase;             // t'
						pf =     (1-a)       ~  a;
		case PhaseB :
						nxt =    t0[PhaseB]    ~ t0[PhaseC1]             // t
						        |    SamePhase ~  NextPhase;             // t'
						pf =     (1-a)       ~  a;
		case PhaseC1 :
                        wksearned = Weeks();
                                            //  Add Week   @MaxWeek       Laid off, no job accepted          Acc. 1st week UE
                        nxt  =  (wkk<MaxWrkReq ? t.v+1 : t0[PhaseC2]) ~ t0[PhaseC3]+(MaxBenWks-wksearned) ~ t0[PhaseD]
                              |      SamePhase                        ~ NextPhase                         ~  LastPhase;
                        pf   =                      m                 ~ (1-m)*(1-a)                       ~(1-m)*a;
		case PhaseC2 : //      Still @ Work	     Already Laidoff   Took New Job Right Away
                        nxt  =          t.v      ~ t0[PhaseC3] ~ t0[PhaseD]
                              |      SamePhase   ~ NextPhase   ~ LastPhase;
                        pf   =          m        ~ (1-m)*(1-a) ~ (1-m)*a;
		case PhaseC3 ://               Still Working or Exhausted UI
						nxt=     (wkk>1  ? t.v+1  : t0[PhaseD]) ~ t0[PhaseD]
                               |               SamePhase        ~ NextPhase;
						pf	=                    (1-a)          ~  a;
		case PhaseD  : // Stay in D forever, uninsured
					   nxt = t0[PhaseD] | SamePhase;
					   pf = ones(rows(a));
		}
	return {nxt,pf};
	}

UIPhases::Vupdate(now) {
    decl iwks;
    if (aSPstar[0]) {
        aVV[0][now][NextPhase*ME+1:LastPhase*ME] = aVV[0][now][:ME];	//XXX: copy today's value to tomorrow place
        switch_single(phase[t.v]) {
            case PhaseD : hold[0]= aVV[0][now][LastPhase*ME+1:] = aVV[0][now][:ME];	
            case PhaseC3: if ( (iwks = wks[t.v]-MinInitialWeeks)>=0 )
                          hold[iwks]= aVV[0][now][:ME];
            case PhaseC1: aVV[0][now][NextPhase*ME+1:LastPhase*ME] = hold[Weeks()];   // Wipes out default copy at XXX
                          if (wks[t.v]==1) hold[0] = aVV[0][now][:ME];   // first week of C1 ...
            case PhaseB: aVV[0][now][:ME] = hold[0];        //start of C1 is put in SamePhase for PhaseA;
            }
		}
    }

UIPhases::setPstar() {return MaxTimes[phase.v]!=StatPhase; 	}
