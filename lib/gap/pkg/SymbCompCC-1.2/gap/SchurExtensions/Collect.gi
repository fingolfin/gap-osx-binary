###############################################################################
##
#F Collect.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## What do the element of p-power-poly-pcp-groups look like?
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

## store relations
## r_i_j is a list of lists where r_i_j[i][j] gives the relations described 
## above.
## then r_i_j[i][j] consists of the list of lists [[k,l]_k,l] where k gives 
## the generator and l the exponent (l is positive).
## Keep in mind that to each realtion r_i_j[i][j] there belongs the 
## tail x_i,j.

###############################################################################
##
## GetFullWord( list , p , n , d )
##
## [ IsList, IsPosInt, IsPosInt, IsPosInt ],
##
## Comment: technical function (change [..,[i,j],..] in [..,j,..] (j in 
##          position i))
##
InstallMethod( GetFullWord,
   "generate full word out of parts",
   [ IsList, IsPosInt, IsPosInt, IsPosInt ],
   function( list , p , n , d )
      local res , Zero0 , i;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the second parameter has to be a prime.");
      fi;

      res := [];
      Zero0 := Int2PPowerPoly( p , 0 );
      for i in [1..n] do
         res[i] := 0;
      od;
      for i in [1..d] do
         res[n+i] := Zero0;
      od;
      for i in [1..Length( list )] do
         res[list[i][1]] := list[i][2];
      od;
   
      return res;
   end);

###############################################################################
##
## PosTails( i , j )
##
## [ IsPosInt, IsPosInt ],
##
## Comment: technical function (position of x_i,j in list)
##
InstallMethod( PosTails,
   "get position of tail x_i,j",
   [ IsPosInt, IsPosInt ],
   function( i , j )
      local pos;

      pos := (i*(i-1)/2) + j;

      return pos;
   end);

###############################################################################
##
## TailsPos( l, lim )
##
## [ IsPosInt, IsPosInt ], 
##
## Comment: technical function (i,j of position l in tails)
##
InstallMethod( TailsPos,
   "get i,j of tail-position l",
   [ IsPosInt, IsPosInt ], 
   function( l, lim )
      local i,j;

      i := lim;

      ## lim = n+d
      while l - (i*(i-1)/2) < 0 do
         i := i - 1;
      od;
      j := l - (i*(i-1)/2);

      return [i,j];
   end);

###############################################################################
##
## Reduce_x_ij( p, n, d, x_ij_in, pos, expo )
##
## [ IsPosInt, IsPPowerPoly, IsPPowerPoly, IsPosInt ]
##
## Comment: technical function (reduce x)
##
InstallGlobalFunction( Reduce_x_ij, 
   function( p, n, d, x_ij_in, pos, expo )
      local x_ij, list, i, j;

      x_ij := StructuralCopy( x_ij_in );

      if not IsPrimeInt(p) then 
         Error("Wrong input, the first parameter has to be a prime.");
      fi;

      list := TailsPos( pos, n+d );
      i := list[1];
      j := list[2];

      if i > n and j > n and i <> j then
         list := PPP_QuotientRemainder( x_ij, expo );
         return list[2];
      else return x_ij;
      fi;

   end);

