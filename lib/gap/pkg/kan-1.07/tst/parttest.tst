##############################################################################
##
#W  parttest.tst                 Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.07, 16/10/2013
##
#Y  Copyright (C) 1996-2013, Chris Wensley and Anne Heyworth 
##

gap> SetInfoLevel( InfoKan, 0 );;
gap> SetInfoLevel( InfoKnuthBendix, 0 );;
gap> previous_assertion_level := AssertionLevel();; 
gap> ## setting AssertionLevel to 0 to avoid recursion in Automata
gap> SetAssertionLevel( 0 );; 

## Example 1 
gap> G1 := FreeGroup( 2 );;
gap> L1 := [2,1,4,3];;
gap> order := "shortlex";;
gap> alph1 := "AaBb";;
gap> rws1 := ReducedConfluentRewritingSystem( G1, L1, order, 0, alph1 );
Rewriting System for Monoid( [ f1, f1^-1, f2, f2^-1 ] ) with rules 
[ [ f1*f1^-1, <identity ...> ], [ f1^-1*f1, <identity ...> ], 
  [ f2*f2^-1, <identity ...> ], [ f2^-1*f2, <identity ...> ] ]
gap> DisplayRwsRules( rws1 );;
[ [ Aa, id ], [ aA, id ], [ Bb, id ], [ bB, id ] ]
gap> genG1 := GeneratorsOfGroup( G1 );;
gap> genH1 := [ genG1[1]^6 ];;
gap> genK1 := [ genG1[1]^4 ];;
gap> dcrws1 := DoubleCosetRewritingSystem( G1, genH1, genK1, rws1 );;
gap> IsDoubleCosetRewritingSystem( dcrws1 );
true
gap> DisplayRwsRules( dcrws1 );;
G-rules:
[ [ Aa, id ], [ aA, id ], [ Bb, id ], [ bB, id ] ]
H-rules:
[ [ Haaaa, HAA ],
  [ HAAA, Haaa ] ]
K-rules:
[ [ aaaK, AK ],
  [ AAK, aaK ] ]
H-K-rules:
[ [ HaaK, HK ],
  [ HAK, HaK ] ]
gap> waG1 := WordAcceptorOfReducedRws( rws1 );;
gap> Print( waG1 );
Automaton("nondet",6,"aAbB",[ [ [ 1 ], [ 4 ], [ 1 ], [ 4 ], [ 4 ], [ 4 ] ], [ \
[ 1 ], [ 3 ], [ 3 ], [ 1 ], [ 3 ], [ 3 ] ], [ [ 1 ], [ 6 ], [ 6 ], [ 6 ], [ 1 \
], [ 6 ] ], [ [ 1 ], [ 5 ], [ 5 ], [ 5 ], [ 5 ], [ 1 ] ] ],[ 2 ],[ 1 ]);;
gap> wadc1 := WordAcceptorOfDoubleCosetRws( dcrws1 );
< deterministic automaton on 6 letters with 15 states >
gap> words1 := [ "HK","HaK","HbK","HAK","HaaK","HbbK","HabK","HbaK","HbaabK"];;
gap> valid1 := List( words1, w -> IsRecognizedByAutomaton( wadc1, w ) );;
gap> Print( valid1, "\n" );
[ true, true, true, false, false, true, true, true, true ]
gap> lang1 := FAtoRatExp( wadc1 );
((H(aaaUAA)BUH(a(aBUB)UABUB))(a(a(aa*BUB)UB)UA(AA*BUB)UB)*(a(a(aa*bUb)Ub)UA(AA\
*bUb))UH(aaaUAA)bUH(a(abUb)UAbUb))((a(a(aa*BUB)UB)UA(AA*BUB))(a(a(aa*BUB)UB)UA\
(AA*BUB)UB)*(a(a(aa*bUb)Ub)UA(AA*bUb))Ua(a(aa*bUb)Ub)UA(AA*bUb)Ub)*((a(a(aa*BU\
B)UB)UA(AA*BUB))(a(a(aa*BUB)UB)UA(AA*BUB)UB)*(a(aKUK)UAKUK)Ua(aKUK)UAKUK)U(H(a\
aaUAA)BUH(a(aBUB)UABUB))(a(a(aa*BUB)UB)UA(AA*BUB)UB)*(a(aKUK)UAKUK)UH(aKUK)
gap> FT := FreeGroup( 2 );;
gap> relsT := [ FT.1^3*FT.2^-2 ];;
gap> T := FT/relsT;;
gap> genT := GeneratorsOfGroup( T );;
gap> x := genT[1];;  y := genT[2];;
gap> alphT := "XxYy";;
gap> ordT := [4,3,2,1];;
gap> orderT := "wreath";;
gap> rwsT := ReducedConfluentRewritingSystem( T, ordT, orderT, 0, alphT );;
gap> DisplayRwsRules( rwsT );;
[ [ Yy, id ], [ yY, id ], [ xxx, yy ], [ yyx, xyy ], [ X, xxYY ], [ Yx, yxYY ]\
 ]
