#ScalarOfSimilairty example
gram := [ [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ], 
  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ] ];;
form := BilinearFormByMatrix( gram, GF(3) );
m := [ [ Z(3)^0, Z(3)^0, Z(3), 0*Z(3), Z(3)^0, Z(3) ], 
  [ Z(3), Z(3), Z(3)^0, 0*Z(3), Z(3)^0, Z(3) ], 
  [ 0*Z(3), Z(3), 0*Z(3), Z(3), 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), Z(3), Z(3)^0, Z(3), Z(3), Z(3) ], 
  [ Z(3)^0, Z(3)^0, Z(3), Z(3), Z(3)^0, Z(3)^0 ], 
  [ Z(3)^0, 0*Z(3), Z(3), Z(3)^0, Z(3), Z(3) ] ];;
ScalarOfSimilarity( m, form );
quit;
