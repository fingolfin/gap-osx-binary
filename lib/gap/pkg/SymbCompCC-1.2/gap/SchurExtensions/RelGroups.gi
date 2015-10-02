###############################################################################
##
#F RelGroups.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## GetRelAsWord( rel, n, d, p, m, FSet )
##
## Input: a relation rel, number of generators n, d, m, a prime p and a set of
##        free generators FSet
##
## Output: the relation rel as word
##
InstallMethod( GetRelAsWord,
   "take rel and make a word out of it", 
   [ IsList, IsInt, IsInt, IsPosInt, IsInt, IsList ],
   function( rel, n, d, p, m, FSet )
      local exp, word, i;

      if not IsPrime( p ) then
         Error( "Wrong input, the fourth parameter has to be a prime." );
      fi;

      ## get first
      if rel[1][1] <= n then
         exp := rel[1][2];
      else exp := EvaluatePPowerPoly( rel[1][2], m );
      fi;
      word := FSet[rel[1][1]]^exp;
      ## get rest
      for i in [2..Length( rel )] do
         if rel[i][1] <= n then
            exp := rel[i][2];
         else exp := EvaluatePPowerPoly( rel[i][2], m );
         fi;
         word := word*FSet[rel[i][1]]^exp;
      od;

      return word;
   end);

###############################################################################
##
## GetPcGroupPPowerPoly( ParPres, m )
##
## Input: a record ParPres, presententing p-power-poly-pcp-groups, and an 
##        integer m
##
## Ouput: a pc-group which corresponds to ParPres evaluated at m
##
InstallMethod( GetPcGroupPPowerPoly, 
   "take rels and get a pc-presentation for the group", 
   [ IsRecord, IsInt],
   function( ParPres, m )
      local p, n, d, rel, expo, F, FSet, relord, i, coll, word, j, G, 
            Zero0, One1;

      if not IsPrime( ParPres!.prime ) then Error("Wrong input." ); fi;

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      rel := ParPres!.rel;
      expo := ParPres!.expo;

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      ## initalize free group
      F := FreeGroup( n+d );
      FSet := GeneratorsOfGroup( F );

      ## get relative order vector
      relord := [];
      for i in [1..n] do
         relord[i] := p;
      od;
      for i in [n+1..n+d] do
         relord[i] := EvaluatePPowerPoly( expo, m );
      od;

      ## initalize collector
      coll := SingleCollector( F, relord );

      ## get powers
      for i in [1..n] do
         if rel[i][i] <> [[i,0]] then
            word := GetRelAsWord( rel[i][i], n, d, p, m, FSet );
            SetPower( coll, i, word );
         fi;
      od;
      for i in [n+1..n+d] do
         if rel[i][i] <> [[i,Zero0]] then
            word := GetRelAsWord( rel[i][i], n, d, p, m, FSet );
            SetPower( coll, i, word );
         fi;
      od;

      ## get conjugates
      for i in [1..n] do
         for j in [1..i-1] do
             if rel[i][j] <> [[i,1]] then
                word := GetRelAsWord( rel[i][j], n, d, p, m, FSet );
                SetConjugate( coll, i, j, word );
             fi;
         od;
      od;
      for i in [n+1..n+d] do
         for j in [1..i-1] do
            if rel[i][j] <> [[i,One1]] then
               word := GetRelAsWord( rel[i][j], n, d, p, m, FSet );
               SetConjugate( coll, i, j, word );
            fi;
         od;
      od;

      G := GroupByRws( coll );

      return G;
   end);

