#############################################################################
##
##
#W  simpleChains.gd                       Ruth Hoffmann
##
##
#Y  Copyright (C) 2004-2015 School of Computer Science, 
#Y                          University of St. Andrews, North Haugh,
#Y                          St. Andrews, Fife KY16 9SS, Scotland
##

################################################################################
##
#F  OnePointDelete(perm)
##
## OnePointDelete removes single points in the simple permutation and returns
## a list of the resulting simple permutations, in their rank encoding.
##
DeclareGlobalFunction( "OnePointDelete" );

################################################################################
##
#F  TwoPointDelete(perm)
##
## TwoPointDelete removes two points of the input exceptional permutation and
## returns the list of the unique resulting permutation, in its rank encoding.
##
DeclareGlobalFunction( "TwoPointDelete" );

################################################################################
##
#F  PointDeletion(perm)
##
## PointDeletion, takes any simple permutation does not matter whether 
## exceptional or not and removes the right number of points.
##
DeclareGlobalFunction( "PointDeletion" );

########
## Experimental, undocumented code to get the language of simple permutations 
## with one more point.
########
################################################################################
##
#F NonSimpleOnePointAdditionTransducer(length,k)
##
## Constructs an transducer that when applied to an language, finds all the words
## with an additional letter which seem are not simple permutations.
##
DeclareGlobalFunction( "NonSimpleOnePointAdditionTransducer" );

################################################################################
##
#F OneStepSimplePermsAut(perms)
##
## Takes in a list of rank encoded simple permutations, of the same length and 
## returns the simple permutations that are have one additional point and are 
## encoded using the same alphabet.
##
DeclareGlobalFunction( "OneStepSimplePermsAut" );