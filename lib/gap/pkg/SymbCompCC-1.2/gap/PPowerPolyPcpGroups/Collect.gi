###############################################################################
##
#F Collect.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## G = <h_1, ..., h_n+d+m> = <g_1, .., g_n, t_1, .., t_d, c_1, .., c_m>
## words: [[i_1,f_1],.., [i_j, f_j]], wobei i_1, .., i_j in [1..n+d+m] und
##        f_k in Z, falls i_k <= n, sonst in Q_p^0[p^x]
## relations: c_i are central
##            rel[i][j] gives the relation h_i^h_j, where j<i
##            rel[i][i] gives the power relation of h_i
##

###############################################################################
##
## Reduce_ci_ppowerpolypcp( c_i_in, div_i_in, i, expo_vec )
##
## [ IsPPowerPoly, IsPosInt, IsPosInt, IsList ]
##
## Comment: technical function (reduce c)
##
InstallGlobalFunction( Reduce_ci_ppowerpolypcp, 
   function( c_i_in, div_i_in, i, expo_vec )
      local Zero0, c_i, div_i, list, p, div, help;

      Zero0 := PPP_ZeroNC( c_i_in );
      p := Zero0[1];

      c_i := StructuralCopy( c_i_in );
      div_i := StructuralCopy( div_i_in );

      ## check if c_i >= expo_vec[i] if so then reduce
      if not PPP_Equal( expo_vec[i], Zero0 ) and ( not PPP_Smaller( c_i, expo_vec[i] ) or not PPP_Smaller( PPP_AdditiveInverse( c_i ), expo_vec[i] ) ) then
         list := PPP_QuotientRemainder( c_i, expo_vec[i], false );
         c_i := list[2];

         ## if div_i <> 1 then test if list[2] is integer
         if div_i <> 1 then 
            if Length( c_i[2] ) = 1 then
               ## c_i is an integer, doesn't depend on x -> can divide by div_i
               help := EvaluatePPowerPoly( c_i , 1 );
               if (help mod div_i) <> 0 then
                  Error( "Something went wrong with dividing by 2." );
               else 
                  help := help / div_i;
                  c_i := Int2PPowerPoly( p, help );
                  div_i := 1;
               fi;
            fi;
         fi;

         ## check that c_i is positive
         if PPP_Smaller( c_i, Zero0 ) then
            c_i := PPP_Add( c_i, expo_vec[i] );
         fi;

         return [c_i, div_i];
      else 
         ## check if we can divide
         if not PPP_Equal( expo_vec[i], Zero0 ) and div_i <> 1 then
            list := PPP_QuotientRemainder( c_i, expo_vec[i], false );
            c_i := list[2];

            if Length( c_i[2] ) = 1 then
               ## c_i is an integer, doesn't depend on x -> can divide by div_i
               help := EvaluatePPowerPoly( c_i , 1 );
               if (help mod div_i) <> 0 then
                  Error( "Something went wrong with dividing by 2." );
               else 
                  help := help / div_i;
                  c_i := Int2PPowerPoly( p, help );
                  div_i := 1;
               fi;
            fi;
         fi;

         return [c_i,div_i];
      fi;
   end);

###############################################################################
##
## Add_ci_c_ppowerpolypcp( i, c_i, c_j, div_i, div_j, expo_vec )
##
## [ IsPosInt, IsPPowerPoly, IsPPowerPoly, IsPosInt, IsPosInt, IsList ]
##
## Comment: technical function (add tails, paying attention to div)
##
InstallGlobalFunction( Add_ci_c_ppowerpolypcp, 
   function( i, c_i, c_j, div_i, div_j, expo_vec )
      local p, c, div_c, elm_i, elm_j, m_i, m_j, list;

      p := c_i[1];

      if p <> c_j[1] then
         Error( "Wrong input, the underlying primes have to be the same." );
      fi;

      ## add and reduce, paying attention to the different possible divs
      ## both divs are 1, so nothing to do
      if (div_i = 1) and (div_j = 1) then
         c := PPP_Add( c_i, c_j );
         div_c := 1;
         list := Reduce_ci_ppowerpolypcp( c, div_c, i, expo_vec );
         c := list[1];
         div_c := list[2];
      elif div_i = 1 then
         ## only one div is 1, so fractional arithmetic
         elm_i := Int2PPowerPoly( p, div_j );
         c := PPP_Add( PPP_Mult(elm_i, c_i ), c_j );
         div_c := div_j;
         list := Reduce_ci_ppowerpolypcp( c, div_c, i, expo_vec );
         c := list[1];
         div_c := list[2];
      elif div_j = 1 then
         ## same as last
         elm_j := Int2PPowerPoly( p, div_i );
         c := PPP_Add( c_i, PPP_Mult(elm_j, c_j ) );
         div_c := div_i;
         list := Reduce_ci_ppowerpolypcp( c, div_c, i, expo_vec );
         c := list[1];
         div_c := list[2];
      else
         ## both divs > 1, so get lcm and use frational arithmetic
         div_c := LcmInt( div_i, div_j );
         m_i := div_c / div_i;
         m_j := div_c / div_j;
         elm_i := Int2PPowerPoly( p, m_i );
         elm_j := Int2PPowerPoly( p, m_j );
         c := PPP_Add( PPP_Mult(elm_i, c_i ), PPP_Mult(elm_j, c_j ) );
         list := Reduce_ci_ppowerpolypcp( c, div_c, i, expo_vec );
         c := list[1];
         div_c := list[2];
      fi;
   
      return [ c, div_c ];
   end);

