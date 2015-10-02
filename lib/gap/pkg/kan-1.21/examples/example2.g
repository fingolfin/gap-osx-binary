##############################################################################
##
#W  example2.g                   Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.11, 10/11/2014
##
#Y  Copyright (C) 1996-2014, Chris Wensley and Anne Heyworth 
##

SetInfoLevel( InfoKan, 1 );
SetInfoLevel( InfoKnuthBendix, 1 );

Print( "\n===============================================================\n" );
Print( "2-generator example example2.g, trefoil group, version 10/11/14\n" );
Print( "===============================================================\n\n" );

FT := FreeGroup( 2 );;
relsT := [ FT.1^3*FT.2^-2 ];;
T := FT/relsT;;
genT := GeneratorsOfGroup( T );;
x := genT[1];;  y := genT[2];;
alphT := "XxYy";;
ordT := [4,3,2,1];;
orderT := "wreath";;
rwsT := ReducedConfluentRewritingSystem( T, ordT, orderT, 0, alphT );;
Print( "rules for reduced rws for trefoil group with wreath order:\n" );
DisplayRwsRules( rwsT );;
accT := WordAcceptorOfReducedRws( rwsT );
Print( "word acceptor for this rws:\n", accT, "\n" );
langT := FAtoRatExp( accT );

## find a partial dcrws with a maximum of 20 rules
prwsT :=  PartialDoubleCosetRewritingSystem( T, [x], [y], rwsT, 20 );;
Print("\nrules for partial double coset rws:\n" );
DisplayRwsRules( prwsT );

paccT := WordAcceptorOfPartialDoubleCosetRws( T, prwsT );
Print( "word acceptor for this partial double coset rws:\n", paccT, "\n" );

plangT := FAtoRatExp( paccT );
wordsT := [ "HK", "HxK", "HyK", "HYK", "HyxK", "HyxxK", "HyyH", "HyxYK"];;
Print( "list of 8 words:\n", wordsT, "\n" );
validT := List( wordsT, w -> IsRecognizedByAutomaton( paccT, w ) );
Print( "these words are or are not recognized?\n", validT, "\n\n" );
