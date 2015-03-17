#import "DDP"
#include <oxdraw.h>

struct PhaseD : OneDimensionalChoice { // Is this the right class to derive from?

	enum{Male, Female, Ngender} // gender
	enum{HS, College, Neduc} // education
	enum{White, Nwhite, Nrace} //race variable for US
	enum{Natlantic, Atlantic, Nregion} // region variables for Canada
 	
	// define random effects group
	enum{skill0, skill1, Nskill} // skill levels
	// define parameters to be estimated

	
	//parameter values from Table 2, p. 122
	//Just Canada

	//	Note: we decided to split up the random and fixed FX found in Table 2

	static const decl pars_L1r= < -5.302, -3.515>;    // lambda1 random FX
	static const decl pars_L1f= <-0.030, 0.519, -5.198>;    // lambda1 fixed FX

	static const decl pars_gammainvr = <-1.054, -0.650>;   //gamma_inv random FX
	static const decl pars_gammainvf = <-0.700 , -0.186>;   //gamma_inv fixed FX

	static const decl pars_L0r = <-0.473, -0.842> ;    // lambda0 random FX
	static const decl pars_L0f = < 0.808, -0.595> ;    // lambda0 fixed FX

	static const decl pars_cr = < 4.705, 4.633 >;  // c random FX
	static const decl pars_cf = < -0.277, -0.41 >;  // c fixed FX
		
	static decl done, m, a, ubar; //  "m" is market status, "ubar" is the miminum wage, "a" is accept/reject
	
	static decl gender, educ, race, region; // declaring fixed effect variables
	/**   */


	static 	Reachable();
	static 	Run();
	PhaseD();
	Udiff(z);
	EUtility();

}
