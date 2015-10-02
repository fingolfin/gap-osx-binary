##############################################################################
##
#W  example3.g                   Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.02, 20/09/2011
##
#Y  Copyright (C) 1996-2011, Chris Wensley and Anne Heyworth 
##

Print("\n==================================================================\n"); 
Print("2-generator example example3.g, <a^3,b^3,(ab)^3>, version 20/09/11\n"); 
Print("==================================================================\n\n"); 

if ( Filename( KBMAG_FOR_KAN_PATH, "kbprog" ) = fail ) then
    Info( InfoKan, 1, "aborting: needs functions from the KBMAG package" );
else
    SetInfoLevel( InfoKan, 1 );
    SetInfoLevel( InfoKnuthBendix, 1 );

    F3 := FreeGroup("a","b");
    rels3 := [ F3.1^3, F3.2^3, (F3.1*F3.2)^3 ];
    G3 := F3/rels3;
    alph3 := "AaBb";
    waG3 := WordAcceptorByKBMag( G3, alph3 );;
    Print( waG3, "\n");
    langG3 := FAtoRatExp( waG3 );
    Print( langG3, "\n" );

    limit := 100;
    Print( "\nusing a limit of ", limit, " for the partial rws\n\n" );
    genG3 := GeneratorsOfGroup( G3 );
    a := genG3[1];;  b := genG3[2];; 
    genH3 := [ a*b ];; genK3 := [ b*a ];;
    rwsG3 := KnuthBendixRewritingSystem( G3, "shortlex", [2,1,4,3], alph3 );
    Print( "Attributes of G3 :-\n", KnownAttributesOfObject( G3 ), "\n\n" );
    dcrws3 := PartialDoubleCosetRewritingSystem
        ( G3, genH3, genK3, rwsG3, limit );
    Print( "#I ", Length( Rules( dcrws3 ) ), " rules found.\n" );
    dcaut3 := WordAcceptorByKBMagOfDoubleCosetRws( G3, dcrws3 );
    Print( "\nDouble Coset Minimalized automaton:\n", dcaut3, "\n");
    dclang3 := FAtoRatExp( dcaut3 );
    Print( "Double Coset language of acceptor:\n", dclang3, "\n\n" );
    ok := DCrules(dcrws3);;
    alph3e := dcrws3!.alphabet;
    Print( "H-rules = \n" );  DisplayAsString( Hrules(dcrws3), alph3e, true );
    Print( "K-rules = \n" );  DisplayAsString( Krules(dcrws3), alph3e, true );
    Print( "HK-rules= \n" );  DisplayAsString( HKrules(dcrws3), alph3e, true );

    len := 30;;
    L3 := 0*[1..len];;
    L3[1] := IdentityDoubleCoset( dcrws3 );;
    for i in [2..len] do
        L3[i] := NextWord( dcrws3, L3[i-1] );
    od;
    Print( "\nlist of ", len," irreducible words:-\n" );
    DisplayAsString( L3, alph3e, true );

    R3 := 0*[1..len];
    R3[1] := true;
    for i in [2..len] do
        w := Subword( L3[i], 2, Length(L3[i])-1 );
        s := WordToString( w, alph3e );
        R3[i] := IsRecognizedByAutomaton( waG3, s );
    od;
    if ( First(R3, b -> b=false) = fail ) then
        Print( "\nAll ", len, " irreducible reps accepted by rwsG3\n" );
    else
        Print( "not all of these representatives are accepted by rwsG3\n" );
    fi;

    w := NextWord( dcrws3, L3[30] );
    Print( "\nnext word w is: ", w, "\n" );
    s := WordToString( w, alph3e );
    Print( "converting w to a string gives: ", s, "\n\n" );
fi;