###############################################################################
##
## Mult_ci_c_ppowerpolypcp( i, c_i, c_j, div_i, div_j, expo_vec )
##
## [ IsPosInt, IsPPowerPoly, IsPPowerPoly, IsInt, IsInt, IsList ]
##
## Comment: technical function (multiply tails, paying attention to *.div)
##
InstallGlobalFunction( Mult_ci_c_ppowerpolypcp,
   function( i, c_i, c_j, div_i, div_j, expo_vec )
      local p, c, div_c, list;

      p := c_i[1];

      if p <> c_j[1] then 
         Error( "Wrong input, the underlying primes have to be the same." );
      fi;

      ## multiply
      c := PPP_Mult( c_i, c_j );
      div_c := div_i * div_j;
      ## reduce c
      list := Reduce_ci_ppowerpolypcp( c, div_c, i, expo_vec );
      c := list[1];
      div_c := list[2];

      return [ c, div_c ];
   end);

###############################################################################
##
## Reduce_word_gi_ppowerpolypcp( word_in, c_in, div_in, ParPres )
##
## [ IsList, IsList, IsList, IsPPPPcpGroups ]
##
## Comment: reduce word * g_u^e
##          note that the word is in collected form until g_u, i.e. 
##          word = [[j,e_j],[u,e]] and j < u
##
InstallGlobalFunction( Reduce_word_gi_ppowerpolypcp,
   function( word_in, c_in, div_in, ParPres )
      local div, word, l_word, stack, l_st, c, p, Zero0, One1, j, k, n, 
            d, rel, new_word, pos, i, u, e, help, l_help, list, expo_vec;

      word := StructuralCopy( word_in );
      l_word := Length( word );
      pos := ShallowCopy( l_word );
      div := StructuralCopy( div_in );
      c := StructuralCopy( c_in );
      u := word[pos][1];
      e := word[pos][2];

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      rel := ParPres!.rel;
      expo_vec := ParPres!.expo_vec;

      if u > n then
         Error( "Wrong input." );
      fi;

      stack := [];
      l_st := 0;

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      ## if exponent of g is greater than p, then we  have to reduce g
      if e >= p then
         ## get the relation
         help := MakeMutableCopyListPPP( rel[u][u] );
         l_help := Length( help );
         ## reduce g until exponent is < p
         while e >= p do
            e := e - p;
            ## put relation on stack
            for j in [l_help,l_help-1..1] do
               if help[j][1] > n+d then
                  list := Add_ci_c_ppowerpolypcp( help[j][1]-n-d, c[help[j][1]-n-d], help[j][2], div[help[j][1]-n-d], 1, expo_vec );
                  c[help[j][1]-n-d] := list[1];
                  div[help[j][1]-n-d] := list[2];
               elif help[j][1] > n then
                  if help[j][2] <> Zero0 then
                     l_st := l_st + 1;
                     stack[l_st] := help[j];
                  fi;
               elif help[j][2] <> 0 then
                  for k in [1..help[j][2]] do
                     l_st := l_st + 1;
                     stack[l_st] := [help[j][1],1];
                  od;
               fi;
            od;
         od;
      fi;

      ## check if e = 0, if so delete
      if e = 0 then
         new_word := [];
         for j in [pos-1,pos-2..1] do
            new_word[j] := word[j];
         od;
         word := new_word;
      else word[pos][2] := e;
      fi;

      ## empty stack
      for j in [l_st,l_st-1..1] do
         if stack[j][1] <= n then
            for k in [1..stack[j][2]] do
               list := Collect_word_gi_ppowerpolypcp( word, c, div, stack[j][1], ParPres );
               word := list[1];
               c := list[2];
               div := list[3];
            od;
         else list := Collect_word_ti_ppowerpolypcp( stack[j][1], stack[j][2], word, c, div, ParPres );
            word := list[1];
            c := list[2];
            div := list[3];
         fi;
      od;

      return [ word, c, div ];
   end);

