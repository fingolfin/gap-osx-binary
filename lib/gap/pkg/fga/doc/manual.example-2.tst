
gap> f := FreeGroup( 2 );
<free group on the generators [ f1, f2 ]>
gap> u := Group( f.1^2, f.2^2, f.1*f.2 );
Group([ f1^2, f2^2 ])
gap> u1 := Subgroup( u, [f.1^2, f.1^4*f.2^6] );
Group([ f1^2, f1^4*f2^6 ])
gap> elm := f.1;
f1
gap> u2 := Normalizer( u, elm );
Group([ f1^2 ])


gap> f := FreeGroup( 2 );
<free group on the generators [ f1, f2 ]>
gap> ua := f.1^2*f.2^2;; ub := f.1^2*f.2;;
gap> u := Group( ua, ub );;
gap> g := FreeGroup( "a", "b" );;
gap> hom := GroupHomomorphismByImages( g, u,
              GeneratorsOfGroup(g),
              GeneratorsOfGroup(u) );
[ a, b ] -> [ f1^2*f2^2, f1^2*f2 ]
gap> # how can f.1^2 be expressed?
gap> PreImagesRepresentative( hom, f.1^2 );
b*a^-1*b
gap> last ^ hom; # check this
f1^2
gap> ub * ua^-1 * ub; # another check
f1^2
gap> PreImagesRepresentative( hom, f.1 ); # try f.1
fail
gap> f.1 in u;
false


gap> AsWordLetterRepInGenerators( f.1^2, u );
[ 2, -1, 2 ]
gap> AsWordLetterRepInFreeGenerators( f.1^2, u );
[ 2 ]


gap> f := FreeGroup( 2 );;
gap> a := AutomorphismGroup( f );;
gap> iso := IsomorphismFpGroup( a );;
gap> Range( iso );
<fp group on the generators [ O, P, U ]>


gap> aut := GroupHomomorphismByImages( f, f,
               GeneratorsOfGroup( f ), [ f.1^f.2, f.1*f.2 ] );
[ f1, f2 ] -> [ f2^-1*f1*f2, f1*f2 ]
gap> ImageElm( iso, aut );
O^2*U*O*P^-1*U

