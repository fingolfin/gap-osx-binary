###############################################################################
##
#F Apps.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## SchurMultiplicatorsStructurePPPPcps( ParPres )
##
## Input: p-power-poly-pcp-groups ParPres
##
## Output: a list, describing the structure of the Schur multiplicators / 
##         multipliers of ParPres
##
InstallMethod(SchurMultiplicatorsStructurePPPPcps,[IsPPPPcpGroups], 
   function( ParPres )
      local p, cc, name, pos, expo_vec, m, SchurMult, l_sm, i, Zero0, S, One1;

      if ParPres!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      p := ParPres!.prime;
      cc := ParPres!.cc;
      name := ParPres!.name;
      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      if p = 2 and cc = 1 then
         pos := Position( ParPresGlobalVar_2_1_Names, name );
         if pos = fail then
            Error( "Wrong name of presentations." );
         fi;
         S := GetMatrixPPowerPolySchurExt( ParPresGlobalVar_2_1[pos] );
         S := PPowerPolyMat2PPowerPolyLocMat( S );
         S := SmithNormalFormPPowerPoly( S );
         expo_vec := [];
         for i in [1..Length( S[1] )] do
            expo_vec[i] := S[i][i]![1];
         od;
         m := Length( expo_vec );
      elif p = 2 and cc = 2 then
         pos := Position( ParPresGlobalVar_2_2_Names, name);
         if pos = fail then
            Error( "Wrong name of presentations." );
         fi;
         S := GetMatrixPPowerPolySchurExt( ParPresGlobalVar_2_2[pos] );
         S := PPowerPolyMat2PPowerPolyLocMat( S );
         S := SmithNormalFormPPowerPoly( S );
         expo_vec := [];
         for i in [1..Length( S[1] )] do
            expo_vec[i] := S[i][i][1];
         od;
         m := Length( expo_vec );
      elif p = 3 and cc = 1 then
         pos := Position( ParPresGlobalVar_3_1_Names, name);
         if pos = fail then
            Error( "Wrong name of presentations." );
         fi;
         S := GetMatrixPPowerPolySchurExt( ParPresGlobalVar_3_1[pos] );
         S := PPowerPolyMat2PPowerPolyLocMat( S );
         S := SmithNormalFormPPowerPoly( S );
         expo_vec := [];
         for i in [1..Length( S[1] )] do
            expo_vec[i] := S[i][i][1];
         od;
         m := Length( expo_vec );
      else Error( "The parameter presentations are not yet in the data base." );
      fi;

      SchurMult := [];
      l_sm := 0;
      for i in [1..m] do
         if not PPP_Equal( expo_vec[i], Zero0 ) and not PPP_Equal( expo_vec[i], One1 ) then
            l_sm := l_sm + 1;
            SchurMult[l_sm] := expo_vec[i];
         fi;
      od;

      return SchurMult;
   end);

###############################################################################
##
## SchurMultiplicator( ParPres )
##
## Input: p-power-poly-pcp-groups ParPres
##
## Output: a list, describing the structure of the Schur multiplicators / 
##         multipliers of ParPres
##
InstallMethod( SchurMultiplicator, true, [ IsPPPPcpGroups ], 0, 
   function( G )
      local SchurMult, SchurMultParPres, Zero0, One1, i, j, rel;

      if G!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ## get the structure describtion of the Schur Multiplier
      SchurMult := SchurMultiplicatorsStructurePPPPcps( G );

      ## initalize
      SchurMultParPres := rec( prime := G!.prime );
      SchurMultParPres!.n := 0; 
      SchurMultParPres!.d := 0;
      SchurMultParPres!.m := Length( SchurMult ); 
      SchurMultParPres!.cc := fail;
      SchurMultParPres!.expo := 1;
      SchurMultParPres!.expo_vec := SchurMult;
      SchurMultParPres!.name := Concatenation( "SchurMult", G!.name );

      ## get the relations
      Zero0 := Int2PPowerPoly( G!.prime, 0 );
      One1 := Int2PPowerPoly( G!.prime, 1 );
      rel := [];
      for i in [1..Length( SchurMult )] do
         rel[i] := [];
         for j in [1..i-1] do
            rel[i][j] := [[ j, One1 ]];
         od;
         rel[i][i] := [[ i, Zero0 ]];
      od;
      SchurMultParPres!.rel := rel;

      return PPPPcpGroups( SchurMultParPres );
   end);

#E Apps.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
