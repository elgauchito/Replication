#import "DDP"
#import "UIPhases"
#import "HetJobStatus"
#include <oxdraw.h>

enum{ubar,lamL,delt,gamm,c,piz,pij,lamO,sig,Nparams}  //CF why did you get rid of this?
enum{rx,fx,CoeffTypes}
enum{Njobtypes=Two,Ncountry=Two}

struct UISearch : OneDimensionalChoice { // Is this the right class to derive from?  CF: Yess, but it is a bad name!

	enum{Male, Female, Ngender} // gender
	enum{HS, College, Neduc} // education
	enum{White, Nwhite, Nrace} //race variable for US
	enum{Natlantic, Atlantic, Nregion} // region variables for Canada
 	
	// define random effects group
	enum{skill0, skill1, Nskill} // skill levels
	// define parameters to be estimated

	
	//parameter values from Table 2, p. 122
	//Just Canada

	static decl mpars, epars, Lambda1;
	static decl m; //  "m" is market status, "ubar" is the miminum wage, "a" is accept/reject

	static decl gender, educ, race, region, skill, WinSch, ctry; // declaring fixed effect variables CF: you were missing skill, country? work in school?
	/**   */


	static 	Reachable();
	static 	Run();
	static	eparsInitialize();
	static  mparsUpdate();
	static  skdens();
	UISearch();
	Udiff(z);
	EUtility();

}
