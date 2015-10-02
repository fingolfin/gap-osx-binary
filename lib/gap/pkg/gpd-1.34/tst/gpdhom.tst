##############################################################################
##
#W  gpdhom.tst                    Gpd Package                    Chris Wensley
##
##  version 1.31, 09/11/2014   
##
#Y  Copyright (C) 2000-2014, Chris Wensley,  
#Y  School of Computer Science, Bangor University, U.K. 
##  

gap> gpd_infolevel_saved := InfoLevel( InfoGpd );; 
gap> SetInfoLevel( InfoGpd, 0 );; 

###  Section 4.1

## SubSection 4.1.1
gap> gend12 := [ (15,16,17,18,19,20), (15,20)(16,19)(17,18) ];; 
gap> d12 := Group( gend12 );; 
gap> Gd12 := Groupoid( d12, [-37,-36,-35,-34] );;
gap> SetName( d12, "d12" );  
gap> SetName( Gd12, "Gd12" );
gap> s3 := Subgroup( d12, [ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ] );;
gap> Gs3 := SubgroupoidByPieces( Gd12, [ [ s3, [-36,-35,-34] ] ] );;
gap> SetName( s3, "s3" );  
gap> SetName( Gs3, "Gs3" );
gap> gend8 := GeneratorsOfGroup( d8 );;
gap> imhd8 := [ ( ), (15,20)(16,19)(17,18) ];;
gap> hd8 := GroupHomomorphismByImages( d8, s3, gend8, imhd8 );;
gap> homd8 := GroupoidHomomorphismByGroupHom( Gd8, Gs3, hd8 ); 
groupoid homomorphism : Gd8 -> Gs3
[ [ GroupHomomorphismByImages( d8, s3, [ (1,2,3,4), (1,3) ], 
        [ (), (15,20)(16,19)(17,18) ] ), [ -36, -35, -34 ], [ (), (), () ] ] ]
gap> e2; ImageElm( homd8, e2 );
[(1,3) : -8 -> -7]
[(15,20)(16,19)(17,18) : -35 -> -34]
gap> incGs3 := InclusionMappingGroupoids( Gd12, Gs3 );; 
gap> ihomd8 := homd8 * incGs3;; 
gap> IsBijectiveOnObjects( ihomd8 );
false
gap> Display( ihomd8 );
 groupoid mapping: [ Gd8 ] -> [ Gd12 ]
root homomorphism: [ [ (1,2,3,4), (1,3) ], [ (), (15,20)(16,19)(17,18) ] ]
images of objects: [ -36, -35, -34 ]
   images of rays: [ (), (), () ]

## SubSection 4.2.1
gap> hc6 := GroupHomomorphismByImages( c6, s3, 
>            [(5,6,7)(8,9)], [(15,16)(17,20)(18,19)] );;
gap> Fs3 := FullSubgroupoid( Gs3, [ -35 ] );; 
gap> SetName( Fs3, "Fs3" ); 
gap> homc6 := GroupoidHomomorphism( Gc6, Fs3, hc6 );;
gap> incFs3 := InclusionMappingGroupoids( Gs3, Fs3 );; 
gap> ihomc6 := homc6 * incFs3; 
groupoid homomorphism : Gc6 -> Gs3
[ [ GroupHomomorphismByImages( c6, s3, [ (5,6,7)(8,9) ], 
        [ (15,16)(17,20)(18,19) ] ), [ -35 ], [ () ] ] ]
gap> idGs3 := IdentityMapping( Gs3 );;
gap> V3 := ReplaceOnePieceInUnion( U3, 1, Gs3 ); 
groupoid with 3 pieces:
[ Gs3, Gd8, Gc6 ]
gap> images3 := [ PieceImages( idGs3 )[1], 
>              PieceImages( homd8 )[1], 
>              PieceImages( ihomc6 )[1] ];; 
gap> homV3 := HomomorphismToSinglePiece( V3, Gs3, images3 );; 
gap> Display( homV3 );         
homomorphism to single piece magma with pieces:
(1): [ Gs3 ] -> [ Gs3 ]
magma mapping: [ [ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ], 
  [ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ] ]
   object map: [ -36, -35, -34 ] -> [ -36, -35, -34 ]
