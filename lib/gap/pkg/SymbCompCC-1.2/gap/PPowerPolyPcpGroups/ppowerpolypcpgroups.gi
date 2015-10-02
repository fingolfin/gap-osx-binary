###############################################################################
##
#F ppowerpolypcpgroups.gi     The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## Declare a new category to be able to handle the groups elements of the Schur 
## Extension with p-power-poly exponents
##

###############################################################################
##
#M  PPPPcpGroups( rel, n, d, m, expo, expo_vec, prime )
##
## Input: a list of relations rel, the numbers of the different generators n, 
##        m, d, the exponend of the t_i's expo, the list of exponents of the 
##        c_i's and a prime p
##
## Output: p-power-poly-pcp-groups (including checks)
##
InstallGlobalFunction( PPPPcpGroups,
    function( arg )
#   function( rel, n, d, m, expo, expo_vec, prime, cc, name )
      local prime, n, d, m, rel, expo, expo_vec, name, cc, i, j, k, obj;

      if Length( arg ) = 1 then
         prime := arg[1]!.prime;
         n := arg[1]!.n;
         d := arg[1]!.d;
         m := arg[1]!.m;
         rel := arg[1]!.rel;
         expo := arg[1]!.expo;
         expo_vec := arg[1]!.expo_vec;
         cc := arg[1]!.cc;
         name := arg[1]!.name;
      else rel := arg[1];
         n := arg[2];
         d := arg[3];
         m := arg[4];
         expo := arg[5];
         expo_vec := arg[6];
         prime := arg[7];
         cc := arg[8];
         name := arg[9];
      fi;

      if not IsPrime( prime ) then
      	 Error( "Wrong input. The seventh input has to be a prime." );
      elif Length( expo_vec ) <> m then
         Error( "Wrong input. The sixth input has to be a list of length the fourth input." );
      elif Length( rel ) <> n+d+m then
         Error( "Wrong input. See the manual for more information." );
      else i := 1;
         while i <= m do
            if not IsList( expo_vec[i] ) then
               Error( "Wrong input. See the manual for more information." );
            fi;
            i := i + 1;
         od;
      fi;
      i := 1;
      while i <= n+d+m do
         j := 1;
         if Length( rel[i] ) <> i then
            Error( "Wrong input. See the manual for more information." );
         fi;
         while j <= i do
            k := 1;
            while k <= Length( rel[i][j] ) do
               if rel[i][j][k][1] <= n then
                  if not IsInt( rel[i][j][k][2] ) then
                     Error( "Wrong input. See the manual for more information." );
                  fi;
               else
                  if not IsList( rel[i][j][k][2] ) then
                     Error( "Wrong input. See the manual for more information." );
                  fi;
               fi;
               k := k + 1;
            od;
            j := j + 1;
         od;
         i := i + 1;
      od; 
    
      obj := Objectify( NewType( PPPPcpGroupsFamily, IsPPPPcpGroupsRep ), rec(rel:=StructuralCopy(rel),n:=n,d:=d,m:=m,expo:=ShallowCopy(expo),expo_vec:=StructuralCopy(expo_vec),prime:=prime,cc:=cc,name:=name ) );

      if IsConsistentPPPPcp( obj ) then
         return obj;
      else Error( "The pp-presentation has to be consistent." );
      fi;

   end);