###############################################################################
##
## GetPcGroupPPowerPoly( G, m )
##
## Input: p-power-poly-pcp-groups G and an integer m
##
## Ouput: a pc-group which corresponds to G evaluated at m
##
InstallMethod( GetPcGroupPPowerPoly, 
   "take rels and get a pc-presentation for the group", 
   [ IsPPPPcpGroups, IsInt],
   function( G, m )
      local ParPres;

      ParPres := rec( prime := G!.prime );
      ParPres!.rel := G!.rel;
      ParPres!.n := G!.n;
      ParPres!.d := G!.d;
      ParPres!.m := G!.m;
      ParPres!.expo := G!.expo;
      ParPres!.expo_vec := G!.expo_vec;
      ParPres!.cc := G!.cc;
      ParPres!.name := G!.name;

      return GetPcGroupPPowerPoly( ParPres, m );
   end);

###############################################################################
##
## GetPcpGroupPPowerPoly( SchurExtParPres, x )
##
## Input: a record SchurExtParPres, presententing p-power-poly-pcp-groups, 
##        and an integer x
##
## Ouput: a pcp-group which corresponds to SchurExtParPres evaluated at x
##
InstallMethod( GetPcpGroupPPowerPoly, 
   "take rels of Schur extension and get a pcp-presentation for this",
   [ IsRecord, IsInt ],
   function( SchurExtParPres, x )
      local p, n, d, m, rel, expo, expo_vec, coll, Zero0, One1, word, 
            rel_pcp, help, i, j, k, G, rel_ordC, rel_ord;

      if not IsPrime( SchurExtParPres!.prime ) then Error("Wrong input." ); fi;

      p := SchurExtParPres!.prime;
      n := SchurExtParPres!.n;
      d := SchurExtParPres!.d;
      m := SchurExtParPres!.m;
      rel := SchurExtParPres!.rel;
      expo := SchurExtParPres!.expo;
      expo_vec := SchurExtParPres!.expo_vec;

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      ## initalize collector
      coll := FromTheLeftCollector( n+d+m );

      ## set relative orders
      for i in [1..n] do
         SetRelativeOrder( coll, i, p );
      od;
      word := EvaluatePPowerPoly( expo, x );
      rel_ord := word;
      for i in [1..d] do
         SetRelativeOrder( coll, n+i, word );
      od;
      rel_ordC := [];
      for i in [1..m] do
         if expo_vec[i] <> Zero0 then
            word := EvaluatePPowerPoly( expo_vec[i], x );
            rel_ordC[i] := word;
            SetRelativeOrder( coll, n+d+i, word );
          else rel_ordC[i] := 0;
         fi;
      od;

      ## get powers
      for i in [1..n] do
         if rel[i][i] <> [[i,0]] then
            rel_pcp := [];
            for j in [1..Length(rel[i][i])] do
               help := Length( rel_pcp );
               if rel[i][i][j][1] <= n then
                  rel_pcp[help+1] := rel[i][i][j][1];
                  rel_pcp[help+2] := rel[i][i][j][2];
               else word := EvaluatePPowerPoly( rel[i][i][j][2], x );
                  if rel[i][i][j][1] <= n+d then
                     word := word mod rel_ord;
                     if word <> 0 then
                        rel_pcp[help+1] := rel[i][i][j][1];
                        rel_pcp[help+2] := word;
                     fi;
                  else word := word mod rel_ordC[rel[i][i][j][1]-n-d];
                     if word <> 0 then
                        rel_pcp[help+1] := rel[i][i][j][1];
                        rel_pcp[help+2] := word;
                     fi;
                  fi;
               fi;
            od;
            SetPower( coll, i, rel_pcp );
         fi;
      od;
      for i in [1..d] do
         if rel[n+i][n+i] <> [[n+i,Zero0]] then
            rel_pcp := [];
            for j in [1..Length(rel[n+i][n+i])] do
               help := Length( rel_pcp );
               if rel[n+i][n+i][j][1] <= n then
                  rel_pcp[help+1] := rel[n+i][n+i][j][1];
                  rel_pcp[help+2] := rel[n+i][n+i][j][2];
               else word := EvaluatePPowerPoly( rel[n+i][n+i][j][2], x );
                  if rel[n+i][n+i][j][1] <= n+d then
                     word := word mod rel_ord;
                     if word <> 0 then
                        rel_pcp[help+1] := rel[n+i][n+i][j][1];
                        rel_pcp[help+2] := word;
                     fi;
                  else word := word mod rel_ordC[rel[n+i][n+i][j][1]-n-d];
                     if word <> 0 then
                        rel_pcp[help+1] := rel[n+i][n+i][j][1];
                        rel_pcp[help+2] := word;
                     fi;
                  fi;
               fi;
            od;
            SetPower( coll, n+i, rel_pcp );
         fi;
      od;

      ## get conjugates
      for i in [2..n] do
         for j in [1..i-1] do
            if rel[i][j] <> [[i,1]] then
               rel_pcp := [];
               for k in [1..Length(rel[i][j])] do
                  help := Length( rel_pcp );
                  if rel[i][j][k][1] <= n then
                     rel_pcp[help+1] := rel[i][j][k][1];
                     rel_pcp[help+2] := rel[i][j][k][2];
                  else word := EvaluatePPowerPoly( rel[i][j][k][2], x );
                     if rel[i][j][k][1] <= n+d then
                        word := word mod rel_ord;
                        if word <> 0 then
                           rel_pcp[help+1] := rel[i][j][k][1];
                           rel_pcp[help+2] := word;
                        fi;
                     else word := word mod rel_ordC[rel[i][j][k][1]-n-d];
                        if word <> 0 then
                           rel_pcp[help+1] := rel[i][j][k][1];
                           rel_pcp[help+2] := word;
                        fi;
                     fi;
                  fi;
               od;
               SetConjugate( coll, i, j, rel_pcp );
            fi;
         od;
      od;
      for i in [1..d] do
         for j in [1..n+i-1] do
            if rel[n+i][j] <> [[n+i,Zero0]] then
               rel_pcp := [];
               for k in [1..Length(rel[n+i][j])] do
                  help := Length( rel_pcp );
                  if rel[n+i][j][k][1] <= n then
                     rel_pcp[help+1] := rel[n+i][j][k][1];
                     rel_pcp[help+2] := rel[n+i][j][k][2];
                  else word := EvaluatePPowerPoly( rel[n+i][j][k][2], x );
                     if rel[n+i][j][k][1] <= n+d then
                        word := word mod rel_ord;
                        if word <> 0 then
                           rel_pcp[help+1] := rel[n+i][j][k][1];
                           rel_pcp[help+2] := word;
                        fi;
                     else word := word mod rel_ordC[rel[n+i][j][k][1]-n-d];
                        if word <> 0 then
                           rel_pcp[help+1] := rel[n+i][j][k][1];
                           rel_pcp[help+2] := word;
                        fi;
                     fi;
                  fi;
               od;
               SetConjugate( coll, n+i, j, rel_pcp );
            fi;
         od;
      od;

      UpdatePolycyclicCollector( coll );
      G := PcpGroupByCollector( coll );

      return G;
   end);

###############################################################################
##
## GetPcpGroupPPowerPoly( H, x )
##
## Input: p-power-poly-pcp-groups H and an integer x
##
## Ouput: a pcp-group which corresponds to H evaluated at x
##
InstallMethod( GetPcpGroupPPowerPoly, 
   "take rels of Schur extension and get a pcp-presentation for this",
   [ IsPPPPcpGroups, IsInt ],
   function( H, x )
      local ParPres;

      ParPres := rec( prime := H!.prime );
      ParPres!.rel := H!.rel;
      ParPres!.n := H!.n;
      ParPres!.d := H!.d;
      ParPres!.m := H!.m;
      ParPres!.expo := H!.expo;
      ParPres!.expo_vec := H!.expo_vec;
      ParPres!.cc := H!.cc;
      ParPres!.name := H!.name;

      return GetPcpGroupPPowerPoly( ParPres, x );
   end);

#E RelGroups.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
