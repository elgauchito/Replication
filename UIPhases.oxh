#import "DDP"

/** Weeks in the UI system.
MinWrkReq: weeks of work required before any UI earned.<br>
MinInitialWeeks:  weeks of UI at MinWrkReq<br>
MaxWrkReq: weeks of work at which maximum UI earned<br>
MaxBenWks: maximum weeks of UI<br>
StatPhase: 0, indicates the phase is stationary<br>

@name UIlimits **/
enum{MinWrkReq=26,MinInitialWeeks=26,MaxWrkReq=52,MaxBenWks=52,StatPhase=0}

/** Phases of time in the model.
PhaseA : Search in school<br>
PhaseB : Search after leaving school without a job<br>
PhaseC1 : First working spell after school, building up UI<br>
PhaseC2 : Acquired maximum benefits.<br>
PhaseC3 : Receiving UI benefits after first spell ends<br>
PhaseD  : Search and work in a stationary environment without UI.
@name Phases
**/
enum{PhaseA,  PhaseB,     PhaseC1,      PhaseC2, PhaseC3,   PhaseD,  NPhases}

/** Vector of Maximum phase lengths.**/
static const
    decl MaxTimes =
                 <1;      StatPhase;   MaxWrkReq-1;  StatPhase; MaxBenWks;   StatPhase>;
    //           In Sch. |After     |Qualifying	  |Max Wks	|LostUIJob |ExhuastedBenfits

/** Feasible times next period (values of t'').  @name NextPhases **/
enum{SamePhase,NextPhase,LastPhase,Tprime}

struct UIPhases : Clock {
    const decl
    /** Weeks acquired if in PhaseC1/2.
        Weeks left on UI if in Phase C3.   **/        wks,
    /** Phase of the model at current t.
        @see NPhases **/                              phase,
    /** accept ActionVariable .**/	                  acc,
    /** work status at start of period
        StateVariable. **/                            mstat,
    /** vector of phase starts times. **/             t0,
    /** length of phases (1 for stationary).**/       Rmaxes,
    /** array to hold PhaseC3 V() values for
        different initial UI weeks depending
        on weeks worked in Phase C1/C2. **/           hold;
    decl
    /** TRUE if no UI system available. **/           noUI;
	UIPhases(acc,mstat);
    virtual Update();
    virtual Weeks();
	Vupdate(now);
	Transit(FeasA);
	setPstar();
	}
