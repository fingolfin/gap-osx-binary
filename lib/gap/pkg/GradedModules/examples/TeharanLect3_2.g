LoadPackage( "GradedModules" );

S := GradedRing( HomalgFieldOfRationalsInDefaultCAS( ) * "x0,x1" );

M := LeftPresentationWithDegrees( HomalgMatrix( "[x0,x0]", 1, 2, S ) );

T := TateResolution( M, -6, 5 );
H0T := LinearStrand( 0, T );
H1T := LinearStrand( 1, T );
