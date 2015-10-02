LoadPackage("RingsForHomalg");
Qi := HomalgFieldOfRationalsInDefaultCAS( ) * "i";
C := Qi / [ "i^2+1" ];
r := HomalgRingElement( "i+1", C );

Qxy := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y";
R := Qxy / [ "x^2-1", "y^3-2" ];
a := HomalgRingElement( "x", R );
b := HomalgRingElement( "y", R );

q := HomalgRingElement( "x+y", R );
