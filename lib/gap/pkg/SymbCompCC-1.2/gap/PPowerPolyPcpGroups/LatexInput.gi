###############################################################################
##
#F LatexInput.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
#M  LatexInputPPPPcpGroups( file, grp_pres )
##
## Input: a string file, which is a file-name, and p-power-poly-pcp-groups
##        grp_pres
##
## Output: the function writes the presentations for grp_pres to file in latex
##         code in short form
##
InstallMethod( LatexInputPPPPcpGroups,[IsString,IsPPPPcpGroups],0,
   function( file, grp_pres )
      local p, n, d, m, rel, expo, expo_vec, name, i, j, k, One1, Zero0, 
            first_rel_done;

      ## Initialize
      p := grp_pres!.prime;
      n := grp_pres!.n;
      d := grp_pres!.d;
      m := grp_pres!.m;
      rel := grp_pres!.rel;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;
      name := grp_pres!.name;

      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## Start the file
      PrintTo( file, "\\begin{eqnarray*}\n" );
      AppendTo( file, name, " = \\langle \\; " );
      ## catch trivial group
      if n = 0 and d = 0 and m = 0 then
         AppendTo( file, "\\rangle\n\\end{eqnarray*}" );
      else
         ## print the g's
         if n > 0 then
            AppendTo( file, "g_1" );
            if n = 2 then 
               AppendTo( file, ",g_2" );
            elif n > 2 then
               AppendTo( file, ", \\ldots, g_", n );
            fi;
         fi;
         ## print the t's
         if d > 0 then
            if n > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "t_1" );
            if d = 2 then 
               AppendTo( file, ",t_2" );
            elif d > 2 then
               AppendTo( file, ", \\ldots, t_", d );
            fi;
         fi;
         ## print the c's
         if m > 0 then
            if n > 0 or d > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "c_1" );
            if m = 2 then 
               AppendTo( file, ",c_2" );
            elif m > 2 then
               AppendTo( file, ", \\ldots, c_", m );
            fi;
         fi;

         first_rel_done := false;
         ## middle slash and relations
         AppendTo( file, "& | &" );
         for i in [1..n+m+d] do
            ## conjugating relations
            for j in [1..i-1] do
               ## conjugating g -> only conjugating with lower g's
               if i <= n then
                  if rel[i][j] <> [[i,1]] then
                     if first_rel_done then
                        AppendTo( file, ",\\\\\n & & " );
                     else first_rel_done := true;
                     fi;
                     AppendTo( file, "g_", i, "\^{g_", j, "} = " );
                     for k in [1..Length( rel[i][j] )] do
                        if rel[i][j][k][1] <= n then
                           AppendTo( file, "g_", rel[i][j][k][1] );
                           if rel[i][j][k][2] <> 1 then
                              AppendTo( file, "^{", rel[i][j][k][2], "}" );
                           fi;
                        elif rel[i][j][k][1] <= n+d then
                           AppendTo( file, "t_", rel[i][j][k][1]-n );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        fi;
                     od;
                  fi;
               ## conjugating t's with g's and lower t's
               elif i <= n+d then
                  if rel[i][j][1][1] <> i and not PPP_Equal( rel[i][j][1][2], One1 ) then
                     if first_rel_done then
                        AppendTo( file, ",\\\\\n & & " );
                     else first_rel_done := true;
                     fi;
                     AppendTo( file, "t_", i-n );
                     if j <= n then
                        AppendTo( file, "\^{g_", j, "} = " );
                     else AppendTo( file, "\^{t_", j-n, "} = " );
                     fi;
                     for k in [1..Length( rel[i][j] )] do
                        if rel[i][j][k][1] <= n then
                           AppendTo( file, "g_", rel[i][j][k][1] );
                           if rel[i][j][k][2] <> 1 then
                              AppendTo( file, "^{", rel[i][j][k][2], "}" );
                           fi;
                        elif rel[i][j][k][1] <= n+d then
                           AppendTo( file, "t_", rel[i][j][k][1]-n );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        fi;
                     od;
                  fi;
                  ## c's are central thus no conjugating relation
               fi;
            od;
            ## power relations
            ## g's powers
            if i <= n then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "g_", i, "^{", p, "} = " );
               if rel[i][i] = [[i,0]] then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     if rel[i][i][k][1] <= n then
                        AppendTo( file, "g_", rel[i][i][k][1] );
                        if rel[i][i][k][2] <> 1 then
                           AppendTo( file, "^{", rel[i][i][k][2], "}" );
                        fi;
                     elif rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     fi;
                  od;
               fi;
            ## t's powers
            elif i <= n+d then 
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "t_", i-n, "^{" );
               AppendPPP( file, expo );
               AppendTo( file, "} = " );
               if rel[i][i][1][1] = i and PPP_Equal( rel[i][i][1][2], Zero0 ) then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     ## relations do not contain g's
                     if rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                       fi;
                     fi;
                  od;
               fi;
            elif not PPP_Equal( expo_vec[i-n-d], Zero0 ) then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "c_", i-n-d, "^{" );
               AppendPPP( file, expo_vec[i-n-d] );
               AppendTo( file, "} = " );
               AppendTo( file, "1" );
            fi;
         od;
         AppendTo( file, "\\; \\rangle\n\\end{eqnarray*}\n" );
      fi;

   end);

