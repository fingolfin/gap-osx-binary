###############################################################################
##
#F GetMatrix.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## What do the elements of p-power-poly-pcp-groups look like?
## -----------------------------------------------------------
## 
## The generators of the groups are 
## 
## g_1 , ... g_n , 
## t_1 , ... , t_d,
## x_1,1 , ... , x_n+d,n+d 
##
## with the following relations:
##
## g_i^p = r_i,i(g_k^e_k , t_l^m_l(n) ) x_i,i for 1 <= i <= n , i < k <= n and 
##                                            some non-negative integers e_k, 
##                                            p-power-poly's m_l(n)
## g_i^g_j = r_i,j( g_k^e_k , t_l^m_l(n) ) x_i,j for 1 <= i <= n , 1 <= j < i,
##                                               i < k <= n and some 
##                                               non-negative integers 
##                                               e_k, p-power-poly's m_l(n)
## t_i^(exp( i , n )) = r_n+i,n+i( t_l^m_l(n) ) x_n+i,n+i for 1 <= i <= d, 
##                                                        i < l <= d and some
##                                                        non-negative 
##                                                        p-power-poly's m_l(n)
## t_i^t_j = t_i x_n+i,n+j for 1 <= i <= d, 1 <= j < i
## t_i^g_j = r_n+i,j( t_l^m_l(n) ) x_n+i,j for 1 <= i <= d, 1 <= j <= n, 
##                                         1 <= l <= d, some non-negative 
##                                         p-power-poly m_l(n) 
## x_k,l^g_i = x_k,l for 1 <= i <= n and 1 <= k , l <= n+d
## x_k,l^t_i = x_k,l for 1 <= i <= d and 1 <= k , l <= n+d
## x_i,j^x_k,l = x_i,j for 1 <= i , j , k , l <= n+d
## => the x_i,j are central and there exist x_i,j for 1 <= i <= n+d and 
##    1 <= j < i
##
## Define X := < x_i,j | 1 <= i <= n+d , 1 <= j < i >
##        T := < t_j   | 1 <= j <= d >
##        G := < g_i   | 1 <= i <= n >
##
## Then T/X abelian.
##
## We have elements of the (collected) form h = gtx where g \in G, t \in T and
## x \in X.
##
## How are the elements stored?
## ----------------------------
##
## Let h = gtx with g \in G, t \in T and x \in X. Then store h as follows:
##
## h := rec( prime, word, tails , div ) with
## 
## h.word := gt with g = g_1^e_1 , ... , g_n^e_n where e_1 , ... , e_n \in 
## {0 , ... , p-1} and t = t_1^f_1(x) ... t_d^f_d(x) 
## where f_1(x) , ... , f_d(x) p-power-polys. Thus store
## h.word := [ e_1 , ... , e_n , f_1(x) , ... , f_d(x) ];
##
## h.tails := x with x = x_1,1^k_1,1(x) ... x_n+d,n+d^k_n+d,n+d(x) where 
## k_1,1(x) , ... , k_n+d,n+d(x) p-power-poly elements. Thus store
## h.tails := [ k_1,1(x) , k_1,2(x) , ... , k_n+d,n+d(x) ];
## h.div := [a_1,1, ..., a_n+d,n+d]; where it is stored by which 
## integer the corresponding exponent of x has to be divided (normally 1, but 
## sometimes a power of 2).
##

## store relations
## r_i_j is a list of lists where r_i_j[i][j] gives the relations described 
## above.
## then r_i_j[i][j] consists of the list of lists [[k,l]_k,l] where k gives 
## the generator and l the exponent (l is positive).
## Keep in mind that to each realtion r_i_j[i][j] there belongs the 
## tail x_i,j.

