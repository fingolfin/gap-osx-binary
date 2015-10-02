#############################################################################
##
##  samples.gd                      CRISP                    Burkhard Höfling
##
##  Copyright (C) 2000 Burkhard Höfling
##


#############################################################################
##  
#V  TrivialGroups
##
DeclareGlobalVariable ("TrivialGroups");


#############################################################################
##  
#V  NilpotentGroups
##
DeclareGlobalVariable ("NilpotentGroups");


#############################################################################
##  
#A  NilpotentProjector (<grp>)
##
DeclareAttribute ("NilpotentProjector", IsGroup);


#############################################################################
##
#V  SupersolvableGroups
##
DeclareGlobalVariable ("SupersolvableGroups");


#############################################################################
##
#A  SupersolvableProjector (<grp>)
##
DeclareAttribute ("SupersolvableProjector", IsGroup);


#############################################################################
##
#V  AbelianGroups
##
DeclareGlobalVariable ("AbelianGroups");


#############################################################################
##
#F  AbelianGroupsOfExponent (<exp>)
##
DeclareGlobalFunction ("AbelianGroupsOfExponent");


#############################################################################
##
#F  PiGroups (<primes>)
##
DeclareGlobalFunction ("PiGroups");


#############################################################################
##
#F  PGroups (<p>)
##
DeclareGlobalFunction ("PGroups");


#############################################################################
##
#V  AllPrimes
##
DeclareGlobalVariable ("AllPrimes");


############################################################################
##
#E
##

