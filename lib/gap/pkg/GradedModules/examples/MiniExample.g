LoadPackage( "RingsForHomalg" );

Qxy := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y";

wmat := HomalgMatrix( "[x*y ]", 1, 1, Qxy );

LoadPackage( "GradedRingForHomalg" );

S := GradedRing( Qxy );

LoadPackage( "Modules" );

N := LeftPresentation( wmat );

LoadPackage( "GradedModules" );

M := LeftPresentation( S * wmat );

W := LeftPresentationWithDegrees( wmat, S );
