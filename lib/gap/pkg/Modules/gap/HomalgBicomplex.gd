#############################################################################
##
##  HomalgBicomplex.gd          Modules package              Mohamed Barakat
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations for homalg bicomplexes.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# constructors:

#DeclareOperation( "*",
#        [ IsHomalgRing, IsHomalgBicomplex ] );

DeclareOperation( "*",
        [ IsHomalgBicomplex, IsHomalgRing ] );

# basic operations:

