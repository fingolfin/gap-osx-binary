#############################################################################
##
##  HomalgExternalMatrix.gd   HomalgToCAS package            Mohamed Barakat
##                                                            Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for homalg matrices.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "homalgPointer",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystem",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystemVersion",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgStream",
        [ IsHomalgMatrix ] );

DeclareOperation( "homalgExternalCASystemPID",
        [ IsHomalgMatrix ] );

# constructor methods:

## ConvertHomalgMatrix has been declared in homalg since it is called there

DeclareOperation( "ConvertHomalgMatrixViaFile",
        [ IsHomalgMatrix, IsHomalgRing ] );