(2): [ Gd8 ] -> [ Gs3 ]
magma mapping: [ [ (1,2,3,4), (1,3) ], [ (), (15,20)(16,19)(17,18) ] ]
   object map: [ -9, -8, -7 ] -> [ -36, -35, -34 ]
(3): [ Gc6 ] -> [ Gs3 ]
magma mapping: [ [ (5,6,7)(8,9) ], [ (15,16)(17,20)(18,19) ] ]
   object map: [ -6 ] -> [ -35 ]

## Section 4.3, Homomorphisms with more than one piece 

## SubSection 4.3.1
gap> isoq8 := IsomorphismNewObjects( Gq8, [-38,-37] ); 
groupoid homomorphism : 
[ 
  [ IdentityMapping( q8 ), [ -38, -37 ], 
      [ <identity> of ..., <identity> of ... ] ] ]
gap> Gq8b := Range( isoq8 );; 
gap> SetName( Gq8b, "Gq8b" ); 
gap> V4 := UnionOfPieces( [ V3, Gq8 ] ); 
groupoid with 4 pieces:
[ Gs3, Gq8, Gd8, Gc6 ]
gap> SetName( V4, "V4" ); 
gap> Vs3q8b := UnionOfPieces( [ Gs3, Gq8b ] );; 
gap> SetName( Vs3q8b, "Vs3q8b" ); 
gap> hom4 := HomomorphismByUnion( V4, Vs3q8b, [ homV3, isoq8 ] );; 
gap> PiecesOfMapping( hom4 );
[ groupoid homomorphism : Gq8 -> Gq8b
    [ [ IdentityMapping( q8 ), [ -38, -37 ], 
          [ <identity> of ..., <identity> of ... ] ] ], 
  groupoid homomorphism : 
    [ [ IdentityMapping( s3 ), [ -36, -35, -34 ], [ (), (), () ] ], 
      [ GroupHomomorphismByImages( d8, s3, [ (1,2,3,4), (1,3) ], 
            [ (), (15,20)(16,19)(17,18) ] ), [ -36, -35, -34 ], 
          [ (), (), () ] ], 
      [ GroupHomomorphismByImages( c6, s3, [ (5,6,7)(8,9) ], 
            [ (15,16)(17,20)(18,19) ] ), [ -35 ], [ () ] ] ] ]

## Section 4.4, Groupoid automoprphisms 

## SubSection 4.4.1
gap> a4 := Subgroup( s4, [(1,2,3),(2,3,4)] );; 
gap> SetName( a4, "a4" ); 
gap> gensa4 := GeneratorsOfGroup( a4 );; 
gap> Ga4 := SubgroupoidByPieces( Gs4, [ [a4, [-15,-13,-11]] ] ); 
single piece groupoid: < a4, [ -15, -13, -11 ] >
gap> SetName( Ga4, "Ga4" ); 
gap> aut1 := GroupoidAutomorphismByObjectPerm( Ga4, [-13,-11,-15] );; 
gap> Display( aut1 ); 
 groupoid mapping: [ Ga4 ] -> [ Ga4 ]
root homomorphism: [ [ (1,2,3), (2,3,4) ], [ (1,2,3), (2,3,4) ] ]
images of objects: [ -13, -11, -15 ]
   images of rays: [ (), (), () ]
gap> h2 := GroupHomomorphismByImages( a4, a4, gensa4, [(2,3,4), (1,3,4)] );; 
gap> aut2 := GroupoidAutomorphismByGroupAuto( Ga4, h2 );; 
gap> Display( aut2 ); 
 groupoid mapping: [ Ga4 ] -> [ Ga4 ]
root homomorphism: [ [ (1,2,3), (2,3,4) ], [ (2,3,4), (1,3,4) ] ]
images of objects: [ -15, -13, -11 ]
   images of rays: [ (), (), () ]
