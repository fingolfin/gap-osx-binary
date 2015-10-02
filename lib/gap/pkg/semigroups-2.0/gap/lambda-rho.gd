############################################################################
##
#W  lambda-rho.gd
#Y  Copyright (C) 2013-14                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

DeclareGlobalFunction("RectifyLambda");
DeclareGlobalFunction("RectifyRho");
DeclareGlobalFunction("RectifyInverseRho");

DeclareAttribute("LambdaOrb", IsActingSemigroup, "mutable");
DeclareAttribute("RhoOrb", IsActingSemigroup, "mutable");
DeclareFilter("IsLambdaOrb", IsOrbit);
DeclareFilter("IsRhoOrb", IsOrbit);
DeclareFilter("IsInverseOrb", IsOrbit);

DeclareGlobalFunction("LambdaOrbMults");
DeclareGlobalFunction("LambdaOrbMult");
DeclareGlobalFunction("RhoOrbMults");
DeclareGlobalFunction("RhoOrbMult");
DeclareGlobalFunction("LambdaOrbSchutzGp");
DeclareGlobalFunction("LambdaOrbRep");
DeclareGlobalFunction("RhoOrbRep");
DeclareGlobalFunction("RhoOrbSchutzGp");
DeclareGlobalFunction("LambdaOrbStabChain");
DeclareAttribute("RhoOrbStabChain", IsActingSemigroupGreensClass);
DeclareOperation("RhoOrbStabChain", [IsOrbit, IsPosInt]);

#EOF
