LoadPackage( "GradedRingForHomalg" );

##
R := HomalgFieldOfRationalsInDefaultCAS( ) * "a00,a01,a02,a03,a04,a10,a11,a12,a13,a14";

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
x0, 0, a00*x1, a01*x1, a02*x1, a03*x1, a04*x1, 0, 0, \
-x1, 0, 0, 0, 0, 0, 0, 0, 0, \
0, x0, a10*x1, a11*x1, a12*x1, a13*x1, a14*x1, 0, 0, \
0, -x1, 0, 0, 0, 0, 0, 0, 0, \
0, 0, x0, 0, 0, 0, 0, 0, 0, \
0, 0, -x1, x0, 0, 0, 0, 0, 0, \
0, 0, 0, -x1, x0, 0, 0, 0, 0, \
0, 0, 0, 0, -x1, x0, 0, 0, 0, \
0, 0, 0, 0, 0, -x1, x0, 0, 0, \
0, 0, 0, 0, 0, 0, -x1, x0, 0, \
0, 0, 0, 0, 0, 0, 0, -x1, x0, \
0, 0, 0, 0, 0, 0, 0, 0, -x1 \
]", 12, 9, S );

LoadPackage( "GradedModules" );

M := RightPresentationWithDegrees( m );

T := TateResolution( M, -2, 2 );