###############################################################################
##
## Collect_word_ti_ppowerpolypcp( i, b, word_in, c_in, div_in, ParPres )
##
## [ IsPosInt, IsPPowerPoly, IsList, IsList, IsList, IsPPPPcpGroups ]
##
## Comment: technical function (collecting word * t_i^b, assuming that 
##          word is collected)
##
InstallGlobalFunction( Collect_word_ti_ppowerpolypcp,
   function( i, b, word_in, c_in, div_in, ParPres )
      local p, m, d, n, rel, expo, expo_vec, c, word, div, Zero0, One1, l_w, 
            tstack, j, l_tst, k, list, help, div_help, l, new_word, new_help;

      word := StructuralCopy( word_in );
      c := StructuralCopy( c_in );
      div := StructuralCopy( div_in );

      p := ParPres!.prime;
      rel := ParPres!.rel;
      expo := ParPres!.expo;
      expo_vec := ParPres!.expo_vec;
      m := ParPres!.m;
      d := ParPres!.d;
      n := ParPres!.n;

      if i <= n or i > n+d then
         Error( "Wrong input." );
      fi;

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      l_tst := 0;
      tstack := [];

      # start at the end of the word and conjugate until position is reached
      l_w := Length( word );
      j := l_w;
      while j > 0 and i < word[j][1] do
         k := word[j][1];
         ## if the word which has to be conjugated is a tail, they commute
         ## add the tails
         if k > n+d then
            list := Add_ci_c_ppowerpolypcp( k-n-d, c[k-n-d], PPP_Mult( b, word[j][2] ), div[k-n-d], div_in[k-n-d], expo_vec );
            c[k-n-d] := list[1];
            div[k-n-d] := list[2];
            l_w := l_w - 1;
         ## case n<word[j][1]<=n+d and word[j][1] and i commute modulo tails
         else l_tst := l_tst + 1; 
            tstack[l_tst] := word[j];
            l_w := l_w - 1;
            help := MakeMutableCopyListPPP( rel[k][i] );
            ## if b <> One1 power
            if not PPP_Equal( b, One1 ) then
               div_help := [];
               for k in [1..m] do
                  div_help[k] := 1;
               od;
               new_help := [];
               ## power the tails in the relation immediately and add to others
               for l in [1..Length( help )] do
                  if help[l][1] > n+d then
                     list := Add_ci_c_ppowerpolypcp( help[l][1]-n-d, c[help[l][1]-n-d], PPP_Mult( word[j][2], PPP_Mult( help[l][2], b ) ), div[help[l][1]-n-d], div_help[help[l][1]-n-d], expo_vec );
                     c[help[l][1]-n-d] := list[1];
                     div[help[l][1]-n-d] := list[2];
                  else new_help[Length(new_help)+1] := help[l];
                  fi;
               od;
               help := StructuralCopy( new_help );
               ## power the t's
               if Length( help ) > 0 then
                  list := Collect_t_y_ppowerpolypcp( new_help,b,c,div_help,ParPres );
                  help := list[1];
                  div_help := list[2];
               fi;
            fi;
            ## using that the t's commute modulo the tails, it follows that 
            ## the relation consists of t_i and tails. Collect the tails
            for l in [2..Length( help )] do
               if not ( IsBound( div_help ) ) then
                  div_help := [];
                  for k in [1..m] do
                     div_help[k] := 1;
                  od;
               fi;
               list := Add_ci_c_ppowerpolypcp( help[l][1]-n-d, c[help[l][1]-n-d], PPP_Mult( help[l][2], word[j][2] ), div[help[l][1]-n-d], div_help[help[l][1]-n-d], expo_vec );
               c[help[l][1]-n-d] := list[1];
               div[help[l][1]-n-d] := list[2];
            od;
         fi;
         j := j - 1;
      od;

      ## if conjugated through then add
      if j > 0 and i = word[j][1] then
         word[j][2] := PPP_Add( word[j][2],  b );
      else j := j + 1;
         l_w := l_w + 1;
         word[j] := [];
         word[j][1] := i;
         word[j][2] := b;
      fi;

      ## reduce t_i, careful this is a recursive call, so only if >= expo
      ## furthermore add the elements from the t-stack
      if not PPP_Smaller( word[j][2], expo ) then
         new_word := [];
         for k in [1..j] do
            new_word[k] := word[k];
         od;
         list := Reduce_word_ti_ppowerpolypcp( new_word, c, div, ParPres );
         word := list[1];
         l_w := Length( word );
         c := list[2];
         div := list[3];
         while l_tst > 0 and l_w > 0 and word[l_w][1] >= tstack[l_tst][1] do
            list := Collect_word_ti_ppowerpolypcp( tstack[l_tst][1], tstack[l_tst][2], word, c, div, ParPres);
            word := list[1];
            l_w := Length( word );
            c := list[2];
            div := list[3];
            l_tst := l_tst - 1;
         od;
      fi;
      ## get the higher t's from the stack
      for k in [l_tst,l_tst-1..1] do
         l_w := l_w + 1;
         word[l_w] := tstack[k];
      od;

      return [ word, c, div ];
   end);

