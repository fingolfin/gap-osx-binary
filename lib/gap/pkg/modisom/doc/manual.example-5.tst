
gap> F := FreeAssociativeAlgebra(GF(2), 2);;
gap> g := GeneratorsOfAlgebra(F);;
gap> r := [g[1]^2, g[2]^2];;
gap> A := F/r;;
gap> NilpotentQuotientOfFpAlgebra(A,3);
rec( def := [ 1, 2 ], dim := 6, fld := GF(2),
  img := [ <a GF2 vector of length 6>, <a GF2 vector of length 6> ],
  mat := [ [  ], [  ] ], rnk := 2,
  tab := [ [ <a GF2 vector of length 6>, <a GF2 vector of length 6>,
          [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2) ],
          [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ] ],
      [ <a GF2 vector of length 6>, <a GF2 vector of length 6>,
          [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ],
          [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0 ] ] ],
  wds := [ ,, [ 2, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 4 ] ],
  wgs := [ 1, 1, 2, 2, 3, 3 ] )

