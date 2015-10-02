LoadPackage( "GradedRingForHomalg" );

##
R := GradedRing( HomalgFieldOfRationalsInDefaultCAS( ) * "a" );

param := Length( Indeterminates( R ) );

weights := ListWithIdenticalEntries( param, 0 );

SetWeightsOfIndeterminates( R, weights );

##
S := R * "x,y";

n := Length( Indeterminates( S ) ) - param - 1;

weights := Concatenation(
                   weights,
                   ListWithIdenticalEntries( n + 1, 1 )
                   );

SetWeightsOfIndeterminates( S, weights );

##
A := KoszulDualRing( S, "e,f" );

##
m := HomalgMatrix( "[\
-a*x,  0, \
   y,  0, \
  -x,  y, \
   0, -x  \
]", 4, 2, S );

LoadPackage( "GradedModules" );

M := RightPresentationWithDegrees( m, [ 2, 2, 2, 2 ] );

T := TateResolution( M, -2, 4 );

# Rpi := DegreeZeroSubcomplex( T, R );
