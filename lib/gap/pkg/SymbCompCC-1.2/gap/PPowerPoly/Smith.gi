###############################################################################
##
#F Smith.gi            The SymbCompCC package          Dörte Feichtenschlager
##

###############################################################################
##
## InfoLevel: InfoSmithPPowerPoly: 1 level until which SNF is computed
##                                 2 show pivot element
##                                 3 show always P, Q and S
##
## Global Varialble: CHECK_SMITHNF_PPOWERPOLY
##

###############################################################################
##
## IdentityPPowerPolyMat( p, n )
##
## Input: a prime p and a positive integer n.
##
## Output: the nxn-identity matrix with p-power-poly entries.
##
InstallMethod( IdentityPPowerPolyMat, [ IsPosInt, IsPosInt ],
   function( p, n )
      local I, One1, Zero0, i, j;
      
      I := [];
      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      for i in [1..n] do
         I[i] := [];
         I[i][i] := One1;
         for j in [1..i-1] do
            I[i][j] := Zero0;
         od;
         for j in [i+1..n] do
            I[i][j] := Zero0;
         od;
      od;

      return I;
   end);

###############################################################################
##
## IdentityPPowerPolyLocMat( p, n )
##
## Input: a prime p and a positive integer n.
##
## Output: a nxn-identity-matrix with p-power-poly-loc entries.
##
InstallMethod( IdentityPPowerPolyLocMat, [ IsPosInt, IsPosInt ],
   function( p, n )
      local I, One1, Zero0, i, j, One1Loc, Zero0Loc;
      
      I := [];
      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );
      One1Loc := [ One1, One1 ];
      Zero0Loc := [ Zero0, One1 ];

      for i in [1..n] do
         I[i] := [];
         I[i][i] := One1Loc;
         for j in [1..i-1] do
            I[i][j] := Zero0Loc;
         od;
         for j in [i+1..n] do
            I[i][j] := Zero0Loc;
         od;
      od;

      return I;
   end);

###############################################################################
##
## NullPPowerPolyMat( p, n )
##
## Input: a prime p and a positive integer n.
##
## Output: a nxn-zero-matrix with p-power-poly entries.
##
InstallMethod( NullPPowerPolyMat, [ IsPosInt, IsPosInt ],
   function( p, n )
      local N, Zero0, i, j;
      
      N := [];
      Zero0 := Int2PPowerPoly( p, 0 );

      for i in [1..n] do
         N[i] := [];
         for j in [1..n] do
            N[i][j] := Zero0;
         od;
      od;

      return N;
   end);

###############################################################################
##
## NullPPowerPolyLocMat( p, n )
##
## Input: a prime p and a positive integer n.
##
## Output: a nxn-zero-matrix with p-power-poly-loc entries.
##
InstallMethod( NullPPowerPolyLocMat, [ IsPosInt, IsPosInt ],
   function( p, n )
      local N, Zero0, One1, Zero0Loc, i, j;
      
      N := [];
      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );
      Zero0Loc := [ Zero0, One1 ];

      for i in [1..n] do
         N[i] := [];
         for j in [1..n] do
            N[i][j] := Zero0Loc;
         od;
      od;

      return N;
   end);

###############################################################################
##
## NullPPowerPolyMat( p, n, m )
##
## Input: a prime p and positive integers n and m.
##
## Output: a nxm-zero-matrix with p-power-poly entries.
##
InstallMethod( NullPPowerPolyMat, [ IsPosInt, IsPosInt, IsPosInt ], 
   function( p, n, m )
      local N, Zero0, i, j;
      
      N := [];
      Zero0 := Int2PPowerPoly( p, 0 );

      for i in [1..n] do
         N[i] := [];
         for j in [1..m] do
            N[i][j] := Zero0;
         od;
      od;

      return N;
   end);

###############################################################################
##
## NullPPowerPolyLocMat( p, n, m )
##
## Input: a prime p and positive integers n and m.
##
## Output: a nxm-zero-matrix with p-power-poly-loc entries.
##
InstallMethod( NullPPowerPolyLocMat, [ IsPosInt, IsPosInt, IsPosInt ], 
   function( p, n, m )
      local N, Zero0, One1, Zero0Loc, i, j;
      
      N := [];
      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );
      Zero0Loc := [ Zero0, One1 ];

      for i in [1..n] do
         N[i] := [];
         for j in [1..m] do
            N[i][j] := Zero0Loc;
         od;
      od;

      return N;
   end);

###############################################################################
##
## ExchangeRowsPPP( i, j, S )
##
## Input: a matrix S with p-power-poly entries and positive integers i and j,
##        where i and j are smaller than or equal to the number of rows of S.
##
## Output: a matrix with p-power-poly entries, which is the matrix S, but the
##         rows i and j interchanged.
##
InstallMethod( ExchangeRowsPPP, [ IsPosInt, IsPosInt, IsList ], 
   function( i, j, S )
      local help, k, l_s;

      l_s := Length( S );

      ## check if the input is alright
      if i > l_s or j > l_s then
         Error("Wrong input, the first two input parameters (integers) have to be smaller than the number of rows of the matrix (the third input).");
      fi;

      ## exchange the rows
      for k in [1..Length(S[1])] do
         if not PPP_Equal( S[i][k], S[j][k] ) then
            help := StructuralCopy( S[i][k] );
            S[i][k] := StructuralCopy( S[j][k] );
            S[j][k] := help;
         fi;
      od;

      return S;
   end);

###############################################################################
##
## ExchangeRowsPPPL( i, j, S )
##
## Input: a matrix S with p-power-poly-loc entries and positive integers i and
##        j, where i and j are smaller than or equal to the number of rows of S.
##
## Output: a matrix with p-power-poly-loc entries, which is the matrix S, but 
##         the rows i and j interchanged.
##
InstallMethod( ExchangeRowsPPPL, [ IsPosInt, IsPosInt, IsList ], 
   function( i, j, S )
      local help, k, l_s;

      l_s := Length( S );

      ## check if the input is alright
      if i > l_s or j > l_s then
         Error("Wrong input, the first two input parameters (integers) have to be smaller than the number of rows of the matrix (the third input).");
      fi;

      ## exchange the rows
      for k in [1..Length(S[1])] do
         if not PPPL_Equal( S[i][k], S[j][k] ) then
            help := StructuralCopy( S[i][k] );
            S[i][k] := StructuralCopy( S[j][k] );
            S[j][k] := help;
         fi;
      od;

      return S;
   end);