###############################################################################
##
#M  PPPPcpGroupsNC( rel, n, d, m, expo, expo_vec, prime )
##
## "for Schur extension with p-power-poly exponents", 
## [ IsList,IsPosInt,IsPosInt,IsPosInt,IsPPowerPoly,IsList,IsPosInt ], 
##
## Input: a list of relations rel, the numbers of the different generators n, 
##        m, d, the exponend of the t_i's expo, the list of exponents of the 
##        c_i's and a prime p
##
## Output: p-power-poly-pcp-groups (no checks)
##
InstallGlobalFunction( PPPPcpGroupsNC,
    function( arg )
#   function( rel, n, d, m, expo, expo_vec, primen cc, name )
      local prime, n, d, m, rel, expo, expo_vec, cc, name, i, j, k, obj;

      if Length( arg ) = 1 then
         prime := arg[1]!.prime;
         n := arg[1]!.n;
         d := arg[1]!.d;
         m := arg[1]!.m;
         rel := arg[1]!.rel;
         expo := arg[1]!.expo;
         expo_vec := arg[1]!.expo_vec;
         cc := arg[1]!.cc;
         name := arg[1]!.name;
      else rel := arg[1];
         n := arg[2];
         d := arg[3];
         m := arg[4];
         expo := arg[5];
         expo_vec := arg[6];
         prime := arg[7];
         cc := arg[8];
         name := arg[9];
      fi;

      if not IsPrime( prime ) then
         Error( "Wrong input. The seventh input has to be a prime." );
      elif Length( expo_vec ) <> m then
         Error( "Wrong input. The sixth input has to be a list of length the fourth input." );
      elif Length( rel ) <> n+d+m then
         Error( "Wrong input. See the manual for more information." );
      else i := 1;
         while i <= m do
            if not IsList( expo_vec[i] ) then
               Error( "Wrong input. See the manual for more information." );
            fi;
            i := i + 1;
         od;
      fi;
      i := 1;
      while i <= n+d+m do
         j := 1;
         if Length( rel[i] ) <> i then
            Error( "Wrong input. See the manual for more information." );
         fi;
         while j <= i do
            k := 1;
            while k <= Length( rel[i][j] ) do
               if rel[i][j][k][1] <= n then
                  if not IsInt( rel[i][j][k][2] ) then
                     Error( "Wrong input. See the manual for more information." );
                  fi;
               else 
                  if not IsList( rel[i][j][k][2] ) then
                     Error( "Wrong input. See the manual for more information." );
                  fi;
               fi;
               k := k + 1;
            od;
            j := j + 1;
         od;
         i := i + 1;
      od; 
    
      obj := Objectify( NewType( PPPPcpGroupsFamily, IsPPPPcpGroupsRep ), rec(rel:=StructuralCopy(rel),n:=n,d:=d,m:=m,expo:=ShallowCopy(expo),expo_vec:=StructuralCopy(expo_vec),prime:=prime,cc:=cc,name:=name ) );

      return obj;

   end);

###############################################################################
##
#M PPPPcpGroupsElement( grp_pres, word )
##
## Input: a list word that represents a word and p-power-poly-pcp-groups 
##        grp_pres (accepts collected or uncollected words)
##
## Output: word as an element of grp_pres (including checks)
##
InstallMethod(PPPPcpGroupsElement,[IsPPPPcpGroups,IsList],0,
   function( grp_pres, word )
      local m, div; 

      m := grp_pres!.m;
      div := List( [1..m], x -> 1 );

      return PPPPcpGroupsElement( grp_pres, word, div );
   end);

###############################################################################
##
#M  PPPPcpGroupsElementNC( grp_pres, word )
##
## Input: a list word that represents a word and p-power-poly-pcp-groups 
##        grp_pres (accepts collected or uncollected words)
##
## Output: word as an element of grp_pres (no checks)
##
InstallMethod(PPPPcpGroupsElementNC,[IsPPPPcpGroups,IsList],0,
   function( grp_pres, word )
      local m, div; 

      m := grp_pres!.m;
      div := List( [1..m], x -> 1 );

      return PPPPcpGroupsElementNC( grp_pres, word, div );
   end);

###############################################################################
##
#M  PPPPcpGroupsElementNC( grp_pres, word, div )
##
## Input: a list word that represents a word together with a list div and 
##        p-power-poly-pcp-groups grp_pres (accepts collected or uncollected 
##        words)
##
## Output: word as an element of grp_pres (no checks)
##
InstallMethod(PPPPcpGroupsElementNC,[IsPPPPcpGroups,IsList,IsList],0,
   function( grp_pres, word, div )
      local i, obj; 

      if Length( div ) <> grp_pres!.m then
         Error( "The input has to be of the correct form, see the manual for more information." );
      elif word <> [] then
         i := 1;
         while i <= Length( word )  do
            if not IsList( word[i] ) then
                Error( "The second input has to be a list of lists of length two, see the manual for more information." );
            elif Length( word[i] ) <> 2 then
                Error( "The second input has to be a list of lists of length two, see the manual for more information." );
            elif word[i][1] > grp_pres!.n + grp_pres!.d + grp_pres!.m then
               Error( "The number of the generator has to be smaller then or equal to the total number of generators, see the manual for more information." );
            elif word[i][1] <= grp_pres!.n then
               if not IsInt( word[i][2] ) then 
                   Error( "The method can only handle exponents with integers as constant term, see the manual for more information." );
               fi;
            else
               if not IsList(word[i][2]) and not IsInt(word[i][2]) then
                   Error( "The input has to be of the correct form, see the manual for more information." );
               elif IsList(word[i][2]) and not grp_pres!.prime=word[i][2][1] then
                  Error( "The underlying primes are different, see the manual for more information." );
               elif IsInt( word[i][2] ) then
                  word[i][2] := Int2PPowerPoly( grp_pres!.prime, word[i][2] );
               fi;
            fi;
            i := i + 1;
         od;
      fi;

      i := 1;
      while i <= grp_pres!.m do
         if not IsPosInt( div[i] ) then
            Error( "The input has to be of the correct form, see the manual for more information." );
         else i := i + 1;
         fi;
      od;
 
      obj := Objectify( NewType( PPPPcpGroupsElementFamily, IsPPPPcpGroupsElementRep ), rec(word:=StructuralCopy(word),div:=StructuralCopy(div),grp_pres:=StructuralCopy(grp_pres) ) );

      return obj;

   end);

