
gap> CyclicSplitExtensionMethod( 2,2,7, true );
rec( up := [  ],
  down  := [ <pc group of size 28 with 3 generators>,
             <pc group of size 28 with 3 generators> ],
  both  := [ <pc group of size 28 with 3 generators>,
             <pc group of size 28 with 3 generators> ] )

gap> CyclicSplitExtensionMethod( 2,2,[3,5], true );
rec( up := [ <pc group of size 12 with 3 generators> ],
  down  := [ <pc group of size 12 with 3 generators>,
             <pc group of size 20 with 3 generators>,
             <pc group of size 20 with 3 generators>,
             <pc group of size 12 with 3 generators>,
             <pc group of size 20 with 3 generators> ],
  both  := [ <pc group of size 12 with 3 generators>,
             <pc group of size 20 with 3 generators>,
             <pc group of size 12 with 3 generators>,
             <pc group of size 20 with 3 generators> ] )


gap> G := SmallGroup( 16, 10 );;
gap> CyclicSplitExtensionsUp( G, 3, true );
[ <pc group with 5 generators> ]

gap> G := SylowSubgroup( SymmetricGroup(4), 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> CyclicSplitExtensionsDown( G, 3 );
[ rec( code := 6562689, order := 24 ),
  rec( code := 2837724033, order := 24 ) ]

