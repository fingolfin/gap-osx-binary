#############################################################################
##
##  GaussSparse.gd              Gauss package                 Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for performing Gauss algorithms on sparse matrices.
##
#############################################################################

##
DeclareOperation( "EchelonMatDestructive",
        [ IsSparseMatrix ] );

DeclareOperation( "EchelonMatTransformationDestructive",
        [ IsSparseMatrix ] );

DeclareOperation( "ReduceMatWithEchelonMat",
        [ IsSparseMatrix, IsSparseMatrix ] ) ;

DeclareOperation( "ReduceMatWithEchelonMatTransformation",
        [ IsSparseMatrix, IsSparseMatrix ] ) ;

DeclareOperation( "KernelEchelonMatDestructive",
        [ IsSparseMatrix, IsList ] );

DeclareOperation( "RankDestructive",
        [ IsSparseMatrix, IsInt ] );