###############################################################################
##
#M  PPPPcpGroupsElement( grp_pres, word, div )
##
## Input: a list word that represents a word together with a list div and 
##        p-power-poly-pcp-groups grp_pres (accepts collected or uncollected 
##        words)
##
## Output: word as an element of grp_pres (including checks)
##
InstallMethod(PPPPcpGroupsElement,[IsPPPPcpGroups,IsList,IsList],0,
   function( grp_pres, word, div )
      local obj;

      obj := PPPPcpGroupsElementNC( grp_pres, word, div );
      if COLLECT_PPOWERPOLY_PCP then
         obj := CollectPPPPcp( obj );
      fi;

      return obj;

   end);

###############################################################################
##
#M PrintObj( obj )
##
## Input: p-power-poly-pcp-groups obj
##
## Output: the method prints obj
##
InstallMethod( PrintObj, [ IsPPPPcpGroups ],
    function( obj )
       local i, p, expo, expo_vec;

       Print( "< P-Power-Poly-pcp-groups with ", obj!.n+obj!.d+ obj!.m ); 
       Print( " generators of relative orders [ " );
       p := obj!.prime;
       expo := obj!.expo;
       expo_vec := obj!.expo_vec;

       ## first n-part
       if obj!.n > 0 then
          Print( p );
       fi;
       for i in [2..obj!.n] do
          Print( ",", p );
       od;

       ## then d-part
       if obj!.n = 0 and obj!.d > 0 then
          Print( expo );
       elif obj!.d > 0 then
          Print( "," );
          PPP_Print( expo );
       fi;
       for i in [2..obj!.d] do
          Print( "," );
          PPP_Print( expo );
       od;

       ## finally m-part
       if obj!.n = 0 and obj!.d = 0 and obj!.m > 0 then
          PPP_Print( expo_vec[1] );
       elif obj!.m > 0 then
          Print( "," );
          PPP_Print( expo_vec[1] );
       fi;
       for i in [2..obj!.m] do
          Print( "," );
          PPP_Print( expo_vec[i] );
       od;

       Print( " ] >\n" );

   end);

###############################################################################
##
#M  ViewObj( obj )
##
## Input: p-power-poly-pcp-groups obj
##
## Output: the method prints obj
##
InstallMethod( ViewObj, [ IsPPPPcpGroups ],
    function( obj )
       local strg, i, p, expo, expo_vec;

       Print( "< P-Power-Poly-pcp-groups with ", obj!.n+obj!.d+ obj!.m ); 
       Print( " generators of relative orders [ " );
       p := obj!.prime;
       expo := obj!.expo;
       expo_vec := obj!.expo_vec;

       ## first n-part
       if obj!.n > 0 then
          Print( p );
       fi;
       for i in [2..obj!.n] do
          Print( ",", p );
       od;

       ## then d-part
       if obj!.n = 0 and obj!.d > 0 then
          PPP_Print( expo );
       elif obj!.d > 0 then
          Print( "," );
          PPP_Print( expo );
       fi;
       for i in [2..obj!.d] do
          Print( "," );
          PPP_Print( expo );
       od;

       ## finally m-part
       if obj!.n = 0 and obj!.d = 0 and obj!.m > 0 then
          PPP_Print( expo_vec[1] );
       elif obj!.m > 0 then
          Print( "," );
          PPP_Print( expo_vec[1] );
       fi;
       for i in [2..obj!.m] do
          Print( "," );
          PPP_Print( expo_vec[i] );
       od;

       Print( " ] >" );

    end);

