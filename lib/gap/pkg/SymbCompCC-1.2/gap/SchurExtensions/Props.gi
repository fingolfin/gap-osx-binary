###############################################################################
##
#F Props.gi           The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
#M AbelianInvariants( grp_pres )
##
## Input: p-power-poly-pcp-groups grp_pres
##
## Output: a list which describes the abelian invariants of grp_pres
##
InstallMethod( AbelianInvariants, [ IsPPPPcpGroups ], 0, 
   function( grp_pres )
      local p, rel, n, d, m, expo, expo_vec, Zero0, One1, A, l_a, null_vec, 
            i, j, k, S, Ab, l_ab, pos, PrimeP;

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ## Initialize
      p := grp_pres!.prime;
      rel := grp_pres!.rel;
      n := grp_pres!.n;
      d := grp_pres!.d;
      m := grp_pres!.m;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );
      PrimeP := Int2PPowerPoly( p, p );
      null_vec := [];
      for i in [1..n+d+m] do
         null_vec[i] := Zero0;
      od;

      A := [];
      l_a := 0;

      for i in [1..Length(rel)] do
         for j in [1..Length(rel[i])] do
            l_a := l_a + 1;
            ## initialize
            A[l_a] := StructuralCopy( null_vec );
            if i <= n then
               if j <> i then
                  A[l_a][i] := PPP_Add( A[l_a][i], One1 );
               else
                  A[l_a][i] := PPP_Add( A[l_a][i], PrimeP );
               fi;
            elif i <= n+d then
               if j <> i then
                  A[l_a][i] := PPP_Add( A[l_a][i], One1 );
               else
                  A[l_a][i] := PPP_Add( A[l_a][i], expo );
               fi;
            else ## d < i <= m
               if j <> i then
                  A[l_a][i] := PPP_Add( A[l_a][i], One1 );
               else
                  A[l_a][i] := PPP_Add( A[l_a][i], expo_vec[i] );
               fi;
            fi;
            ## add the relation
            for k in [1..Length(rel[i][j])] do
               pos := rel[i][j][k][1];
               if pos <= n then
                  A[l_a][pos] := PPP_Subtract( A[l_a][pos], Int2PPowerPoly( p, rel[i][j][k][2] ) );
               else
                  A[l_a][pos] := PPP_Subtract( A[l_a][pos], rel[i][j][k][2] );
               fi;
            od;
         od;
      od;
 
      A := PPowerPolyMat2PPowerPolyLocMat( A );
      S := SmithNormalFormPPowerPoly( A );
      l_ab := 0;
      Ab := [];
      for i in [1..Length( S[1] )] do
         if S[i][i][1] <> One1 then
            l_ab := l_ab + 1;
            Ab[l_ab] := S[i][i][2];
         fi;
      od;

      return Ab;
   end);

###############################################################################
##
#M  ZeroCohomologyPPPPcps( grp_pres, p )
##
## Input: p-power-poly-pcp-groups grp_pres and a prime p
##
## Output: a list which describes the zero-mod-p-cohomology of grp_pres
##
InstallMethod( ZeroCohomologyPPPPcps, [ IsPPPPcpGroups, IsInt ], 0, 
   function( grp_pres, p )
      local Ab, coho, i;

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ## check
      if not IsPrime( p ) or p < 0 then 
         return Error( "Wrong input, the second parameter has to be a positive prime." ); 
      fi;

      ## catch trivial case
      if not p = grp_pres!.prime then return []; fi;

      return [ p ];
   end); 

###############################################################################
##
#M  ZeroCohomologyPPPPcps( grp_pres )
##
## Input: p-power-poly-pcp-groups grp_pres
##
## Output: a list which describes the zero integral cohomology of grp_pres
##
InstallMethod( ZeroCohomologyPPPPcps, [ IsPPPPcpGroups ], 0, 
   function( grp_pres )

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      return [ 0 ];
   end); 

###############################################################################
##
#M  FirstCohomologyPPPPcps( grp_pres, p )
##
## Input: p-power-poly-pcp-groups grp_pres and a prime p
##
## Output: a list which describes the first-mod-p-cohomology of grp_pres
##
InstallMethod( FirstCohomologyPPPPcps, [ IsPPPPcpGroups, IsInt ], 0, 
   function( grp_pres, p )
      local Ab, coho, i;

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ## check
      if not IsPrime( p ) or p < 0 then 
         return Error( "Wrong input, the second parameter has to be a positive prime." ); 
      fi;

      ## catch trivial case
      if not p = grp_pres!.prime then return []; fi;

      ##
      Ab := AbelianInvariants( grp_pres );
      coho := [];

      for i in [1..Length( Ab )] do
         coho[i] := p;
      od;

      return coho;
   end);

###############################################################################
##
#M  FirstCohomologyPPPPcps( grp_pres )
##
## Input: p-power-poly-pcp-groups grp_pres
##
## Output: a list which describes the first integral cohomology of grp_pres
##
InstallMethod( FirstCohomologyPPPPcps, [ IsPPPPcpGroups ], 0, 
   function( grp_pres )

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      return [  ];
   end); 

###############################################################################
##
#M  SecondCohomologyPPPPcps( grp_pres, p )
##
## Input: p-power-poly-pcp-groups grp_pres and a prime p
##
## Output: a list which describes the second-mod-p-cohomology of grp_pres
##
InstallMethod( SecondCohomologyPPPPcps, [ IsPPPPcpGroups, IsInt ], 0, 
   function( grp_pres, p )
      local Ab, Schur, coho, l_c, i;

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ## check
      if not IsPrime( p ) or p < 0 then 
         return Error( "Wrong input, the second parameter has to be a positive prime." );  
      fi;

      ## catch trivial case
      if not p = grp_pres!.prime then return []; fi;

      ##
      Ab := AbelianInvariants( grp_pres );
      Schur := SchurMultiplicatorsStructurePPPPcps( grp_pres );
      coho := [];

      for i in [1..Length( Ab )] do
         coho[i] := p;
      od;
      l_c := Length( coho );
      for i in [1..Length( Schur )] do
         coho[l_c+i] := p;
      od;

      return coho;
   end);

###############################################################################
##
#M  SecondCohomologyPPPPcps( grp_pres )
##
## Input: p-power-poly-pcp-groups grp_pres
##
## Output: a list which describes the second integral cohomology of grp_pres
##
InstallMethod( SecondCohomologyPPPPcps, [ IsPPPPcpGroups ], 0, 
   function( grp_pres )

      if grp_pres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      return AbelianInvariants( grp_pres );
   end); 

#E Props.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
