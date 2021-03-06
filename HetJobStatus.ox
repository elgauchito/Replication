#include "HetJobStatus.oxh"

/** Create the job market status state variable.
@param L label
@param acc accept action variable
@param OffProb offer probability
@param TypeProp job type proportions
@param LayOffProb vector-valued layoff probabilities conditional on job type.
@see Jstates
**/
HetJobStatus::HetJobStatus(L,acc,OffProb,TypeProp,LayOffProb) {
	StateVariable(L,NJstates);
	this.acc = acc;
	this.OffProb = OffProb;
	this.TypeProp = TypeProp;
	this.LayOffProb = LayOffProb;
	}

HetJobStatus::Transit(FeasA) {
	decl a = FeasA[][acc.pos],op = CV(OffProb);
	op = (1-op)~op;
	if (v==hasoff) return { vals , (1-a)*op ~ a.*CV(TypeProp)' };
	if (v==nooff) return { nooff~hasoff , reshape(op,rows(FeasA),2) };
	decl l = CV(LayOffProb)[v-J1];
	return { nooff~hasoff~v , reshape( l*op~(1-l), rows(FeasA), 3) };
	}