## here the following consistency relations are evaluated and stored in a 
## matrix:
## 1 (a) g_k(g_jg_i) = (g_kg_j)g_i, k>j>i
##   (b) t_k(g_jg_i) = (t_kg_j)g_i, j>i
##   (c) t_k(t_jg_i) = (t_kt_j)g_i, k>j
##   (d) t_k(t_jt_i) = (t_kt_j)t_i, k>j>i  => trivial rel OK
## 2 (a) (g_j^p)g_i = (g_j^p-1)(g_jg_i), j>i
##   (b) g_j(g_i^p) = (g_jg_i)(g_i^p-1), j>i
##   (c) g_i^pg_i = g_ig_i^p
## 3 (a) (t_j^expo)t_i = (t_j^expo-1)(t_jt_i), j>i, expo = exponent of t's
##   (b) t_j(t_i^expo) = (t_jt_i)(t_i^expo-1), j>i, epxo = exponent of t's
##   => x_(n+j,n+j)^expo = 1 for 1 <= j < i <= d
##   (c) (t_i^expo)t_i = t_i(t_i^expo), expo=exponent of t's => trivial rel OK
## 4 (a) (t_j^expo)g_i = (t_j^expo-1)(t_jg_i), expo = exponent of t's
##   (b) t_j(g_i^p) = (t_jg_i)(g_i^p-1)
##

###############################################################################
##
## WordsEqualPPP( word1, word2, n, d )
##
## Input: ppp-words word1 and word2, the number of generators n and d
##
## Output: a boolean, indicating whether word1 and word2 are equal
##
InstallGlobalFunction( WordsEqualPPP, 
   function( word1, word2, n, d )
      local i;

      for i in [1..n] do
         if word1[i] <> word2[i] then return false; fi;
      od;

      for i in [1..d] do
         if not PPP_Equal( word1[n+i], word2[n+i] ) then return false; fi;
      od;

      return true;
   end);

###############################################################################
##
## PPP_PrintWord( word )
##
## Input: a ppp-word word
##
## Output: the function prints word in an easy to read way
##
InstallGlobalFunction( PPP_PrintWord, 
   function( word )

      Print( "rec( \n" );
      Print( "prime := ", word!.prime, "\n", "word := " );
      PPP_PrintRow( word!.word );
      Print( "tails := " );
      PPP_PrintRow( word!.tails );
      Print( "div := ", word!.div, " )" );

   end);

###############################################################################
##
## CompareGetRelation( word1, word2, p, n, d, expo )
##
## Comment: technical function (comparing consistency checks and computing 
##          relations out of it)
##
InstallGlobalFunction( CompareGetRelation, 
   function( word1, word2, p, n, d, expo )
      local tails, div, pos_nd, i, list, help, lcm;

      if not WordsEqualPPP( word1.word, word2.word, n, d ) then 
         Error(); 
      fi;

      tails := [];
      div := [];

      pos_nd := PosTails( n+d, n+d );
   
      ## compare and get relation
      for i in [1..pos_nd] do
         list:=Add_x_ij(p,n,d,i,word2.tails[i],PPP_AdditiveInverse( word1.tails[i] ),word2!.div[i], word1!.div[i],expo);
         tails[i] := list[1];
         div[i] := list[2];
      od;

      ## if p <> 2 then div can be <> 1
      if p <> 2 then
         ## find lcm of div
         lcm := MaximumList( div );

         ## if lcm <> 1 then multiply
         if lcm <> 1 then
            for i in [1..pos_nd] do
               help := Int2PPowerPoly( p, lcm/div[i] );
               tails[i] := StructuralCopy( PPP_Mult( help, tails[i] ) );
            od;
         fi;
      fi;

      return tails;
   end);

