###############################################################################
##
#F ppowerpolypcpgroups.gd     The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## Declare a new category to be able to handle the groups elements of the Schur 
## Extension with p-power-poly exponents
##

###############################################################################
##
## Introduce the category of elements of p-power-poly-pcp groups
##
DeclareCategory( "IsPPPPcpGroupsElement", 
                 IsMultiplicativeElementWithInverse );
DeclareCategoryFamily( "IsPPPPcpGroupsElement" );
DeclareCategoryCollections( "IsPPPPcpGroupsElement" );

DeclareSynonym( "IsPPPPcpGroups",
                 IsGroup and IsPPPPcpGroupsElementCollection );

###############################################################################
##
## Family
##
BindGlobal( "PPPPcpGroupsElementFamily", NewFamily( "PPPPcpGroupsElementFamily" , IsPPPPcpGroupsElement, IsPPPPcpGroupsElement ) );
BindGlobal( "PPPPcpGroupsFamily", NewFamily( "PPPPcpGroupsFamily", IsPPPPcpGroups, IsPPPPcpGroups ) );

###############################################################################
##
## Introduce the representation of elements of p-power-poly-pcp groups and 
## p-power-poly-pcp groups
##
DeclareRepresentation( "IsPPPPcpGroupsElementRep", 
                        IsComponentObjectRep,
                        ["word",
                         "div", 
                         "grp_pres" ] );
DeclareRepresentation( "IsPPPPcpGroupsRep", 
                        IsComponentObjectRep, 
                        ["rel", 
                         "n", "d", "m", 
                         "expo", "expo_vec", 
                         "prime", "cc", "name" ] ); 

###############################################################################
##
## Global Functions
##
DeclareGlobalFunction( "PPP_Words_Equal" );

###############################################################################
##
## Operations
##
DeclareOperation("PPPPcpGroupsElement",[IsPPPPcpGroups,IsList,IsList]);
DeclareOperation("PPPPcpGroupsElementNC",[IsPPPPcpGroups,IsList,IsList]);
DeclareOperation("PPPPcpGroupsElement",[IsPPPPcpGroups,IsList]);
DeclareOperation("PPPPcpGroupsElementNC",[IsPPPPcpGroups,IsList]);
DeclareOperation("CollectPPPPcp",[ IsPPPPcpGroupsElement ]);
DeclareOperation("IsConsistentPPPPcp",[ IsPPPPcpGroups ]);
DeclareOperation("IsConsistentPPPPcp",[ IsRecord ]);
#DeclareOperation("RelativeOrder_PPPPcp", [IsPPPPcpGroupsElement] );
DeclareOperation("GAPInputPPPPcpGroups",[IsString,IsPPPPcpGroups]);
DeclareOperation("GAPInputPPPPcpGroups",[IsString,IsRecord]);
DeclareOperation("GAPInputPPPPcpGroupsAppend",[IsString,IsPPPPcpGroups]);
DeclareOperation("GAPInputPPPPcpGroupsAppend",[IsString,IsRecord]);
DeclareOperation("LatexInputPPPPcpGroups",[IsString,IsPPPPcpGroups]);
DeclareOperation("LatexInputPPPPcpGroups",[IsString,IsRecord]);
DeclareOperation("LatexInputPPPPcpGroupsAppend",[IsString,IsPPPPcpGroups]);
DeclareOperation("LatexInputPPPPcpGroupsAppend",[IsString,IsRecord]);
DeclareOperation("LatexInputPPPPcpGroupsAllAppend",[IsString,IsPPPPcpGroups]);
DeclareOperation("LatexInputPPPPcpGroupsAllAppend",[IsString,IsRecord]);
DeclareOperation("AppendPPP",[IsString,IsList] );

###############################################################################
##
## infoclass
##
## InfoConsistenceyPPPPcp: 1 shows consistency rel that fails
##                         2 shows which family of consistency rels 
##                           have been checked
## InfoCollectingPPPPcp: 1 shows what is done during collecting
##
DeclareInfoClass( "InfoConsistencyPPPPcp" );
SetInfoLevel( InfoConsistencyPPPPcp, 1 );
DeclareInfoClass( "InfoCollectingPPPPcp" );
SetInfoLevel( InfoCollectingPPPPcp, 0 );

###############################################################################
##
## variable
##
COLLECT_PPOWERPOLY_PCP := true;

###############################################################################
##
## Global Functions - Collecting
##
DeclareGlobalFunction( "Reduce_ci_ppowerpolypcp" );
DeclareGlobalFunction( "Add_ci_c_ppowerpolypcp" );
DeclareGlobalFunction( "Mult_ci_c_ppowerpolypcp" );
DeclareGlobalFunction( "Reduce_word_gi_ppowerpolypcp" );
DeclareGlobalFunction( "Collect_word_ti_ppowerpolypcp" );
DeclareGlobalFunction( "Reduce_word_ti_ppowerpolypcp" );
DeclareGlobalFunction( "Collect_t_y_ppowerpolypcp" );
DeclareGlobalFunction( "Collect_word_gi_ppowerpolypcp" );
DeclareGlobalFunction( "PPPPcpGroups" );
DeclareGlobalFunction( "PPPPcpGroupsNC" );

###############################################################################
##
## Operations - Collecting
##
DeclareOperation( "Collect_ppowerpolypcp", [ IsList, IsPPPPcpGroups ] );

#E ppowerpolypcpgroups.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
