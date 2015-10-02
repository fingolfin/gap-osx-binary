#############################################################################
##
##  GAPHomalg.gd              RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for the external computer algebra system GAP.
##
#############################################################################

####################################
#
# global variables:
#
####################################

DeclareGlobalVariable( "HOMALG_IO_GAP" );

DeclareGlobalVariable( "GAPHomalgMacros" );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "_ExternalGAP_multiple_delete" );

DeclareGlobalFunction( "InitializeGAPHomalgMacros" );

# constructor methods:

DeclareGlobalFunction( "RingForHomalgInExternalGAP" );

DeclareGlobalFunction( "HomalgRingOfIntegersInExternalGAP" );

DeclareGlobalFunction( "HomalgFieldOfRationalsInExternalGAP" );

# basic operations:

