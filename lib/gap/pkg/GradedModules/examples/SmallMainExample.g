LoadPackage( "GradedRingForHomalg" );

Qxyzt := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z,t";
S := GradedRing( Qxyzt );

wmat := HomalgMatrix( "[ \
x*y,  y*z,    z*t,       \
x^3*z,x^2*z^2,0,         \
x^4,  x^3*z,  0,         \
0,    0,      x*y,       \
0,    0,      x^2*z      \
]", 5, 3, Qxyzt );

LoadPackage( "GradedModules" );

wmor := GradedMap( wmat, "free", "free", "left", S );
W := LeftPresentationWithDegrees( wmat, S );
