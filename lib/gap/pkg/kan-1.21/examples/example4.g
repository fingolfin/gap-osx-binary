##############################################################################
##
#W  example4.g                   Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.11, 10/11/2014
##
#Y  Copyright (C) 1996-2014, Chris Wensley and Anne Heyworth 
##

Print("\n==============================================================\n");
Print("2-generator example example4.g, <b^2,(ab)^2>, version 10/11/14\n");
Print("==============================================================\n\n");

SetInfoLevel( InfoKan, 1 );
SetInfoLevel( InfoKnuthBendix, 1 );

F := FreeGroup(2);;
rels := [ F.2^2, (F.1*F.2)^2 ];;
G4 := F/rels;;
genG4 := GeneratorsOfGroup( G4 );;
a := genG4[1];;  b := genG4[2];;
U := Subgroup( G4, [a^2] );;
V := Subgroup( G4, [b] );;
dc4 := DoubleCosetsAutomaton( G4, U, V );;
Print( dc4, "\n" );
rc4 := RightCosetsAutomaton( G4, V );;
Print( rc4, "\n" );

