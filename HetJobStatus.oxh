#import "DDP"

struct HetJobStatus : Random {
	const decl TypeProp, LayOffProb, acc;
	HetJobStatus(L,N,acc,TypeProp,LayOffProb);
	Transit(FeasA);
}