###############################################################################
##
## GetMatrixPPowerPolySchurExt( ParPres )
##
## Input: a record ParPres, representing p-power-poly-pcp-groups
##
## Output: a matrix which is computed using consistency checks
##
InstallMethod( GetMatrixPPowerPolySchurExt, 
   "get matrix out of consistency checks for p-power-poly Schur extension", 
   [ IsRecord ], 
   function( ParPres )
      local Zero0, One1, i, j, k, l, M, l_M, word_Zero, word, help1, 
            help2, help, help_expo, pos_nd, list, pos, Zero_Row, 
            p, n, d, rel, expo, test_row;

      ## check input
      if not IsPrime( ParPres!.prime ) then Error( "Wrong input." ); fi;
      if not IsPosInt( ParPres!.n ) then Error( "Wrong input." ); fi;
      if not IsPosInt( ParPres!.d ) then Error( "Wrong input." ); fi;
      if not IsList( ParPres!.rel ) then Error( "Wrong input." ); fi;
      if not IsList( ParPres!.expo ) then Error("Wrong input."); fi;

      p := ParPres!.prime;
      n := ParPres!.n;
      d := ParPres!.d;
      rel := ParPres!.rel;
      expo := ParPres!.expo;

      ## initalizing
      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      M := [];
      l_M := 0;

      word_Zero := rec( prime := p, word := [], tails := [] );
      word_Zero!.div := [];
      for i in [1..n] do
         word_Zero.word[i] := 0;
      od;
      for i in [1..d] do
         word_Zero.word[n+i] := Zero0;
      od;

      pos_nd := PosTails( n+d, n+d );
      for i in [1..pos_nd] do
         word_Zero.tails[i] := Zero0;
         word_Zero!.div[i] := 1;
      od;

      Zero_Row := [];
      for i in [1..pos_nd] do
         Zero_Row[i] := Zero0;
      od;

      ## 1 (a) g_k(g_jg_i) = (g_kg_j)g_i, k>j>i
      ## 1 (b) t_k(g_jg_i) = (t_kg_j)g_i, j>i
      ## in both cases g_jg_i is needed
      for i in [1..n] do
         for j in [i+1..n] do
            word := StructuralCopy( word_Zero );
            word.word[j] := 1;
            word := Collect_h_g_i( word, n, d, i, rel, expo );
            ## for 1(a) g_k(g_jg_i) = (g_kg_j)g_i, k>j>i
            for k in [j+1..n] do
               ## compute g_k(g_jg_i)
               help1 := StructuralCopy( word_Zero );
               help1.word[k] := 1;
               ## collect tails
               for l in [1..pos_nd] do
                  if not PPP_Equal( word.tails[l], Zero0 ) then
                     list := TailsPos( l, n+d );
                     help1:=Collect_h_x_ij(help1,list[1],list[2],word.tails[l],p,n,d,expo);
                  fi;
               od;
               ## collect word
               for l in [1..n] do
                  help_expo := word.word[l];
                  while help_expo > 0 do
                     help_expo := help_expo - 1;
                     help1 := Collect_h_g_i( help1, n, d, l, rel, expo );
                  od;
               od;
               for l in [1..d] do
                  if not PPP_Equal( word.word[n+l], Zero0 ) then
                     help1:=Collect_h_t_i(help1,n,d,n+l,word.word[n+l],p,rel,expo);
                  fi;
               od;
               ## compute (g_kg_j)g_i
               help2 := StructuralCopy( word_Zero );
               help2.word[k] := 1;
               help2 := Collect_h_g_i( help2, n, d, j, rel, expo );
               help2 := Collect_h_g_i( help2, n, d, i, rel, expo );
               ## compare help1 and help2
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "1(a) [k,j,i] = ", [k,j,i], "\n" );
                  Print( "g_k(g_jg_i) = " );
                  PPP_PrintWord( help1 );
                  Print( "\n", "(g_kg_j)g_i = " );
                  PPP_PrintWord( help2 );
                  Print( "\n" );
               fi;
               test_row := CompareGetRelation( help1, help2, p, n, d, expo );
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "=> " );
                  PPP_PrintRow( test_row );
                  Print( "\n\n"  );
               fi;

               ## check if consistency relation is necessary
               if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
                  if not test_row in M then
                     l_M := l_M + 1;
                     M[l_M] := test_row;
                     if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                        Print( "=> l_M := ", l_M, "\n\n" );
                     fi;
                  fi;
               fi;
            od;

            ## for 1 (b) t_k(g_jg_i) = (t_kg_j)g_i, j>i
            for k in [1..d] do
               ## compute t_k(g_jg_i)
               help1 := StructuralCopy( word_Zero );
               help1.word[n+k] := One1;
               ## collect tails
               for l in [1..pos_nd] do
                  if not PPP_Equal( word.tails[l], Zero0 ) then
                     list := TailsPos( l, n+d );
                     help1:=Collect_h_x_ij(help1,list[1],list[2],word.tails[l],p,n,d,expo);
                  fi;
               od;
               ## collect word
               for l in [1..n] do
                  help_expo := word.word[l];
                  while help_expo > 0 do
                     help_expo := help_expo - 1;
                     help1 := Collect_h_g_i( help1, n, d, l, rel, expo );
                  od;
               od;
               for l in [1..d] do
                  if not PPP_Equal( word.word[n+l], Zero0 ) then
                     help1:=Collect_h_t_i(help1,n,d,n+l,word.word[n+l],p,rel,expo);
                  fi;
               od;
               ## compute (t_kg_j)g_i
               help2 := StructuralCopy( word_Zero );
               help2.word[n+k] := One1;
               help2 := Collect_h_g_i( help2, n, d, j, rel, expo );
               help2 := Collect_h_g_i( help2, n, d, i, rel, expo );
               ## compare help1 and help2
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "1(b) [k,j,i] = ", [k,j,i], "\n" );
                  Print( "t_k(g_jg_i) = " );
                  PPP_PrintWord( help1 );
                  Print( "\n", "(t_kg_j)g_i = " );
                  PPP_PrintWord( help2 );
                  Print( "\n" );
               fi;
               test_row := CompareGetRelation( help1, help2, p, n, d, expo );
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "=> " );
                  PPP_PrintRow( test_row );
                  Print( "\n\n"  );
               fi;

               ## check if consistency relation is necessary
               if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
                  if not test_row in M then
                     l_M := l_M + 1;
                     M[l_M] := test_row;
                     if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                        Print( "=> l_M := ", l_M, "\n\n" );
                     fi;
                  fi;
               fi;
            od;
         od;
      od;

      ## 1 (c) t_k(t_jg_i) = (t_kt_j)g_i, k>j
      for i in [1..n] do
         for j in [1..d] do
            help := StructuralCopy( word_Zero );
            help.word[n+j] := One1;
            help := Collect_h_g_i( help, n, d, i, rel, expo );
            for k in [j+1..d] do
               ## compute t_k(t_jg_i)
               help1 := StructuralCopy( word_Zero );
               help1.word[n+k] := One1;
               ## collect tails
               for l in [1..pos_nd] do
                  if not PPP_Equal( help.tails[l], Zero0 ) then
                     list := TailsPos( l, n+d );
                     help1:=Collect_h_x_ij(help1,list[1],list[2],help.tails[l],p,n,d,expo);
                  fi;
               od;
               ## collect word
               for l in [1..n] do
                  help_expo := help.word[l];
                  while help_expo > 0 do
                     help_expo := help_expo - 1;
                     help1 := Collect_h_g_i( help1, n, d, l, rel, expo );
                  od;
               od;
               for l in [1..d] do
                  if not PPP_Equal( help.word[n+l], Zero0 ) then
                     help1:=Collect_h_t_i(help1,n,d,n+l,help.word[n+l],p,rel,expo);
                  fi;
               od;
               ## compute (t_kt_j)g_i
               help2 := StructuralCopy( word_Zero );
               help2.word[n+k] := One1;
               help2 := Collect_h_t_i( help2, n, d, n+j, One1, p, rel, expo );
               help2 := Collect_h_g_i( help2, n, d, i, rel, expo );
               ## compare help1 and help2
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "1(c) [k,j,i] = ", [k,j,i], "\n" );
                  Print( "t_k(t_jg_i) = " );
                  PPP_PrintWord( help1 );
                  Print( "\n", "(t_kt_j)g_i = " );
                  PPP_PrintWord( help2 );
                  Print( "\n" );
               fi;
               test_row := CompareGetRelation( help1, help2, p, n, d, expo );
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "=> " );
                  PPP_PrintRow( test_row );
                  Print( "\n\n"  );
               fi;

               ## check if consistency relation is necessary
               if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
                  if not test_row in M then
                     l_M := l_M + 1;
                     M[l_M] := test_row;
                     if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                        Print( "=> l_M := ", l_M, "\n\n" );
                     fi;
                  fi;
               fi;
            od;             
         od;
      od;

      ## 2 (a) (g_j^p)g_i = (g_j^p-1)(g_jg_i), j>i
      ## 2 (b) g_j(g_i^p) = (g_jg_i)(g_i^p-1), j>i
      ## in both cases g_jg_i is needed.
      for i in [1..n] do
         for j in [i+1..n] do
            help := StructuralCopy( word_Zero );
            help.word[j] := 1;
            help := Collect_h_g_i( help, n, d, i, rel, expo );
            ## for 2 (a) (g_j^p)g_i = (g_j^p-1)(g_jg_i), j>i
            ## (g_j)^pg_i
            help1 := StructuralCopy( word_Zero );
            pos := PosTails( j, j );
            help1.tails[pos] := One1;
            for k in [1..Length( rel[j][j] )] do
               help1.word[rel[j][j][k][1]] := ShallowCopy( rel[j][j][k][2] );