gap> accT := WordAcceptorOfReducedRws( rwsT );
< non deterministic automaton on 4 letters with 7 states >
gap> Print( accT );
Automaton("nondet",7,"yYxX",[ [ [ 1 ], [ 4 ], [ 1 ], [ 4, 7 ], [ 4 ], [ 4 ], [\
 4, 7 ] ], [ [ 1 ], [ 3 ], [ 3 ], [ 1 ], [ 3 ], [ 3 ], [ 1 ] ], [ [ 1 ], [ 5 ]\
, [ 1 ], [ 5 ], [ 5, 6 ], [ 1 ], [ 1 ] ], [ [ 1 ], [ 1 ], [ 1 ], [ 1 ], [ 1 ],\
 [ 1 ], [ 1 ] ] ],[ 2 ],[ 1 ]);;
gap> langT := FAtoRatExp( accT );
(xx*(xyUy)Uy)(xx*(xyUy)Uyy*yUy)*(xx*((xYUY)Y*(yUxUX)Ux(xUX)UX)(yUYUxUX)*U(yy*(\
YUxUX)UYUX)(yUYUxUX)*)Uxx*((xYUY)Y*(yUxUX)Ux(xUX)UX)(yUYUxUX)*U(YY*(yUxUX)UX)(\
yUYUxUX)*
gap> r := RationalExpression( "((xyUy)y*UxY*UY*)Uyy*UY*" ); 
(xyUy)y*UxY*UY*Uyy*UY*
gap> AreEqualLang( langT, r );
The given languages are not over the same alphabet
false
gap> ## find a partial dcrws with a maximum of 20 rules
gap> prwsT :=  PartialDoubleCosetRewritingSystem( T, [x], [y], rwsT, 20 );;
gap> DisplayRwsRules( prwsT );;
G-rules:
[ [ X, xxYY ], [ Yx, yxYY ], [ Yy, id ], [ yY, id ], [ xxx, yy ], [ yyx, xyy ]\
 ]
H-rules:
[ [ Hx, H ],
  [ HY, Hy ],
  [ Hyy, H ],
  [ Hyxyy, Hyx ],
  [ HyxY, Hyxy ],
  [ Hyxyxyy, Hyxyx ],
  [ Hyxxyy, Hyxx ],
  [ HyxxY, Hyxxy ],
  [ HyxyxY, Hyxyxy ],
  [ Hyxyxyxyy, Hyxyxyx ],
  [ Hyxyxxyy, Hyxyxx ],
  [ Hyxxyxyy, Hyxxyx ],
  [ HyxxyxYY, Hyxxyx ] ]
K-rules:
[ [ YK, K ],
  [ yK, K ] ]
gap> paccT := WordAcceptorOfPartialDoubleCosetRws( T, prwsT );
< deterministic automaton on 6 letters with 6 states >
gap> Print( paccT );
Automaton("det",6,"HKyYxX",[ [ 2, 2, 2, 6, 2, 2 ], [ 2, 2, 1, 2, 2, 1 ], [ 2, \
2, 5, 2, 2, 5 ], [ 2, 2, 2, 2, 2, 2 ], [ 2, 2, 6, 2, 3, 2 ], [ 2, 2, 2, 2, 2, \
2 ] ],[ 4 ],[ 1 ]);;
gap> plangT := FAtoRatExp( paccT );
H(yx(yx)*x)*(yx(yx)*KUK)
gap> wordsT := [ "HK", "HxK", "HyK", "HYK", "HyxK", "HyxxK", "HyyH", "HyxYK"];;
gap> validT := List( wordsT, w -> IsRecognizedByAutomaton( paccT, w ) );
[ true, false, false, false, true, true, false, false ]

##
## Example 3 omitted because kbmag is not available 
##

##
## Example 4 ==========================\n\n");
##
gap> F := FreeGroup(2);;
gap> rels := [ F.2^2, (F.1*F.2)^2 ];;
gap> G4 := F/rels;;
gap> genG4 := GeneratorsOfGroup( G4 );;
gap> a := genG4[1];;  b := genG4[2];;
gap> U := Subgroup( G4, [a^2] );;
gap> V := Subgroup( G4, [b] );;
gap> dc4 := DoubleCosetsAutomaton( G4, U, V );;
gap> Print( dc4 );
Automaton("det",5,"HKaAbB",[ [ 2, 2, 2, 5, 2 ], [ 2, 2, 1, 2, 1 ], [ 2, 2, 2, \
2, 3 ], [ 2, 2, 2, 2, 2 ], [ 2, 2, 2, 2, 2 ], [ 2, 2, 2, 2, 2 ] ],[ 4 ],[ 1 ])\
;;
gap> rc4 := RightCosetsAutomaton( G4, V );;
gap> Print( rc4 );
Automaton("det",6,"HKaAbB",[ [ 2, 2, 2, 6, 2, 2 ], [ 2, 2, 1, 2, 1, 1 ], [ 2, \
2, 3, 2, 2, 3 ], [ 2, 2, 2, 2, 5, 5 ], [ 2, 2, 2, 2, 2, 2 ], [ 2, 2, 2, 2, 2, \
2 ] ],[ 4 ],[ 1 ]);;
gap> SetAssertionLevel( previous_assertion_level );; 
