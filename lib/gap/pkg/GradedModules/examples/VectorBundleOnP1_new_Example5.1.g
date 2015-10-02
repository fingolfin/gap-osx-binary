LoadPackage( "GradedRingForHomalg" );

##
R := HomalgFieldOfRationalsInDefaultCAS( ) * "a";

param := Length( Indeterminates( R ) );

weights := ListWithIdenticalEntries( param, 0 );

SetWeightsOfIndeterminates( R, weights );

##
RR := R * "x0,x1";

S := GradedRing( RR );

n := Length( Indeterminates( S ) ) - param - 1;

weights := Concatenation(
                   weights,
                   ListWithIdenticalEntries( n + 1, 1 )
                   );

SetWeightsOfIndeterminates( S, weights );

##
A := KoszulDualRing( S, "e0,e1" );

##
m := HomalgMatrix( "[\
 x0, a*x1,   0,   0, \
-x1,    0,   0,   0, \
  0,   x0,   0,   0, \
  0,  -x1,  x0,   0, \
  0,    0, -x1,  x0, \
  0,    0,   0, -x1  \
]", 6, 4, S );

LoadPackage( "GradedModules" );

M := RightPresentationWithDegrees( m, [ 3, 3, 3, 3, 3, 3 ] );

T := TateResolution( M, -2, 4 );
