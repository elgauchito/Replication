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

	//Defining groups in the model
	/{skill0, skill1, College, Nwhite, Atlantic, Jobtype1, Female, Ngroup} 

	enum{lambda1, gamma_inv, lambda0, c, Npars}

	//parameter values from Table 2, p. 122
	//parsc -> Canada, parsu -> US

	static const decl parsc= < -5.302, -3.515

				, -0.030, .Nan, 0.519, -5.198, .Nan ;    // lambda1
				   -1.054, -0.650, -0.700, .Nan , .Nan , .Nan , -0.186;   //gamma_inv
				   -0.473, -0.842, 0.808 , .Nan , -0.595, .Nan, .Nan ;    // lambda0
				    4.705, 4.633 , -0.277, .Nan , .Nan , .Nan , -0.41 >;  // c     
			

	static decl done, m, ubar; //  "m" is market status, "ubar" is the miminum wage
	
	/**   */


	static 	Reachable();
	static 	Run();
	PhaseD();
	Udiff(z);
	EUtility();

}