###############################################################################
##
#M  LatexInputPPPPcpGroups( record )
##
## Input: a string file, which is a file-name, and a record record, which
##        represents p-power-poly-pcp-groups
##
## Output: the function writes the presentations of record to file in latex
##         code in short form
##
InstallMethod( LatexInputPPPPcpGroups, true, [ IsString, IsRecord ], 0,
   function( file, record )
      local G;

      G := PPPPcpGroupsNC( record );
      LatexInputPPPPcpGroups( file, G );

   end);

###############################################################################
##
#M  LatexInputPPPPcpGroupsAppend( file, grp_pres )
##
## Input: a string file, which is a file-name, and p-power-poly-pcp-groups
##        grp_pres
##
## Output: the function appends the presentations for grp_pres to file in latex
##         code in short form
##
InstallMethod(LatexInputPPPPcpGroupsAppend,true,[IsString,IsPPPPcpGroups],0,
   function( file, grp_pres )
      local p, n, d, m, rel, expo, expo_vec, name, i, j, k, One1, Zero0, 
            first_rel_done;

      ## Initialize
      p := grp_pres!.prime;
      n := grp_pres!.n;
      d := grp_pres!.d;
      m := grp_pres!.m;
      rel := grp_pres!.rel;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;
      name := grp_pres!.name;

      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## Start the file
      AppendTo( file, "\\begin{eqnarray*}\n" );
      AppendTo( file, name, " = \\langle \\; " );
      ## catch trivial group
      if n = 0 and d = 0 and m = 0 then
         AppendTo( file, "\\rangle\n\\end{eqnarray*}" );
      else
         ## print the g's
         if n > 0 then
            AppendTo( file, "g_1" );
            if n = 2 then 
               AppendTo( file, ",g_2" );
            elif n > 2 then
               AppendTo( file, ", \\ldots, g_", n );
            fi;
         fi;
         ## print the t's
         if d > 0 then
            if n > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "t_1" );
            if d = 2 then 
               AppendTo( file, ",t_2" );
            elif d > 2 then
               AppendTo( file, ", \\ldots, t_", d );
            fi;
         fi;
         ## print the c's
         if m > 0 then
            if n > 0 or d > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "c_1" );
            if m = 2 then 
               AppendTo( file, ",c_2" );
            elif m > 2 then
               AppendTo( file, ", \\ldots, c_", m );
            fi;
         fi;

         first_rel_done := false;
         ## middle slash and relations
         AppendTo( file, "& | &" );
         for i in [1..n+m+d] do
            ## conjugating relations
            for j in [1..i-1] do
               ## conjugating g -> only conjugating with lower g's
               if i <= n then
                  if rel[i][j] <> [[i,1]] then
                     if first_rel_done then
                        AppendTo( file, ",\\\\\n & & " );
                     else first_rel_done := true;
                     fi;
                     AppendTo( file, "g_", i, "\^{g_", j, "} = " );
                     for k in [1..Length( rel[i][j] )] do
                        if rel[i][j][k][1] <= n then
                           AppendTo( file, "g_", rel[i][j][k][1] );
                           if rel[i][j][k][2] <> 1 then
                              AppendTo( file, "^{", rel[i][j][k][2], "}" );
                           fi;
                        elif rel[i][j][k][1] <= n+d then
                           AppendTo( file, "t_", rel[i][j][k][1]-n );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                           if PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        fi;
                     od;
                  fi;
               ## conjugating t's with g's and lower t's
               elif i <= n+d then
                  if rel[i][j][1][1] <> i and not PPP_Equal( rel[i][j][1][2], One1 ) then
                     if first_rel_done then
                        AppendTo( file, ",\\\\\n & & " );
                     else first_rel_done := true;
                     fi;
                     AppendTo( file, "t_", i-n );
                     if j <= n then
                        AppendTo( file, "\^{g_", j, "} = " );
                     else AppendTo( file, "\^{t_", j-n, "} = " );
                     fi;
                     for k in [1..Length( rel[i][j] )] do
                        if rel[i][j][k][1] <= n then
                           AppendTo( file, "g_", rel[i][j][k][1] );
                           if rel[i][j][k][2] <> 1 then
                              AppendTo( file, "^{", rel[i][j][k][2], "}" );
                           fi;
                        elif rel[i][j][k][1] <= n+d then
                           AppendTo( file, "t_", rel[i][j][k][1]-n );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                           if not PPP_Equal( rel[i][j][k][2], One1 ) then
                              AppendTo( file, "^{" );
                              AppendPPP( file, rel[i][j][k][2] );
                              AppendTo( file, "}" );
                           fi;
                        fi;
                     od;
                  fi;
                  ## c's are central thus no conjugating relation
               fi;
            od;
            ## power relations
            ## g's powers
            if i <= n then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "g_", i, "^{", p, "} = " );
               if rel[i][i] = [[i,0]] then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     if rel[i][i][k][1] <= n then
                        AppendTo( file, "g_", rel[i][i][k][1] );
                        if rel[i][i][k][2] <> 1 then
                           AppendTo( file, "^{", rel[i][i][k][2], "}" );
                        fi;
                     elif rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     fi;
                  od;
               fi;
            ## t's powers
            elif i <= n+d then 
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "t_", i-n, "^{" );
               AppendPPP( file, expo );
               AppendTo( file, "} = " );
               if rel[i][i][1][1] = i and PPP_Equal( rel[i][i][1][2], Zero0 ) then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     ## relations do not contain g's
                     if rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                       fi;
                     fi;
                  od;
               fi;
            elif not PPP_Equal( expo_vec[i-n-d], Zero0 ) then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "c_", i-n-d, "^{" );
               AppendPPP( file, expo_vec[i-n-d] );
               AppendTo( file, "} = " );
               AppendTo( file, "1" );
            fi;
         od;
         AppendTo( file, "\\; \\rangle\n\\end{eqnarray*}\n" );
      fi;

   end);