gap> im3 := [(), (1,3,2), (2,4,3)];; 
gap> aut3 := GroupoidAutomorphismByRayImages( Ga4, im3 );; 
gap> Display( aut3 ); 
 groupoid mapping: [ Ga4 ] -> [ Ga4 ]
root homomorphism: [ [ (1,2,3), (2,3,4) ], [ (1,2,3), (2,3,4) ] ]
images of objects: [ -15, -13, -11 ]
   images of rays: [ (), (1,3,2), (2,4,3) ]
gap> aut123 := aut1*aut2*aut3;; 
gap> Display( aut123 ); 
 groupoid mapping: [ Ga4 ] -> [ Ga4 ]
root homomorphism: [ [ (1,2,3), (2,3,4) ], [ (2,3,4), (1,3,4) ] ]
images of objects: [ -13, -11, -15 ]
   images of rays: [ (), (1,4,3), (1,2,3) ]
gap> inv123 := InverseGeneralMapping( aut123 );; 
gap> Display( inv123 ); 
 groupoid mapping: [ Ga4 ] -> [ Ga4 ]
root homomorphism: [ [ (2,3,4), (1,3,4) ], [ (1,2,3), (2,3,4) ] ]
images of objects: [ -11, -15, -13 ]
   images of rays: [ (), (1,2,4), (1,3,4) ]
gap> id123 := aut123 * inv123;; 
gap> id123 = IdentityMapping( Ga4 ); 
true
gap> AGa4 := AutomorphismGroup( Ga4 ); 
<group with 10 generators>
gap> AGgens := GeneratorsOfGroup( AGa4); 
[ groupoid homomorphism : Ga4 -> Ga4
    [ [ InnerAutomorphism( a4, (2,4,3) ), [ -15, -13, -11 ], [ (), (), () ] ] 
     ], groupoid homomorphism : Ga4 -> Ga4
    [ [ ConjugatorAutomorphism( a4, (3,4) ), [ -15, -13, -11 ], 
          [ (), (), () ] ] ], groupoid homomorphism : Ga4 -> Ga4
    [ [ InnerAutomorphism( a4, (1,2)(3,4) ), [ -15, -13, -11 ], 
          [ (), (), () ] ] ], groupoid homomorphism : Ga4 -> Ga4
    [ [ InnerAutomorphism( a4, (1,4)(2,3) ), [ -15, -13, -11 ], 
          [ (), (), () ] ] ], groupoid homomorphism : Ga4 -> Ga4
    [ [ GroupHomomorphismByImages( a4, a4, [ (1,2,3), (2,3,4) ], 
            [ (1,2,3), (2,3,4) ] ), [ -13, -11, -15 ], [ (), (), () ] ] ], 
  groupoid homomorphism : Ga4 -> Ga4
    [ [ GroupHomomorphismByImages( a4, a4, [ (1,2,3), (2,3,4) ], 
            [ (1,2,3), (2,3,4) ] ), [ -13, -15, -11 ], [ (), (), () ] ] ], 
  groupoid homomorphism : Ga4 -> Ga4
    [ [ IdentityMapping( a4 ), [ -15, -13, -11 ], [ (), (1,2,3), () ] ] ], 
  groupoid homomorphism : Ga4 -> Ga4
    [ [ IdentityMapping( a4 ), [ -15, -13, -11 ], [ (), (2,3,4), () ] ] ], 
  groupoid homomorphism : Ga4 -> Ga4
    [ [ IdentityMapping( a4 ), [ -15, -13, -11 ], [ (), (), (1,2,3) ] ] ], 
  groupoid homomorphism : Ga4 -> Ga4
    [ [ IdentityMapping( a4 ), [ -15, -13, -11 ], [ (), (), (2,3,4) ] ] ] ]
