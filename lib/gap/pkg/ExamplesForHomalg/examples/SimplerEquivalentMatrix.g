LoadPackage( "RingsForHomalg" );

LoadPackage( "Modules" );

Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";

wmat := HomalgMatrix( "[ \
x*z, z*y, z^2, 0, 0, y, \
0, 0, 0, z^2*y-z^2, z^3, x*z, \
0, 0, 0, z*y^2-z*y, z^2*y, x*y, \
0, 0, 0, x*z*y-x*z, x*z^2, x^2, \
x^2*z, x*z*y, x*z^2, 0, 0, x*y, \
-x*y, -y^2, -z*y, x^2*y-y-x^2+1, x^2*z-z, 0, \
x^2*y-x^2, x*y^2-x*y, x*z*y-x*z, -y^3+2*y^2-y, -z*y^2+z*y, 0, \
0, 0, 0, z*y-z, z^2, x^3-y^2 \
]", 8, 6, Qxyz );

rsyz := SyzygiesGeneratorsOfRows( wmat );

U := HomalgVoidMatrix( Qxyz );
V := HomalgVoidMatrix( Qxyz );
UI := HomalgVoidMatrix( Qxyz );
VI := HomalgVoidMatrix( Qxyz );

smat := SimplerEquivalentMatrix( rsyz, U, V, UI, VI );
a := U * rsyz * V - smat;
b := rsyz - UI * smat * VI;

isyz := Involution( rsyz );

U := HomalgVoidMatrix( Qxyz );
V := HomalgVoidMatrix( Qxyz );
UI := HomalgVoidMatrix( Qxyz );
VI := HomalgVoidMatrix( Qxyz );

tmat := SimplerEquivalentMatrix( isyz, U, V, UI, VI );
c := U * isyz * V - tmat;
d := isyz - UI * tmat * VI;

Assert( 0, IsZero( a ) );
Assert( 0, IsZero( b ) );
Assert( 0, IsZero( c ) );
Assert( 0, IsZero( d ) );


m := GetRidOfRowsAndColumnsWithUnits( rsyz );

Assert( 0, m = List( Reversed( GetRidOfRowsAndColumnsWithUnits( isyz ) ), Involution ) );

MM := rsyz;
U := m[1];
UI := m[2];
M := m[3];
VI := m[4];
V := m[5];

Assert( 0, GenerateSameColumnModule( U * MM, M ) );
Assert( 0, GenerateSameRowModule( MM * V, M ) );
Assert( 0, IsZero( DecideZeroColumns( UI * M, BasisOfColumnModule( MM ) ) ) );
Assert( 0, IsZero( DecideZeroRows( M * VI, BasisOfRowModule( MM ) ) ) );