###############################################################################
##
#M  LatexInputPPPPcpGroupsAppend( file, record )
##
## Input: a string file, which is a file-name, and a record record, which
##        represents p-power-poly-pcp-groups
##
## Output: the function appends the presentations of record to file in latex
##         code in short form
##
InstallMethod( LatexInputPPPPcpGroupsAppend,true,[IsString,IsRecord],0,
   function( file, record )
      local G;

      G := PPPPcpGroupsNC( record );
      LatexInputPPPPcpGroupsAppend( file, G );

   end);

###############################################################################
##
#M  LatexInputPPPPcpGroupsAllAppend( file, grp_pres )
##
## Input: a string file, which is a file-name, and p-power-poly-pcp-groups
##        grp_pres
##
## Output: the function appends the presentations for grp_pres to file in latex
##         code (all relations)
##
InstallMethod(LatexInputPPPPcpGroupsAllAppend,true,[IsString,IsPPPPcpGroups],0,
   function( file, grp_pres )
      local p, n, d, m, rel, expo, expo_vec, name, i, j, k, One1, Zero0, 
            first_rel_done;

      ## Initialize
      p := grp_pres!.prime;
      n := grp_pres!.n;
      d := grp_pres!.d;
      m := grp_pres!.m;
      rel := grp_pres!.rel;
      expo := grp_pres!.expo;
      expo_vec := grp_pres!.expo_vec;
      name := grp_pres!.name;

      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## Start the file
      AppendTo( file, "\\begin{eqnarray*}\n" );
      AppendTo( file, name, " = \\langle \\; " );
      ## catch trivial group
      if n = 0 and d = 0 and m = 0 then
         AppendTo( file, "\\rangle\n\\end{eqnarray*}" );
      else
         ## print the g's
         if n > 0 then
            AppendTo( file, "g_1" );
            if n = 2 then 
               AppendTo( file, ",g_2" );
            elif n > 2 then
               AppendTo( file, ", \\ldots, g_", n );
            fi;
         fi;
         ## print the t's
         if d > 0 then
            if n > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "t_1" );
            if d = 2 then 
               AppendTo( file, ",t_2" );
            elif d > 2 then
               AppendTo( file, ", \\ldots, t_", d );
            fi;
         fi;
         ## print the c's
         if m > 0 then
            if n > 0 or d > 0 then
               AppendTo( file, "," );
            fi;
            AppendTo( file, "c_1" );
            if m = 2 then 
               AppendTo( file, ",c_2" );
            elif m > 2 then
               AppendTo( file, ", \\ldots, c_", m );
            fi;
         fi;

         first_rel_done := false;
         ## middle slash and relations
         AppendTo( file, "& | &" );
         for i in [1..n+m+d] do
            ## conjugating relations
            for j in [1..i-1] do
               ## conjugating g -> only conjugating with lower g's
               if i <= n then
                  if first_rel_done then
                     AppendTo( file, ",\\\\\n & & " );
                  else first_rel_done := true;
                  fi;
                  AppendTo( file, "g_", i, "\^{g_", j, "} = " );
                  for k in [1..Length( rel[i][j] )] do
                     if rel[i][j][k][1] <= n then
                        AppendTo( file, "g_", rel[i][j][k][1] );
                        if rel[i][j][k][2] <> 1 then
                           AppendTo( file, "^{", rel[i][j][k][2], "}" );
                        fi;
                     elif rel[i][j][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][j][k][1]-n );
                        if not PPP_Equal( rel[i][j][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][j][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                       if not PPP_Equal( rel[i][j][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][j][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     fi;
                  od;
               ## conjugating t's with g's and lower t's
               elif i <= n+d then
                  if first_rel_done then
                     AppendTo( file, ",\\\\\n & & " );
                  else first_rel_done := true;
                  fi;
                  AppendTo( file, "t_", i-n );
                  if j <= n then
                     AppendTo( file, "\^{g_", j, "} = " );
                  else AppendTo( file, "\^{t_", j-n, "} = " );
                  fi;
                  for k in [1..Length( rel[i][j] )] do
                     if rel[i][j][k][1] <= n then
                        AppendTo( file, "g_", rel[i][j][k][1] );
                        if rel[i][j][k][2] <> 1 then
                           AppendTo( file, "^{", rel[i][j][k][2], "}" );
                        fi;
                     elif rel[i][j][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][j][k][1]-n );
                        if not PPP_Equal( rel[i][j][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][j][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][j][k][1]-n-d );
                       if not PPP_Equal( rel[i][j][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][j][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     fi;
                  od;
               ## c's are central thus no conjugating relation
               ## last line c's are central
               fi;
            od;
            ## power relations
            ## g's powers
            if i <= n then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "g_", i, "^{", p, "} = " );
               if rel[i][i] = [[i,0]] then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     if rel[i][i][k][1] <= n then
                        AppendTo( file, "g_", rel[i][i][k][1] );
                        if rel[i][i][k][2] <> 1 then
                           AppendTo( file, "^{", rel[i][i][k][2], "}" );
                        fi;
                     elif rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     fi;
                  od;
               fi;
            ## t's powers
            elif i <= n+d then 
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "t_", i-n, "^{" );
               AppendPPP( file, expo );
               AppendTo( file, "} = " );
               if rel[i][i][1][1] = i and PPP_Equal( rel[i][i][1][2], Zero0 ) then
                  AppendTo( file, "1" );
               else
                  for k in [1..Length( rel[i][i] )] do
                     ## relations do not contain g's
                     if rel[i][i][k][1] <= n+d then
                        AppendTo( file, "t_", rel[i][i][k][1]-n );
                        if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                        fi;
                     else AppendTo( file, "c_", rel[i][i][k][1]-n-d );
                       if not PPP_Equal( rel[i][i][k][2], One1 ) then
                           AppendTo( file, "^{" );
                           AppendPPP( file, rel[i][i][k][2] );
                           AppendTo( file, "}" );
                       fi;
                     fi;
                  od;
               fi;
            elif not PPP_Equal( expo_vec[i-n-d], Zero0 ) then
               if first_rel_done then
                  AppendTo( file, ",\\\\\n & & " );
               else first_rel_done := true;
               fi;
               AppendTo( file, "c_", i-n-d, "^{" );
               AppendPPP( file, expo_vec[i-n-d] );
               AppendTo( file, "} = " );
               AppendTo( file, "1" );
            fi;
         od;
         if m > 0 then
            AppendTo( file, ",\\\\\n & & c_i \\mbox{ are central for } 1 \\le i \\le");
            AppendTo( file, m );
         fi;
         AppendTo( file, "\\; \\rangle\n\\end{eqnarray*}\n" );
      fi;

   end
);

###############################################################################
##
#M  LatexInputPPPPcpGroupsAllAppend( file, record )
##
## Input: a string file, which is a file-name, and a record record, which
##        represents p-power-poly-pcp-groups
##
## Output: the function appends the presentations of record to file in latex
##         code (all relations)
##
InstallMethod( LatexInputPPPPcpGroupsAllAppend, true, [ IsString, IsRecord ], 0, 
   function( file, record )
      local G;

      G := PPPPcpGroupsNC( record );
      LatexInputPPPPcpGroupsAllAppend( file, G );

   end);

###############################################################################
##
#M AppendPPP( file, el )
##
## Input: a sting file and a p-power-poly element el
##
## Output: the function appends the p-power-poly element to file in latex code
##
InstallMethod( AppendPPP, true, [ IsString, IsList ], 0,
   function( file, obj )
      local p, c, l_c, strg, i, j, One1, start;

       p := obj[1];
       c := obj[2];
       One1 := Int2PPowerPoly( p, 1 );

       ## check for trivial cases
       if c = [] then 
          AppendTo( file, "0" );
       elif PPP_Equal( obj, One1 ) then
          AppendTo( file, "1" );
       ## start appending
       else strg := "";
          l_c := Length( c );

          start := false;

          ## append p^(0x)-part
          if c[1] <> 0 then
             Append( strg, String( c[1] ) );
             start := true;
          fi;

          ## append p^x-part
          if l_c > 1 then
             if c[2] < 0 then
                if c[2] = -1 then
                   Append( strg, "-" );
                else   Append( strg, String( c[2] ) );
                   Append( strg, "\\cdot" ); 
                fi;
                Append( strg, String( p ) );
                Append( strg, "^x" );
                start := true;
             elif c[2] > 0 then
                if start then
                   Append( strg, "+" );
                fi;
                if c[2] <> 1 then
                   Append( strg, String( c[2] ) );
                   Append( strg, "\\cdot" );
                fi;
                Append( strg, String( p ) );
                Append( strg, "^x" );
                start := true;
             fi;
          fi;

          ## append rest
          for i in [3..l_c] do
             if c[i] < 0 then
                if c[i] = -1 then
                   Append( strg, "-" );
                else Append( strg, String( c[i] ) );
                   Append( strg, "\\cdot" );
                fi;
                Append( strg, String( p ) );
                Append( strg, "^{" );
                Append( strg, String( i ) );
                Append( strg, "x}" );
                start := true;
             elif c[i] > 0 then
                if start then
                   Append( strg, "+" );
                fi;
                if c[i] <> 1 then
                   Append( strg, String( c[i] ) );
                   Append( strg, "\\cdot" );
                fi;
                Append( strg, String( p ) );
                Append( strg, "^{" );
                Append( strg, String( i ) );
                Append( strg, "x}" );
                start := true;
             fi;
          od;
       fi;
 
       AppendTo( file, strg );

   end);

#E LatexInput.gi . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
