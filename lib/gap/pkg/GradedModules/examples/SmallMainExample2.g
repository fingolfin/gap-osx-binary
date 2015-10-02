LoadPackage( "GradedRingForHomalg" );

Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";
S := GradedRing( Qxyz );

wmat := HomalgMatrix( "[ \
x*y,  y*z,    x*z,        0,\
x^3*z,0,z^4,0,         \
0,  x^3*z,  x^4,        0, \
0,  x^2,      x*y,      0, \
x^3,  x^3,    x^2*z,      1,\
0,    0,      0,          x,\
0,    0,      0,          y,\
0,    0,      0,          z\
]", 8, 4, Qxyz );


LoadPackage( "GradedModules" );

wmor := GradedMap( wmat, "free", [0,0,0,3], "left", S );
W := LeftPresentationWithDegrees( wmat, S );