###############################################################################
##
## Add_x_ij( p, n, d, pos, x_i, x_j, div_i, div_j, expo )
##
## [ IsPosInt, IsInt, IsInt, IsPPowerPoly, IsPPowerPoly, IsInt, 
##   IsInt, IsPPowerPoly ]
##
## Comment: technical function (add tails, paying attention to *.div)
##
InstallGlobalFunction( Add_x_ij, 
   function( p, n, d, pos, x_i, x_j, div_i, div_j, expo )
      local x, div_x, Elm_i, Elm_j, m_i, m_j, min_pos;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the first parameter has to be a prime.");
      fi;

      ## get min_pos, as higher pos-tails have to be reduced
      min_pos := PosTails( n, n );
   
      ## add and reduce, paying attention to the different possible divs
      ## both divs are 1, so nothing to do
      if (div_i = 1) and (div_j = 1) then
         x := PPP_Add( x_i, x_j );
         div_x := 1;
         x := Reduce_x_ij( p, n, d, x, pos, expo );
      elif div_i = 1 then
         ## only one div is 1, so fractional arithmetic
         Elm_i := Int2PPowerPoly( p, div_j );
         x := PPP_Add( PPP_Mult(Elm_i, x_i ), x_j );
         div_x := div_j;
         x := Reduce_x_ij( p, n, d, x, pos, expo );
      elif div_j = 1 then
         ## same as last
         Elm_j := Int2PPowerPoly( p, div_i );
         x := PPP_Add( x_i, PPP_Mult( Elm_j, x_j ) );
         div_x := div_i;
         x := Reduce_x_ij( p, n, d, x, pos, expo );
      else
         ## both divs >= 1, so get lcm and use frational arithmetic
         div_x := Maximum( div_i, div_j );
         m_i := div_x / div_i;
         m_j := div_x / div_j;
         Elm_i := Int2PPowerPoly( p, m_i );
         Elm_j := Int2PPowerPoly( p, m_j );
         x := PPP_Add( PPP_Mult( Elm_i, x_i ), PPP_Mult( Elm_j, x_j ) );
         x := Reduce_x_ij( p, n, d, x, pos, expo );
      fi;

      ## check if trivial case
      if div_x <> 1 then
         if PPP_Equal( x, PPP_ZeroNC( x ) ) then
            div_x := 1;
         fi;
      fi;

      ## check if we can cancel
      if div_x <> 1 then
         if Length( x[2] ) = 1 then
            if IsInt( x[2][1] / div_x ) then
               x[2][1] := x[2][1] / div_x;
               div_x := 1;
            fi;
         fi;
      fi;

      return [ x, div_x ];
   end);

###############################################################################
##
## Mult_x_ij( p, n, d, pos, x_i, x_j, div_i, div_j, expo )
##
## [ IsPosInt, IsInt, IsInt, IsPPowerPoly, IsPPowerPoly, IsInt, 
##   IsInt, IsPPowerPoly ]
##
## Comment: technical function (multiply tails, paying attention to *.div)
##
InstallGlobalFunction( Mult_x_ij,
   function( p, n, d, pos, x_i, x_j, div_i, div_j, expo )
      local x, div_x;

      if not IsPrimeInt( p ) then 
         Error("Wrong input, the first parameter has to be a prime.");
      fi;

      ## multiply
      x := PPP_Mult( x_i, x_j );
      div_x := div_i * div_j;
      ## reduce x
      x := Reduce_x_ij( p, n, d, x, pos, expo );

      ## check if trivial case
      if div_x <> 1 then
         if PPP_Equal( x, PPP_ZeroNC( x ) ) then
            div_x := 1;
         fi;
      fi;

      ## check if we can cancel
      if div_x <> 1 then
         if Length( x[2] ) = 1 then
            if IsInt( x[2][1] / div_x ) then
               x[2][1] := x[2][1] / div_x;
               div_x := 1;
            fi;
         fi;
      fi;

      return [ x, div_x ];
   end);