###############################################################################
##
#M Order( obj )
##
## Input: p-power-poly-pcp-groups obj
##
## Output: the orders of obj
##
InstallImmediateMethod( Order, IsPPPPcpGroups, 0, 
    function( obj )
       local i, ord, expo_vec;

       ## p is the relative order of g_1, ..., g_n
       ord := obj!.prime^obj!.n;

       ## expo is the relative order of t_1, ..., t_d
       for i in [1..obj!.d] do
          ord := PPP_Mult( ord, obj!.expo );
       od;

       ## expo_vec[i] is the relative order of c_i
       expo_vec := obj!.expo_vec;
       for i in [1..obj!.m] do
          ord := PPP_Mult( ord, expo_vec[i] );
       od;

       Print( "Order of the p-power-poly-pcp-groups: " );
       PPP_Print( ord );
       Print( "\n" );

       return ord;
   end);

###############################################################################
##
#M  PrintObj
##
## Input: a p-power-poly-pcp-groups element obj
##
## Output: the method prints obj
##
InstallMethod( PrintObj, [ IsPPPPcpGroupsElement ],
    function( obj )
       local word, div, n, d, m, p, One1, Zero0, i;

       if COLLECT_PPOWERPOLY_PCP then
          obj := CollectPPPPcp( obj );
       fi;

       word := obj!.word;
       div := obj!.div;

       if word = [] then
          Print( "<identity>" );
       else n := obj!.grp_pres!.n;
          d := obj!.grp_pres!.d;
          m := obj!.grp_pres!.m;
          p := obj!.grp_pres!.prime;
          One1 := Int2PPowerPoly( p, 1 );
          Zero0 := Int2PPowerPoly( p, 0 );
          for i in [1..Length( word  )] do
             if word[i][1] <= n then
                if word[i][2] > 0 then
                   Print( "g", word[i][1] );
                   if word[i][2] > 1 then
                      Print( "^", word[i][2] );
                   fi;
                fi;
             elif word[i][1] <= n+d then
                if not PPP_Equal( word[i][2], Zero0 ) then
                   Print( "t", word[i][1]-n );
                   if PPP_Greater( word[i][2], One1 ) then
                      Print( "^(" );
                      PPP_Print( word[i][2] );
                      Print( ")" );
                   fi;
                fi;
             else Print( "c", word[i][1]-(n+d) );
                if div[word[i][1]-n-d] <> 1 then
                   if not PPP_Equal( word[i][2], One1 ) then
                      Print( "^(" );
                      PPP_Print( word[i][2] );
                   else Print( "^(1" );
                   fi;
                   Print( "/", div[word[i][1]-n-d], ")" );
                elif not PPP_Equal( word[i][2], One1 ) then
                   Print( "^(" );
                   PPP_Print( word[i][2] );
                   Print( ")" );
                fi;
             fi;
             if i < Length( word ) then
                Print( "*" );
             fi;
          od;
       fi;

    end);

###############################################################################
##
## \in
##
## Input: a p-power-poly-pcp-groups element obj and p-power-poly-pcp-groups G
##
## Output: a boolean that indicates whether obj is an element of G
##
InstallMethod( \in, true, [ IsPPPPcpGroupsElement, IsPPPPcpGroups ], 1974,
   function( obj, G )
      local word, n, d, m, i;

      if obj!.grp_pres <> G then return false; fi;

      word := obj!.word;
      n := obj!.grp_pres!.n;
      d := obj!.grp_pres!.d;
      m := obj!.grp_pres!.m;
      for i in [1..Length( word )] do
         if word[i][1] > n+d+m then return false; fi;
         if word[i][1] <= n and not IsInt( word[i][2] ) then return false; fi;
      od;

      return true; 
    end);

###############################################################################
##
## ShallowCopy
##
## Input: a p-power-poly-pcp-groups element obj
##
## Output: a shallow copy of obj
##
InstallMethod( ShallowCopy, [ IsPPPPcpGroupsElement ], 
   function( obj )
      local word, div, grp_pres;

      word := StructuralCopy( obj!.word );
      div := StructuralCopy( obj!.div );
      grp_pres := StructuralCopy( obj!.grp_pres );

      return PPPPcpGroupsElement( grp_pres, word );
   end);