gap> NGa4 := NiceObject( AGa4 );; 
gap> MGa4 := NiceMonomorphism( AGa4 );; 
gap> Size( AGa4 ); 
20736
gap> SetName( AGa4, "AGa4" ); 
gap> SetName( NGa4, "NGa4" ); 
gap> ##  cannot test images of AGgens because of random variations 
gap> ##  Now do some tests!
gap> mgi := MappingGeneratorsImages( MGa4 );; 
gap> autgen := mgi[1];; 
gap> pcgen := mgi[2];;
gap> ngen := Length( autgen );; 
gap> ForAll( [1..ngen], i -> Order(autgen[i]) = Order(pcgen[i]) ); 
true

## SubSection 4.4.2
gap> Hs3 := HomogeneousDiscreteGroupoid( s3, [ -13..-10] ); 
homogeneous, discrete groupoid: < s3, [ -13 .. -10 ] >
gap> aut4 := GroupoidAutomorphismByObjectPerm( Hs3, [-12,-10,-11,-13] ); 
morphism from a homogeneous discrete groupoid:
[ -13, -12, -11, -10 ] -> [ -12, -10, -11, -13 ]
object homomorphisms:
IdentityMapping( s3 )
IdentityMapping( s3 )
IdentityMapping( s3 )
IdentityMapping( s3 )

gap> gens3 := GeneratorsOfGroup( s3 );; 
gap> g1 := gens3[1];; 
gap> g2 := gens3[2];; 
gap> b1 := GroupHomomorphismByImages( s3, s3, gens3, [g1, g2^g1 ] );; 
gap> b2 := GroupHomomorphismByImages( s3, s3, gens3, [g1^g2, g2 ] );; 
gap> b3 := GroupHomomorphismByImages( s3, s3, gens3, [g1^g2, g2^(g1*g2) ] );; 
gap> b4 := GroupHomomorphismByImages( s3, s3, gens3, [g1^(g2*g1), g2^g1 ] );; 
gap> aut5 := GroupoidAutomorphismByGroupAutos( Hs3, [b1,b2,b3,b4] ); 
morphism from a homogeneous discrete groupoid:
[ -13, -12, -11, -10 ] -> [ -13, -12, -11, -10 ]
object homomorphisms:
GroupHomomorphismByImages( s3, s3, 
[ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ], 
[ (15,17,19)(16,18,20), (15,18)(16,17)(19,20) ] )
GroupHomomorphismByImages( s3, s3, 
[ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ], 
[ (15,19,17)(16,20,18), (15,20)(16,19)(17,18) ] )
GroupHomomorphismByImages( s3, s3, 
[ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ], 
[ (15,19,17)(16,20,18), (15,16)(17,20)(18,19) ] )
GroupHomomorphismByImages( s3, s3, 
[ (15,17,19)(16,18,20), (15,20)(16,19)(17,18) ], 
[ (15,19,17)(16,20,18), (15,18)(16,17)(19,20) ] )

gap> AHs3 := AutomorphismGroup( Hs3 ); 
<group with 4 generators>
gap> Size( AHs3) ;
31104
gap> GeneratorsOfGroup( AHs3 ); 
[ morphism from a homogeneous discrete groupoid:
    [ -13, -12, -11, -10 ] -> [ -13, -12, -11, -10 ]
    object homomorphisms:
    InnerAutomorphism( s3, (15,20)(16,19)(17,18) )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    , morphism from a homogeneous discrete groupoid:
    [ -13, -12, -11, -10 ] -> [ -13, -12, -11, -10 ]
    object homomorphisms:
    InnerAutomorphism( s3, (15,19,17)(16,20,18) )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    , morphism from a homogeneous discrete groupoid:
    [ -13, -12, -11, -10 ] -> [ -12, -11, -10, -13 ]
    object homomorphisms:
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    , morphism from a homogeneous discrete groupoid:
    [ -13, -12, -11, -10 ] -> [ -12, -13, -11, -10 ]
    object homomorphisms:
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
    IdentityMapping( s3 )
     ]
gap> SetInfoLevel( InfoGpd, gpd_infolevel_saved );;  

#############################################################################
##
#E  gpdhom.tst . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