###############################################################################
##
## Reduce_g_i( word_in,tails_in,div_in,n,d,p,i,wstack_in,l_in,rel_i_j,expo )
##
## [ IsList, IsList, IsList, IsPosInt, IsPosInt, IsPosInt, IsPosInt, IsList, 
##   IsInt, IsList, IsPPowerPoly ]
##
## Comment: technical function (reduce g_i)
##
InstallGlobalFunction( Reduce_g_i,
   function( word_in,tails_in,div_in,n,d,p,i,wstack_in,l_in,rel_i_j,expo )
      local div, word, tails, wstack, l, j, help, l_help, pos, Zero0, One1, 
            list, k;

      if not IsPrimeInt(p) then 
         Error( "Wrong input, the sixth parameter has to be a prime." );
      fi;

      word := StructuralCopy( word_in );
      tails := StructuralCopy( tails_in );
      wstack := StructuralCopy( wstack_in );

      div := StructuralCopy( div_in );
      l := StructuralCopy( l_in );

      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      ## if exponent of g is greater than p, then we  have to reduce g
      if word[i] >= p then
         ## put t's on the stack
         for j in [n+d,n+d-1..n+1] do
            if not PPP_Equal( word[j], Zero0 ) then
               l := l + 1;
               wstack[l] := [j , word[j]];
               word[j] := Zero0;
            fi;
         od;
         ## put the rest of the g's on the stack
         for j in [n,n-1..i+1] do
            if word[j] <> 0 then
               l := l + 1;
               wstack[l] := [j , word[j]];
               word[j] := 0;
            fi;
         od;
      fi;
      ## get the relation
      help := MakeMutableCopyListPPP( rel_i_j[i][i] );
      l_help := Length( help );
      ## reduce g until exponent is < p
      while word[i] >= p do
         word[i] := word[i] - p;
         pos := PosTails( i ,i );
         list := Add_x_ij( p, n, d, pos, tails[pos], One1, div[pos], 1, expo );
         tails[pos] := list[1];
         div[pos] := list[2];
         ## put relation on stack
         for j in [l_help,l_help-1..1] do
            if help[j][1] > n then
               if not PPP_Equal( help[j][2], Zero0 ) then
                  l := l + 1;
                  wstack[l] := help[j];
               fi;
            elif help[j][2] <> 0 then
               for k in [1..help[j][2]] do
                  l := l + 1;
                  wstack[l] := [help[j][1],1];
               od;
            fi;
         od;
      od;

      return [ word, tails, div, wstack, l ];
   end);

###############################################################################
##
## Collect_t_ti( word_in, p, n, d, i, b, tails_in, div_in, rel_i_j, expo )
##
## [ IsList, IsPosInt, IsPosInt, IsPosInt, IsPosInt, IsPPowerPoly, 
##   IsList, IsList, IsPPowerPoly ]
##
## Comment: technical function (collecting g_1^e_1..g_n^e_n t_1^b1...t_d^bd 
##          * t_i^b)
##
InstallGlobalFunction( Collect_t_ti,
   function( word_in, p, n, d, i, b, tails_in, div_in, rel_i_j, expo )
      local j, pos, help, list, m, m_div, word, tails, div;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the second parameter has to be a prime.");
      fi;

      word := StructuralCopy( word_in );
      tails := StructuralCopy( tails_in );
      div := StructuralCopy( div_in );

      ## add the exponents
      word[n+i] := PPP_Add( word[n+i], b );

      ## reduce t_i, careful this is a recursive call, so only if >= expo
      if not PPP_Smaller( word[n+i], expo ) then
         list := Reduce_t_i( word, tails, div, n, d, p, n+i, rel_i_j, expo );
         word := list[1];
         tails := list[2];
         div := list[3];
      fi;

      ## correct the tails
      for j in [i+1,i+2..d] do
         pos := PosTails( n+j , n+i );
         help := Mult_x_ij( p, n, d, pos, b, word[n+j], 1, 1, expo );
         m := help[1];
         m_div := help[2];
         list := Add_x_ij( p,n,d,pos,tails[pos],m,div[pos],m_div,expo );
         tails[pos] := list[1];
         div[pos] := list[2];
      od;

      return [ word, tails, div ];
   end);

###############################################################################
##
## Reduce_t_i( word_in, tails_in, div_in, n, d, p, i, rel_i_j, expo )
##
## [ IsList, IsPosInt, IsPosInt, IsPosInt, IsPosInt, IsPPowerPoly, 
##   IsList, IsList, IsPPowerPoly ]
##
## Comment: technical function (reduce t_i (higher t's can still have too 
##          large relations))
##
InstallGlobalFunction( Reduce_t_i,
   function( word_in, tails_in, div_in, n, d, p, i, rel_i_j, expo )
      local pos, list, Zero0, One1, word, tails, div;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the sixth parameter has to be a prime.");
      fi;

      word := StructuralCopy( word_in );
      tails := StructuralCopy( tails_in );
      div := StructuralCopy( div_in );
   
      Zero0 := Int2PPowerPoly( p, 0 );
      One1 := Int2PPowerPoly( p, 1 );

      list := PPP_QuotientRemainder( word[i], expo );
      word[i] := StructuralCopy( list[2] );

      if not PPP_Equal( list[1], Zero0 ) then
         pos := PosTails( i, i );
         tails[pos] := PPP_Add( tails[pos], list[1] );
      fi;

      return [ word, tails, div ];
   end);

