LoadPackage( "GradedRingForHomalg" );

##
A := GradedRing( HomalgFieldOfRationalsInDefaultCAS( ) * "t" );

param := Length( Indeterminates( A ) );

weights := ListWithIdenticalEntries( param, 0 );

# SetWeightsOfIndeterminates( R, weights );

##
RR := A * "x0,x1";

S := GradedRing( RR );

n := Length( Indeterminates( S ) ) - param - 1;

weights := Concatenation(
                   weights,
                   ListWithIdenticalEntries( n + 1, 1 )
                   );

SetWeightsOfIndeterminates( S, weights );

##
E1 := KoszulDualRing( S );

##
m := HomalgMatrix( "t", 1, 1, S );

LoadPackage( "GradedModules" );

M := RightPresentationWithDegrees( m );

T := TateResolution( M, -2, 2 );
