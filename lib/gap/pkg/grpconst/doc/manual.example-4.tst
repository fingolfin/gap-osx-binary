
gap> flags := rec( nonnilpot := true, pnormal := [3] );
rec( nonnilpot := true, pnormal := [ 3 ] )
gap> grps := FrattiniExtensionMethod( 24, flags, true );
[ <pc group with 4 generators>, <pc group with 4 generators>,
  <pc group with 4 generators>, <pc group with 4 generators>,
  <pc group with 4 generators>, <pc group with 4 generators>,
  <pc group with 4 generators> ]
gap> List( last, IdGroup );
[ [ 24, 1 ], [ 24, 5 ], [ 24, 8 ], [ 24, 6 ], [ 24, 7 ], [ 24, 4 ],
  [ 24, 14 ] ]

gap> FrattiniExtensionMethod( 8 );
[ rec( code := 323, order := 8, isFrattiniFree := false, first := [ 1, 1, 2 ],
      socledim := [ 1 ], extdim := [ 2, 2 ], isUnique := true ),
  rec( code := 34, order := 8, isFrattiniFree := false, first := [ 1, 1, 3 ],
      socledim := [ 1, 1 ], extdim := [ 2 ], isUnique := true ),
  rec( code := 36, order := 8, isFrattiniFree := false, first := [ 1, 1, 3 ],
      socledim := [ 1, 1 ], extdim := [ 2 ], isUnique := true ),
  rec( code := 2343, order := 8, isFrattiniFree := false,
      first := [ 1, 1, 3 ], socledim := [ 1, 1 ], extdim := [ 2 ],
      isUnique := true ),
  rec( code := 0, order := 8, isFrattiniFree := true, first := [ 1, 1, 4 ],
      socledim := [ 1, 1, 1 ], extdim := [  ], isUnique := true ) ]


gap> flags := rec( nonsupsol := true );
rec( nonsupsol := true )
gap> FrattiniFactorCandidates( 24, flags, true );
[ <pc group with 4 generators>, <pc group with 3 generators>,
  <pc group with 4 generators> ]
gap> List(last, IdGroup);
[ [ 24, 12 ], [ 12, 3 ], [ 24, 13 ] ]


gap> G := SmallGroup( 24, 12 );
<pc group of size 24 with 4 generators>
gap> FrattiniSubgroup(G);
Group([  ])
gap> FrattiniExtensions( G, 48, true );
[ <pc group with 5 generators>, <pc group with 5 generators>,
  <pc group with 5 generators> ]
gap> List( last, IdGroup);
[ [ 48, 29 ], [ 48, 30 ], [ 48, 28 ] ]

gap> cand := FrattiniFactorCandidates( 6, rec() );
[ rec( code := 25, order := 6, isFrattiniFree := true, first := [ 1, 2, 3 ],
      socledim := [ 1 ], extdim := [  ], isUnique := true ),
  rec( code := 1, order := 6, isFrattiniFree := true, first := [ 1, 1, 3 ],
      socledim := [ 1, 1 ], extdim := [  ], isUnique := true ) ]
gap> FrattiniExtensions( cand, 12 );
[ rec( code := 6442, order := 12, isFrattiniFree := false,
      first := [ 1, 2, 3 ], socledim := [ 1 ], extdim := [ 2 ],
      isUnique := true ),
  rec( code := 266, order := 12, isFrattiniFree := false,
      first := [ 1, 1, 3 ], socledim := [ 1, 1 ], extdim := [ 2 ],
      isUnique := true ) ]

