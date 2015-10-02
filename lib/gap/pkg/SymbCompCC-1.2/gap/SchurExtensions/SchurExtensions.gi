###############################################################################
##
#F SchurExtension.gi         The SymbCompCC package     Dörte Feichtenschlager
##

##
## What do the elements of p-power-poly-pcp groups look like?
## -------------------------------------
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

###############################################################################
##
## SchurExtParPres( ParPres )
##
## Input: a record ParPres, representing p-power-poly-pcp-groups
##
## Output: a record, representing the Schur extensions
##
InstallMethod( SchurExtParPres, 
   "get parameter presentations for Schur extension of family", 
   [ IsRecord ], 
   function( ParPres )
      local One1, Zero0, G, SNF, S, Q, Schur_Ext_Par_Pres, count, vec, i, j, k,
            rel, pos, null_vec, n, d, l, list, gcd, p, a, b;

      if ParPres!.m > 0 then
         Error( "The function needs a pp-presentation of an infinite coclass sequence as input." );
      fi;

      if not IsPrime( ParPres!.prime ) then
         Error( "Wrong input." );
      fi;

      One1 := Int2PPowerPoly( ParPres!.prime, 1 );
      Zero0 := Int2PPowerPoly( ParPres!.prime, 0 );

      G := GetMatrixPPowerPolySchurExt( ParPres );

      G := PPowerPolyMat2PPowerPolyLocMat( G );

      if CHECK_SMITHNF_PPOWERPOLY then
         SNF := SmithNormalFormPPowerPolyTransforms( G );
         SNF := UnLocSmithNFPPowerPoly( SNF );
      else SNF := SmithNormalFormPPowerPolyColTransform( G );
         SNF := UnLocSmithNFPPowerPolyCol( SNF );
      fi;

      S := SNF!.norm;
      Q := SNF!.coltrans;

      Schur_Ext_Par_Pres := ShallowCopy( ParPres );
      Schur_Ext_Par_Pres!.name:=Concatenation("SchurExt_",Schur_Ext_Par_Pres!.name);
      Schur_Ext_Par_Pres!.cc := fail;
      Schur_Ext_Par_Pres!.rel := MakeMutableCopyListPPP( ParPres!.rel );

      null_vec := [];
      for i in [1..Length(Q[1])] do
         null_vec[i] := Zero0;
      od;

      n := ParPres!.n;
      d := ParPres!.d;
      p := ParPres!.prime;

      count := 0;
      vec := [];
      for i in [1..Length( S )] do
         if PPP_Equal( S[i], One1 ) then 
            count := count + 1; 
            vec[i] := 0;
         else vec[i] := i - count;
         fi;
      od;
      Schur_Ext_Par_Pres!.m := Length( S ) - count;
      ## make presentations smaller
      for i in [1..Length( S )] do
         if Length( S[i][2] ) = 2 and S[i][2][1] = 0 then
            if IsInt( S[i][2][2] ) then
               list := [];
               l := 0;
               for j in [1..Length( Q )] do
                  if not PPP_Equal( Q[j][i], Zero0 ) then
                     l := l + 1;
                     list[l] := Q[j][i][2][1];
                  fi;
               od;
               gcd := Gcd( list );
               while (gcd = 0 mod p) do
                  gcd := gcd / p;
               od;
               if gcd <> 1 then
                  for j in [1..Length( Q )] do
                     if not PPP_Equal( Q[j][i], Zero0 ) then
                        a := Q[j][i][2][1]/gcd; 
                        b := (Q[j][i][2][2]/gcd) mod S[i][2][2];
                        Q[j][i][2] := RedPPowerPolyCoeffs( [ a, b ] );
                     fi;
                  od;
               fi;
            else ## is p-divisible element
               list := [];
               l := 0;
               for j in [1..Length( Q )] do
                  if not PPP_Equal( Q[j][i], Zero0 ) then
                     l := l + 1;
                     list[l] := Q[j][i][2][1];
                     if IsBound( Q[j][i][2][2] ) then
                        l := l + 1;
                        list[l] := Q[j][i][2][2];
                     fi;
                  fi;
               od;
               gcd := Gcd( list );
               while (gcd = 0 mod p) do
                  gcd := gcd / p;
               od;
               if gcd <> 1 then
                  for j in [1..Length( Q )] do
                     if Q[j][i] <> Zero0 then
                        a := Q[j][i][2][1]/gcd; 
                        b := (Q[j][i][2][2]/gcd) mod S[i][2][2];
                        Q[j][i][2] := RedPPowerPolyCoeffs( [ a, b ] );
                     fi;
                  od;
               fi;
            fi;
         fi;
      od;

      ## add to presentations 
      for i in [1..n+d] do
         for j in [1..i] do
            pos := PosTails( i, j );
            if Q[pos] <> null_vec then
               rel := Schur_Ext_Par_Pres!.rel[i][j];
               if j <= n and i = j then
                  if rel = [[i,0]] then
                     rel := [];
                  fi;
               elif j > n and i = j then
                  if rel[1][1] = i and PPP_Equal( rel[1][2], Zero0 ) then
                     rel := [];
                  fi;
               fi;
               for k in [1..Length( S )] do
                  if not PPP_Equal( S[k], One1 ) then 
                     if not PPP_Equal( Q[pos][k], Zero0 ) then
                        if not PPP_Equal( S[k], Zero0 ) then
                           if not PPP_Smaller( Q[pos][k], S[k] ) or not PPP_Smaller( PPP_AdditiveInverse( Q[pos][k] ), S[k] ) then
                              Q[pos][k] := PPP_QuotientRemainder(Q[pos][k],S[k])[2];
                           fi;
                           if PPP_Smaller( Q[pos][k], Zero0 ) then
                              Q[pos][k] := PPP_Add( Q[pos][k], S[k] );
                           fi;
                        fi;
                        if not PPP_Equal( Q[pos][k], Zero0 ) then
                           rel[Length( rel ) + 1] := [n+d+vec[k], Q[pos][k]];
                        fi;
                     fi;
                  fi;
               od;
               if rel = [] then
                  if i <= n then
                     rel := [[i,0]];
                  else rel := [[i,Zero0]];
                  fi;
               fi;
               Schur_Ext_Par_Pres!.rel[i][j] := rel;
            fi;
         od;
      od;
      ## add presentations for extra generators of Schur extension
      for i in [1..Schur_Ext_Par_Pres!.m] do
         Schur_Ext_Par_Pres!.rel[n+d+i] := [];
         for j in [1..n+d] do
            Schur_Ext_Par_Pres!.rel[n+d+i][j] := [[n+d+i, One1]];
         od;
         for j in [1..i-1] do
            Schur_Ext_Par_Pres!.rel[n+d+i][n+d+j] := [[n+d+i, One1]];
         od;
         Schur_Ext_Par_Pres!.rel[n+d+i][n+d+i] := [[n+d+i, Zero0]];
      od;
      ## add exponent vector for extra generators of Schur extension
      Schur_Ext_Par_Pres!.expo_vec := [];
      count := 0;
      for i in [1..Length( S )] do
         if not PPP_Equal( S[i], One1 ) then
            count := count + 1;
            Schur_Ext_Par_Pres!.expo_vec[count] := S[i];
         fi;
      od;

      return MakeImmutable( Schur_Ext_Par_Pres );
   end);