###############################################################################
##
## Reduce_word_ti_ppowerpolypcp( word_in, c_in, div_in, ParPres )
##
## [ IsList, IsList, IsList, IsPPPPcpGroups ]
##
## Comment: technical function (reduce t_i at the last position word
##          note that the word is in collected form until t_i, i.e. 
##          word = [[j,e_j],[i,F]] )
##
InstallGlobalFunction( Reduce_word_ti_ppowerpolypcp,
   function( word_in, c_in, div_in, ParPres )
      local word, c, div, p, n, d, Zero0, list, new_word, i, j, help,  
            pos, expo, expo_vec, rel, quot;

      word := StructuralCopy( word_in );
      c := StructuralCopy( c_in );
      div := StructuralCopy( div_in );

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      rel := ParPres!.rel;
      expo := ParPres!.expo;
      expo_vec := ParPres!.expo_vec;

      pos := Length( word );

      i := word[pos][1];

      if i <= n or i > n+d then
         Error( "Wrong input." );
      fi;
   
      Zero0 := Int2PPowerPoly( p, 0 );

      if not PPP_Smaller( word[pos][2], expo ) then
         ## change the t
         quot := PPP_QuotientRemainder( word[pos][2], expo );
         if PPP_Equal( quot[2], Zero0 ) then
            new_word := [];
            for j in [pos-1,pos-2..1] do
               new_word[j] := word[j];
            od;
            word := new_word;
         else word[pos][2] := StructuralCopy( quot[2] );
         fi;

         ## sort out the tails
         help := MakeMutableCopyListPPP( rel[i][i] );
         if help <> [[i,Zero0]] then
            for j in [1..Length( help )] do
                list := Add_ci_c_ppowerpolypcp( help[j][1]-n-d, c[help[j][1]-n-d], PPP_Mult( quot[1], help[j][2] ), div[help[j][1]-n-d], 1, expo_vec );
                c[help[j][1]-n-d] := list[1];
                div[help[j][1]-n-d] := list[2];
            od;
         fi;
      fi;

      return [ word, c, div ];
   end);

