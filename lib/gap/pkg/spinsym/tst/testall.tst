#############################################################################
##
##  testall.tst                The SpinSym Package                 Lukas Maas
##
#############################################################################

gap> LoadPackage( "SpinSym", false );
true
gap> 
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> 
gap> START_TEST( "SpinSym Doc Examples" );
gap> 
gap> ordtbl:= CharacterTable( "2.Sym(18)" );
CharacterTable( "2.Sym(18)" )
gap> modtbl:= ordtbl mod 3;
BrauerTable( "2.Sym(18)", 3 )
gap> OrdinaryCharacterTable(modtbl)=ordtbl;
true
gap> ctS:= CharacterTable( "Sym(5)" );;
gap> CharacterParameters(ctS);
[ [ 1, [ 1, 1, 1, 1, 1 ] ], [ 1, [ 2, 1, 1, 1 ] ], [ 1, [ 2, 2, 1 ] ],
  [ 1, [ 3, 1, 1 ] ], [ 1, [ 3, 2 ] ], [ 1, [ 4, 1 ] ], [ 1, [ 5 ] ] ]
gap> ctA:= CharacterTable( "Alt(5)" );;
gap> CharacterParameters(ctA);
[ [ 1, [ 1, 1, 1, 1, 1 ] ], [ 1, [ 2, 1, 1, 1 ] ], [ 1, [ 2, 2, 1 ] ],
  [ 1, [ [ 3, 1, 1 ], '+' ] ], [ 1, [ [ 3, 1, 1 ], '-' ] ] ]
gap> chi:= Irr(ctS)[1];;
gap> psi:= RestrictedClassFunction(chi,ctA);;  
gap> Position(Irr(ctA),psi);  
1
gap> xi:= Irr(ctS)[7];;
gap> RestrictedClassFunction(xi,ctA) = psi;
true
gap> InducedClassFunction(psi,ctS) = chi + xi;
true
gap> chi:= Irr(ctS)[4];;
gap> psi:= RestrictedClassFunction(chi,ctA);;
gap> psi1:= Irr(ctA)[4];; psi2:= Irr(ctA)[5];;
gap> psi = psi1+psi2;
true
gap> InducedClassFunction(psi1,ctS) = chi;        
true
gap> InducedClassFunction(psi2,ctS) = chi;
true
gap> 
gap> ctS:= CharacterTable( "Sym(5)" );;
gap> ct2S:= CharacterTable( "2.Sym(5)" );;
gap> ch:= CharacterParameters(ct2S);
[ [ 1, [ 1, 1, 1, 1, 1 ] ], [ 1, [ 2, 1, 1, 1 ] ], [ 1, [ 2, 2, 1 ] ],
  [ 1, [ 3, 1, 1 ] ], [ 1, [ 3, 2 ] ], [ 1, [ 4, 1 ] ], [ 1, [ 5 ] ], 
  [ 2, [ [ 3, 2 ], '+' ] ], [ 2, [ [ 3, 2 ], '-' ] ], 
  [ 2, [ [ 4, 1 ], '+' ] ], [ 2, [ [ 4, 1 ], '-' ] ], [ 2, [ 5 ] ] ]
gap> pos:= Positions( List(ch, x-> x[1]), 1 );;
gap> RestrictedClassFunctions( Irr(ctS), ct2S ) = Irr(ct2S){pos};
true
gap> 
gap> ct2A:= CharacterTable( "2.Alt(5)" );;
gap> CharacterParameters(ct2A);
[ [ 1, [ 1, 1, 1, 1, 1 ] ], [ 1, [ 2, 1, 1, 1 ] ], [ 1, [ 2, 2, 1 ] ],
  [ 1, [ [ 3, 1, 1 ], '+' ] ], [ 1, [ [ 3, 1, 1 ], '-' ] ], 
  [ 2, [ 3, 2 ] ], [ 2, [ 4, 1 ] ], [ 2, [ [ 5 ], '+' ] ], 
  [ 2, [ [ 5 ], '-' ] ] ]
gap> ctS:= CharacterTable( "Sym(5)" ) mod 3;;
gap> ct2S:= CharacterTable( "2.Sym(5)" ) mod 3;;
gap> ch:= CharacterParameters(ct2S);
[ [ 1, [ 5 ] ], [ 1, [ 4, 1 ] ], [ 1, [ 3, 2 ] ], [ 1, [ 3, 1, 1 ] ], 
  [ 1, [ 2, 2, 1 ] ], [ 2, [ [ 4, 1 ], '+' ] ], 
  [ 2, [ [ 4, 1 ], '-' ] ], [ 2, [ [ 3, 2 ], '0' ] ] ]
