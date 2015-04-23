#include "Ahn1995.h"

/** Return a new instance of Zurcher (a state &theta;).**/
Ahn::Reachable()	{ return new Ahn(); }


/** The one period return.
<dd><pre>U = dRC+(1-d)&theta;<sub>1</sub>mx + n</pre></dd>
**/
Ahn::Utility()  {
// NOT SURE WHAT TO PUT HERE.... Equation 12 with a substition for x_k (Equation 2)?
	return ;	
	}

/** Setup and solve the model.
**/	
Ahn::Run()	{
	decl EMax,row;

    Initialize(Reachable);
	SetClock(NormalAging,T+tau)
	decl t, nc, nb;


	//HERE
	
	EndogenousStates(x = new Renewal("x",NX,d,pars[0][theta3]) );
	CreateSpaces();

	EMax = new ValueIteration();
	EMax.vtoler = 1E-1;   					//loose tolerance because beta near 0 and 1
    for(row=0;row<sizeof(pars);++row) {
		SetDelta(pars[row][disc]);
		th1 = pars[row][theta1];
		normalization = th1*mfact*NX/2.0;	//median cost, keep U() centered on 0.0
		rc = pars[row][RC];
		EMax -> Solve();
        Output();
		}
	}

	
Zurcher::Output() {
    decl vmat,first,ps;
    if (first=isint(chprob)) chprob = data =<>;
	DPDebug::outV(TRUE,&vmat);
	chprob |= reverser(vmat[][sizec(vmat)-1]');
    ps = new Panel(!first);
	ps -> Simulate(10,400,0,TRUE);  //draw from ergodic distn.
	ps->Flat();		
	data |= selectifr(ps.flat,ps.flat[][columns(ps.flat)-1]);
    if (!first) {	
       println("Simulated data ","%c",Panel::Lflat,"%cf",{"%6.0f"},data);
       SetDraw(SET_COLORMODEL,3);
	   SetDraw(SET_MARGIN,1000,1000);
	   SetDraw(SET_PRINTPAGE,PAGE_LETTER,PAGE_PORTRAIT);
	   DrawTitle(0,"Replication of Figure 3, Rust 1987 Using DDP");
	   DrawText(0,"\\delta=0.0",85,chprob[1][85]);
	   DrawText(0,"\\delta=0.9999",85,chprob[0][85]-.01);
	   DrawText(0,"Probability of Engine Replacement",0,0,-1,-1,TEXT_YLABEL);
	   SetDraw(SET_LINE,2,TP_SOLID,500,0,0);
	   SetDraw(SET_LINE,3,TP_SOLID,500,0,0);
	   Draw(0,chprob);
	   SaveDrawWindow("Zurcher-Figure3-Replication.pdf");
       }
    }