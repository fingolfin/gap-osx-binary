
gap> G := PerfectGroup( IsPermGroup, 120, 1 );
A5 2^1
gap> c := CyclicExtensions( G, 2 );;
gap> List( c, IdGroup );
[ [ 240, 94 ], [ 240, 93 ], [ 240, 90 ], [ 240, 89 ] ]
gap> H := c[1];
<permutation group of size 240 with 2 generators>
gap> CyclicExtensions( H, 2 );;
gap> List(last, IdGroup);
[ [ 480, 960 ], [ 480, 955 ], [ 480, 222 ], [ 480, 222 ], [ 480, 953 ],
  [ 480, 953 ], [ 480, 957 ], [ 480, 957 ], [ 480, 949 ], [ 480, 950 ],
  [ 480, 219 ], [ 480, 219 ] ]

gap> u := UpwardsExtensions( G, 4 );;
gap> List( u, Length );
[ 1, 4, 14 ]
gap> List( u[3], IdGroup);
[ [ 480, 960 ], [ 480, 959 ], [ 480, 950 ], [ 480, 222 ], [ 480, 221 ],
  [ 480, 947 ], [ 480, 949 ], [ 480, 219 ], [ 480, 948 ], [ 480, 218 ],
  [ 480, 955 ], [ 480, 957 ], [ 480, 953 ], [ 480, 946 ] ]

