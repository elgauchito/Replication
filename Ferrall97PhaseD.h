#import "DDP"
#include <oxdraw.h>

struct PhaseD : OneDimensionalChoice { // Is this the right class to derive from?

	// define fixed effects group of the model
	enum{Male, Female, Ngender} // gender
	enum{HS, College, Neduc} // education
	enum{White, Nwhite, Nrace} //race variable for US
	enum{Natlantic, Atlantic, Nregion} // region variables for Canada
 	
	// define random effects group
	enum{skill0, skill1, Nskill} // skill levels
	// define parameters to be estimated
	enum{beta, gamma_inv, lambda0, lambda1, c, Npars}

	// parameter values from table 3 p. 123
	static const decl pars={{.979,4.02,.50,.031,3.00}, // row 1 etc
				{.978,4.03,.38,.038,3.18},
			 	{.989,4.38,.78,.015,1.76},
				{.989,4.39,.73,.018,1.80},
				{.974,4.46,.31,.018,4.64},
				{.974,4.47,.20,.030,4.64},
				{.977,4.64,.51,.016,4.37},
				{.976,4.64,.37,.027,4.37} 
	};

	
	/** what other variables we need ??? */

	static decl done, m, ubar; //  "m" is market status, "ubar" is the miminum wage
	
	/**   */


	static 	Reachable();
	static 	Run();
	PhaseD();
	Udiff(z);
	EUtility();

}