###############################################################################
##
## SchurExtParPres( G )
##
## Input: p-power-poly-pcp-groups G
##
## Output: p-power-poly-pcp-groups, the Schur extensions of G
##
InstallMethod( SchurExtParPres, 
   "get parameter presentations for Schur extension of family", 
   [ IsPPPPcpGroups ], 
   function( G )
      local ParPres, SG;

      if G!.m > 0 then
         Error( "The function needs an infinite coclass sequence as input." );
      fi;

      ParPres := rec( prime := G!.prime );
      ParPres!.rel := G!.rel;
      ParPres!.n := G!.n;
      ParPres!.d := G!.d;
      ParPres!.m := G!.m;
      ParPres!.expo := G!.expo;
      ParPres!.expo_vec := G!.expo_vec;
      ParPres!.cc := G!.cc;
      ParPres!.name := G!.name;

      SG := SchurExtParPres( ParPres );
      return PPPPcpGroups( SG );
   end);

###############################################################################
##
## UnLocSmithNFPPowerPoly( SNF )
##
## Comment: technical method (it takes the output of the Smith normal form
##          method (which returns the row transformation matrix as well) and 
##          changes the Smith normal form and the column transformation
##          matrix to be over non-quotient elements
##
InstallMethod( UnLocSmithNFPPowerPoly, [ IsRecord ], 
   function( SNF )
      local S, P, Q, One1, Zero0, i, cm, cm_inv, j, list, S_diag, Zero0Loc,
            cd, test, test2, k, list1, list2, P_change;

      if not IsBound( SNF!.rowtrans ) then
         Error( "Wrong input." );
      fi;
      S := SNF!.norm;
      P := SNF!.rowtrans;
      Q := SNF!.coltrans;

      One1 := PPP_OneNC( S[1][1][1] );
      Zero0 := PPP_ZeroNC( S[1][1][1] );
      Zero0Loc := PPPL_ZeroNC( S[1][1] );

      ## change S (and Q) so that all denominators in Q are One1
      ## find a "least" common multiple of the denominators in each column
      ## and afterwards check for a common p-prime divisor of the numerators  
      ## in each column
      for i in [1..Length( Q[1] )] do
         cm := One1;
         for j in [1..Length( Q )] do
            if not PPP_Equal( Q[j][i][2], One1 ) then
               list1 := PPP_QuotientRemainder( cm, Q[j][i][2] );
               if not PPP_Equal( list1[2], Zero0 ) then
                  list2 := PPP_QuotientRemainder( Q[j][i][2],cm );
                  if not PPP_Equal( list2[2], Zero0 ) then
                     cm := ShallowCopy( PPP_Mult( cm, Q[j][i][2] ) );
                  else cm := ShallowCopy( Q[j][i][2] );
                  fi;
               fi;
            fi;
         od;
         cm := [cm, One1 ];
         if not PPP_Equal( cm[1], One1 ) then
            ## change column i of S and Q 
            for j in [1..Length( Q )] do
               if not PPPL_Equal( Q[j][i], Zero0Loc ) then
                  Q[j][i] := PPPL_Mult( Q[j][i], cm );
               fi;
            od;
         fi;

         ## check for common p-prime divisor of the numerators in column
         cd := One1;
         j := 1;
         test := false;
         while j <= Length( Q ) and test = false do
            if not PPP_Equal( Q[j][i][1], Zero0 ) then
               cd := PPrimePartPoly( Q[j][i][1] );
               k := 1;
               test2 := true;
               while k <= Length(Q) and test2 = true do
                  if not PPP_Equal( PPP_QuotientRemainder(Q[k][i][1], cd )[2], Zero0 ) then
                     test2 := false;
                     j := j + 1;
                  else k := k + 1;
                  fi;
               od;
               if test2 = true and k > Length(Q) then
                  test := true;
               fi;
            else j := j + 1;
            fi;
         od;
         if j > Length( Q ) then
            cd := [ One1, One1 ];
         else cd := [ One1, cd ];
         fi;
         ## change Q again, now with cd:
         if cd <> One1 then
            for j in [1..Length( Q )] do
               if not PPPL_Equal( Q[j][i], Zero0Loc ) then
                  Q[j][i] := PPPL_Mult( Q[j][i], cd );
               fi;
            od;
         fi;
#         ## change S
#         S[i][i] := PPPL_Mult( S[i][i], PPPL_Mult( cm, cd ) );
         ## change P (not going via S)
         P_change := PPPL_Check( [ cd[2], cd[1] ] );
         for j in [1..Length( P[i] )] do
            P[i][j] := PPPL_Mult( P[i][j], P_change );
         od;
      od;

      ## change S (and P) so that the denominators in S are One1
      ## and the entries in S are either Zero0 or One1 or a power of p
      for i in [1..Length( S[1] )] do
         if not PPPL_Equal( S[i][i], Zero0Loc ) then
            cm := [ One1, One1 ];
            cm[2] := S[i][i][2];
            if not PPP_Equal( S[i][i][1], One1 ) then
               cm[1] := PPrimePartPoly( S[i][i][1] );
            fi;
            if not PPPL_Equal( cm, PPPL_OneNC( cm ) ) then
               list := DivRowLoc( i, S, P, cm );
               S := list[1];
               P := list[2];
            fi;
         fi;
      od;

      ## compute the diagonal of S as p-power-polys
      S_diag := [];
      for i in [Length(S[1]),Length(S[1])-1..1] do
          if not PPP_Equal( S[i][i][2], One1 ) then
            list := PPP_QuotientRemainder( S[i][i][1], S[i][i][2] );
            if not PPP_Equal( list[2], Zero0 ) then 
               Error( "Something went wrong with S." );
            else S_diag[i] := list[1];
            fi;
         else S_diag[i] := S[i][i][1];
         fi;
      od;
      ## change Q to be over p-power-polys
      for i in [1..Length( Q )] do
         for j in [1..Length( Q )] do
            if not PPP_Equal( Q[i][j][2], One1 ) then
               list := PPP_QuotientRemainder( Q[i][j][1], Q[i][j][2] );
               if not PPP_Equal( list[2], Zero0 ) then 
                  Error( "Something went wrong with Q." );
               else Q[i][j] := list[1];
               fi;
            else Q[i][j] := Q[i][j][1];
            fi;
         od;
      od;

      return rec(norm := S_diag, rowtrans := P, coltrans := Q );
   end);

