# unitlib, chapter 4

# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/example.xml", 14, 34 ]

gap> IdGroup(DihedralGroup(128));
[ 128, 161 ]
gap> V := PcNormalizedUnitGroupSmallGroup( 128, 161 );
<pc group of size 170141183460469231731687303715884105728 with 127 generators>
gap> C := Center( V );           
<pc group with 34 generators>  
gap> gens := MinimalGeneratingSet( C );;
gap> KG := UnderlyingGroupRing( V );
<algebra-with-one over GF(2), with 7 generators>
gap> f := NaturalBijectionToNormalizedUnitGroup( KG );;
gap> gens[8]^f;
(Z(2)^0)*f3+(Z(2)^0)*f4+(Z(2)^0)*f7+(Z(2)^0)*f3*f4+(Z(2)^0)*f3*f5+(Z(2)^
0)*f3*f6+(Z(2)^0)*f3*f7+(Z(2)^0)*f4*f5+(Z(2)^0)*f4*f6+(Z(2)^0)*f4*f7+(Z(2)^
0)*f3*f4*f5+(Z(2)^0)*f3*f4*f6+(Z(2)^0)*f3*f4*f7+(Z(2)^0)*f3*f5*f6+(Z(2)^
0)*f3*f5*f7+(Z(2)^0)*f3*f6*f7+(Z(2)^0)*f4*f5*f6+(Z(2)^0)*f4*f5*f7+(Z(2)^
0)*f4*f6*f7+(Z(2)^0)*f3*f4*f5*f6+(Z(2)^0)*f3*f4*f5*f7+(Z(2)^0)*f3*f4*f6*f7+(
Z(2)^0)*f3*f5*f6*f7+(Z(2)^0)*f4*f5*f6*f7+(Z(2)^0)*f3*f4*f5*f6*f7


# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/example.xml", 60, 74 ]

gap> for n in [ 1 .. NrSmallGroups( 64 ) ] do
> if not IsAbelian( SmallGroup( 64, n ) ) then
>   V := PcNormalizedUnitGroupSmallGroup( 64, n );
>   KG := UnderlyingGroupRing( V );
>   if LieLowerNilpotencyIndex( KG ) <>
>      LieUpperNilpotencyIndex( KG ) then
>     Print( n," - counterexample !!! \n" );
>     break;
>   fi;
> fi;
> od;


# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/example.xml", 83, 95 ]

gap> cl := [];;
gap> for n in [ 1 .. NrSmallGroups( 64 ) ] do
> if not IsAbelian( SmallGroup( 64, n ) ) then
>   V := PcNormalizedUnitGroupSmallGroup( 64, n );  
>   AddSet( cl, NilpotencyClassOfGroup( V ) );
> fi;
> od;
gap> cl;
[ 2, 3, 4, 5, 6, 7, 8, 16 ]