###############################################################################
##
##  ExchangeColumnsPPP( o, j, S )
##
## Input: a matrix S with p-power-poly entries and positive integers i and j,
##        where i and j are smaller than or equal to the number of columns of S.
##
## Output: a matrix with p-power-poly entries, which is the matrix S, but the
##         columns i and j interchanged.
##
InstallMethod( ExchangeColumnsPPP, [ IsPosInt, IsPosInt, IsList ], 
   function( i, j, S )
      local l_s, k, help;

      l_s := Length( S[1] );

      ## check if the input is alright
      if i > l_s or j > l_s then
         Error("Wrong input, the first two input parameters (integers) have to be smaller than the number of columns of the matrix (the third input).");
      fi;

      ## exchange the columns
      for k in [1..Length(S)] do
         if not PPP_Equal( S[k][i], S[k][j] ) then
            help := StructuralCopy( S[k][i] );
            S[k][i] := StructuralCopy( S[k][j] );
            S[k][j] := help;
         fi;
      od;

      return S;
   end);

###############################################################################
##
##  ExchangeColumnsPPPL( i, j, S )
##
## Input: a matrix S with p-power-poly-loc entries and positive integers i and
##        j, where i and j are smaller than or equal to the number of columns 
##        of S.
##
## Output: a matrix with p-power-poly-loc entries, which is the matrix S, but 
##         the columns i and j interchanged.
##
InstallMethod( ExchangeColumnsPPPL, [ IsPosInt, IsPosInt, IsList ], 
   function( i, j, S )
      local l_s, k, help;

      l_s := Length( S[1] );

      ## check if the input is alright
      if i > l_s or j > l_s then
         Error("Wrong input, the first two input parameters (integers) have to be smaller than the number of columns of the matrix (the third input).");
      fi;

      ## exchange the columns
      for k in [1..Length(S)] do
         if not PPPL_Equal( S[k][i], S[k][j] ) then
            help := StructuralCopy( S[k][i] );
            S[k][i] := StructuralCopy( S[k][j] );
            S[k][j] := help;
         fi;
      od;

      return S;
   end);

