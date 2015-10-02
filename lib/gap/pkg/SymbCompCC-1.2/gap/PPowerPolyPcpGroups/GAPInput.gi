###############################################################################
##
#F GAPInput.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
#M  GAPInputPPPPcpGroups( file, grp_pres )
##
## Input: a string file and p-power-poly-pcp-groups grp_pres
##
## Output: the function writes the p-power-poly pcp-groups presentations 
##         grp_pres to a file that is readable for GAP
##
InstallMethod( GAPInputPPPPcpGroups,[IsString,IsPPPPcpGroups],0,
   function( file, grp_pres )
      local p, i, j, k, rel, cc, expo, expo_vec, One1, Zero0;

      ## Initialize
      p := grp_pres!.prime;
      rel := grp_pres!.rel;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;
      cc := grp_pres!.cc;
      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## Print One1 and Zero0 to file
      PrintTo( file, "One1 := Int2PPowerPoly( ", p, ", 1 );\n" );
      AppendTo( file, "Zero0 := Int2PPowerPoly( ", p, ", 0 );\n\n" );

      ## start with appending presentations to file
      AppendTo( file, grp_pres!.name, " := rec( \n" );

      ## rel
      AppendTo( file, "rel := [ " );
      for i in [1..Length( rel )] do
         AppendTo( file, "[ " );
         for j in [1..Length( rel[i] )] do
            AppendTo( file, "[ " );
            for k in [1..Length( rel[i][j] )] do
               AppendTo( file, "[ ", rel[i][j][k][1], ", " );
               if IsInt( rel[i][j][k][2] ) then
                  AppendTo( file, rel[i][j][k][2] );
               elif PPP_Equal( rel[i][j][k][2], One1 ) then
                  AppendTo( file, "One1" );
               elif PPP_Equal( rel[i][j][k][2], Zero0 ) then
                  AppendTo( file, "Zero0" );
               else AppendTo( file, "[ ", p, ", " );
                  AppendTo( file, rel[i][j][k][2][2], "]" );
               fi;
               AppendTo( file, " ]" );
               if k < Length( rel[i][j] ) then
                  AppendTo( file, ", " );
               fi;
            od;
            AppendTo( file, " ]" );
            if j < Length( rel[i] ) then
               AppendTo( file, ", " );
            fi;
         od;
         AppendTo( file, " ]" );
         if i < Length( rel ) then
            AppendTo( file, ", " );
         fi;
      od;
      AppendTo( file, " ], \n" );
 
      ## expo
      AppendTo( file, "expo := [ ", p, ", " );
      AppendTo( file, expo[2], " ], \n" );

      ## n
      AppendTo( file, "n := ", grp_pres!.n, ",\n" );

      ## d
      AppendTo( file, "d := ", grp_pres!.d, ",\n" );

      ## m
      AppendTo( file, "m := ", grp_pres!.m, ",\n" );

      ## prime
      AppendTo( file, "prime := ", p, ",\n" );

      ## coclass
      AppendTo( file, "cc := ", cc, ",\n" );

      ## expo_vec
      AppendTo( file, "expo_vec := [" );
      for i in [1..grp_pres!.m] do
         if PPP_Equal( expo_vec[i], One1 ) then
            AppendTo( file, "One1" );
         else AppendTo( file, "[ ", p, ", " );
            AppendTo( file, expo_vec[i][2], " ]" );
         fi;
         if i <> grp_pres!.m then
            AppendTo( file, ", " );
         fi;
      od;
      AppendTo( file, " ], \n" );
      ## name
      AppendTo( file, "name := \"", grp_pres!.name, "\"\n);\n" );

   end);

###############################################################################
##
#M  GAPInputPPPPcpGroups( file, record )
##
## Input: a string file and p-power-poly-pcp-groups presented by the record
##        record
##
## Output: the function writes the p-power-poly pcp-groups presentations 
##         grp_pres to a file that is readable for GAP
##
InstallMethod( GAPInputPPPPcpGroups, true, [ IsString, IsRecord ], 0,
   function( file, record )
      local G;

      G := PPPPcpGroupsNC( record );
      GAPInputPPPPcpGroups( file, G );

   end);