##               help1.word[rel[j][j][k][1]] := StructuralCopy( rel[j][j][k][2] );
            od;
            ## collect
            help1 := Collect_h_g_i( help1, n, d, i, rel, expo );
            ## (g_j^p-1)(g_jg_i)
            help2 := StructuralCopy( word_Zero );
            help2.word[j] := p-1;
            ## collect tails
            for l in [1..pos_nd] do
               if not PPP_Equal( help.tails[l], Zero0 ) then
                  list := TailsPos( l, n+d );
                  help2:=Collect_h_x_ij(help2,list[1],list[2],help.tails[l],p,n,d,expo);
               fi;
            od;
            ## collect word
            for l in [1..n] do
               help_expo := help.word[l];
               while help_expo > 0 do
                  help_expo := help_expo - 1;
                  help2 := Collect_h_g_i( help2, n, d, l, rel, expo );
               od;
            od;
            for l in [1..d] do
               if not PPP_Equal( help.word[n+l], Zero0 ) then
                  help2:=Collect_h_t_i(help2,n,d,n+l,help.word[n+l],p,rel,expo);
               fi;
            od;
            ## compare help1 and help2
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "2(a) [j,i] = ", [j,i], "\n" );
               Print( "(g_j)^pg_i = " );
               PPP_PrintWord( help1 );
               Print( "\n", "(g_j^p-1)(g_jg_i) = " );
               PPP_PrintWord( help2 );
               Print( "\n" );
            fi;
            test_row := CompareGetRelation( help1, help2, p, n, d, expo );
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "=> " );
	       PPP_PrintRow( test_row );
               Print( "\n\n"  );
            fi;
            ## check if consistency relation is necessary
            if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
               if not test_row in M then
                  l_M := l_M + 1;
                  M[l_M] := test_row;
                  if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                     Print( "=> l_M := ", l_M, "\n\n" );
                  fi;
               fi;
            fi;

            ## 2 (b) g_j(g_i^p) = (g_jg_i)(g_i^p-1), j>i
            ## g_j(g_i^p)
            help1 := StructuralCopy( word_Zero );
            help1.word[j] := 1;
            ## collect tails
            pos := PosTails( i, i );
            help1.tails[pos] := One1;
            ## collect word
            for k in [1..Length( rel[i][i] )] do
               if rel[i][i][k][1] <= n then
                  help_expo := ShallowCopy( rel[i][i][k][2] );