###############################################################################
##
## EmptyColumn( i, S, P )
##
## Input: a positive integer i and p-power-poly matrices S and P, where P
##        stores row-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyColTrans := P ), where S is the
##         modified matrix where the entries in column i are zero, except 
##         (i,i), subject to the condition that (i,i) divides every entry in 
##         the i-th column of S; P stores row-transformation performed on 
##         S so far.
##
InstallMethod( EmptyColumn, [ IsPosInt, IsList, IsList ], 
   function( i, S, P )
      local Zero0, One1, l_s, l_s1, l_p1, j, list, q, k;

      Zero0 := PPP_ZeroNC( S[1][1] );
      One1 := PPP_OneNC( S[1][1] );

      l_s := Length( S );
      l_s1 := Length( S[1] );
      l_p1 := Length( P[1] );

      if i > l_s then
         Error("Wrong input, the first entry cannot be larger then the row-length of the second entry.");
      fi;

      ## empty column in S and P, first columns above i
      for j in [1..i-1] do
         if not PPP_Equal( S[j][i], Zero0 ) then
            if not PPP_Equal( S[i][i], One1 ) then
               q := DivPPartPoly( S[j][i], S[i][i] );
            else q := S[j][i];
            fi;
            for k in [1..l_s1] do
               S[j][k] := PPP_Subtract( S[j][k], PPP_Mult( q, S[i][k] ) );
               P[j][k] := PPP_Subtract( P[j][k], PPP_Mult( q, P[i][k] ) );
            od;
         fi;
      od;

      ## empty column in S and P, first columns below i
      for j in [i+1..l_s] do
         if not PPP_Equal( S[j][i], Zero0 ) then
            if not PPP_Equal( S[i][i], One1 ) then
               q := DivPPartPoly( S[j][i], S[i][i] );
            else q := S[j][i];
            fi;

            ## row j of S - q row i of S
            for k in [1..l_s1] do
               if not PPP_Equal( S[i][k], Zero0 ) then
                  S[j][k] := PPP_Subtract( S[j][k], PPP_Mult( q, S[i][k] ) );
               fi;
            od;

            ## row j of P - q row i of P
            for k in [1..l_p1] do
               if not PPP_Equal( P[i][k], Zero0 ) then
                  P[j][k] := PPP_Subtract( P[j][k], PPP_Mult( q, P[i][k] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyCol := S, emptyColTrans := P );
   end);

###############################################################################
##
## EmptyColumnLoc( i, S, P )
##
## Input: a positive integer i and p-power-poly-loc matrices S and P, where P
##        stores row-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyColTrans := P ), where S is the
##         modified matrix where the entries in column i are zero, except 
##         (i,i), subject to the condition that (i,i) divides every entry in 
##         the i-th column of S; P stores row-transformation performed on 
##         S so far.
##
InstallMethod( EmptyColumnLoc, [ IsPosInt, IsList, IsList ], 
   function( i, S, P )
      local Zero0Loc, num, denom, Zero0, j, num_j, denom_j, list, q,
            q_Loc, k, l_s, l_s1, l_p1, One1;

      Zero0Loc := PPPL_ZeroNC( S[1][1] );

      l_s := Length( S );
      l_s1 := Length( S[1] );
      l_p1 := Length( P[1] );

      if i > l_s then
         Error("Wrong input.");
      fi;

      num := S[i][i][1];
      denom := S[i][i][2];

      Zero0 := PPP_ZeroNC( num );
      One1 := PPP_OneNC( num );
 
      ## empty column in S and P, first columns above i
      for j in [1..i-1] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            num_j := S[j][i][1];
            denom_j := S[j][i][1];
            q := PPP_Mult( num_j, denom );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( PPP_Mult( num_j, denom ), num );
            fi;
            if PPP_Equal( denom_j, One1 ) then
               q_Loc := [ q, denom_j ];
            else q_Loc := PPPL_Check( [ q, denom_j ] );
            fi;
            for k in [1..l_s1] do
               S[j][k] := PPPL_Subtract( S[j][k], PPPL_Mult( q_Loc, S[i][k] ) );
               P[j][k] := PPPL_Subtract( P[j][k], PPPL_Mult( q_Loc, P[i][k] ) );
            od;
         fi;
      od;

      ## empty column in S and P, first columns below i
      for j in [i+1..l_s] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            num_j := S[j][i][1];
            denom_j := S[j][i][2];
            q := PPP_Mult( num_j, denom );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( PPP_Mult( num_j, denom ), num );
            fi;
            if PPP_Equal( denom_j, One1 ) then
               q_Loc := [ q, denom_j ];
            else q_Loc := PPPL_Check( [ q, denom_j ] );
            fi;

            ## row j of S - q_Loc row i of S
            for k in [1..l_s1] do
               if not PPPL_Equal( S[i][k], Zero0Loc ) then
                  S[j][k] := PPPL_Subtract( S[j][k], PPPL_Mult( q_Loc, S[i][k] ) );
               fi;
            od;

            ## row j of P - q_Loc row i of P
            for k in [1..l_p1] do
               if not PPPL_Equal( P[i][k], Zero0Loc ) then
                  P[j][k] := PPPL_Subtract( P[j][k], PPPL_Mult( q_Loc, P[i][k] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyCol := S, emptyColTrans := P );
   end);

###############################################################################
##
## EmptyColumnGreater( i, S, P )
##
## Input: a positive integer i and p-power-poly matrices S and P, where P
##        stores row-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyColTrans := P ), where S is the
##         modified matrix where the entries in column i and row j with j > i
##         are zero, subject to the condition that (i,i) divides every entry 
##         in the i-th column of S; P stores row-transformation performed 
##         on S so far.
##
InstallMethod( EmptyColumnGreater, [ IsPosInt, IsList, IsList ], 
   function( i, S, P )
      local Zero0, One1, j, list, q, k, l_s, l_s1, l_p1;

      Zero0 := PPP_ZeroNC( S[1][1] );
      One1 := PPP_OneNC( S[1][1] );

      l_s := Length( S );
      l_s1 := Length( S[1] );
      l_p1 := Length( P[1] );

      if i > l_s then
         Error("Wrong input, the first entry cannot be larger then the number of rows of the second entry.");
      fi;

      for j in [i+1..l_s] do
         if not PPP_Equal( S[j][i], Zero0 ) then
            if not PPP_Equal( S[i][i], One1 ) then
               q := DivPPartPoly( S[j][i], S[i][i] ); 
            else q := S[j][i];
            fi;

            ## row j of S - q row i of S
            for k in [1..l_s1] do
               if not PPP_Equal( S[i][k], Zero0 ) then
                  S[j][k] := PPP_Subtract( S[j][k], PPP_Mult( q, S[i][k] ) );
               fi;
            od;

            ## row j of P - q row i of P
            for k in [1..l_p1] do
               if not PPP_Equal( P[i][k], Zero0 ) then
                  P[j][k] := PPP_Subtract( P[j][k], PPP_Mult( q, P[i][k] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyCol:=S, emptyColTrans:=P );
   end);

###############################################################################
##
## EmptyColumnGreaterLoc( i, S, P )
##
## Input: a positive integer i and p-power-poly-loc matrices S and P, where P
##        stores row-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyColTrans := P ), where S is the
##         modified matrix where the entries in column i and row j with j > i
##         are zero, subject to the condition that (i,i) divides every entry 
##         in the i-th column of S; P stores row-transformation performed 
##         on S so far.
##
InstallMethod( EmptyColumnGreaterLoc, [ IsPosInt, IsList, IsList ], 
   function( i, S, P )
      local Zero0Loc, num, denom, Zero0, j, num_j, denom_j, 
            list, q, q_Loc, k, l_s, l_s1, l_p1, One1;

      Zero0Loc := PPPL_ZeroNC( S[1][1] );

      l_s := Length( S );
      l_s1 := Length( S[1] );
      l_p1 := Length( P[1] );

      if i > l_s then
         Error("Wrong input, the first entry cannot be larger than the number of rows of the second entry.");
      fi;

      num := S[i][i][1];
      denom := S[i][i][2];

      Zero0 := PPP_ZeroNC( num );
      One1 := PPP_OneNC( num );

      for j in [i+1..l_s] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            num_j := S[j][i][1];
            denom_j := S[j][i][2];
            q := PPP_Mult( num_j, denom );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( q, num ); 
            fi;
            if PPP_Equal( denom_j, One1 ) then
               q_Loc := [ q, denom_j ];
            else q_Loc := PPPL_Check( [ q, denom_j ] );
            fi;

            ## row j of S - q_Loc row i of S
            for k in [1..l_s1] do
               if not PPPL_Equal( S[i][k], Zero0Loc ) then
                  S[j][k] := PPPL_Subtract( S[j][k], PPPL_Mult( q_Loc, S[i][k] ) );
               fi;
            od;

            ## row j of P - q_Loc row i of P
            for k in [1..l_p1] do
               if not PPPL_Equal( P[i][k], Zero0Loc ) then
                  P[j][k] := PPPL_Subtract( P[j][k], PPPL_Mult( q_Loc, P[i][k] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyCol := S, emptyColTrans := P );
   end);

###############################################################################
##
## EmptyColumnGreaterLoc_NonP( i, S )
##
## Input: a positive integer i and a p-power-poly matrix S.
##
## Output: a matrix S: S is the modified matrix where the entries in column 
##         i and row j with j > i are zero, subject to the condition that 
##         (i,i) divides every entry in the i-th column of S. 
##
InstallMethod( EmptyColumnGreaterLoc_NonP, [ IsPosInt, IsList ], 
   function( i, S )
      local Zero0Loc, num, denom, Zero0, j, num_j, denom_j, 
            list, q, q_Loc, k, l_s, l_s1, l_p1, One1;

      Zero0Loc := PPPL_ZeroNC( S[1][1] );

      l_s := Length( S );
      l_s1 := Length( S[1] );

      if i > l_s then
         Error("Wrong input, the first entry cannot be larger than the number of colums of the second entry.");
      fi;

      num := S[i][i][1];
      denom := S[i][i][2];

      Zero0 := PPP_ZeroNC( num );
      One1 := PPP_OneNC( num );

      for j in [i+1..l_s] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            num_j := S[j][i][1];
            denom_j := S[j][i][2];
            q := PPP_Mult( num_j, denom );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( q, num ); 
            fi;
            if PPP_Equal( denom_j, One1 ) then
               q_Loc := [ q, denom_j ];
            else q_Loc := PPPL_Check( [ q, denom_j ] );
            fi;

            ## row j of S - q_Loc row i of S
            for k in [1..l_s1] do
               if not PPPL_Equal( S[i][k], Zero0Loc ) then
                  S[j][k] := PPPL_Subtract( S[j][k], PPPL_Mult( q_Loc, S[i][k] ) );
               fi;
            od;

         fi;
      od;

      return S;
   end);

###############################################################################
##
## EmptyRowGreater( i, S, Q )
##
## Input: a positive integer i and p-power-poly matrices S and Q, where Q
##        stores column-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyRowTrans := Q ), where S is the
##         modified matrix where the entries in row i and column j with j > i
##         are zero, subject to the condition that (i,i) divides every entry 
##         in the i-th row of S; Q stores column-transformation performed 
##         on S so far.
##
InstallMethod( EmptyRowGreater, [ IsPosInt, IsList, IsList ], 
   function( i, S, Q )
      local n, Zero0, One1, j, k, q, list, l_s, l_q;

      n := Length( S[1] );
      Zero0 := PPP_ZeroNC( S[1][1] );
      One1 := PPP_OneNC( S[1][1] );

      l_s := Length( S );
      l_q := Length( Q );

      if i > n then
         Error("Wrong input, the first entry cannot be larger than the number of rows of the second entry.");
      fi;

      for j in [i+1..n] do
         if not PPP_Equal( S[i][j], Zero0 ) then
            if not PPP_Equal( S[i][i], One1 ) then
               q := DivPPartPoly( S[i][j], S[i][i] );
            else q := S[i][j];
            fi;

            ## column j of S - q column i of S
            for k in [1..l_s] do
               if not PPP_Equal( S[k][i], Zero0 ) then
                  S[k][j] := PPP_Subtract( S[k][j], PPP_Mult( q, S[k][i] ) );
               fi;
            od;

            ## column j of Q - q column i of Q
            for k in [1..l_q] do
               if not PPP_Equal( Q[k][i], Zero0 ) then
                  Q[k][j] := PPP_Subtract( Q[k][j], PPP_Mult( q, Q[k][i] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyRow := S, emptyRowTrans := Q );
   end);

###############################################################################
##
## EmptyRowGreaterLoc( i, S, Q )
##
## Input: a positive integer i and p-power-poly-loc matrices S and Q, where Q
##        stores column-transformation performed on S so far.
##
## Output: a record rec( emptyCol := S, emptyRowTrans := Q ), where S is the
##         modified matrix where the entries in row i and column j with j > i
##         are zero, subject to the condition that (i,i) divides every entry 
##         in the i-th row of S; Q stores column-transformation performed 
##         on S so far.
##
InstallMethod( EmptyRowGreaterLoc, [ IsPosInt, IsList, IsList ], 
   function( i, S, Q )
      local n, Zero0Loc, Zero0, num, denom, j, k, q, list, q_Loc, l_s, 
            l_q, One1;

      n := Length( S[1] );
      Zero0Loc := PPPL_ZeroNC( S[1][1] );
      Zero0 := PPP_ZeroNC( S[1][1][1] );
      One1 := PPP_OneNC( S[1][1][1] );

      l_s := Length( S );
      l_q := Length( Q );

      if i > n then
         Error("Wrong input, the first entry cannot be larger than the numver of rows of the second entry.");
      fi;

      num := S[i][i][1];
      denom := S[i][i][2];

      for j in [i+1..n] do
         if not PPP_Equal( S[i][j][1], Zero0 ) then
            q := PPP_Mult( denom, S[i][j][1] );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( q, num );
            fi;
            if PPP_Equal( S[i][j][2], One1 ) then
               q_Loc := [ q, S[i][j][2] ];
            else q_Loc := PPPL_Check( [ q, S[i][j][2] ] );
            fi;

            ## column j of S - q_Loc column i of S
            for k in [1..l_s] do
               if not PPPL_Equal( S[k][i], Zero0Loc ) then
                  S[k][j] := PPPL_Subtract( S[k][j], PPPL_Mult( q_Loc, S[k][i] ) );
               fi;
            od;

            ## column j of Q - q_Loc column i of Q
            for k in [1..l_q] do
               if not PPPL_Equal( Q[k][i], Zero0Loc ) then
                  Q[k][j] := PPPL_Subtract( Q[k][j], PPPL_Mult( q_Loc, Q[k][i] ) );
               fi;
            od;
         fi;
      od;

      return rec( emptyRow := S, emptyRowTrans := Q );
   end);

###############################################################################
##
## EmptyRowGreaterLoc_NonQ( i, S )
##
## Input: a positive integer i and p-power-poly-loc matrix S.
##
## Output: a matrix S: S is the modified matrix where the entries in row i 
##         and column j with j > i are zero, subject to the condition that 
##         (i,i) divides every entry in the i-th row of S.
##
InstallMethod( EmptyRowGreaterLoc_NonQ, [ IsPosInt, IsList ], 
   function( i, S )
      local n, Zero0Loc, Zero0, num, denom, j, k, q, list, q_Loc, l_s, 
            One1;

      n := Length( S[1] );
      Zero0Loc := PPPL_ZeroNC( S[1][1] );
      Zero0 := PPP_ZeroNC( S[1][1][1] );
      One1 := PPP_OneNC( S[1][1][1] );

      l_s := Length( S );

      if i > n then
         Error("Wrong input, the first entry cannot be larger than the number of rows of the second entry.");
      fi;

      num := S[i][i][1];
      denom := S[i][i][2];

      for j in [i+1..n] do
         if not PPP_Equal( S[i][j][1], Zero0 ) then
            q := PPP_Mult( denom, S[i][j][1] );
            if not PPP_Equal( num, One1 ) then
               q := DivPPartPoly( q, num );
            fi;
            if PPP_Equal( S[i][j][2], One1 ) then
               q_Loc := [ q, S[i][j][2] ];
            else q_Loc := PPPL_Check( [ q, S[i][j][2] ] );
            fi;

            ## column j of S - q_Loc column i of S
            for k in [1..l_s] do
               if not PPPL_Equal( S[k][i], Zero0Loc ) then
                  S[k][j] := PPPL_Subtract( S[k][j], PPPL_Mult( q_Loc, S[k][i] ) );
               fi;
            od;
         fi;
      od;

      return S;
   end);

###############################################################################
##
## DivRowLoc( i, S, P, el )
##
## Input: a positive integer i, p-power-poly-loc matrices S and P and a
##        p-power-poly-loc element el, where P stores row-transformation 
##        performed on S so far. 
##
## Output: a list [S, P]: S is the modified matrix where the entries in row i
##         are divided by the p-power-poly-loc element el; P stores 
##         row-transformation performed on S so far.
##
InstallGlobalFunction( DivRowLoc, 
   function( i, S, P, el )
      local Zero0Loc, num, Zero0, denom, j, div;

      Zero0Loc := PPPL_ZeroNC( el );

      num := el[1];
      Zero0 := PPP_ZeroNC( num );
      ## check
      if PPP_Equal( num, Zero0 ) then
         Error( "Wrong input, division by zero." );
      fi;

      denom := el[2];
      div := PPPL_CheckNC( [ denom, num ] );

      ## divide entries in row i of S
      for j in [1..Length(S[1])] do
         if not PPPL_Equal( S[i][j], Zero0Loc ) then
            S[i][j] := PPPL_Mult( S[i][j], div );
         fi;
      od;

      ## divide entries in row i of P
      for j in [1..Length(P[1])] do
         if not PPPL_Equal( P[i][j], Zero0Loc ) then
            P[i][j] := PPPL_Mult( P[i][j], div );
         fi;
      od;

      return [ S, P ];
   end);

###############################################################################
##
## DivRowLoc_NonP( i, S, el )
##
## Input: a positive integer i, a p-power-poly-loc matrix S and a
##        p-power-poly-loc element el. 
##
## Output: a matrix S which is the modified matrix where the entries in row i
##         are divided by the p-power-poly-loc element el.
##
InstallGlobalFunction( DivRowLoc_NonP, 
   function( i, S, el )
      local Zero0Loc, num, Zero0, denom, j, div;

      Zero0Loc := PPPL_ZeroNC( el );

      num := el[1];
      Zero0 := PPP_ZeroNC( num );
      ## check
      if PPP_Equal( num, Zero0 ) then
         Error( "Wrong input, division by zero." );
      fi;

      denom := el[2];
      div := PPPL_CheckNC( [ denom, num ] );

      ## divide entries in row i of S
      for j in [1..Length(S[1])] do
         if not PPPL_Equal( S[i][j], Zero0Loc ) then
            S[i][j] := PPPL_Mult( S[i][j], div );
         fi;
      od;

      return S;
   end);

###############################################################################
##
## DivColLoc( i, S, Q, el )
##
## Input: a positive integer i, p-power-poly-loc matrices S and Q and a
##        p-power-poly-loc element el, where Q stores column-transformation 
##        performed on S so far. 
##
## Output: a list [S, Q]: S is the modified matrix where the entries in 
##         column i are divided by the p-power-poly-loc element el; Q stores 
##         column-transformation performed on S so far.
##
InstallGlobalFunction( DivColLoc, 
   function( i, S, Q, el )
      local Zero0Loc, Zero0, num, denom, div, j;

      Zero0Loc := PPPL_ZeroNC( el );

      num := el[1];
      Zero0 := PPP_ZeroNC( num );
      ## check
      if PPP_Equal( num, Zero0 ) then
         Error( "Wrong input, division by zero." );
      fi;

      denom := el[2];
      div := PPPL_CheckNC( [ denom, num ] );

      ## divide entries in column i of S
      for j in [1..Length(S)] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            S[j][i] := PPPL_Mult( S[j][i], div );
         fi;
      od;

      ## divide entries in column i of Q
      for j in [1..Length(Q)] do
         if not PPPL_Equal( Q[j][i], Zero0Loc ) then
            Q[j][i] := PPPL_Mult( Q[j][i], div );
         fi;
      od;

      return [ S, Q ];
   end);

###############################################################################
##
## DivColLoc_NonQ( i, S, el )
##
## Input: a positive integer i, a p-power-poly-loc matrix S and a
##        p-power-poly-loc element el. 
##
## Output: a matrix S which is the modified matrix where the entries in 
##         column i are divided by the p-power-poly-loc element el.
##
InstallGlobalFunction( DivColLoc_NonQ, 
   function( i, S, el )
      local Zero0Loc, num, Zero0, denom, div, j;

      Zero0Loc := PPPL_ZeroNC( el );

      num := el[1];
      Zero0 := PPP_ZeroNC( num );
      ## check
      if PPP_Equal( num, Zero0 ) then
         Error( "Wrong input, division by zero." );
      fi;

      denom := el[2];
      div := PPPL_CheckNC( [ denom, num ] );

      ## divide entries in column i of S
      for j in [1..Length(S)] do
         if not PPPL_Equal( S[j][i], Zero0Loc ) then
            S[j][i] := PPPL_Mult( S[j][i], div );
         fi;
      od;

      return [ S ];
   end);

###############################################################################
##
## SmithNormalFormPPowerPoly( M_in )
##
## Input: a matrix M_in with p-power-poly-loc entries.
##
## Output: a matrix which is the Smith normal form of M_in.
##
InstallMethod( SmithNormalFormPPowerPoly, [ IsList ], 
   function( M_in )

      local p, n, m, i, j, k, l, S, Zero0Loc, One1Loc, eval_pv, eval_test, 
            pprimediv, pv_set, pv_1, pv_2, q, Rec, test, check;

      check := CHECK_SMITHNF_PPOWERPOLY;

      if check then
         Print( "Note: no check can be done during the computation of the Smith normal form." );
      fi;

      CHECK_SMITHNF_PPOWERPOLY := false;

      n := Length( M_in[1] );
      m := Length( M_in );

      p := M_in[1][1][2][1];

      Zero0Loc := PPPL_ZeroNC( M_in[1][1] );
      One1Loc := PPPL_OneNC( M_in[1][1] );

      ## if zero-mat, then return
      if ForAll( M_in, x -> ForAll( x, y -> PPPL_Equal( y, PPPL_Mult( Zero0Loc, y ) ) ) ) then
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "Smith normal form is computed. \n" );
         fi;

         CHECK_SMITHNF_PPOWERPOLY := check;

         return M_in;
      fi;
      S := StructuralCopy( M_in );

      ## change the matrix to a diagonal matrix
      i := 1;
      while i <= n do
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "SNF: i = ", i, " of ", n , "\n" );
         fi;
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         # get set of record with pivot-element and position
         pv_set := [ rec( el := S[i][i], p_1 := i, p_2 := i ) ];
         if not PPPL_Equal( S[i][i], One1Loc ) then
            k := i;
            ## find list of elements with smallest p-adic value
            while k <= m do
               l := i;
               while l <= n do
                  if PPPL_Equal( S[k][l], One1Loc ) then
                     pv_set := [ rec( el := S[k][l], p_1 := k, p_2 := l ) ];
                     l := n + 1;
                     k := m + 1;
                  elif PPPL_PadicValue( S[k][l] ) < PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set := [];
                     pv_set[1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  elif PPPL_PadicValue( S[k][l] ) = PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set[Length([pv_set])+1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  else
                     l := l + 1;
                  fi;
               od;
               k := k + 1;
            od;
            ## find element in that set with smallest p-prime-part
            if not PPPL_Equal( pv_set[1]!.el, One1Loc ) and not PPPL_Equal( pv_set[1]!.el, Zero0Loc ) then
               test := pv_set[1];
               for j in [1..Length( pv_set )] do
                  if PPPL_Smaller( PPPL_AbsValue( PPrimePartPolyLoc( pv_set[j]!.el ) ), PPPL_AbsValue( PPrimePartPolyLoc( test!.el ) ) ) then
                     test := pv_set[j];
                  fi;
               od;
               pv_set := [ test ];
            else pv_set := [pv_set[1]];
            fi;
         fi;

         ## get position of pivot element
         pv_1 := pv_set[1]!.p_1;
         pv_2 := pv_set[1]!.p_2;

         ## if there is no pivot then return
         if PPPL_Equal( S[pv_1][pv_2], Zero0Loc ) then
            if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
               Print( "Smith normal form is computed. \n" );
            fi;

            CHECK_SMITHNF_PPOWERPOLY := check;

            return S;
         fi;
         
         ## check that pivot (k,l) is positive
         if PPPL_Smaller( S[pv_1][pv_2], Zero0Loc ) then
            S := DivRowLoc_NonP( pv_1, S, PPPL_AdditiveInverse( One1Loc ) );
         fi;

         ## move pivot to position (i,i)
         if pv_1 <> i or pv_2 <> i then
            S := ExchangeRowsPPPL( i, pv_1, S );
            S := ExchangeColumnsPPPL( i, pv_2, S );
            if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
            elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
            fi;
            pv_1 := i;
            pv_2 := i;
            if InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "pivot = [", pv_1, ",", pv_2, "] \n\n" );
            fi;
         fi;
         
         ## make pivot a p-part element
         if not PPPL_Equal( S[i][i], Zero0Loc ) and not PPPL_Equal( S[i][i], One1Loc ) then
            ## divide row by p-prime-part of pivot
            pprimediv := PPrimePartPolyLoc( S[i][i] );
            S := DivRowLoc_NonP( i, S, pprimediv );
         fi;

         ## emtpy column greater than i
         S := EmptyColumnGreaterLoc_NonP( i, S );

         ## empty row greater than i
         S := EmptyRowGreaterLoc_NonQ( i, S );
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         
         ## initialize next step
         i := i + 1;
      od;

      if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
         Print( "Smith normal form is computed. \n" );
      fi;

      CHECK_SMITHNF_PPOWERPOLY := check;

      return S;
   end);

###############################################################################
##
## SmithNormalFormPPowerPolyTransforms( M_in )
##
## Input: a matrix M_in with p-power-poly-loc entries.
##
## Output: a record rec( norm:=S, rowtrans:=P, coltrans:=Q ) where S is the
##         Smith normal form of M_in, P records the row transformations 
##         performed and Q the column transformations, such that PMQ = S
##
InstallMethod( SmithNormalFormPPowerPolyTransforms,
   "compute Smith normal form with p-power-poly-loc entries", 
   [ IsList ], 
   function( M_in )
      local p, n, m, i, j, k, l, S, M, P, Q, Zero0Loc, One1Loc, eval_pv, 
            eval_test, pprimediv, pv_set, pv_1, pv_2, list, q, Rec, test, T;

      n := Length( M_in[1] );
      m := Length( M_in );

      p := M_in[1][1][2][1];

      Zero0Loc := PPPL_ZeroNC( M_in[1][1] );
      One1Loc := PPPL_OneNC( M_in[1][1] );

      P := IdentityPPowerPolyLocMat( p, m );
      Q := IdentityPPowerPolyLocMat( p, n );

      ## if zero-mat, then return
      if ForAll( M_in, x -> ForAll( x, y -> PPPL_Equal( y, PPPL_Mult( Zero0Loc, y ) ) ) ) then
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "Smith normal form is computed. \n" );
         fi;

         return rec( norm:=M_in, rowtrans:=P, coltrans:=Q );
      fi;

      S := StructuralCopy( M_in );

      if CHECK_SMITHNF_PPOWERPOLY then
         M := StructuralCopy( S );
      fi;

      ## change the matrix to a diagonal matrix
      i := 1;
      while i <= n do
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "SNF: i = ", i, " of ", n , "\n" );
         fi;
         ## check?
         if CHECK_SMITHNF_PPOWERPOLY then
            T := PPPL_MatrixMult( P, PPPL_MatrixMult( M, Q ) );
            if not ForAll( [1..m], x -> ForAll( [1..n], y -> PPPL_Equal( T[x][y], S[x][y] ) ) ) then 
               Print( "P = " );
               PPPL_PrintMat( P );
               Print( "\n " );
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
               Print( "Q = " );
               PPPL_PrintMat( Q );
               Print( "\n " );
               Error("1");
            fi;
         fi;
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "P = " );
            PPPL_PrintMat( P );
            Print( "\n " );
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
            Print( "Q = " );
            PPPL_PrintMat( Q );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         # get set of record with pivot-element and position
         pv_set := [ rec( el := S[i][i], p_1 := i, p_2 := i ) ];
         if not PPPL_Equal( S[i][i], One1Loc ) then
            k := i;
            ## find list of elements with smallest p-adic value
            while k <= m do
               l := i;
               while l <= n do
                  if PPPL_Equal( S[k][l], One1Loc ) then
                     pv_set := [ rec( el := S[k][l], p_1 := k, p_2 := l ) ];
                     l := n + 1;
                     k := m + 1;
                  elif PPPL_PadicValue( S[k][l] ) < PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set := [];
                     pv_set[1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  elif PPPL_PadicValue( S[k][l] ) = PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set[Length([pv_set])+1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  else
                     l := l + 1;
                  fi;
               od;
               k := k + 1;
            od;
            ## find element in that set with smallest p-prime-part
            if not PPPL_Equal( pv_set[1]!.el, One1Loc ) and not PPPL_Equal( pv_set[1]!.el, Zero0Loc ) then
               test := pv_set[1];
               for j in [1..Length( pv_set )] do
                  if PPPL_Smaller( PPPL_AbsValue( PPrimePartPolyLoc( pv_set[j]!.el ) ), PPPL_AbsValue( PPrimePartPolyLoc( test!.el ) ) ) then
                     test := pv_set[j];
                  fi;
               od;
               pv_set := [ test ];
            else pv_set := [pv_set[1]];
            fi;
         fi;

         ## get position of pivot element
         pv_1 := pv_set[1]!.p_1;
         pv_2 := pv_set[1]!.p_2;

         ## if there is no pivot then return
         if PPPL_Equal( S[pv_1][pv_2], Zero0Loc ) then
            if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
               Print( "Smith normal form is computed. \n" );
            fi;

            return rec( norm:=S, rowtrans:=P, coltrans:=Q );
         fi;
         
         ## check that pivot (k,l) is positive
         if PPPL_Smaller( S[pv_1][pv_2], Zero0Loc ) then
            list := DivRowLoc( pv_1, S, P, PPPL_AdditiveInverse( One1Loc ) );
            S := list[1];
            P := list[2];
         fi;

         ## move pivot to position (i,i)
         if pv_1 <> i or pv_2 <> i then
            S := ExchangeRowsPPPL( i, pv_1, S );
            P := ExchangeRowsPPPL( i, pv_1, P );
            S := ExchangeColumnsPPPL( i, pv_2, S );
            Q := ExchangeColumnsPPPL( i, pv_2, Q );
            ## check?
            if CHECK_SMITHNF_PPOWERPOLY then
               T := PPPL_MatrixMult( P, PPPL_MatrixMult( M, Q ) );
               if not ForAll( [1..m], x -> ForAll( [1..n], y -> PPPL_Equal( T[x][y], S[x][y] ) ) ) then 
                  Print( "P = " );
                  PPPL_PrintMat( P );
                  Print( "\n " );
                  Print( "S = " );
                  PPPL_PrintMat( S );
                  Print( "\n " );
                  Print( "Q = " );
                  PPPL_PrintMat( Q );
                  Print( "\n " );
                  Error("3");
               fi;
            fi;
            if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
               Print( "P = " );
               PPPL_PrintMat( P );
               Print( "\n " );
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
               Print( "Q = " );
               PPPL_PrintMat( Q );
               Print( "\n " );
            elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
            fi;
            pv_1 := i;
            pv_2 := i;
            if InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "pivot = [", pv_1, ",", pv_2, "] \n\n" );
            fi;
         fi;
         
         ## make pivot a p-part element
         if not PPPL_Equal( S[i][i], Zero0Loc ) and not PPPL_Equal( S[i][i], One1Loc ) then
            ## divide row by p-prime-part of pivot
            pprimediv := PPrimePartPolyLoc( S[i][i] );
            list := DivRowLoc( i, S, P, pprimediv );
            S := list[1];
            P := list[2];
            ## check?
            if CHECK_SMITHNF_PPOWERPOLY then
               T := PPPL_MatrixMult( P, PPPL_MatrixMult( M, Q ) );
               if not ForAll( [1..m], x -> ForAll( [1..n], y -> PPPL_Equal( T[x][y], S[x][y] ) ) ) then 
                  Print( "P = " );
                  PPPL_PrintMat( P );
                  Print( "\n " );
                  Print( "S = " );
                  PPPL_PrintMat( S );
                  Print( "\n " );
                  Print( "Q = " );
                  PPPL_PrintMat( Q );
                  Print( "\n " );
                  Error("4a");
               fi;
            fi;
         fi;
         ## emtpy column greater than i
         Rec := EmptyColumnGreaterLoc( i, S, P );
         S := Rec.emptyCol;
         P := Rec.emptyColTrans; ## row operations needed
         ## check?
         if CHECK_SMITHNF_PPOWERPOLY then
            T := PPPL_MatrixMult( P, PPPL_MatrixMult( M, Q ) );
            if not ForAll( [1..m], x -> ForAll( [1..n], y -> PPPL_Equal( T[x][y], S[x][y] ) ) ) then 
               Print( "P = " );
               PPPL_PrintMat( P );
               Print( "\n " );
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
               Print( "Q = " );
               PPPL_PrintMat( Q );
               Print( "\n " );
               Error("4b");
            fi;
         fi;

         ## empty row greater than i
         Rec := EmptyRowGreaterLoc( i, S, Q );
         S := Rec.emptyRow;
         Q := Rec.emptyRowTrans; ## column operations needed
         ## check?
         if CHECK_SMITHNF_PPOWERPOLY then
            T := PPPL_MatrixMult( P, PPPL_MatrixMult( M, Q ) );
            if not ForAll( [1..m], x -> ForAll( [1..n], y -> PPPL_Equal( T[x][y], S[x][y] ) ) ) then 
               Print( "P = " );
               PPPL_PrintMat( P );
               Print( "\n " );
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
               Print( "Q = " );
               PPPL_PrintMat( Q );
               Print( "\n " );
               Error("4c");
            fi;
         fi;
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "P = " );
            PPPL_PrintMat( P );
            Print( "\n " );
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
            Print( "Q = " );
            PPPL_PrintMat( Q );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         
         ## initialize next step
         i := i + 1;
      od;

      if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
         Print( "Smith normal form is computed. \n" );
      fi;

      return rec( norm:=S, rowtrans:=P, coltrans:=Q );
   end);

###############################################################################
##
## SmithNormalFormPPowerPolyColTransform( M )
##
## Input: a matrix M_in with p-power-poly-loc entries.
##
## Output: a record rec( norm:=S, coltrans:=Q ) where S is the Smith normal 
##         form of M_in and Q records the column transformations performed, 
##         such that PMQ = S for some invertible matrix P which is NOT 
##         computed in this function.
##
InstallMethod( SmithNormalFormPPowerPolyColTransform, [ IsList ], 
   function( M_in )
      local p, n, m, i, j, k, l, S, Q, Zero0Loc, One1Loc, eval_pv, eval_test, 
            pprimediv, pv_set, pv_1, pv_2, q, Rec, test, check;

      check := CHECK_SMITHNF_PPOWERPOLY;

      if check then
         Print( "Note: no check can be done during the computation of the Smith normal form." );
      fi;

      CHECK_SMITHNF_PPOWERPOLY := false;

      n := Length( M_in[1] );
      m := Length( M_in );

      p := M_in[1][1][2][1];

      Zero0Loc := PPPL_ZeroNC( M_in[1][1] );
      One1Loc := PPPL_OneNC( M_in[1][1] );

      Q := IdentityPPowerPolyLocMat( p, n );

      ## if zero-mat, then return
      if ForAll( M_in, x -> ForAll( x, y -> PPPL_Equal( y, PPPL_Mult( Zero0Loc, y ) ) ) ) then
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "Smith normal form is computed. \n" );
         fi;

         CHECK_SMITHNF_PPOWERPOLY := check;

         return rec( norm:=M_in, coltrans:=Q );
      fi;

      S := StructuralCopy( M_in );

      ## change the matrix to a diagonal matrix
      i := 1;
      while i <= n do
         if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
            Print( "SNF: i = ", i, " of ", n , "\n" );
         fi;
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
            Print( "Q = " );
            PPPL_PrintMat( Q );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         # get set of record with pivot-element and position
         pv_set := [ rec( el := S[i][i], p_1 := i, p_2 := i ) ];
         if not PPPL_Equal( S[i][i], One1Loc ) then
            k := i;
            ## find list of elements with smallest p-adic value
            while k <= m do
               l := i;
               while l <= n do
                  if PPPL_Equal( S[k][l], One1Loc ) then
                     pv_set := [ rec( el := S[k][l], p_1 := k, p_2 := l ) ];
                     l := n + 1;
                     k := m + 1;
                  elif PPPL_PadicValue( S[k][l] ) < PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set := [];
                     pv_set[1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  elif PPPL_PadicValue( S[k][l] ) = PPPL_PadicValue( pv_set[1]!.el ) then
                     pv_set[Length([pv_set])+1] := rec( el := S[k][l], p_1 := k, p_2 := l );
                     l := l + 1;
                  else
                     l := l + 1;
                  fi;
               od;
               k := k + 1;
            od;
            ## find element in that set with smallest p-prime-part
            if not PPPL_Equal( pv_set[1]!.el, One1Loc ) and not PPPL_Equal( pv_set[1]!.el, Zero0Loc ) then
               test := pv_set[1];
               for j in [1..Length( pv_set )] do
                  if PPPL_Smaller( PPPL_AbsValue( PPrimePartPolyLoc( pv_set[j]!.el ) ), PPPL_AbsValue( PPrimePartPolyLoc( test!.el ) ) ) then
                     test := pv_set[j];
                  fi;
               od;
               pv_set := [ test ];
            else pv_set := [pv_set[1]];
            fi;
         fi;

         ## get position of pivot element
         pv_1 := pv_set[1]!.p_1;
         pv_2 := pv_set[1]!.p_2;

         ## if there is no pivot then return
         if PPPL_Equal( S[pv_1][pv_2], Zero0Loc ) then
            if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
               Print( "Smith normal form is computed. \n" );
            fi;

            CHECK_SMITHNF_PPOWERPOLY := check;

            return rec( norm:=S, coltrans:=Q );
         fi;
         
         ## check that pivot (k,l) is positive
         if PPPL_Smaller( S[pv_1][pv_2], Zero0Loc ) then
            S := DivRowLoc_NonP( pv_1, S, PPPL_AdditiveInverse( One1Loc ) );
         fi;

         ## move pivot to position (i,i)
         if pv_1 <> i or pv_2 <> i then
            S := ExchangeRowsPPPL( i, pv_1, S );
            S := ExchangeColumnsPPPL( i, pv_2, S );
            Q := ExchangeColumnsPPPL( i, pv_2, Q );
            if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
               Print( "Q = " );
               PPPL_PrintMat( Q );
               Print( "\n " );
            elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "S = " );
               PPPL_PrintMat( S );
               Print( "\n " );
            fi;
            pv_1 := i;
            pv_2 := i;
            if InfoLevel( InfoSmithPPowerPoly ) >= 2 then
               Print( "pivot = [", pv_1, ",", pv_2, "] \n\n" );
            fi;
         fi;
         
         ## make pivot a p-part element
         if not PPPL_Equal( S[i][i], Zero0Loc ) and not PPPL_Equal( S[i][i], One1Loc ) then
            ## divide row by p-prime-part of pivot
            pprimediv := PPrimePartPolyLoc( S[i][i] );
            S := DivRowLoc_NonP( i, S, pprimediv );
         fi;

         ## emtpy column greater than i
         S := EmptyColumnGreaterLoc_NonP( i, S );

         ## empty row greater than i
         Rec := EmptyRowGreaterLoc( i, S, Q );
         S := Rec.emptyRow;
         Q := Rec.emptyRowTrans; ## column operations needed
         if InfoLevel( InfoSmithPPowerPoly ) >= 3 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
            Print( "Q = " );
            PPPL_PrintMat( Q );
            Print( "\n " );
         elif InfoLevel( InfoSmithPPowerPoly ) >= 2 then
            Print( "S = " );
            PPPL_PrintMat( S );
            Print( "\n " );
         fi;
         
         ## initialize next step
         i := i + 1;
      od;

      if InfoLevel( InfoSmithPPowerPoly ) >= 1 then
         Print( "Smith normal form is computed. \n" );
      fi;

      CHECK_SMITHNF_PPOWERPOLY := check;

      return rec( norm:=S, coltrans:=Q );
   end);

#E Smith.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