###############################################################################
##
## Collect_t_y_ppowerpolypcp( word_in, y , c_in , div_in, ParPres )
##
## [ IsList, IsPPowerPoly, IsList, IsList, IsPPPPcpGroups ]
##
## Comment: technical function (collecting t^y)
##
InstallGlobalFunction( Collect_t_y_ppowerpolypcp,
   function( word_in, y , c_in , div_in, ParPres )
      local word, c, div, i, j, k, One1, Zero0, pos, elm, test, help, list, 
            help2, help3, new_y, eval, value, coeffs, new_word, p, n, d, 
            expo_vec, rel;

      word := StructuralCopy( word_in );
      c := StructuralCopy( c_in );
      div := StructuralCopy( div_in );

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      expo_vec := ParPres!.expo_vec;
      rel := ParPres!.rel;

      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      if InfoLevel( InfoCollectingPPPPcp ) = 1 then
         Print("\n Doing t_y: word = ", word, " y = ", y, "\n");
      fi;

      ## collect and power the tails 
      new_word := [];
      for i in [1..Length( word )] do
         if word[i][1] > n+d then
            help := Mult_ci_c_ppowerpolypcp( word[i][1]-n-d, y, word[i][2], 1, div[word[i][1]-n-d], expo_vec );
            list := Add_ci_c_ppowerpolypcp( word[i][1]-n-d, help[1], c[word[i][1]-n-d], help[2], div[word[i][1]-n-d], expo_vec );
            c[word[i][1]-n-d] := list[1];
            div[word[i][1]-n-d] := list[2];
         else new_word[Length(new_word)+1] := word[i];
         fi;
      od;
      word := StructuralCopy( new_word );

      ## test whether y is an integer
      test := 0; ## tests whether y is an integer, so if can divide by 2
      if Length( y[2] ) = 1 then
         ## now y is an integer, doesn't depend on m and can divide by 2
         test := 1;
         help := EvaluatePPowerPoly( y , 1 );
         elm := ( help - 1 ) * help / 2;
         elm := Int2PPowerPoly( p, elm );
      fi;
      if test = 0 then
         if p = 2 then
            test := 1;
            help := StructuralCopy( PPP_Subtract( y, One1 ) );
            ## test if elm is even
            eval := 1/2;;
            value := 1;;
            while not IsInt( eval ) do
               eval := EvaluatePPowerPoly( help, value );
               value := value + 1;;
            od;
            if IsEvenInt( eval ) then
               ## divide help by 2
               new_y := y;
               coeffs := StructuralCopy( help[2] );
               for i in [1..Length( coeffs )] do
                  coeffs[i] := coeffs[i] / 2 ;
               od;
               help := PPP_Check( [ p, coeffs ] );
            else ## divide y by 2;
               coeffs := StructuralCopy( y[2] );
               for i in [1..Length( coeffs )] do
                  coeffs[i] := coeffs[i] / 2;
               od;
               new_y := PPP_Check( [ p, coeffs ] );
            fi;
            elm := StructuralCopy( PPP_Mult( help, new_y ) );
         else
            elm := StructuralCopy( PPP_Mult( PPP_Subtract(y, One1 ), y ) );
         fi;
      fi;

      ## collect the tails which arise from commuting the t's
      for i in [1..Length( word )] do
         for j in [i+1,i+2..Length( word )]do
            ## collect the tails
            help2 := PPP_Mult( word[i][2], PPP_Mult( word[j][2], elm ) );
            help := MakeMutableCopyListPPP( rel[word[j][1]][word[i][1]] );
            if help <> [[word[j][1], One1]] then
               for k in [2..Length( help )] do
                  if test = 0 then
                     help3 := Mult_ci_c_ppowerpolypcp( help[k][1]-n-d, help[k][2], help2, 1, 2, expo_vec );
                  else ## test = 1
                     help3 := Mult_ci_c_ppowerpolypcp( help[k][1]-n-d, help[k][2], help2, 1, 1, expo_vec );
                  fi;
                  list := Add_ci_c_ppowerpolypcp( help[k][1]-n-d, c[help[k][1]-n-d], help3[1], div[help[k][1]-n-d], help3[2],expo_vec );
                  c[help[k][1]-n-d] := list[1];
                  div[help[k][1]-n-d] := list[2];
               od;
            fi;
         od;
      od;

      ## collect the t's   
      new_word := [];
      if word <> [] then
         new_word[1] := word[1];
         new_word[1][2] := PPP_Mult( new_word[1][2], y );
         list := Reduce_word_ti_ppowerpolypcp( new_word, c, div, ParPres );
         new_word := list[1];
         c := list[2];
         div := list[3];
         for i in [2..Length( word )] do
            if word[i][1] <= n+d then
               list := Collect_word_ti_ppowerpolypcp( word[i][1], PPP_Mult( word[i][2], y ), new_word, c, div, ParPres );
               new_word := list[1];
               c := list[2];
               div := list[3];
            else  Add_ci_c_ppowerpolypcp( word[i][1]-n-d, c[word[i][1]-n-d], word[i][2], div[word[i][1]-n-d], div[word[i][1]-n-d],expo_vec );
               c[word[i][1]-n-d] := list[1];
               div[word[i][1]-n-d] := list[2];
            fi;
         od;
      fi;

      return [ new_word , c , div ];
   end
);

