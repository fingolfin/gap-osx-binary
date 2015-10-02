##############################################################################
##
#W  example1.g                   Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.02, 20/09/2011
##
#Y  Copyright (C) 1996-2011, Chris Wensley and Anne Heyworth 
##

SetInfoLevel( InfoKan, 1 );
SetInfoLevel( InfoKnuthBendix, 1 );

Print( "\n==============================================================\n" );
Print( "2-generator example example1.g, <a^6>F2<a^4>, version 20/09/11\n" );
Print( "==============================================================\n\n" );

G1 := FreeGroup( 2 );
L1 := [2,1,4,3];
order := "shortlex";
alph1 := "AaBb";
rws1 := ReducedConfluentRewritingSystem( G1, L1, order, 0, alph1 );
Print( "rules for rewriting system rws1:\n" );
DisplayRwsRules( rws1 );

genG1 := GeneratorsOfGroup( G1 );
genH1 := [ genG1[1]^6 ];
genK1 := [ genG1[1]^4 ];
dcrws1 := DoubleCosetRewritingSystem( G1, genH1, genK1, rws1 );;
IsDoubleCosetRewritingSystem( dcrws1 );
Print( "\nrules for double coset rewriting system dcrws1:\n" );
DisplayRwsRules( dcrws1 );
waG1 := WordAcceptorOfReducedRws( rws1 );
Print( "\ngroup word acceptor waG1:\n", waG1, "\n" );
Print( "alphabet of group acceptor: ", AlphabetOfAutomatonAsList(waG1), "\n" );
Print( "language of group acceptor:\n", FAtoRatExp( waG1 ), "\n\n" );
wadc1 := WordAcceptorOfDoubleCosetRws( dcrws1 );
Print( "word acceptor wadc1 of dcrws1:\n", wadc1 );
Print( "has alphabet ", AlphabetOfAutomatonAsList( wadc1 ), "\n\n" ); 

words1 := [ "HK","HaK","HbK","HAK","HaaK","HbbK","HabK","HbaK","HbaabK"];;
Print( "list of 9 words:\n", words1, "\n" );
valid1 := List( words1, w -> IsRecognizedByAutomaton( wadc1, w ) );
Print( "these words are or are not recognized?\n", valid1, "\n" );
Print( "alphabet of group acceptor: ", AlphabetOfAutomatonAsList(wadc1), "\n");
lang1 := FAtoRatExp( wadc1 );
Print( "language of double coset word acceptor:\n", lang1, "\n\n" );