###############################################################################
##
## UnLocSmithNFPPowerPolyCol( SNF )
##
## Comment: technical method (it takes the output of the Smith normal form
##          method (which returns tonly the Smith normal form and the
##          column transformation matrix) and changes the Smith normal form 
##          and the column transformation matrix to be over non-quotient 
##          elements
##
InstallMethod( UnLocSmithNFPPowerPolyCol, [ IsRecord ], 
   function( SNF )
      local S, Q, One1, Zero0, i, cm, cm_inv, j, list, S_diag, Zero0Loc,
            cd, test, test2, k;

      if not IsBound( SNF!.coltrans ) then
         Error( "Wrong input." );
      fi;
      S := SNF!.norm;
      Q := SNF!.coltrans;

      One1 := PPP_OneNC( S[1][1][1] );
      Zero0 := PPP_ZeroNC( S[1][1][1] );
      Zero0Loc := PPPL_ZeroNC( S[1][1] );

      ## change S (and Q) so that Q is over p-power-polys/One1
      ## find a "least" common multiple of the denominators in each column
      ## and afterwards check for a common p-prime divisor of the numerators  
      ## in each column
      for i in [1..Length( Q[1] )] do
         cm := One1;
         for j in [1..Length( Q )] do
            if not PPP_Equal( Q[j][i][2], One1 ) then
               list := PPP_QuotientRemainder( cm, Q[j][i][2] );
               if not PPP_Equal( list[2], Zero0 ) then
                  cm := ShallowCopy( PPP_Mult( cm, Q[j][i][2] ) );
               fi;
            fi;
         od;
         if not PPP_Equal( cm, One1 ) then
            ## change column i of S and Q 
            cm := [ cm, One1 ];
            for j in [1..Length( Q )] do
               if not PPPL_Equal( Q[j][i], Zero0Loc ) then
                  Q[j][i] := PPPL_Mult( Q[j][i], cm );
               fi;
            od;
            ## check for common p-prime divisor of the numerators in column
            cd := One1;
            j := 1;
            test := false;
            while j <= Length( Q ) and test = false do
               if not PPP_Equal( Q[j][i][1], Zero0 ) then
                  cd := PPrimePartPoly( Q[j][i][1] );
                  k := 1;
                  test2 := true;
                  while k <= Length(Q) and test2 = true do
                     if not PPP_Equal( PPP_QuotientRemainder( Q[k][i][1], cd )[2], Zero0 ) then
                        test2 := false;
                        j := j + 1;
                     else k := k + 1;
                     fi;
                  od;
                  if test2 = true and k > Length(Q) then
                     test := true;
                  fi;
               else j := j + 1;
               fi;
            od;
            if j > Length( Q ) then
               cd := [ One1, One1 ];
            else cd := [ One1, cd ];
            fi;
            ## change Q again, now with cd:
            for j in [1..Length( Q )] do
               if not PPPL_Equal( Q[j][i], Zero0Loc ) then
                  Q[j][i] := PPPL_Mult( Q[j][i], cd );
               fi;
            od;
#            ## change S
#            S[i][i] := PPPL_Mult( S[i][i], PPPL_Mult( cm, cd ) );
#            can move directly to P (see above) and thus not computed here
         fi;
      od;

      ## change S so that elements in S have denominator One1
      ## and the entries in S are either Zero0 or One1 or a power of p
      for i in [1..Length( S[1] )] do
         if not PPPL_Equal( S[i][i], Zero0Loc ) then
            cm := [ One1, One1 ];
            cm[2] := S[i][i][2];
            if not PPP_Equal( S[i][i][1], One1 ) then
               cm[1] := PPrimePartPoly( S[i][i][1] );
            fi;
            if not PPP_Equal( cm, PPPL_OneNC( cm ) ) then
               S := DivRowLoc_NonP( i, S, cm );
            fi;
         fi;
      od;

      ## compute the diagonal of S over p-power-polys
      S_diag := [];
      for i in [Length(S[1]),Length(S[1])-1..1] do
          if not PPP_Equal( S[i][i][2], One1 ) then
            list := PPP_QuotientRemainder( S[i][i][1], S[i][i][2] );
            if not PPP_Equal( list[2], Zero0 ) then 
               Error( "Something went wrong with S." );
            else S_diag[i] := list[1];
            fi;
         else S_diag[i] := S[i][i][1];
         fi;
      od;
      ## change Q to be over p-poewr-polys
      for i in [1..Length( Q )] do
         for j in [1..Length( Q )] do
            if not PPP_Equal( Q[i][j][2], One1 ) then
               list := PPP_QuotientRemainder( Q[i][j][1], Q[i][j][2] );
               if not PPP_Equal( list[2], Zero0 ) then 
                  Error( "Something went wrong with Q." );
               else Q[i][j] := list[1];
               fi;
            else Q[i][j] := Q[i][j][1];
            fi;
         od;
      od;

      return rec(norm := S_diag, coltrans := Q );
   end);

#E SchurExtension.gi . . . . . . . . . . . . . . . . . . . . . . .  ends here

