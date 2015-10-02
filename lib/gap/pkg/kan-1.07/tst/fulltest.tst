##############################################################################
##
#W  fulltest.tst                  Kan Package                    Chris Wensley
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
## Example 3 
##
gap> F3 := FreeGroup("a","b");;
gap> rels3 := [ F3.1^3, F3.2^3, (F3.1*F3.2)^3 ];;
gap> G3 := F3/rels3;;
gap> alph3 := "AaBb";;
gap> waG3 := WordAcceptorByKBMag( G3, alph3 );;
gap> Print( waG3 );
Automaton("det",18,"aAbB",[ [ 2, 18, 18, 8, 10, 12, 13, 18, 18, 18, 18, 18, 18\
, 8, 17, 12, 18, 18 ], [ 3, 18, 18, 9, 11, 9, 12, 18, 18, 18, 18, 18, 18, 11, \
18, 11, 18, 18 ], [ 4, 6, 6, 18, 18, 18, 18, 18, 6, 12, 16, 18, 12, 18, 18, 18\
, 12, 18 ], [ 5, 5, 7, 18, 18, 18, 18, 14, 15, 5, 18, 18, 7, 18, 18, 18, 15, 1\
8 ] ],[ 1 ],[ 1 .. 17 ]);;
gap> langG3 := FAtoRatExp( waG3 );;
gap> Print( langG3, "\n" );
((abUAb)AUbA)(bA)*(b(aU@)UB(aB)*(a(bU@)U@)U@)U(abUAb)(aU@)U((aBUB)(aB)*AUba(Ba\
)*BA)(bA)*(b(aU@)U@)U(aBUB)(aB)*(a(bU@)U@)Uba(Ba)*(BU@)UbUaUA(B(aB)*(a(bU@)UAU\
@)U@)U@
gap> limit := 100;;
gap> genG3 := GeneratorsOfGroup( G3 );;
gap> a := genG3[1];;  b := genG3[2];; 
gap> genH3 := [ a*b ];;  genK3 := [ b*a ];;
gap> rwsG3 := KnuthBendixRewritingSystem( G3, "shortlex", [2,1,4,3], alph3 );;
gap> dcrws3 := PartialDoubleCosetRewritingSystem( G3, genH3, genK3, rwsG3, limit );;
gap> Print( Length( Rules( dcrws3 ) ), " rules found.\n" );
101 rules found.
gap> dcaut3 := WordAcceptorByKBMagOfDoubleCosetRws( G3, dcrws3 );;
gap> Print( "Double Coset Minimalized automaton:\n", dcaut3 );
Double Coset Minimalized automaton:
Automaton("det",44,"HKaAbB",[ [ 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2\
, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2\
, 2, 2 ], [ 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, \
2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 2, 1 ], [ 2, 2, 2,\
 2, 3, 24, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 43, 2, 43, 2, 27, 2, 2, 2\
, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 ], [ 2, 2, 2, 2, 44, 3, 29, 2\
, 8, 2, 10, 2, 12, 2, 14, 2, 16, 2, 18, 2, 20, 2, 22, 2, 2, 2, 2, 26, 2, 29, 2\
, 31, 2, 33, 2, 35, 2, 37, 2, 39, 2, 41, 2, 2 ], [ 2, 2, 2, 2, 21, 2, 2, 28, 2\
, 9, 2, 11, 2, 13, 2, 15, 2, 17, 2, 19, 2, 42, 2, 3, 2, 28, 3, 2, 7, 2, 30, 2,\
 32, 2, 34, 2, 36, 2, 38, 2, 40, 2, 2, 28 ], [ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2\
, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 2, 25, 25, 2, 2, 2, 2, 2, 2, 2, 2, 2,\
 2, 2, 2, 2, 2, 2, 23, 6 ] ],[ 4 ],[ 1 ]);;
gap> dclang3 := FAtoRatExp( dcaut3 );;
gap> Print( "Double Coset language of acceptor:\n", dclang3, "\n" );
Double Coset language of acceptor:
(HbAbAbAbAbAbAbAbUHAb)(Ab)*(A(Ba(Ba)*bKUK)UK)UHbAbA(bA(bA(bA(bA(bAKUK)UK)UK)UK\
)UK)UH(A(B(aB)*(abUA)KUK)UaKUb(a(Ba)*BA(bA(bA(bA(bA(bA(bA(bA(bA)*(bKUK)UK)UK)U\
K)UK)UK)UK)UK)UAK)UK)
gap> ok := DCrules(dcrws3);;
gap> alph3e := dcrws3!.alphabet;;
gap> Print("H-rules:\n");  DisplayAsString( Hrules(dcrws3), alph3e, true );;
H-rules:
[ HB, Ha ]
[ HaB, Hb ]
[ Hab, H ]
[ HbAB, HAba ]
[ HbAbAB, HAbAba ]
[ HbAbAbAB, HAbAbAba ]
[ HbAbAbAbAB, HAbAbAbAba ]
[ HbAbAbAbAbAB, HAbAbAbAbAba ]
[ HbAbAbAbAbAbAB, HAbAbAbAbAbAba ]
[ HbAbAbAbAbAbAbAB, HAbAbAbAbAbAbAba ]
gap>     Print(" K-rules:\n");  DisplayAsString( Krules(dcrws3), alph3e, true );;
 K-rules:
[ BK, aK ]
[ BaK, bK ]
[ baK, K ]
[ BAbK, abAK ]
[ BAbAbK, abAbAK ]
[ BAbAbAbK, abAbAbAK ]
[ BAbAbAbAbK, abAbAbAbAK ]
[ BAbAbAbAbAbK, abAbAbAbAbAK ]
[ BAbAbAbAbAbAbK, abAbAbAbAbAbAK ]
[ BAbAbAbAbAbAbAbK, abAbAbAbAbAbAbAK ]
gap> Print("HK-rules:\n");  DisplayAsString( HKrules(dcrws3), alph3e, true );;
HK-rules:
[ HbK, HAK ]
[ HbAbK, HAbAK ]
[ HbAbAbK, HAbAbAK ]
[ HbAbAbAbK, HAbAbAbAK ]
[ HbAbAbAbAbK, HAbAbAbAbAK ]
[ HbAbAbAbAbAbK, HAbAbAbAbAbAK ]
[ HbAbAbAbAbAbAbK, HAbAbAbAbAbAbAK ]
gap> len := 30;;
gap> L3 := 0*[1..len];;
gap> L3[1] := IdentityDoubleCoset( dcrws3 );;
gap> for i in [2..len] do
>     L3[i] := NextWord( dcrws3, L3[i-1] );
> od;
gap> ## List of 30 normal forms for double cosets:
gap> DisplayAsString( L3, alph3e, true );
[ HK, HAK, HaK, HAbK, HbAK, HABAK, HAbAK, HABabK, HAbAbK, HbAbAK, HbaBAK, HABa\
BAK, HAbAbAK, HABaBabK, HAbABabK, HAbAbAbK, HbAbAbAK, HbaBAbAK, HbaBaBAK, HABa\
BaBAK, HAbAbAbAK, HABaBaBabK, HAbABaBabK, HAbAbABabK, HAbAbAbAbK, HbAbAbAbAK, \
HbaBAbAbAK, HbaBaBAbAK, HbaBaBaBAK, HABaBaBaBAK ]
gap> w := NextWord( dcrws3, L3[30] );;
gap> Print( w, "\n" );
m1*(m3*m6)^4*m3*m2
gap> s := WordToString( w, alph3e );;
gap> Print( s, "\n" );
HAbAbAbAbAK

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
