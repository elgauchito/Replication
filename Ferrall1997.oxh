#import "niqlow"
//#import "UIPhases"
#import "HetJobStatus"
#include <oxdraw.h>

/** Structural parameter indices. @name ParamIndices **/
		            enum{ubar,lamL,delt,gamm,c,piz,pij,lamO,sig,Nparams}  
static const decl Lpar={"ub" ,"lamL","delt","gam","c","piz","pij","lamO","sig"};

enum{rx,fx,CoeffTypes}	// Types of estimated coefficients
enum{Njobtypes=Two}

/** X variable indices. @name Xindices **/
  					enum{gender,educ,raceregion,wkinsch,ctry,NX}
static const decl LX = {"fem","Coll","r/r","wksch","ctry"};

/** Replicate the DP reservation-wage model in Ferrall (JBES 1997).**/
struct UISearch : OneDimensionalChoice { 

	/** gender codes. @name Gender **/				enum{Male, Female, Ngender} 
	/** educ.  codes. @name Educ  **/				enum{HS, College, Neduc}
	/** U..S.race codes. @name Race **/				enum{White, Nwhite, Nrace} 
	/** Cdn regio codes. @name Region **/			enum{Natlantic, Atlantic, Nregion} 
	/** work in school codes. @name WkInSch **/		enum{No,Yes,NSch}
	/** country codes. @name Country **/			enum{Canada,Nctry} 	
	/** skill codes. @name Skills **/				enum{skill0, skill1, Nskill} 

	static decl
	/** Dynamically set `ParamIndices` array of model parameters.**/ 		mp,
	/** Static  `ParamIndices` array of specifications .**/ 				spec,
	/** Static `ParamIndices` array of estimated parameters. **/			epars,
	/** Dynamic &Lambda;<sub>1</sub> in the paper. **/						Lambda1,
	
	/** labour market status. **/											m,
	/** Regressors FixedEffectBlock. **/									xvars,
	/** Skill type RandomEffect.**/											skill,
	/** Dynamicc current value of xvars.**/ 								curx,
	/** Dyanmic current skill type. **/										cursk; 

	static 	Run();
	static	eparsInitialize();
	static  mparsUpdate();
	static  skdens();

	// Econometric Specification functions 
	static  LamL();
	static  Piz();
	static PDVcoeff();
	static LamO();
	static Ubar();
	static Gamm();
	static Delt();
	static C();
	static Pij();

	OfferF();
	uPDV();
	UISearch();
	Utility();
	Udiff(z);
	EUtility();
	FeasibleActions(A);

}

/*  Used to track down lambda-function bug
struct Simple : UISearch {
	static SRun();
	Simple();
	Utility();
	Udiff(z);
	EUtility();
	}
*/	