LoadPackage( "RingsForHomalg" );

LoadPackage( "Modules" );

R := HomalgRingOfIntegersInDefaultCAS( );
k := RightPresentation( TransposedMat( [[1,2,3],[3,4,5]] ), R );
l := RightPresentation( TransposedMat( [[4,5,6,0],[0,2,0,2]] ), R );
hm := Hom( l, k );
map := HomalgMap( GetGenerators( hm, 1 ), l, k );
hommap := Hom( l, map );
