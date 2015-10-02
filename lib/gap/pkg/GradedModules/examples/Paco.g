LoadPackage( "GradedModules" );

S := GradedRing( HomalgFieldOfRationalsInDefaultCAS( ) * "x0..2" );

I := GradedLeftSubmodule ( "x0*x1^2-x2^3", S );

J := I + GradedLeftSubmodule( "x0^10", S );

M := FactorObject( J );

A := KoszulDualRing( S, "e0..2" );