###############################################################################
##
## Collect_h_x_ij( h_in, i , j , c , p, n, d, expo )
##
## [ IsRecord, IsPosInt, IsPosInt, IsPPowerPoly, IsPosInt, IsPosInt,
##   IsPPowerPoly ]
##
## Comment: technical function (collecting h * x_{i,j}^c)
##
InstallGlobalFunction( Collect_h_x_ij,
   function( h_in, i , j , c , p, n, d, expo )
      local pos, list, h;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the fifth parameter has to be a prime.");
      fi;

      h := StructuralCopy( h_in );

      pos := PosTails( i , j );
      ## add tails
      list := Add_x_ij( p, n, d, pos, h.tails[pos], c, h.div[pos], 1, expo );
      h.tails[pos] := list[1];
      h.div[pos] := list[2];

      return h;
   end);

###############################################################################
##
## Collect_h_t_i( h_in , n , d , i , b, p, rel_i_j, expo )
##
## [ IsRecord, IsPosInt, IsPosInt, IsPosInt, IsPPowerPoly, IsPosInt, 
##   IsList, IsPPowerPoly ]
##
## Comment: technical function (collecting h * t_i^b)
InstallGlobalFunction( Collect_h_t_i,
   function( h_in , n , d , i , b, p, rel_i_j, expo )
      local h, list, word, tails, div, j;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the sixth parameter has to be a prime.");
      fi;

      h := StructuralCopy( h_in );

      word := h.word;
      tails := h.tails;
      div := h.div;

      ## collect the t's
      list := Collect_t_ti( word, p, n, d, i-n, b, tails, div, rel_i_j, expo );
      word := list[1];
      tails := list[2];
      div := list[3];

      ## reduce the t's
      for j in [1..d] do
         if not PPP_Smaller( word[n+j], expo ) then
            list := Reduce_t_i(word, tails, div, n, d, p, n+j, rel_i_j, expo);
            word := list[1];
            tails := list[2];
            div := list[3];
         fi;
      od;

      h.word := word;
      h.tails := tails;
      h.div := div;

      return h;
   end);

###############################################################################
##
## Collect_t_y( w_in, n , d , p , y , x_in , div_in, rel_i_j, expo )
##
## [ IsList, IsPosInt, IsPosInt, IsPosInt, IsPPowerPoly, IsList, IsList, 
##   IsList, IsPPowerPoly ]
##
## Comment: technical function (collecting t^y)
##
InstallGlobalFunction( Collect_t_y,
   function( w_in, n , d , p , y , x_in , div_in, rel_i_j, expo )
      local w, x, div, i, j, One1, Zero0, pos, elm, test, help, list, help2, 
            new_y, eval, value, c;

      if not IsPrimeInt(p) then 
         Error("Wrong input, the fourth parameter has to be a prime.");
      fi;

      w := StructuralCopy( w_in );
      x := StructuralCopy( x_in );
      div := StructuralCopy( div_in );

      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      if InfoLevel( InfoCollectingPPowerPoly ) = 1 then
         Print("\n Doing t_y: w = " );
         if IsInt( w[1] ) then
            Print( w[1] );
         else PPP_Print( w[1] );
         fi;
         for i in [2..Length( w )] do
            Print( ", " );
            if IsInt( w[i] ) then 
               Print( w[i] );
            else PPP_Print( w[i] );
            fi;
         od;
         Print( " y = " );
         if IsInt( y ) then
            Print( y );
         else PPP_Print( y );
         fi;
      fi;

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
            eval := EvaluatePPowerPoly( help, value+1 );
            if IsEvenInt( eval ) then
               ## divide help by 2
               new_y := y;
               c := ShallowCopy( help[2] );
               for i in [1..Length( c )] do
                  c[i] := c[i] / 2;
               od;
               help := PPP_Check( [ p, c ] );
            else ## divide y by 2;
               c := ShallowCopy( y[2] );
               for i in [1..Length( c )] do
                  c[i] := c[i] / 2;
               od;
               new_y := PPP_Check( [p, c] );
            fi;
            elm := StructuralCopy( PPP_Mult( help, new_y ) );
         else
            elm := StructuralCopy( PPP_Mult( PPP_Subtract( y, One1 ), y ) );
         fi;
      fi;

      ## collect the tails
      for i in [1..d-1] do
         for j in [i+1,i+2..d]do
            pos := PosTails( n+j , n+i );

            ## if one is 0, everything is 0 and we don't have to divide by 2
            if PPP_Equal( w[n+i], Zero0 ) or PPP_Equal( w[n+j], Zero0 ) then
               test := 1;
            fi;

            ## collect the tails
            if test = 0 then
               help2:=Mult_x_ij(p,n,d,pos,w[n+i],PPP_Mult( w[n+j], elm ),div[n+i],div[n+j]*2,expo);
            else ## we have already divides by 2
               help2:=Mult_x_ij(p,n,d,pos,w[n+i],PPP_Mult( w[n+j], elm ),div[n+i],div[n+j],expo);
            fi;
            list := Add_x_ij(p,n,d,pos,x[pos],help2[1],div[pos],help2[2],expo);
            x[pos] := list[1];
            div[pos] := list[2];
         od;
      od;

      ## collect the t's   
      for i in [1..d] do
         w[n+i] := PPP_Mult( w[n+i], y );
         list := Reduce_t_i( w, x, div, n, d, p, n+i, rel_i_j, expo );
         w := list[1];
         x := list[2];
         div := list[3];
      od;

      return [ w , x , div ];
   end);

