gap> START_TEST("Test 1 of guarana package");
gap> n := 2;
2
gap> F := FreeGroup( n );
<free group on the generators [ f1, f2 ]>
gap> c := 3;
3
gap> N := NilpotentQuotient( F, c );
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> mo := MalcevObjectByTGroup( N );
<<Malcev object of dimension 5>>
gap> dim := Dimension( mo );
5
gap> UnderlyingGroup( mo );
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> UnderlyingLieAlgebra( mo );
<Lie algebra of dimension 5 over Rationals>
gap> g := MalcevGrpElementByExponents( mo, [1,1,0,2,-1/2] );
[ 1, 1, 0, 2, -1/2 ]
gap> x := MalcevLieElementByCoefficients( mo, [1/2, 2, -1, 3, 5 ] );
[ 1/2, 2, -1, 3, 5 ]
gap> h := RandomGrpElm( mo );
[ -8, 1, 3, -7, 0 ]
gap> y := RandomLieElm( mo );
[ 7, 6, -9, -9, -2 ]
gap> z := Log( g );
[ 1, 1, -1/2, 7/3, -1/3 ]
gap> Exp( z ) = g;
true
gap> k := Exp( y );
[ 7, 6, 12, -2, 89/2 ]
gap> Log( k ) = y;
true
gap> g*h;
[ -7, 2, -5, 31, -17/2 ]
gap> Comm(g,h);
[ 0, 0, -9, 33, -12 ]
gap> Comm(x,y);
[ 0, 0, 11, -8, 13/2 ]
gap> indets := List( List( [1..dim], i->Concatenation( "a_", String(i) ) ),
>                   x->Indeterminate( Rationals, x : new ) );
[ a_1, a_2, a_3, a_4, a_5 ]
gap> g_sym := MalcevSymbolicGrpElementByExponents( mo, indets );
[ a_1, a_2, a_3, a_4, a_5 ]
gap> x_sym := Log( g_sym );
[ a_1, a_2, -1/2*a_1*a_2+a_3, 1/12*a_1^2*a_2+1/4*a_1*a_2-1/2*a_1*a_3+a_4,
  -1/12*a_1*a_2^2+1/4*a_1*a_2-1/2*a_2*a_3+a_5 ]
gap> g_sym * g;
[ a_1+1, a_2+1, a_2+a_3, a_3+a_4+2, 1/2*a_2^2+1/2*a_2+a_3+a_5-1/2 ]
gap> STOP_TEST( "guarana1.tst", 5000);

