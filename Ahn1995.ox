#include "Ahn1995.h"

/** Need to specify the Reachable and  Utility functions**/

Ahn::Reachable(){
				return new Ahn(); }

Ahn::Utility()  {
// eqn(12) with a substition for x_k ( from eqn(2) )?
	return Y + nc;	   //temporary
	}

/** Setup and solve the model.
**/	
Ahn::Run()	{
	Initialize(Reachable);
	SetClock(Aging,T);
	SetDelta(0.95);   // matches delta in eqn(12)
	Actions(d = new BinaryChoice());
	ExogenousStates(p = new SimpleJump("p",Noff));
	CreateSpaces();
	
    }