###############################################################################
##
#M  GAPInputPPPPcpGroupsAppend( grp_pres )
##
## Input: a string file and p-power-poly-pcp-groups grp_pres
##
## Output: the function appends the p-power-poly pcp-groups presentations 
##         grp_pres to a file that is readable for GAP
##
InstallMethod(GAPInputPPPPcpGroupsAppend,[IsString,IsPPPPcpGroups], 0,
   function( file, grp_pres )
      local p, i, j, k, rel, cc, expo, expo_vec, One1, Zero0;

      ## Initialize
      p := grp_pres!.prime;
      rel := grp_pres!.rel;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;
      cc := grp_pres!.cc;
      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## Print One1 and Zero0 to file
      AppendTo( file, "One1 := Int2PPowerPoly( ", p, ", 1 );\n" );
      AppendTo( file, "Zero0 := Int2PPowerPoly( ", p, ", 0 );\n\n" );

      ## start with appending presentations to file
      AppendTo( file, grp_pres!.name, " := rec( \n" );

      ## rel
      AppendTo( file, "rel := [ " );
      for i in [1..Length( rel )] do
         AppendTo( file, "[ " );
         for j in [1..Length( rel[i] )] do
            AppendTo( file, "[ " );
            for k in [1..Length( rel[i][j] )] do
               AppendTo( file, "[ ", rel[i][j][k][1], ", " );
               if IsInt( rel[i][j][k][2] ) then
                  AppendTo( file, rel[i][j][k][2] );
               elif PPP_Equal( rel[i][j][k][2], One1 ) then
                  AppendTo( file, "One1" );
               elif PPP_Equal( rel[i][j][k][2], Zero0 ) then
                  AppendTo( file, "Zero0" );
               else AppendTo( file, "[ ", p, ", " );
                  AppendTo( file, rel[i][j][k][2][2], " ]" );
               fi;
               AppendTo( file, " ]" );
               if k < Length( rel[i][j] ) then
                  AppendTo( file, ", " );
               fi;
            od;
            AppendTo( file, " ]" );
            if j < Length( rel[i] ) then
               AppendTo( file, ", " );
            fi;
         od;
         AppendTo( file, " ]" );
         if i < Length( rel ) then
            AppendTo( file, ", " );
         fi;
      od;
      AppendTo( file, " ], \n" );
 
      ## expo
      AppendTo( file, "expo := PPowerPoly( ", p, ", " );
      AppendTo( file, expo!.coeffs, " ), \n" );

      ## n
      AppendTo( file, "n := ", grp_pres!.n, ",\n" );

      ## d
      AppendTo( file, "d := ", grp_pres!.d, ",\n" );

      ## m
      AppendTo( file, "m := ", grp_pres!.m, ",\n" );

      ## prime
      AppendTo( file, "prime := ", p, ",\n" );

      ## coclass
      AppendTo( file, "cc := ", cc, ",\n" );

      ## expo_vec
      AppendTo( file, "expo_vec := [" );
      for i in [1..grp_pres!.m] do
         if PPP_Equal( expo_vec[i], One1 ) then
            AppendTo( file, "One1" );
         else AppendTo( file, "[ ", p, ", " );
            AppendTo( file, expo_vec[i][2], " ]" );
         fi;
         if i <> grp_pres!.m then
            AppendTo( file, ", " );
         fi;
      od;
      AppendTo( file, " ], \n" );
      ## name
      AppendTo( file, "name := \"", grp_pres!.name, "\"\n);\n" );

   end);

###############################################################################
##
#M  GAPInputPPPPcpGroupsAppend( file, record )
##
## Input: a string file and p-power-poly-pcp-groups presented by the record
##        record
##
## Output: the function appends the p-power-poly pcp-groups presentations 
##         grp_pres to a file that is readable for GAP
##
InstallMethod( GAPInputPPPPcpGroupsAppend,[IsString,IsRecord], 0,
   function( file, record )
      local G;

      G := PPPPcpGroupsNC( record );
      GAPInputPPPPcpGroupsAppend( file, G );

   end);

#E GAPInput.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
