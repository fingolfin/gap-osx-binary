###############################################################################
##
#F ParPres-3-1.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## define the infinite coclass families in G(3,1)
##

###############################################################################
##
## define global variables
##
InstallValue( One1_PPGV31, Int2PPowerPoly( 3 , 1 ) );
InstallValue( Zero0_PPGV31, Int2PPowerPoly( 3 , 0 ) );
InstallValue( ThreeX_PPGV31, [ 3, [0,1], true, [1,0] ] );
InstallValue( ThreeXP1_PPGV31, [ 3, [0,3], true, [1,1] ] );

InstallValue( ParPresGlobalVar_3_1_Names, [ 
"G31_1",
"G31_2", 
"G31_3", 
"G31_4", 
"G31_5", 
"G31_6", 
"G31_7", 
"G31_8", 
"G31_9", 
"G31_10", 
"G31_11", 
"G31_12", 
"G31_13"
] );

###############################################################################
##
## relations and exponents
##
InstallValue( ParPresGlobalVar_3_1, [ 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,One1_PPGV31]]],[[[3,1],[4,One1_PPGV31]],[[3,1]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1,
     expo_vec := [], 
     name := "G31_1" ), 
rec( rel := [[[[5,ThreeX_PPGV31]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,One1_PPGV31]]],[[[3,1],[4,One1_PPGV31]],[[3,1]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1,
     expo_vec := [],
     name := "G31_2" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,PPP_Add(ThreeX_PPGV31,One1_PPGV31)]]],[[[3,1],[4,One1_PPGV31]],[[3,1]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1,
     expo_vec := [], 
     name := "G31_3" ), 
rec( rel := [[[[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,PPP_Add(PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31),One1_PPGV31)]]],[[[3,1],[4,One1_PPGV31]],[[3,1],[5,ThreeX_PPGV31]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1, 
     expo_vec := [], 
     name := "G31_4" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,PPP_Add(PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31),One1_PPGV31)]]],[[[3,1],[4,One1_PPGV31]],[[3,1],[5,ThreeX_PPGV31]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1, 
     expo_vec := [], 
     name := "G31_5"  ), 
rec( rel := [[[[5,ThreeX_PPGV31]]],[[[2,1],[3,1]],[[4,PPP_Add(One1_PPGV31,One1_PPGV31)],[5,PPP_Add(PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31),One1_PPGV31)]]],[[[3,1],[4,One1_PPGV31]],[[3,1],[5,ThreeX_PPGV31]],[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,One1_PPGV31],[5,One1_PPGV31]],[[4,One1_PPGV31]],[[4,One1_PPGV31]],[[4,Zero0_PPGV31]]],[[[4,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31)))],[5,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 3, 
     d := 2, 
     m := 0, 
     prime := 3,
     cc := 1,  
     expo_vec := [], 
     name := "G31_6" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,2],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]],
     expo := ThreeXP1_PPGV31,
     n := 4,
     d := 2,
     m := 0,
     prime := 3,
     cc := 1,
     expo_vec := [],
     name := "G31_7" ), 
rec( rel := [[[[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]]],[[[2,1],[3,1]],[[4,2],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1, 
     expo_vec := [], 
     name := "G31_8" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,2],[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4,
     d := 2, 
     m := 0, 
     prime := 3,
     cc := 1,  
     expo_vec := [], 
     name := "G31_9" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,2],[5,ThreeX_PPGV31],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1, 
     expo_vec := [], 
     name := "G31_10" ), 
rec( rel := [[[[1,0]]],[[[2,1],[3,1]],[[4,2],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1],[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4, 
     d := 2, 
     m := 0, 
     prime := 3,
     cc := 1,  
     expo_vec := [], 
     name := "G31_11"  ), 
rec( rel := [[[[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]]],[[[2,1],[3,1]],[[4,2],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1],[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4, 
     d := 2, 
     m := 0, 
     prime := 3, 
     cc := 1, 
     expo_vec := [], 
     name := "G31_12"  ), 
rec( rel := [[[[5,ThreeX_PPGV31]]],[[[2,1],[3,1]],[[4,2],[6,One1_PPGV31]]],[[[3,1],[4,1]],[[3,1],[5,PPP_Mult(PPP_Add(One1_PPGV31,One1_PPGV31),ThreeX_PPGV31)]],[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)]]],[[[4,1],[6,One1_PPGV31]],[[4,1]],[[4,1]],[[5,One1_PPGV31]]],[[[5,One1_PPGV31],[6,PPP_Add(One1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,One1_PPGV31]],[[5,Zero0_PPGV31]]],[[[5,PPP_Subtract(ThreeXP1_PPGV31,One1_PPGV31)],[6,PPP_Subtract(ThreeXP1_PPGV31,PPP_Add(One1_PPGV31,One1_PPGV31))]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,One1_PPGV31]],[[6,Zero0_PPGV31]]]], 
     expo := ThreeXP1_PPGV31, 
     n := 4, 
     d := 2, 
     m := 0, 
     prime := 3,
     cc := 1,  
     expo_vec := [], 
     name := "G31_13" )
] );

################################################################################
##
## ParPresGlobalVar_3_1 immutable machen
##
MakeImmutable( ParPresGlobalVar_3_1 );

#E ParPres-3-1.gi . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
