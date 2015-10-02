
gap> ConstructAllGroups( 60 );; time;
4080


gap> FrattiniExtensionMethod( 5^3 * 7 * 31, true );;
gap> time;
13670

gap> flags := rec( nonnilpot := true );;
gap> FrattiniExtensionMethod( 5^3 * 7 * 31, flags, true );;
gap> time;
8400

gap> flags := rec( nonsupsol := true );;
gap> FrattiniExtensionMethod( 5^3 * 7 * 31, flags, true );;
gap> time;
3640

gap> flags := rec( nonpnorm := [31] );;
gap> FrattiniExtensionMethod( 5^3 * 7 * 31, flags, true );;
gap> time;
1740


gap> FrattiniExtensionMethod( 10007 * 2, true );
[ <pc group of size 20014 with 2 generators>,
  <pc group of size 20014 with 2 generators> ]
gap> time;
87950

gap> flags := rec( nonnilpot := true );;
gap> FrattiniExtensionMethod( 10007 * 2, flags, true  );
[ <pc group of size 20014 with 2 generators> ]
gap> time;
48950

gap> ConstructAllGroups( 10007 * 2 );
[ <pc group of size 20014 with 2 generators>,
  <pc group of size 20014 with 2 generators> ]
gap> time;
30


gap> flags := rec( nonnilpot := true );;
gap> FrattiniExtensionMethod( 2^5 * 3^2, flags, true );;
gap> time;
656630

gap> flags := rec( nonpnorm := [2,3] );;
gap> FrattiniExtensionMethod( 2^5 * 3^2, flags, true );;
gap> time;
58180

