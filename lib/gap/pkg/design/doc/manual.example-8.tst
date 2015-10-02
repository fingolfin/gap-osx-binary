
gap> List([1..6],k->Length(SemiLatinSquareDuals(4,k))); # weak
[ 2, 10, 40, 164, 621, 2298 ]
gap> List([1..6],k->Length(SemiLatinSquareDuals(4,k,"default","default",4))); # strong
[ 2, 11, 46, 201, 829, 3343 ]


gap> SemiLatinSquareDuals(6,3,"default",[0,1],0);
[ rec( isBlockDesign := true, v := 36,
      blocks := [ [ 1, 8, 15, 22, 29, 36 ], [ 1, 9, 16, 23, 30, 32 ],
          [ 1, 12, 14, 21, 28, 35 ], [ 2, 9, 17, 24, 25, 34 ],
          [ 2, 11, 18, 22, 27, 31 ], [ 2, 12, 16, 19, 29, 33 ],
          [ 3, 10, 14, 24, 29, 31 ], [ 3, 11, 16, 20, 25, 36 ],
          [ 3, 12, 13, 23, 26, 34 ], [ 4, 7, 14, 23, 27, 36 ],
          [ 4, 8, 17, 21, 30, 31 ], [ 4, 9, 18, 19, 26, 35 ],
          [ 5, 7, 15, 20, 30, 34 ], [ 5, 8, 13, 24, 28, 33 ],
          [ 5, 10, 18, 21, 25, 32 ], [ 6, 7, 17, 22, 26, 33 ],
          [ 6, 10, 13, 20, 27, 35 ], [ 6, 11, 15, 19, 28, 32 ] ],
      tSubsetStructure := rec( t := 1, lambdas := [ 3 ] ), isBinary := true,
      isSimple := true, blockSizes := [ 6 ], blockNumbers := [ 18 ], r := 3,
      autSubgroup := <permutation group of size 72 with 3 generators>,
      pointNames := [ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ],
          [ 1, 6 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 2, 4 ], [ 2, 5 ],
          [ 2, 6 ], [ 3, 1 ], [ 3, 2 ], [ 3, 3 ], [ 3, 4 ], [ 3, 5 ],
          [ 3, 6 ], [ 4, 1 ], [ 4, 2 ], [ 4, 3 ], [ 4, 4 ], [ 4, 5 ],
          [ 4, 6 ], [ 5, 1 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ], [ 5, 5 ],
          [ 5, 6 ], [ 6, 1 ], [ 6, 2 ], [ 6, 3 ], [ 6, 4 ], [ 6, 5 ],
          [ 6, 6 ] ] ) ]

