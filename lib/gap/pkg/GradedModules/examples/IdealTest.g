
LoadPackage( "GradedModules" );

LoadPackage( "GradedRingForHomalg" );

R := GradedRing( HomalgFieldOfRationalsInDefaultCAS( ) * "x" );

I := GradedLeftSubmodule( "x^2", R );

M := Indeterminates( R )[1];

Print( RadicalIdealMembership( I, M ) );


