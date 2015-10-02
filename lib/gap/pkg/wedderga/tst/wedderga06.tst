# wedderga, chapter 6

# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 21, 36 ]

gap> CG:=GroupRing( GaussianRationals, DihedralGroup(16) );;
gap> IsSemisimpleZeroCharacteristicGroupAlgebra( CG );
true
gap> FG:=GroupRing( GF(2), SymmetricGroup(3) );;                    
gap> IsSemisimpleZeroCharacteristicGroupAlgebra( FG );
false
gap> f := FreeGroup("a");
<free group on the generators [ a ]>
gap> Qf:=GroupRing(Rationals,f);
<algebra-with-one over Rationals, with 2 generators>
gap> IsSemisimpleZeroCharacteristicGroupAlgebra(Qf);
false


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 53, 65 ]

gap> QG:=GroupRing( Rationals, SymmetricGroup(4) );;       
gap> IsSemisimpleRationalGroupAlgebra( QG );       
true
gap> CG:=GroupRing( GaussianRationals, DihedralGroup(16) );;               
gap> IsSemisimpleRationalGroupAlgebra( CG );                              
false
gap> FG:=GroupRing( GF(2), SymmetricGroup(3) );;
gap> IsSemisimpleRationalGroupAlgebra( FG );
false


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 83, 90 ]

gap> IsSemisimpleANFGroupAlgebra( GroupRing( NF(5,[4]) , CyclicGroup(28) ) );
true
gap> IsSemisimpleANFGroupAlgebra( GroupRing( GF(11) , CyclicGroup(28) ) );
false


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 108, 120 ]

gap> FG:=GroupRing( GF(5), SymmetricGroup(3) );;
gap> IsSemisimpleFiniteGroupAlgebra( FG );
true
gap> KG:=GroupRing( GF(2), SymmetricGroup(3) );; 
gap> IsSemisimpleFiniteGroupAlgebra( KG ); 
false
gap> QG:=GroupRing( Rationals, SymmetricGroup(4) );;
gap> IsSemisimpleFiniteGroupAlgebra( QG );
false


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 135, 145 ]

gap> G:=DihedralGroup(8);;
gap> H:=StrongShodaPairs(G)[5][1];
Group([ f1*f2, f3, f3 ])
gap> K:=StrongShodaPairs(G)[5][2]; 
Group([ f1*f2 ])
gap> IsTwistingTrivial(G,H,K);
true


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 172, 191 ]

gap> D16 := DihedralGroup(16);
<pc group of size 16 with 4 generators>
gap> QD16 := GroupRing( Rationals, D16 );
<algebra-with-one over Rationals, with 4 generators>
gap> a:=QD16.1;b:=QD16.2;
(1)*f1
(1)*f2
gap> e := PrimitiveCentralIdempotentsByStrongSP( QD16)[3];;
gap> Centralizer( D16, a);
Group([ f1, f4 ])
gap> Centralizer( D16, b);
Group([ f2 ])
gap> Centralizer( D16, a+b);
Group([ f4 ])
gap> Centralizer( D16, e);
Group([ f1, f2 ])


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 223, 236 ]

gap> List(D16,x->a^x=a);
[ true, true, false, false, true, false, false, true, false, false, false,
  false, false, false, false, false ]
gap> List(D16,x->e^x=e);
[ true, true, true, true, true, true, true, true, true, true, true, true,
  true, true, true, true ]
gap> ForAll(D16,x->a^x=a);
false
gap> ForAll(D16,x->e^x=e);
true


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 261, 281 ]

gap> G:=DihedralGroup(16);;               
gap> QG:=GroupRing( Rationals, G );;
gap> FG:=GroupRing( GF(5), G );;
gap> e:=AverageSum( QG, DerivedSubgroup(G) );
(1/4)*<identity> of ...+(1/4)*f3+(1/4)*f4+(1/4)*f3*f4
gap> f:=AverageSum( FG, DerivedSubgroup(G) ); 
(Z(5)^2)*<identity> of ...+(Z(5)^2)*f3+(Z(5)^2)*f4+(Z(5)^2)*f3*f4
gap> G=Centralizer(G,e);
true
gap> H:=Subgroup(G,[G.1]);
Group([ f1 ])
gap> e:=AverageSum( QG, H );
(1/2)*<identity> of ...+(1/2)*f1
gap> G=Centralizer(G,e);
false
gap> IsNormal(G,H);
false


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 305, 314 ]

gap> CyclotomicClasses( 2, 21 );
[ [ 0 ], [ 1, 2, 4, 8, 16, 11 ], [ 3, 6, 12 ], [ 5, 10, 20, 19, 17, 13 ],
  [ 7, 14 ], [ 9, 18, 15 ] ]
gap> CyclotomicClasses( 10, 21 );
[ [ 0 ], [ 1, 10, 16, 13, 4, 19 ], [ 2, 20, 11, 5, 8, 17 ],
  [ 3, 9, 6, 18, 12, 15 ], [ 7 ], [ 14 ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 334, 343 ]

gap> IsCyclotomicClass( 2, 7, [1,2,4] );
true
gap> IsCyclotomicClass( 2, 21, [1,2,4] );
false
gap> IsCyclotomicClass( 2, 21, [3,6,12] );
true


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/auxiliar.xml", 367, 377 ]

gap> SetInfoLevel(InfoWedderga, 2);   
gap> WedderburnDecomposition( GroupRing( CF(5), DihedralGroup( 16 ) ) );
#I  Info version : [ [ 1, CF(5) ], [ 1, CF(5) ], [ 1, CF(5) ], [ 1, CF(5) ],
  [ 2, CF(5) ], [ 1, NF(40,[ 1, 31 ]), 8, [ 2, 7, 0 ] ] ]
[ CF(5), CF(5), CF(5), CF(5), ( CF(5)^[ 2, 2 ] ), 
  <crossed product with center NF(40,[ 1, 31 ]) over AsField( NF(40,
    [ 1, 31 ]), CF(40) ) of a group of size 2> ]

