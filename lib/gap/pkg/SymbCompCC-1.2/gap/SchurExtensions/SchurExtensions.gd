###############################################################################
##
#F SchurExtension.gd         The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## Operations
##
DeclareOperation( "MakeMutableCopyListPPP", [ IsList ] );

###############################################################################
##
## Operations
##
DeclareOperation( "GetFullWord", [ IsList, IsPosInt, IsPosInt, IsPosInt ] );
DeclareOperation( "PosTails", [ IsPosInt, IsPosInt ] );
DeclareOperation( "TailsPos", [ IsPosInt, IsPosInt ] );
DeclareOperation( "SchurExtParPres", [ IsRecord ] );
DeclareOperation( "SchurExtParPres", [ IsPPPPcpGroups ] );
DeclareOperation( "GetMatrixPPowerPolySchurExt", [ IsRecord ] );
DeclareOperation( "GetMatrixPPowerPolySchurExt", [ IsPPPPcpGroups ] );
DeclareOperation( "GetRelAsWord",[IsList,IsInt,IsInt,IsPosInt,IsInt,IsList] );
DeclareOperation( "GetPcGroupPPowerPoly", [ IsRecord, IsInt ] );
DeclareOperation( "GetPcGroupPPowerPoly", [ IsPPPPcpGroups, IsInt ] );
DeclareOperation( "GetPcpGroupPPowerPoly", [ IsRecord, IsInt ] );
DeclareOperation( "GetPcpGroupPPowerPoly",[IsPPPPcpGroups,IsInt]);
DeclareOperation( "UnLocSmithNFPPowerPoly", [ IsRecord ] );
DeclareOperation( "UnLocSmithNFPPowerPolyCol", [ IsRecord ] );
DeclareOperation( "SchurMultiplicatorsStructurePPPPcps", [ IsPPPPcpGroups ]);

if VERSION < "4.5.0" then ;
else DeclareOperation( "SchurMultiplicator", [ IsPPPPcpGroups ] );
fi;

DeclareOperation( "ZeroCohomologyPPPPcps", [ IsPPPPcpGroups, IsInt ] );
DeclareOperation( "ZeroCohomologyPPPPcps", [ IsPPPPcpGroups ] );
DeclareOperation( "FirstCohomologyPPPPcps", [ IsPPPPcpGroups, IsInt ] );
DeclareOperation( "FirstCohomologyPPPPcps", [ IsPPPPcpGroups ] );
DeclareOperation( "SecondCohomologyPPPPcps", [ IsPPPPcpGroups, IsInt ]);
DeclareOperation( "SecondCohomologyPPPPcps", [ IsPPPPcpGroups ] );

###############################################################################
##
## Global Functions
##
DeclareGlobalFunction( "Reduce_x_ij" );
DeclareGlobalFunction( "Add_x_ij" );
DeclareGlobalFunction( "Mult_x_ij" );
DeclareGlobalFunction( "Reduce_g_i" );
DeclareGlobalFunction( "Collect_t_ti" );
DeclareGlobalFunction( "Reduce_t_i" );
DeclareGlobalFunction( "Collect_h_x_ij" );
DeclareGlobalFunction( "Collect_h_t_i" );
DeclareGlobalFunction( "Collect_t_y" );
DeclareGlobalFunction( "Collect_h_g_i" );
DeclareGlobalFunction( "CompareGetRelation" );
DeclareGlobalFunction( "WordsEqualPPP" );
DeclareGlobalFunction( "PPP_PrintWord" );

###############################################################################
##
## infoclass
##
## InfoConsistencyRelPPowerPoly: 1 shows which consistency relations are 
##                                 computed and gives the result
## InfoCollectingPPowerPoly:     1 shows which what is done during collecting
##
DeclareInfoClass( "InfoCollectingPPowerPoly" );
 SetInfoLevel( InfoCollectingPPowerPoly, 0 );
DeclareInfoClass( "InfoConsistencyRelPPowerPoly" );
 SetInfoLevel( InfoConsistencyRelPPowerPoly, 0 );

#E SchurExtension.gd . . . . . . . . . . . . . . . . . . . . . . .  ends here