gap> pos:= Positions( List(ch, x-> x[1]), 1 );;
gap> RestrictedClassFunctions( Irr(ctS), ct2S ) = Irr(ct2S){pos};
true
gap> 
gap> ct2A:= CharacterTable( "2.Alt(5)" ) mod 3;;
gap> CharacterParameters(ct2A);
[ [ 1, [ 5 ] ], [ 1, [ 4, 1 ] ], [ 1, [ [ 3, 1, 1 ], '+' ] ], 
  [ 1, [ [ 3, 1, 1 ], '-' ] ], [ 2, [ [ 4, 1 ], '0' ] ], 
  [ 2, [ [ 3, 2 ], '+' ] ], [ 2, [ [ 3, 2 ], '-' ] ] ]
gap> ct:= CharacterTable( "Sym(3)" );;  
gap> ClassParameters(ct);
[ [ 1, [ 1, 1, 1 ] ], [ 1, [ 2, 1 ] ], [ 1, [ 3 ] ] ]
gap> ct:= CharacterTable( "Alt(3)" );;
gap> ClassParameters(ct);
[ [ 1, [ 1, 1, 1 ] ], [ 1, [ [ 3 ], '+' ] ], [ 1, [ [ 3 ], '-' ] ] ]
gap> ct:= CharacterTable( "2.Sym(3)" );;
gap> ClassParameters(ct);
[ [ 1, [ 1, 1, 1 ] ], [ 2, [ 1, 1, 1 ] ], [ 1, [ 2, 1 ] ], 
  [ 2, [ 2, 1 ] ], [ 1, [ 3 ] ], [ 2, [ 3 ] ] ]
gap> ct:= CharacterTable( "2.Alt(3)" );;
gap> ClassParameters(ct);
[ [ 1, [ 1, 1, 1 ] ], [ 2, [ 1, 1, 1 ] ], [ 1, [ [ 3 ], '+' ] ], 
  [ 2, [ [ 3 ], '+' ] ], [ 1, [ [ 3 ], '-' ] ], [ 2, [ [ 3 ], '-' ] ] 
 ]
gap> ct:= CharacterTable( "2.Sym(15)" ) mod 5;;
gap> cl:= ClassParameters(ct)[99];
[ 1, [ 7, 4, 3, 1 ] ]
gap> c:= cl[2];;
gap> rep:= BasicSpinRepresentationOfSymmetricGroup(15,5);;
gap> t:= SpinSymStandardRepresentative(c,rep); 
< immutable compressed matrix 64x64 over GF(25) >
gap> OrdersClassRepresentatives(ct)[99];
168
gap> Order(t);
168
gap> BrauerCharacterValue(t);
0
gap> s1:= SpinSymStandardRepresentativeImage([ 7, 4, 3, 1 ]); 
(1,7,6,5,4,3,2)(8,11,10,9)(12,14,13)
gap> s2:= SpinSymStandardRepresentativeImage([[ 7, 4, 3, 1 ],'-']); 
(1,2,7,6,5,4,3)(8,11,10,9)(12,14,13)
gap> s2 = s1^(1,2);
true
gap> SpinSymStandardRepresentativeImage([ 7, 4, 3, 1 ],3); 
(3,9,8,7,6,5,4)(10,13,12,11)(14,16,15)
gap> 
gap> 2AA:= SpinSymCharacterTableOf\
> MaximalYoungSubgroup(8,5,"Alternating"); 
CharacterTable( "2.(Alt(8)xAlt(5))" )
gap> 2AS:= SpinSymCharacterTableOf\
> MaximalYoungSubgroup(8,5,"AlternatingSymmetric");
CharacterTable( "2.(Alt(8)xSym(5))" )
gap> 2SA:= SpinSymCharacterTableOf\
> MaximalYoungSubgroup(8,5,"SymmetricAlternating");     
CharacterTable( "2.(Sym(8)xAlt(5))" )
gap> 2SS:= SpinSymCharacterTableOf\
> MaximalYoungSubgroup(8,5,"Symmetric");           
CharacterTable( "2.(Sym(8)xSym(5))" )
gap> 
gap> SpinSymBrauerTableOfMaximalYoungSubgroup(2AA,3);
BrauerTable( "2.(Alt(8)xAlt(5))", 3 )
gap> SpinSymBrauerTableOfMaximalYoungSubgroup(2SS,5);
BrauerTable( "2.(Sym(8)xSym(5))", 5 )
gap> 
gap> ct:= SpinSymBrauerTableOfMaximalYoungSubgroup(2SS,2);  
BrauerTable( "2.(Sym(8)xSym(5))", 2 )
gap> ct1:= CharacterTable("Sym(8)") mod 2;;
gap> ct2:= CharacterTable("Sym(5)") mod 2;;     
gap> Irr( ct1*ct2 ) = Irr( ct );
true
gap> 
gap> STOP_TEST( "testall.tst", 1 );
SpinSym Doc Examples
GAP4stones: 0
gap> SizeScreen( save );;
