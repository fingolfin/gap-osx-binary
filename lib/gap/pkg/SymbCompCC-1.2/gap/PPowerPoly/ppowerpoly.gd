###############################################################################
##
#F ppowerpoly.gd            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## Global Functions
##
DeclareGlobalFunction( "RedPPowerPolyCoeffs" );
DeclareGlobalFunction( "Int2PPowerPoly" );
DeclareGlobalFunction( "PPP_Check" );
DeclareGlobalFunction( "PPP_OneNC" );
DeclareGlobalFunction( "PPP_ZeroNC" );
DeclareGlobalFunction( "PPP_Print" );
DeclareGlobalFunction( "PPP_PrintMat" );
DeclareGlobalFunction( "PPP_PrintRow" );
DeclareGlobalFunction( "PPP_Equal" );
DeclareGlobalFunction( "PPP_Smaller" );
DeclareGlobalFunction( "PPP_Greater" );
DeclareGlobalFunction( "PPP_Add" );
DeclareGlobalFunction( "PPP_Subtract" );
DeclareGlobalFunction( "PPP_Mult" );
DeclareGlobalFunction( "PPP_AdditiveInverse" );
DeclareGlobalFunction( "EvaluatePPowerPoly" );
DeclareGlobalFunction( "PPP_AbsValue" );
DeclareGlobalFunction( "IsPDivisiblePPP" );
DeclareGlobalFunction( "PPP_PadicValue" );

DeclareGlobalFunction( "PPPL_Check" );
DeclareGlobalFunction( "PPPL_CheckNC" );
DeclareGlobalFunction( "PPPL_Print" );
DeclareGlobalFunction( "PPPL_PrintMat" );
DeclareGlobalFunction( "PPPL_PrintRow" );
DeclareGlobalFunction( "PPPL_Equal" );
DeclareGlobalFunction( "PPPL_Smaller" );
DeclareGlobalFunction( "PPPL_Greater" );
DeclareGlobalFunction( "PPPL_Add" );
DeclareGlobalFunction( "PPPL_Subtract" );
DeclareGlobalFunction( "PPPL_Mult" );
DeclareGlobalFunction( "PPPL_OneNC" );
DeclareGlobalFunction( "PPPL_ZeroNC" );
DeclareGlobalFunction( "PPPL_AdditiveInverse" );
DeclareGlobalFunction( "PPPL_AbsValue" );
DeclareGlobalFunction( "PPPL_PadicValue" );
DeclareGlobalFunction( "PPPL_MatrixMult" );

###############################################################################
##
## Operations
##
DeclareOperation( "IsPDivRat", [ IsRat, IsInt ] );
DeclareOperation( "PadicValueRatNC", [ IsRat, IsInt ] );
DeclareOperation( "IdentityPPowerPolyMat", [ IsPosInt, IsPosInt ] );
DeclareOperation( "NullPPowerPolyMat", [ IsPosInt, IsPosInt ] );
DeclareOperation( "NullPPowerPolyMat", [ IsPosInt, IsPosInt, IsPosInt ] );
DeclareOperation( "IdentityPPowerPolyLocMat", [ IsPosInt, IsPosInt ] );
DeclareOperation( "NullPPowerPolyLocMat", [ IsPosInt, IsPosInt ] );
DeclareOperation( "NullPPowerPolyLocMat", [ IsPosInt, IsPosInt, IsPosInt ] );

###############################################################################
##
## GlobalFunctions
##
DeclareGlobalFunction( "PPartPoly" );
DeclareGlobalFunction( "PPrimePartPoly" );
DeclareGlobalFunction( "DivPPartPoly" );
DeclareGlobalFunction( "PPartPolyLoc" );
DeclareGlobalFunction( "PPrimePartPolyLoc" );
DeclareGlobalFunction( "PPP_QuotientRemainder" );

DeclareGlobalFunction( "DivRowLoc" );
DeclareGlobalFunction( "DivRowLoc_NonP" );
DeclareGlobalFunction( "DivColLoc" );
DeclareGlobalFunction( "DivColLoc_NonQ" );

###############################################################################
##
## operations for computing the Smith normal form
##
DeclareOperation( "ExchangeRowsPPP", [ IsPosInt, IsPosInt, IsList] );
DeclareOperation( "ExchangeColumnsPPP", [ IsPosInt, IsPosInt, IsList ] );
DeclareOperation( "EmptyColumnGreater", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "EmptyColumn", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "EmptyRowGreater", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "SmithNormalFormPPowerPoly", [ IsList] );
DeclareOperation( "SmithNormalFormPPowerPolyTransforms", [ IsList] );
DeclareOperation( "SmithNormalFormPPowerPolyColTransform", [ IsList] );

###############################################################################
##
## operations for computing the Smith normal form
##
DeclareOperation( "ExchangeRowsPPPL", [ IsPosInt, IsPosInt, IsList] );
DeclareOperation( "ExchangeColumnsPPPL", [ IsPosInt, IsPosInt, IsList ] );
DeclareOperation( "EmptyColumnLoc", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "EmptyColumnGreaterLoc", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "EmptyColumnGreaterLoc_NonP", [ IsPosInt, IsList ] );
DeclareOperation( "EmptyRowGreaterLoc", [ IsPosInt, IsList, IsList ] );
DeclareOperation( "EmptyRowGreaterLoc_NonQ", [ IsPosInt, IsList ] );
DeclareOperation( "PPowerPolyMat2PPowerPolyLocMat", [ IsList ] );

###############################################################################
##
## infoclass
##
## InfoSmithPPowerPoly: 1 level until which SNF is computed
##                      2 show pivot element
##                      3 show always P, Q and S
##
DeclareInfoClass( "InfoSmithPPowerPoly");
SetInfoLevel( InfoSmithPPowerPoly, 0 );

###############################################################################
##
## variable
##
CHECK_SMITHNF_PPOWERPOLY := false;

#E ppowerpoly.gd . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