###############################################################################
##
## Collect_word_gi_ppowerpolypcp( word_in, c_in, div_in, i, ParPres )
##
## [ IsList, IsList, IsList, IsPosInt, IsPPPPcpGroups ] 
##
## Comment: technical function (collecting word * g_i, assuming that word is 
##          collected)
##
InstallGlobalFunction( Collect_word_gi_ppowerpolypcp,
   function( word_in, c_in, div_in, i, ParPres )
      local p, n, d, rel, expo, expo_vec, word, c, div, stack, l_st, u, e, 
            l_w, l, j, k, list, help, Zero0, One1, s, new_word, new_help, 
            stack_2;

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      rel := ParPres!.rel;
      expo := ParPres!.expo;
      expo_vec := ParPres!.expo_vec;

      if i > n then
         Error( "Wrong input" );
      fi;

      word := StructuralCopy( word_in );
      l_w := Length( word );
      c := StructuralCopy( c_in );
      div := StructuralCopy( div_in );

      if l_w = 0 then
         return [ [[i,1]], c, div ];
      fi;

      stack := [[i,1]];
      l_st := 1;

      Zero0 := Int2PPowerPoly( p, 0 ); 
      One1 := Int2PPowerPoly( p, 1 );
   
      ## run until stacks are empty
      while l_st > 0 do
         ## for checking
         if InfoLevel( InfoCollectingPPPPcp ) = 1 then
            stack_2 := [];
            for j in [1..l_st] do
               stack_2[j] := stack[j];
            od;
            Print( "\nword = ", word, "\n c = ", c, "\n stack = ", stack_2 );
            Print( "\n div = ", div, "\n" );
         fi;

         ## take a generator and its exponent
         u := stack[l_st][1];
         e := stack[l_st][2];

         if InfoLevel( InfoCollectingPPPPcp ) = 1 then
            Print("\n u = ", u, " e = ", e, "\n" );
         fi;

         ## correct stack length
         ## if u <= n and e > 1 than keep [u,e-1] on stack, to do later
         ## note: u <= n and e>1 should not occur
         if u > n or e = 1 then
            l_st := l_st - 1;
         else stack[l_st][2] := stack[l_st][2] - 1;
         fi;

         if l_w = 0 then
            l_w := l_w + 1;
            word[l_w] := [u,e];
         else 
            j := word[l_w][1];
            ## if we take a g from the stack
            if u <= n then
               while u < j do
                  ## conjugate through higher, first c's
                  if j > n+d then
                     list := Add_ci_c_ppowerpolypcp( j-n-d, c[j-n-d], word[l_w][2], div[j-n-d], 1, expo_vec );
                     c[j-n-d] := list[1];
                     div[j-n-d] := list[2];
                     l_w := l_w - 1;
                  ## .., then t's
                  elif j > n then
                     ## get the relation
                     help := MakeMutableCopyListPPP( rel[j][u] );
                     ## possibly power relation
                     if word[l_w][2] <> One1 then
                        new_help := [];
                        for l in [1..Length( help )] do
                           if help[l][1] > n+d then
                              list := Add_ci_c_ppowerpolypcp( help[l][1]-n-d, c[help[l][1]-n-d], PPP_Mult( help[l][2], word[l_w][2] ), div[help[l][1]-n-d], 1, expo_vec );
                              c[help[l][1]-n-d] := list[1];
                              div[help[l][1]-n-d] := list[2];
                           else new_help[Length(new_help)+1] := help[l];
                           fi;
                        od;
                        help := StructuralCopy( new_help );
                        if Length( help ) > 0 then
                           list := Collect_t_y_ppowerpolypcp( help, word[l_w][2], c, div, ParPres );
                           help := list[1];
                           c := list[2];
                           div := list[3];
                        fi;
                     fi;
                     ## put relation on stack
                     for k in [Length(help),Length(help)-1..1] do
                        if help[k][1] > n+d then
                           list := Add_ci_c_ppowerpolypcp( help[k][1]-n-d, c[help[k][1]-n-d], help[k][2], div[help[k][1]-n-d], 1, expo_vec );
                           c[help[k][1]-n-d] := list[1];
                           div[help[k][1]-n-d] := list[2];
                        elif help[k][1] > n then
                           l_st := l_st + 1;
                           stack[l_st] := help[k];
                        else 
                           for l in [1..help[k][2]] do
                              l_st := l_st + 1;
                              stack[l_st] := [help[k][1], 1];
                           od;
                        fi;
                     od;
                     l_w := l_w - 1;
                  ## .., and now higher g's
                  else 
                     ## get relation
                     help := MakeMutableCopyListPPP( rel[j][u] );
                     ## put relations word[l_w][2]-times on stack
                     for l in [1..word[l_w][2]] do
                        for k in [Length(help),Length(help)-1..1] do
                           if help[k][1] > n+d then
                              list := Add_ci_c_ppowerpolypcp( help[k][1]-n-d, c[help[k][1]-n-d], help[k][2], div[help[k][1]-n-d], 1, expo_vec );
                              c[help[k][1]-n-d] := list[1];
                              div[help[k][1]-n-d] := list[2];
                           elif help[k][1] > n then
                                 l_st := l_st + 1;
                                 stack[l_st] := [help[k][1], help[k][2]];
                           else 
                              for s in [1..help[k][2]] do
                                 l_st := l_st + 1;
                                 stack[l_st] := [ help[k][1] , 1 ];
                              od;
                           fi;
                        od;
                     od;
                     l_w := l_w - 1;
                  fi;
                  if l_w > 0 then
                     j := word[l_w][1];
                  else j := 0;
                  fi;
               od;
               ## add [u,e] to the word, according to what is left
               if l_w > 0 then
                  if word[l_w][1] = u then
                     if IsInt( word[l_w][2] ) and IsInt( e ) then
                        word[l_w][2] := word[l_w][2] + e;
                     else PPP_Add( word[l_w][2], e );
                     fi;
                  else l_w := l_w + 1;
                     word[l_w] := [u,e];
                  fi;
               else l_w := l_w + 1;
                  word[l_w] := [u,e];
               fi;
               new_word := [];
               for k in [l_w,l_w-1..1] do
                  new_word[k] := word[k];
               od;
               ## reduce the new add highest element in word
               word := new_word;
               list := Reduce_word_gi_ppowerpolypcp( word, c, div, ParPres );
               word := list[1];
               l_w := Length( word );
               c := list[2];
               div := list[3];
            ## if we take a t from the stack, collect
            elif u <= n+d then 
               list := Collect_word_ti_ppowerpolypcp( u,e,word,c,div,ParPres );
               word := list[1];
               l_w := Length( word );
               c := list[2];
               div := list[3];
            ## if we take a tail from the stack add
            else list := Add_ci_c_ppowerpolypcp( u-n-d, c[u-n-d], e, div[u-n-d], 1, expo_vec );
               c[u-n-d] := list[1];
               div[u-n-d] := list[2];
            fi;
         fi;
      od;

      return [ word, c, div ];
   end);