###############################################################################
##
## Collect_h_g_i( h_in , n , d , i , rel_i_j , expo )
##
## [ IsRecord, IsPosInt, IsPosInt, IsPosInt, IsList, IsPPowerPoly ] 
##
## Comment: technical function (collecting h*g_i)
##
InstallGlobalFunction( Collect_h_g_i,
   function( h_in , n , d , i , rel_i_j , expo )
      local word, tails, wstack, l, u, e, res, j, help, k, m, list, s, l_r, p, 
            div, Zero0, One1, pos, exp_pexp, wstack_2, h;

      h := StructuralCopy( h_in );
      p := h.prime;
      word := h.word;
      tails := h.tails;
      div := h.div;
      wstack := [[i,1]];

      Zero0 := Int2PPowerPoly( p, 0 ); 
      One1 := Int2PPowerPoly( p, 1 );
   
      ## run until stacks are empty
      l := 1;
      while l > 0 do

         ## for checking!!!!
         if InfoLevel( InfoCollectingPPowerPoly ) = 1 then
            wstack_2 := [];
            for j in [1..l] do
               wstack_2[j] := wstack[j];
            od;
            Print( "\nword = " );
            PPP_PrintRow( word );
            Print( " tails = " );
            PPP_PrintRow( tails );
            Print( " wstack = [ [ ", wstack_2[1][1], ", " );
            if IsInt( wstack_2[1][2] ) then
               Print( wstack_2[1][2], " ]" );
            else PPP_Print( wstack_2[1][2] );
               Print( " ]" );
            fi;
            for j in [2..Length( wstack_2 )] do
               Print( ", [ [ " );
               if IsInt( wstack_2[j][2] ) then
                  Print( wstack_2[j][2], " ]" );
               else PPP_Print( wstack_2[j][2] );
                  Print( " ]" );
               fi;
            od;
            Print( " ]" );
            Print( "\n div = ", div, "\n" );
         fi;

         ## take a generator and its exponent
         u := wstack[l][1];
         e := wstack[l][2];

         if InfoLevel( InfoCollectingPPowerPoly ) = 1 then
            Print("\n u = ", u, " e = " );
            if IsInt( e ) then
               Print( e );
            else PPP_Print( e );
               Print( "\n" );
            fi;
         fi;

         ## correct stack length
         ## if u <= n and e > 1 than keep [u,e-1] on stack, to do later
         ## note: u <= n and e>1 should not occur
         if u > n or e = 1 then
            l := l - 1;
         else wstack[l][2] := wstack[l][2] - 1;
         fi;

         j := n+d;
         ## if we take a g from the stack
         if u <= n then
            while u < j do
               ## conjugate through higher, first t's
               if j > n then
                  if not PPP_Equal( word[j], Zero0 ) then
                     ## put rest on stack
                     for k in [n+d,n+d-1..j+1] do
                        if not PPP_Equal( word[k], Zero0 ) then
                           l := l + 1;
                           wstack[l] := [k,  word[k]];
                           word[k] := Zero0;
                        fi;
                     od;
                     ## do the tails
                     pos := PosTails( j , u );
                     list:=Add_x_ij(p,n,d,pos,tails[pos],word[j],div[pos],1,expo);
                     tails[pos] := list[1];
                     div[pos] := list[2];
                     ## get the relation
                     help := MakeMutableCopyListPPP( rel_i_j[j][u] );
##                     help := StructuralCopy( rel_i_j[j][u] );
                      help := GetFullWord( help , p, n, d );
                     ## possibly power relation
                     if not PPP_Equal( word[j], One1 ) then
                        list:=Collect_t_y(help,n,d,p,word[j],tails,div,rel_i_j,expo);
                        help := list[1];
                        tails := list[2];
                        div := list[3];
                     fi;
                     ## put relation on stack, first t-part
                     for k in [d,d-1..1] do
                        if not PPP_Equal( help[n+k], Zero0 ) then
                           l := l + 1;
                           wstack[l] := [n+k,help[n+k]];
                        fi;
                     od;
                     ## put relation on stack, now g-part
                     for k in [n,n-1..1] do
                        if help[k] <> 0 then
                           for i in [1..help[k]] do
                              l := l + 1;
                              wstack[l] := [k,1];
                           od;
                        fi;
                     od;
                     word[j] := Zero0;
                  fi;
               ## conjugacte through higher g's
               else pos := PosTails( j , u );
                  if word[j] <> 0 then
                     ## put t's on stack
                     for k in [n+d,n+d-1..n+1] do
                        if not PPP_Equal( word[k], Zero0 ) then
                           l := l + 1;
                           wstack[l] := [k,  word[k]];
                           word[k] := Zero0;
                        fi;
                     od;
                     ## put greater g's on stack
                     for k in [n,n-1..j+1] do
                       if word[k] <> 0 then
                           l := l + 1;
                           wstack[l] := [k,  word[k]];
                           word[k] := 0;
                        fi;
                     od;
                     ## correct the tails
                     exp_pexp := Int2PPowerPoly( p, word[j] );
                     list:=Add_x_ij(p,n,d,pos,tails[pos],exp_pexp,div[pos],1,expo);
                     tails[pos] := list[1];
                     div[pos] := list[2];
                     ## get relation
                     help := MakeMutableCopyListPPP( rel_i_j[j][u] );
##                     help := StructuralCopy( rel_i_j[j][u] );
                     l_r := Length( help );
                     ## put relations word[j]-times on stack
                     for k in [1..word[j]] do
                        for m in [l_r,l_r-1..1] do
                           if help[m][1] > n then
                              l := l + 1;
                              wstack[l] := [ help[m][1] , help[m][2] ];
                           else
                              if help[m][2] > 0 then
                                 for s in [1..help[m][2]] do
                                    l := l + 1;
                                    wstack[l] := [ help[m][1] , 1 ];
                                 od;
                              fi;
                           fi;
                        od;
                     od;
                     word[j] := 0;
                  fi;
               fi;
               j := j - 1;
            od;
            word[u] := word[u] + e;
            list := Reduce_g_i(word,tails,div,n,d,p,u,wstack,l,rel_i_j,expo);
            word := list[1];
            tails := list[2];
            div := list[3];
            wstack := list[4];
            l := list[5];
         ## if we take a t from the stack, collect
         else 
            h.word := word;
            h.tails := tails;
            h.div := div;
            res := Collect_h_t_i( h , n , d , u , e, p, rel_i_j, expo );
            word := res.word;
            tails := res.tails;
            div := res.div;
         fi;
      od;

      ## reduce the t's
      for i in [1..d] do
         if not PPP_Smaller( word[n+i], expo ) then
            list := Reduce_t_i(word, tails, div, n, d, p, n+i, rel_i_j, expo);
            word := list[1];
            tails := list[2];
            div := list[3];
         fi;
      od;
   
      h.word := word;
      h.tails := tails;
      h.div := div;

      return h;
   end);

#E Collect.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
