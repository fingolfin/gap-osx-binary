#############################################################################
##
##  homalgExternalObject.gd     homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg's external objects.
##
#############################################################################

####################################
#
# categories:
#
####################################

# a new GAP-category:

DeclareCategory( "IshomalgExternalObject",
        IsAttributeStoringRep );

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "homalgPointer",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgPointer",
        [ IsString ] );

DeclareOperation( "homalgPointer",
        [ IsBool ] );

DeclareOperation( "homalgExternalCASystem",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgExternalCASystemVersion",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgStream",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgExternalCASystemPID",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgLastWarning",
        [ IshomalgExternalObject ] );

DeclareOperation( "homalgNrOfWarnings",
        [ IshomalgExternalObject ] );

# constructors:

DeclareGlobalFunction( "homalgExternalObject" );

