Read( "homalg.g" );
LoadPackage( "RingsForHomalg" );
HOMALG_IO.color_display := true;
ZZ := HomalgRingOfIntegersInMaple( );
Display( ZZ );
wmat := imat * ZZ;
W := LeftPresentation( wmat );