#############################################################################
##
#M PPP_Words_Equal( word1, word2, group_pres )
##
## Input: lists word1 and word2 and the corresponding p-power-poly-pcp-groups 
##        group_pres
##
## Output: a boolean, indicating whether word1 and word2 are equal
##
InstallGlobalFunction( "PPP_Words_Equal", 
   function( word1, word2, group_pres )
      local n, i;

      if Length( word1 ) <> Length( word2 ) then return false; fi;

      n := group_pres!.n;

      for i in [1..Length( word1 )] do
        if word1[i][1] <> word2[i][1] then return false; fi;
        if word1[i][1] <= n and word1[i][2] <> word2[i][2] then return false; fi;
        if i > n and not PPP_Equal( word1[i][2], word2[i][2] ) then 
           return false; 
        fi;
      od;

      return true;
   end);

#############################################################################
##
#M  \=( objj1, objj2 )
##
## Input: p-power-poly-pcp-groups elements objj1 and objj2
##
##Output: a boolean indicating whether objj1 equals objj2
##
InstallMethod( \=, [ IsPPPPcpGroupsElement, IsPPPPcpGroupsElement ],
   function( objj1, objj2 )
      local obj1, obj2, p, n, d, m, group_pres, div1, div2, word1, word2, 
            expo_vec, vec, i, mult, test1, test2;

      obj1 := CollectPPPPcp( objj1 );;
      obj2 := CollectPPPPcp( objj2 );;
      if obj1!.grp_pres = obj1!.grp_pres then
         if PPP_Words_Equal( obj1!.word, obj2!.word, obj1!.grp_pres ) and obj1!.div = obj2!.div then
            return true; 
         elif ForAny(obj1!.div,x->x<>1) or ForAny(obj2!.div,x->x<>1) then
            div1 := obj1!.div;
            div2 := obj2!.div;
            word1 := StructuralCopy( obj1!.word );;
            word2 := StructuralCopy( obj2!.word );;
            group_pres := obj1!.grp_pres;
            p := group_pres!.prime;
            n := group_pres!.n;
            d := group_pres!.d;
            m := group_pres!.m;
            expo_vec := group_pres!.expo_vec;
            for i in [1..Length( word1 )] do
               if word1[i][1] > n+d and div2[word1[i][1]-n-d] <> 1 then
                  mult := Int2PPowerPoly( p, div2[word1[i][1]-n-d] );
                  word1[i][2] := Reduce_ci_ppowerpolypcp( PPP_Mult( word1[i][2], mult ), div1[word1[i][1]-n-d], word1[i][1]-n-d, expo_vec )[1];
               fi;
            od;
            for i in [1..Length( word2 )] do
               if word2[i][1] >= n+d and div1[word2[i][1]-n-d] <> 1 then
                  mult := Int2PPowerPoly( p, div1[word1[i][1]-n-d] );
                  word2[i][2] := Reduce_ci_ppowerpolypcp( PPP_Mult( word2[i][2], mult ), div2[word2[i][1]-n-d], word2[i][1]-n-d, expo_vec )[1];
               fi;
            od;
            ## initialize div-vec
            vec := [];
            for i in [1..m] do
               vec[i] := div1[i]*div2[i];
            od;

            test1 := PPPPcpGroupsElement( group_pres, word1, vec );;
            test2 := PPPPcpGroupsElement( group_pres, word2, vec );;

            return test1=test2;
         fi;
      else Error( "The underlying PPPPcpGroups are different."  );
      fi;

   end);

#############################################################################
##
#M \*( obj1, obj2 )
##
## Input: p-power-poly-pcp-groups elements obj1 and obj2
##
## Output: the product of obj1 and obj2
##
InstallMethod( \*, [ IsPPPPcpGroupsElement, IsPPPPcpGroupsElement ],
   function( obj1, obj2 )
      local p, n, d, word1, word2, div1, div2, l1, l2, i, obj;

      p := obj1!.grp_pres!.prime;
      n := obj1!.grp_pres!.n;
      d := obj1!.grp_pres!.d;

      if obj1!.grp_pres = obj2!.grp_pres then
         word1 := StructuralCopy( obj1!.word );
         div1 := StructuralCopy( obj1!.div );
         word2 := obj2!.word;
         div2 := obj2!.div;
         l1 := Length( word1 );
         l2 := Length( word2 );
         if div1 <> div2 then
            ## if div is not trivial then act accordingly
            for i in [1..l2] do
               if word2[i][1] > n+d then
                  word2[i][2] := PPP_Mult( word2[i][2], Int2PPowerPoly( p, div1[word2[i][1]-n-d] ) );
               fi;
            od;
            for i in [1..l1] do
               if word1[i][1] > n+d then
                  word1[i][2] := PPP_Mult( word1[i][2], Int2PPowerPoly(p,div2[word1[i][1]-n-d] ) );
               fi;
            od;

         fi;
         for i in [l2, l2-1..1] do
            word1[l1+i] := word2[i];
         od;
         for i in [1..obj1!.grp_pres!.m] do
            div1[i] := div1[i]*div2[i];
         od;
         obj := PPPPcpGroupsElement( obj1!.grp_pres, word1, div1 );
            if COLLECT_PPOWERPOLY_PCP then
               obj := CollectPPPPcp( obj );
            fi;
            return obj;
      else Error( "The underlying PPPPcpGroups are different."  );
      fi;

   end);

