#include "HetJobDuration.h"

HetJobStatus::HetJobStatus(L,N,acc,TypeProp,LayOffProb) {
	StateVariable(L,N);
	this.acc = acc;
	this.TypeProp = TypeProp;
	this.LayOffProb = LayOffProb;
	}


HetJobStatus::Transit(FeasA) {
	decl a = FeasA[][acc.pos];
	if (!v) return { vals , (1-a) ~ a.*CV(TypeProp)' };
	decl l = CV(LayoffProb)[v-1];
	return { 0~v , reshape( l~(1-l), rows(FeasA), 2) };
	}