##                  help_expo := StructuralCopy( rel[i][i][k][2] );
                  while help_expo > 0 do
                     help_expo := help_expo - 1;
                     help1 := Collect_h_g_i( help1,n,d,rel[i][i][k][1],rel,expo );
                  od;
               else 
                  help1:=Collect_h_t_i(help1,n,d,rel[i][i][k][1],rel[i][i][k][2],p,rel,expo);
               fi;
            od;
            ## (g_jg_i)(g_i^p-1)
            help2 := StructuralCopy( help );
            for k in [1..p-1] do
               help2 :=  Collect_h_g_i( help2, n, d, i, rel, expo );
            od;
            ## compare help1 and help2
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "2(b) [j,i] = ", [j,i], "\n" );
               Print( "g_j(g_i^p) = " );
               PPP_PrintWord( help1 );
               Print( "\n", "(g_jg_i)(g_i^p-1) = " );
               PPP_PrintWord( help2 );
               Print( "\n" );
            fi;
            test_row := CompareGetRelation( help1, help2, p, n, d, expo );
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "=> " );
               PPP_PrintRow( test_row );
               Print( "\n\n"  );
            fi;
            ## check if consistency relation is necessary
            if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
               if not test_row in M then
                  l_M := l_M + 1;
                  M[l_M] := test_row;
                  if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                     Print( "=> l_M := ", l_M, "\n\n" );
                  fi;
               fi;
            fi;
         od;
      od;

      ## 2 (c) g_i^pg_i = g_ig_i^p
      for i in [1..n] do
         ## g_i^pg_i
         help1 := StructuralCopy( word_Zero );
         pos := PosTails( i, i );
         help1.tails[pos] := One1;
         for k in [1..Length( rel[i][i] )] do
            help1.word[rel[i][i][k][1]] := ShallowCopy( rel[i][i][k][2] );
         od;
         ## collect
         help1 := Collect_h_g_i( help1, n, d, i, rel, expo );      
         ## g_ig_i^p
         help2 := StructuralCopy( word_Zero );
         help2.word[i] := 1;
         ## collect tails
         help2.tails[pos] := One1;
         ## collect word
         for k in [1..Length( rel[i][i] )] do
            if rel[i][i][k][1] <= n then
               help_expo := ShallowCopy( rel[i][i][k][2] );
               while help_expo > 0 do
                  help_expo := help_expo - 1;
                  help2 := Collect_h_g_i( help2,n,d,rel[i][i][k][1],rel,expo );
               od;
            else 
               help2:=Collect_h_t_i(help2,n,d,rel[i][i][k][1],rel[i][i][k][2],p,rel,expo);
            fi;
         od;
         ## compare help1 and help2
         if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
            Print( "2(c) i = ", i, "\n" );
            Print( "g_i^pg_i = " );
            PPP_PrintWord( help1 );
            Print( "\n", "g_ig_i^p = " );
            PPP_PrintWord( help2 );
            Print( "\n" );
         fi;
         test_row := CompareGetRelation( help1, help2, p, n, d, expo );
         if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
            Print( "=> " );
            PPP_PrintRow( test_row );
            Print( "\n\n"  );
         fi;
         ## check if consistency relation is necessary
         if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
            if not test_row in M then
               l_M := l_M + 1;
               M[l_M] := test_row;
               if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                  Print( "=> l_M := ", l_M, "\n\n" );
               fi;
            fi;
         fi;
      od;

      ## 3 (a) (t_j^expo)t_i = (t_j^expo-1)(t_jt_i), j>i, expo=exponent of t's
      ## 3 (b) t_j(t_i^expo) = (t_jt_i)(t_i^expo-1), j>i, epxo=exponent of t's
      ## => x^(p^expo)_(n+j,n+i) = 1 for all 1<= j < i <= d
      ## as these are 1 do them first... shall I leave them out?
      for i in [1..d] do
         for j in [1..i-1] do
            pos := PosTails( n+i, n+j );
            l_M := l_M + 1;
            M[l_M] := StructuralCopy( Zero_Row );
            M[l_M][pos] := expo;
         od;
      od;

      ## 4 (a) (t_j^expo)g_i = (t_j^expo-1)(t_jg_i), expo = exponent of t's
      ## 4 (b) t_j(g_i^p) = (t_jg_i)(g_i^p-1)
      for i in [1..n] do
         for j in [1..d] do
            help := StructuralCopy( word_Zero );
            help.word[n+j] := One1;
            help := Collect_h_g_i( help,n,d,i,rel,expo );
            ## 4 (a) (t_j^expo)g_i = (t_j^expo-1)(t_jg_i), expo=exponent of t's
            ## (t_j^expo)g_i
            help1 := StructuralCopy( word_Zero );
            help1.word[i] := 1;
            pos := PosTails( n+j, n+j );
            help1.tails[pos] := One1;
            ## (t_j^expo-1)(t_jg_i)
            help2 := StructuralCopy( word_Zero );
            help2.word[n+j] := PPP_Subtract( expo, One1 );
            ## collect tails
            for l in [1..pos_nd] do
               if not PPP_Equal( help.tails[l], Zero0 ) then
                  list := TailsPos( l, n+d );
                  help2:=Collect_h_x_ij(help2,list[1],list[2],help.tails[l],p,n,d,expo);
               fi;
            od;
            ## collect word
            for l in [1..n] do
               help_expo := help.word[l];
               while help_expo > 0 do
                  help_expo := help_expo - 1;
                  help2 := Collect_h_g_i( help2, n, d, l, rel, expo );
               od;
            od;
            for l in [1..d] do
               if not PPP_Equal( help.word[n+l], Zero0 ) then
                  help2:=Collect_h_t_i(help2,n,d,n+l,help.word[n+l],p,rel,expo);
               fi;
            od;
            ## compare help1 and help2
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "4(a) [j,i] = ", [j,i], "\n" );
               Print( "(t_j^expo)g_i = " );
               PPP_PrintWord( help1 );
               Print( "\n", "(t_j^expo-1)(t_jg_i) = " );
               PPP_PrintWord( help2 );
               Print( "\n" );
            fi;
            test_row := CompareGetRelation( help1, help2, p, n, d, expo );
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "=> " );
               PPP_PrintRow( test_row );
               Print( "\n\n"  );
            fi;
            ## check if consistency relation is necessary
            if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
               if not test_row in M then
                  l_M := l_M + 1;
                  M[l_M] := test_row;
                  if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                     Print( "=> l_M := ", l_M, "\n\n" );
                  fi;
               fi;
            fi;


            ## 4 (b) t_j(g_i^p) = (t_jg_i)(g_i^p-1)
            ## t_j(g_i^p)
            help1 := StructuralCopy( word_Zero );
            help1.word[n+j] := One1;
            ## collect tails
            pos := PosTails( i, i );
            help1.tails[pos] := One1;
            ## collect word
            for k in [1..Length( rel[i][i] )] do
               if rel[i][i][k][1] <= n then
                  help_expo := ShallowCopy( rel[i][i][k][2] );
                  while help_expo > 0 do
                     help_expo := help_expo - 1;
                     help1 := Collect_h_g_i( help1,n,d,rel[i][i][k][1],rel,expo );
                  od;
               else 
                  help1:=Collect_h_t_i(help1,n,d,rel[i][i][k][1],rel[i][i][k][2],p,rel,expo);
               fi;
            od;     
            ## (t_jg_i)(g_i^p-1)
            help2 := StructuralCopy( help );
            for l in [1..p-1] do
               help2 := Collect_h_g_i( help2,n,d,i,rel,expo );
            od;
            ## compare help1 and help2
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "4(b) [j,i] = ", [j,i], "\n" );
               Print( "t_j(g_i^p) = " );
               PPP_PrintWord( help1 );
               Print( "\n", "(t_jg_i)(g_i^p-1) = " );
               PPP_PrintWord( help2 );
               Print( "\n" );
            fi;
            test_row := CompareGetRelation( help1, help2, p, n, d, expo );
            if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
               Print( "=> " );
               PPP_PrintRow( test_row );
               Print( "\n\n"   );
            fi;
            ## check if consistency relation is necessary
            if not ForAll( [1..pos_nd], x -> PPP_Equal( test_row[x], Zero0 ) ) then
               if not test_row in M then
                  l_M := l_M + 1;
                  M[l_M] := test_row;
                  if InfoLevel( InfoConsistencyRelPPowerPoly ) = 1 then
                     Print( "=> l_M := ", l_M, "\n\n" );
                  fi;
               fi;
            fi;
         od;
      od;

      return M;
   end);

###############################################################################
##
## GetMatrixPPowerPolySchurExt( ParPres )
##
## Input: p-power-poly-pcp-groups ParPres
##
## Output: a matrix which is computed using consistency checks
##
InstallMethod( GetMatrixPPowerPolySchurExt, 
   "get matrix out of consistency checks for p-power-poly Schur extension", 
   [ IsPPPPcpGroups ], 
   function( G )
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

      return GetMatrixPPowerPolySchurExt( ParPres );
   end);

#E GetMatrix.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