#############################################################################
##
#M Inverse( obj )
##
## Input: a p-power-poly-pcp-groups elements obj
##
## Output: the inverse of obj
##
InstallMethod( Inverse, [ IsPPPPcpGroupsElement ],
   function( obj )

      return obj^-1;
   end);

#############################################################################
##
#M \^-1( obj )
##
## Input: a p-power-poly-pcp-groups elements obj
##
## Output: the inverse of obj
##
InstallMethod( INV, [ IsPPPPcpGroupsElement ],
   function( obj )
      local word, l, i, n;

      n := obj!.grp_pres!.n;

      word := [];
      l := Length( obj!.word );
      for i in [1..l] do
         word[i] := [];
         word[i][1] := obj!.word[l+1-i][1];
         if word[i][1] <= n then
            word[i][2] := - StructuralCopy( obj!.word[l+1-i][2] );
         else word[i][2] := [];
            word[i][2][1] := obj!.word[l+1-i][2][1];
            word[i][2][2] := - obj!.word[l+1-i][2][2];
         fi;
      od;

      return PPPPcpGroupsElement( obj!.grp_pres, word, obj!.div );
   end);

InstallMethod( \/, [ IsPPPPcpGroupsElement, IsPPPPcpGroupsElement ],
   function( obj1, obj2 )

      return obj1 * obj2^-1;
   end);

#############################################################################
##
#M One( obj )
##
## Input: a p-power-poly-pcp-groups elements obj
##
## Output: the one corresponding to obj
##
InstallMethod( OneOp, [ IsPPPPcpGroupsElement ],
    elm -> PPPPcpGroupsElement( elm!.grp_pres, [] ) 
);

###############################################################################
##
## One( G )
##
## Input: p-power-poly-pcp-groups G
##
## Output: the one in G
##
InstallOtherMethod( One, true, [IsPPPPcpGroups], 102, 
   function( G )

      return PPPPcpGroupsElement( G, [] );
   end);

###############################################################################
##
## GeneratorsOfGroup
##
## Input: p-power-poly-pcp-groups G
##
## Output: the generators of G
##
InstallMethod( GeneratorsOfGroup, [ IsPPPPcpGroups ],
   function( G )
      local i, n, d, list;

      n := G!.n;
      d := G!.d;
      list := [];
      for i in [1..n] do
         list[i] := PPPPcpGroupsElement( G, [[i,1]] );
      od;
      for i in [1..d] do
         list[n+i] := PPPPcpGroupsElement( G, [[n+i,1]] );
      od;
      for i in [1..G!.m] do
         list[n+d+i] := PPPPcpGroupsElement( G, [[n+d+i,1]] );
      od;
      
      return list;
   end);