###############################################################################
##
## CollectPPPPcp( obj )
##
## Input: a p-power-poly-pcp-groups element obj
##
## Output: obj in collected form
##
InstallMethod( CollectPPPPcp, 
   "collect a word in p-power-poly-pcp groups", 
   [ IsPPPPcpGroupsElement ],
   function( obj )
      local word, ParPres, new_word, c, div, p, n, d, m, Zero0, i, list, 
            expo_vec, j, expo, test, c_test, k, quot, l, elm, rel, len_rel;

      word := StructuralCopy( obj!.word );
      div := StructuralCopy( obj!.div );
      ParPres := obj!.grp_pres;

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      m := ParPres!.m;
      expo := ParPres!.expo;
      expo_vec := ParPres!.expo_vec;

      Zero0 := Int2PPowerPoly( p, 0 );

      ## check input
      for i in [1..Length( word )] do
         if Length( word[i] ) <> 2 then
            Error( "Wrong input." );
         elif word[i][1] < 1 or word[i][1] > n+d+m then
            Error( "Wrong input." );
         elif word[i][1] <= n and not IsInt( word[i][2] ) then
            Error( "Wrong input." );
         elif word[i][1] > n and not IsList( word[i][2] ) then
            Error( "Wrong input." );
         elif word[i][1] > n and word[i][2][1] <> ParPres!.prime then
            Error( "Wrong input." );
         fi;
      od;

      ## initialise the tails c
      c := [];
      for i in [m,m-1..1] do
         c[i] := Zero0;
      od;

      c_test := StructuralCopy( c );

      ## ensure that all exponents are non-negative
      i := 1;
      while i <= Length( word ) do
         new_word := [];
         if word[i][1] <= n then
            if word[i][2] < 0 then
               for j in [1..i - 1] do
                  new_word[j] := word[j];
               od;
               quot := QuotientRemainder( word[i][2], p );
               if quot[2] < 0 then 
                  quot[1] := quot[1] + 1;
                  quot[2] := quot[2] + p;
               fi;
               new_word[i] := [];
               new_word[i][1] := word[i][1];
               new_word[i][2] := quot[2];
               for j in [1..quot[1]] do
                  k := Length( new_word );
                  rel := ParPres!.rel[word[i][1]][word[i][1]];
                  len_rel := Length( rel );
                  for l in [len_rel,len_rel-1..1] do
                     new_word[k+len_rel+1-l] := [];
                     if IsInt( rel[l][1] ) then 
                        new_word[k+len_rel+1-l][1] := rel[l][1];
                     else new_word[k+len_rel+1-l][1] := MakeMutableCopyListPPP( rel[l][1] );
                     fi;
                     if IsInt( rel[l][2] ) then
                        new_word[k+len_rel+1-l][2] := - rel[l][2];
                     else new_word[k+len_rel+1-l][2] := MakeMutableCopyListPPP( rel[l][2] );
                        new_word[k+len_rel+1-l][2][2] := -new_word[k+len_rel+1-l][2][2];
                     fi;
                  od;
               od;
               k := Length( new_word );
               for j in [i+1..Length( word )] do
                  new_word[k+j-i] := word[j];
               od;
               word := StructuralCopy( new_word );
               i := i + 1;
            else i := i + 1;
            fi;
         elif word[i][1] <= n+d then
            if PPP_Smaller( word[i][2], Zero0 ) then
               for j in [1..i-1] do
                  new_word[j] := word[j];
               od;
               quot := PPP_QuotientRemainder( word[i][2], expo );
               if PPP_Smaller( quot[2], Zero0 ) then 
                  quot[1] := quot[1] + 1;
                  quot[2] := PPP_Add( quot[2], expo );
               fi;
               new_word[i] := [];
               new_word[i][1] := word[i][1];
               new_word[i][2] := quot[2];
               if not PPP_Equal( quot[1], Zero0 ) then
                  elm := PPPPcpGroupsElement( ParPres, ParPres!.rel[word[i][1]][word[i][1]] );
                  if elm <> One(elm) then
                     list := Collect_t_y_ppowerpolypcp( elm!.word, quot[1] , c , div , ParPres );
                     elm := list[1];
                     c := list[2];
                     div := list[3];
                     for j in [1..Length( elm )] do
                        k := Length( new_word );
                        new_word[k+j] := elm[j];
                     od;
                  fi;
               fi;
               k := Length( new_word );
               for j in [i+1..Length( word )] do
                  new_word[k+j-i] := word[j];
               od;
               word := StructuralCopy( new_word );
               i := i + 1;
            else i := i + 1;
            fi;
         elif not PPP_Equal( expo_vec[word[i][1]-n-d], Zero0 ) and PPP_Smaller( word[i][2], Zero0 ) then
            for j in [1..i-1] do
               new_word[j] := word[j];
            od;
            quot := PPP_QuotientRemainder( word[i][2], expo_vec[word[i][1]-n-d] );
            if quot[2] < Zero0 then 
               quot[1] := quot[1] + 1;
               quot[2] := PPP_Add( quot[2], expo_vec[word[i][1]-n-d] );
            fi;
            new_word[i] := [];
            new_word[i][1] := word[i][1];
            new_word[i][2] := quot[2];
            for j in [i+1..Length( word )] do
               new_word[j] := word[j];
            od;
            word := StructuralCopy( new_word );
            i := i + 1;
         else i := i + 1;
         fi;
      od;

      new_word := [];
      j := 1;
      ## find the first non-zero, non-tail entry
      test := false;
      while j <= Length( word ) and not test do
         ## TODO < changed to <=. This is right, isn't it?
         if ( word[j][1] <= n and word[j][2] = 0 ) or ( word[j][1] > n and PPP_Equal( word[j][2], Zero0 ) ) then
            j := j + 1;
         elif word[j][1] > n+d then
            list := Add_ci_c_ppowerpolypcp( word[j][1]-n-d, c[word[j][1]-n-d], word[j][2], div[word[j][1]-n-d], 1, expo_vec );
            c[word[j][1]-n-d] := list[1];
            div[word[j][1]-n-d] := list[2];
            j := j + 1;
         else test := true;
         fi;
      od;

      ## if all elements are zero and no non-tail element, return empty word
      if j > Length( word ) and ForAll( [1..m], x -> PPP_Equal( c[x], c_test[x] ) ) then
         return PPPPcpGroupsElementNC( ParPres, [] );
      ## if there is non-trivial non-tail, add this to new_word and reduce
      elif j <= Length( word ) then
         new_word[1] := word[j];
         if new_word[1][1] <= n and new_word[1][2] >= p then
            list := Reduce_word_gi_ppowerpolypcp( new_word, c, div, ParPres );
            new_word := list[1];
            c := list[2];
            div := list[3];
         elif new_word[1][1]>n and new_word[1][1]<=n+d and not PPP_Smaller( new_word[1][2], expo ) then
            list := Reduce_word_ti_ppowerpolypcp( new_word, c, div, ParPres );
            new_word := list[1];
            c := list[2];
            div := list[3];
         elif new_word[1][1]>n+d and not PPP_Smaller( new_word[1][2], expo_vec[new_word[1][1]-n-d] ) then
            list := Reduce_ci_ppowerpolypcp( new_word[1][2], div[new_word[1][1]], new_word[1][1]-n-d, expo_vec );
            new_word[1][2] := list[1];
            div[new_word[1][1]] := list[2];
         fi;
      fi;

      ## add the remaining non-trivial word parts to new_word
      for i in [j+1..Length(word)] do
         if word[i][1] > n+d then
            if not PPP_Equal( word[i][2], Zero0 ) then
               list := Add_ci_c_ppowerpolypcp( word[i][1]-n-d, c[word[i][1]-n-d], word[i][2], div[word[i][1]-n-d], 1, expo_vec );
               c[word[i][1]-n-d] := list[1];
               div[word[i][1]-n-d] := list[2];
            fi;
         elif word[i][1] > n then
            if not PPP_Equal( word[i][2], Zero0 ) then
               list := Collect_word_ti_ppowerpolypcp( word[i][1], word[i][2], new_word, c, div, ParPres );
               new_word := list[1];
               c := list[2];
               div := list[3];
            fi;
         else 
            for k in [1..word[i][2]] do
               list := Collect_word_gi_ppowerpolypcp( new_word, c, div, word[i][1], ParPres );
               new_word := list[1];
               c := list[2];
               div := list[3];
            od;
         fi;
      od;

      ## check that div[i] = 1 if c[i] = 0
      for i in [1..m] do
         if div[i] <> 1 and PPP_Equal( c[i], Zero0 ) then
            div[i] := 1;
         fi;
      od;

      ## add tails to new word
      for i in [1..m] do
         list := Reduce_ci_ppowerpolypcp( c[i], div[i], i, expo_vec );
         c[i] := list[1];
         div[i] := list[2];

         if not PPP_Equal( c[i], Zero0 ) then
            if not PPP_Equal( expo_vec[i], Zero0 ) and PPP_Smaller( c[i], Zero0 ) then
               new_word[Length(new_word)+1] := [n+d+i,expo_vec[i]+c[i]];
            else new_word[Length(new_word)+1] := [n+d+i,c[i]];
            fi;
         fi;
      od;

      return PPPPcpGroupsElementNC( ParPres, new_word, div );
   end);

#E Collect.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
