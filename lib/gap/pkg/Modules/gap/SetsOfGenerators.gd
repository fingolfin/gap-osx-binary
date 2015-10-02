#############################################################################
##
##  SetsOfGenerators.gd         homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for sets of generators.
##
#############################################################################

####################################
#
# categories:
#
####################################

# A new GAP-category:

DeclareCategory( "IsSetsOfGenerators",
        IsComponentObjectRep );

####################################
#
# function-operation-Attribute triples
#
####################################

KeyDependentOperation( "TransitionMap", IsSetsOfGenerators, IsList, ReturnTrue );

####################################
#
# global functions and operations:
#
####################################

# constructors:

DeclareGlobalFunction( "CreateSetsOfGeneratorsForLeftModule" );

DeclareGlobalFunction( "CreateSetsOfGeneratorsForRightModule" );

# basic operations:

DeclareOperation( "PositionOfLastStoredSetOfGenerators",
        [ IsSetsOfGenerators ] );