###############################################################################
##
#M IsConsistentPPPPcp( group_pres )
##
## Input: p-power-poly-pcp-groups group_pres
##
## Output: a boolean indicating whether group_pres is consistent
##
InstallMethod( IsConsistentPPPPcp, [ IsPPPPcpGroups ], 
   function( group_pres )
      local n, d, m, p, test, One1, Zero0, i, f_i, f_im, j, f_j, k, f_k, 
            help1, help2, help, exp1, exp2;

      n := group_pres!.n;
      d := group_pres!.d;
      m := group_pres!.m;
      p := group_pres!.prime;

      test := true;
      One1 := Int2PPowerPoly( p, 1 );
      Zero0 := Int2PPowerPoly( p, 0 );

      ## check consistency
      ## f_k(f_jf_i) = (f_kf_j)f_i, k>j>i
      i := 1; 
      while test and i <= n+d+m-2 do
         if i <= n then 
            f_i := PPPPcpGroupsElement( group_pres, [[i,1]] );
         else f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
         fi;
         j := i + 1;
         while test and j <= n+d+m-1 do
            if j <= n then 
               f_j := PPPPcpGroupsElement( group_pres, [[j,1]] );
            else f_j := PPPPcpGroupsElement( group_pres, [[j,One1]] );
            fi;
            k := j + 1;
            while test and k <= n+d+m do
               if k <= n then 
                  f_k := PPPPcpGroupsElement( group_pres, [[k,1]] );
               else 
                  f_k := PPPPcpGroupsElement( group_pres, [[k,One1]] );
               fi;
               help1 := StructuralCopy( CollectPPPPcp( f_j*f_i ) );
               help1 := StructuralCopy( CollectPPPPcp( f_k*help1 ) );
               help2 := StructuralCopy( CollectPPPPcp( (f_k*f_j)*f_i ) );
               if not help1 = help2 then 
                  test := false; 
               fi;

               if InfoLevel( InfoConsistencyPPPPcp ) > 0 and not test then
                  Print( "Failing consistency relation: (", k, "*", j, ")*", i, " = ", k, "*(", j, "*", i, ")\n" );
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) = 2 and test then
                  Print( "Checked relation: (", k, "*", j, ")*", i, " = ", k, "*(", j, "*", i, ")\n" );
               fi;
               k := k + 1;
            od;
            j := j + 1;
         od;
         i := i + 1;
      od;

      ## g_j^e_j g_i = g_j^(e_j-1)(g_jg_i), j>i
      i := 1;
      while i <= n+d+m-1 and test do
         if i <= n then
            f_i := PPPPcpGroupsElement( group_pres, [[i,1]] );
         else f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
         fi;
         j := i + 1;
         while j <= n+d+m and test do
            if j <= n then
               f_j := PPPPcpGroupsElement( group_pres, [[j,1]] );
               exp1 := p;
               exp2 := exp1 - 1;
            elif j <= n+d then
               f_j := PPPPcpGroupsElement( group_pres, [[j,One1]] );
               exp1 := group_pres!.expo;
               exp2 := PPP_Subtract( exp1, One1 );
            else f_j := PPPPcpGroupsElement( group_pres, [[j,One1]] );
               exp1 := group_pres!.expo_vec[j-n-d];
               exp2 := PPP_Subtract( exp1, One1 );
            fi;
            if exp1 = p or ( not PPP_Equal( exp1, Zero0 ) ) then
               help1 := PPPPcpGroupsElement( group_pres, [[j,exp1]] );
               if not COLLECT_PPOWERPOLY_PCP then
                  help1 := StructuralCopy( CollectPPPPcp( help1 ) );
               fi;
               help1 := StructuralCopy( CollectPPPPcp( help1*f_i ) );
               help2 := StructuralCopy( CollectPPPPcp( f_j*f_i ) );
               help2 := StructuralCopy( CollectPPPPcp( PPPPcpGroupsElement( group_pres, [[j,exp2]] )*help2 ) );
               if not help1 = help2 then 
                  test := false; 
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) > 0 and not test then
                  Print( "Failing consistency relation: ", j, "^exp*", i, " = ", j, "^(exp-1)*(", j, "*", i, ")\n" );
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) = 2 and test then
                  Print( "Checked relation: ", j, "^exp*", i, " = ", j, "^(exp-1)*(", j, "*", i, ")\n" );
               fi;
            fi;
            j := j + 1;
         od;
         i := i + 1;
      od;

      ## g_jg_i^e_i = (g_jg_i)g_i^(e_i-1), j>i
      i := 1;
      while i <= n+d+m-1 and test do
         if i <= n then
            f_i := PPPPcpGroupsElement( group_pres, [[i,1]] );
            exp1 := p;
            exp2 := exp1 - 1;
         elif i <= n+d then
            f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
            exp1 := group_pres!.expo;
            exp2 := PPP_Subtract( exp1, One1 );
         else f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
            exp1 := group_pres!.expo_vec[i-n-d];
            exp2 := PPP_Subtract( exp1, One1 );
         fi;
         if exp1 = p or (not PPP_Equal( exp1, Zero0 ) ) then
            j := i + 1;
            while j <= n+d+m and test do
               if j <= n then
                  f_j := PPPPcpGroupsElement( group_pres, [[j,1]] );
               else f_j := PPPPcpGroupsElement( group_pres, [[j,One1]] );
               fi;
               help1 := CollectPPPPcp( PPPPcpGroupsElement( group_pres, [[i,exp1]] ) );
               if not COLLECT_PPOWERPOLY_PCP then
                  help1 := StructuralCopy( CollectPPPPcp( help1 ) );
               fi;
               help1 := StructuralCopy( CollectPPPPcp( f_j*help1 ) );
               help2 := StructuralCopy( CollectPPPPcp( f_j*f_i ) );
               help2 := StructuralCopy( CollectPPPPcp( help2*PPPPcpGroupsElement( group_pres, [[i,exp2]] ) ) );
               if help1 <> help2 then 
                  test := false; 
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) > 0 and not test then
                  Print( "Failing consistency relation: ", j, "*", i, "^exp = (", j, "*", i, ")*", i, "^(exp-1))\n" );
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) = 2 and test then
                  Print( "Checked relation: ", j, "*", i, "^exp = (", j, "*", i, ")*", i, "^(exp-1))\n" );
               fi;
               j := j + 1;
            od;
         fi;
         i := i + 1;
      od;

      ## g_i^e_ig_i = g_ig_i^e_i
      i := 1;
      while i <= n+d+m and test do
         if i <= n then
            f_i := PPPPcpGroupsElement( group_pres, [[i,1]] );
            exp1 := p;
         elif i <= n+d then
            f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
            exp1 := group_pres!.expo;
         else f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
            exp1 := group_pres!.expo_vec[i-n-d];
         fi;
         if exp1 = p or (not PPP_Equal( exp1, Zero0 ) ) then
            help := CollectPPPPcp( PPPPcpGroupsElement( group_pres, [[i,exp1]] ) );
            if not COLLECT_PPOWERPOLY_PCP then
               help := StructuralCopy( CollectPPPPcp( help ) );
            fi;
            help1 := StructuralCopy( CollectPPPPcp( help*f_i ) );
            help2 := StructuralCopy( CollectPPPPcp( f_i*help ) );
            if help1 <> help2 then 
               test := false; 
            fi;
            if InfoLevel( InfoConsistencyPPPPcp ) > 0 and not test then
               Print( "Failing consistency relation: (", i, "^exp)*", i, " = ", i, "*(", i, "^exp)\n" );
            fi;
            if InfoLevel( InfoConsistencyPPPPcp ) = 2 and test then
               Print( "Checked relation: (", i, "^exp)*", i, " = ", i, "*(", i, "^exp)\n" );
            fi;
         fi;
         i := i + 1;
      od;

      ## g_j = (g_jg_i^-1)g_i
      i := n+d+1;
      while i <= n+d+m-1 and test do
         if not PPP_Equal( group_pres!.expo_vec[i-n-d], Zero0 ) then
            f_i := PPPPcpGroupsElement( group_pres, [[i,One1]] );
            f_im := PPPPcpGroupsElement( group_pres, [[i,PPP_AdditiveInverse( One1 )]] );
            j := i + 1;
            while j <= n+d+m and test do
               help1 := PPPPcpGroupsElement( group_pres, [[j,One1]] );
               help2 := StructuralCopy( CollectPPPPcp( help1*f_im ) );
               help2 := StructuralCopy( CollectPPPPcp( help2*f_i ) );
               if help1 <> help2 then 
                  test := false;  
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) > 0 and not test then
                  Print( "Failing consistency relation: ", j, " = (", j, "*", i, "^-1)*", i, "\n" );
               fi;
               if InfoLevel( InfoConsistencyPPPPcp ) = 2 and test then
                  Print( "Checked relation: ", j, " = (", j, "*", i, "^-1)*", i, "\n" );
               fi;
               j := j + 1;
            od;
         fi;
         i := i + 1;
      od;

      return test;
   end);

###############################################################################
##
#M IsConsistentPPPPcp( ParPres )
##
## Input: a record ParPres presenting p-power-poly-pcp-groups
##
## Output: a boolean indicating whether ParPres is consistent
##
InstallMethod( IsConsistentPPPPcp, [ IsRecord ], 
   function( ParPres )
      local G;

      G := PPPPcpGroups( ParPres );
      return IsConsistentPPPPcp( G );
   end);

#E ppowerpolypcpgroups.gi . . . . . . . . . . . . . . . . . . . . .  ends here
