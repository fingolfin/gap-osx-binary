###############################################################################
##
#F ppowerpoly.gi            The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## p-power-poly-elements (= lists representing p-power-poly-elements)
##   sum_(i=0)^n k_i p^(ix)
## 
## where: x is an indeterminate over the integers,
##        p is a prime,
##        k_u in Q,
##        n in N_0.
##
## Input: prime p, coeffs [ k_0, k_1, ..., k_n ] and optional: ispdiv and pval
##        where ispdiv indicates whether the element is p-divsible or not, 
##        i.e., whether all k_i are p-divisible,
##        and pval is the p-adic valuation [i,j] of the element,
##        i.e., p^{i+jx} is the largest p-power, dividing the element.
##        ->    [p,[k_0,k_1, ..., k_n]] 
##           or [p,[k_0,k_1, ..., k_n],ispdiv] 
##           or [p,[k_0,k_1, ..., k_n],ispdiv,[i,j]].
##
## Example:  3^(x-1) + 2*3^(x-3) - 2*3^(2x+2) - 3^(2x-1) 
##         = 3^x ((3^2+2)/3^3) + 3^2x ((-2*3^3-1)/3)
##         = 3^x (11/27) + 3^(2x) (-55/3)
##         Input: [3, [0,11/27,-55/3]].
##
## The One:  [p, [ 1 ], true, [0,0] ].
## The Zero: [p, [ ], true, [infinity, infinity] ].
## 

###############################################################################
##
#F RedPPowerPolyCoeffs( elm )
##
## Input: a p-power-poly element [p,coeffs(,ispdiv,pval)].
##
## Output: a p-polwer-poly element with coeffs as short as possible, 
##         i.e., that the last entry in coeffs is not 0.
##
InstallGlobalFunction( RedPPowerPolyCoeffs, 
   function( elm )
      local list, i;

      list := elm[2];

      # check if there are 0's at the end
      i := Length(list);
      while i > 0 and list[i] = 0 do
          i := i - 1;
      od;

      ## eliminate 0's at the end if neccessary
      if i = 0 then 
          return [elm[1],[], true, [infinity, infinity] ]; 
      elif i = Length( list ) then 
          return elm;
      else
          elm[2] := list{ [1..i] };
          return elm;
      fi;
   end);

###############################################################################
##
#M IsPDivRat( q, p )
##
## Input: a rational q and an integer p.
##
## Output: a boolean, that indicates whether q is p-divisible or not, i.e.,
##         if the denominator of q is a power of p or not.
##
InstallMethod( IsPDivRat, true, [ IsRat, IsInt ], 0,
   function( q, p )
      local denom, test;

      denom := DenominatorRat( q );

      ## trivial case that denominator is 1
      if denom = 1 then return true; fi;

      ## check if denom is p-power (p given)
      test := p;
      while denom > test do
            test := p * test;
      od;
      if denom = test then
            return true;
      else 
            return false;
      fi;
   end);

###############################################################################
##
#M IsPDivisiblePPP( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: a boolean that indivates obj = sum_i k_i p^{ix} is p-divisible,
##         i.e., whether all coeffcients k_i are p-divisible, i.e., the
##         denominator of k_i is a power of p.
##
InstallGlobalFunction( IsPDivisiblePPP, 
   function( obj )
      local p;

      ## check if already computed
      if Length( obj ) > 2 then return obj[3]; fi;

      p := obj[1];

      return ForAll( obj[2], x -> IsPDivRat(x,p));
   end);

###############################################################################
##
#M PPP_Check( elm )
##
## Input: a p-power-poly element elm = [p,coeffs(,ispdiv,pval)].
##
## Output: elm with probably reduced coefficient list (if the last entries
##         in coeffs are 0) or an Error occurs if the input does not
##         represent a p-power-poly element.
##
InstallGlobalFunction( PPP_Check,
   function( elm )
      local p, coeffs, ispdiv, pval;

      if not IsList( elm ) then 
         Error( "The input has to be [p, coeffs(, ispdiv, pval) ] where p is prime and coeffs is a list of coefficients to represent sum_(i=0)^n k_i p^(ix) and TODO." ); 
      fi;

      p := elm[1];
      if not IsPrimeInt( p ) then 
         Error( "The first entry in the list has to be a prime." ); 
      fi;

      coeffs := elm[2];
      if not IsList( coeffs ) then 
         Error( "The second entry in the list has to be a list." ); 
      fi;

      if Length( elm ) > 2 then
         ispdiv := elm[3];
         if not IsBool( ispdiv) or IsPDivisiblePPP( elm ) <> ispdiv then 
            Error( "The third entry in the list has to be a boolean indicating p-divisibility." ); 
         fi;
      
         if Length( elm  ) > 3 then
            pval := elm[4];
            if PPP_PadicValue( elm ) <> pval then 
               Error( "The fourth entry in the list has to be the p-adic-value of the element." ); 
            fi;
         fi;
      fi;

      ## make sure that last coefficient is not 0
      if Length( coeffs ) > 0 and coeffs[Length( coeffs )] = 0 then 
         elm := RedPPowerPolyCoeffs( elm );
      fi;

      return elm;
   end);

###############################################################################
##
#M PPP_OneNC( elm )
##
## Input: a p-power-poly element elm = [p,coeffs(,ispdiv,pval)].
##
## Output: the corresponding one p-power-poly element.
## 
InstallGlobalFunction( PPP_OneNC,
   function( elm )

      return [ elm[1], [ 1 ], true, [ 0, 0 ] ];
   end );

###############################################################################
##
#M PPP_ZeroNC( elm )
##
## Input: a p-power-poly element elm = [p,coeffs(,ispdiv,pval)].
##
## Output: the corresponding zero p-power-poly element.
##
InstallGlobalFunction( PPP_ZeroNC, 
   function( elm )

      return [ elm[1], [], true, [ infinity, infinity ] ];
   end );

###############################################################################
##
#M Int2PPowerPoly( p, i )
##
## Input: a prime p and an integer i.
##
## Output: the p-power-poly element representing i.
##
InstallGlobalFunction( Int2PPowerPoly, 
   function( p, i )

      if not IsPrimeInt(p) then 
         Error("Wrong input, the first input has to be a prime.");
      fi;

      if not IsInt(i) then
         Error("Wrong input, the second input has to be an integer.");
      fi;

      ## get p-power-poly if possible with p-adic valuation
      if i = 0 then
         return [ p, [], true, [ infinity, infinity ] ];
      elif 0 < i and i < p then
         return [ p, [ i ], true, [ 0, 0 ] ];
      elif i < 0 and -p < i then
         return [ p, [ i ], true, [ 0, 0 ] ];
      else
         return [ p, [ i ] ];
      fi;

   end);

###############################################################################
##
#M PPP_Print( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: this function prints in an easy to read way.
##
InstallGlobalFunction( PPP_Print,
    function( obj )
       local p, c, l_c, strg, i, One1, start;

       p := obj[1];
       c := obj[2];
       One1 := PPP_OneNC( obj );

       ## check for trivial cases
       if c = [] then 
          Print( "0" );
       elif PPP_Equal( obj, One1 ) then
          Print( "1" );
       ## start printing
       else l_c := Length( c );
          start := false;

          ## print p^(0x)-part
          if c[1] <> 0 then
             Print( c[1] );
             start := true;
          fi;

          ## print p^x-part
          if l_c > 1 then
             if c[2] < 0 then
                if c[2] = -1 then
                   Print( "-" );
                else Print( c[2], "*" ); 
                fi;
                Print( p, "^x" );
                start := true;
             elif c[2] > 0 then
                if start then
                   Print( "+" );
                fi;
                if c[2] <> 1 then
                   Print( c[2], "*" );
                fi;
                Print( p, "^x" );
                start := true;
             fi;
          fi;

          ## print rest
          for i in [3..l_c] do
             if c[i] < 0 then
                if c[i] = -1 then
                   Print( "-" );
                else Print( c[i], "*" );
                fi;
                Print( p, "^(", i-1, "x)" );
                start := true;
             elif c[i] > 0 then
                if start then
                   Print( "+" );
                fi;
                if c[i] <> 1 then
                   Print( c[i], "*" );
                fi;
                Print( p, "^(", i-1,  "x)" );
                start := true;
             fi;
          od;
       fi;

    end);

###############################################################################
##
#M  PPP_PrintMat( obj )
##
## Input: a matrix with p-power-poly entries.
##
## Output: the function prints the matrix in an easy to read way.
##
InstallGlobalFunction( PPP_PrintMat, 
    function( obj )
    local i, j;

       Print( "[" );
       for i in [1..Length( obj )] do
          Print( "[ " );
          PPP_Print( obj[i][1] );
          for j in [2..Length( obj[i] )] do
             Print( ", " );
             PPP_Print( obj[i][j] );
          od;
          Print( "] " );
          if i <> Length( obj ) then
             Print( ",\n" );
          fi;
      od;
      Print( "]\n" );

   end);

###############################################################################
##
#M  PPP_PrintRow( obj )
##
## Input: a row of p-power-poly elements.
##
## Output: the functions prints the row in an easy to read way.
##
InstallGlobalFunction( PPP_PrintRow, 
    function( obj )
    local i, j;

       ## catch trivial case
       if obj = [] then Print( "[ ]\n" ); fi;

       Print( "[ " );
       if IsInt( obj[1] ) then 
          Print( obj[1] );
       else PPP_Print( obj[1] );
       fi;
       for i in [2..Length( obj )] do
          Print( ", " );
          if IsInt( obj[i] ) then
             Print( obj[i] );
          else PPP_Print( obj[i] );
          fi;
      od;
      Print( " ]\n" );

   end);

#############################################################################
##
#M PPP_Equal( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2
##
## Output: a boolean indicating whether obj1 and obj2 are equal where 
##         comparison is defined as follows:
##
## Let obj1 = [p_1, coeffs_1] and obj2 = [p_2, coeffs_2].
## If p_1 < p_2 then obj1 < obj2.
## If p_1 = p_2 = p and obj1 represents f = sum_{i=0}^n f_i p^{ix}
##                  and obj2 represents g = sum_{i=0}^m g_i p^{ix}
## then f < 0 <=> f_n < 0
## and f < g <=> f-g < 0.
##
InstallGlobalFunction( PPP_Equal, 
   function( obj1, obj2 )

      return obj1[1] = obj2[1] and obj1[2] = obj2[2];

   end);

#############################################################################
##
#M PPP_Smaller( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2
##
## Output: a boolean indicating whether obj1 is smaller than obj2 where
##         comparison is defined as follows:
##
## Let obj1 = [p_1, coeffs_1] and obj2 = [p_2, coeffs_2].
## If p_1 < p_2 then obj1 < obj2.
## If p_1 = p_2 = p and obj1 represents f = sum_{i=0}^n f_i p^{ix}
##                  and obj2 represents g = sum_{i=0}^m g_i p^{ix}
## then f < 0 <=> f_n < 0
## and f < g <=> f-g < 0.
##
InstallGlobalFunction( PPP_Smaller, 
   function( obj1, obj2 )
      local Zero0;

      if PPP_Equal( obj1, obj2 ) then return false; fi;

      if obj1[1] < obj2[1] then return true; fi;

      if obj1[1] > obj2[1] then return false; fi;

      Zero0 := PPP_ZeroNC( obj1 );

      ## get trivial case, one obj is zero
      if PPP_Equal( obj1, Zero0 ) then 
         if obj2[2][Length(obj2[2])] > 0 then 
            return true;
         else
            return false;
         fi;
      elif PPP_Equal( obj2, Zero0 ) then
         if obj1[2][Length(obj1[2])] < 0 then 
            return true;
        else
            return false;
         fi;
      ## reduce to trivial case, that comparison of obj and zero
      else return PPP_Smaller( PPP_Subtract( obj1, obj2 ), Zero0 );
      fi;

   end);

#############################################################################
##
#M PPP_Greater( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2.
##
## Output: a boolean indicating whether obj1 is greater than obj2 where
##         comparison is defined as follows:
##
## Let obj1 = [p_1, coeffs_1] and obj2 = [p_2, coeffs_2].
## If p_1 < p_2 then obj1 < obj2.
## If p_1 = p_2 = p and obj1 represents f = sum_{i=0}^n f_i p^{ix}
##                  and obj2 represents g = sum_{i=0}^m g_i p^{ix}
## then f < 0 <=> f_n < 0
## and f < g <=> f-g < 0.
##
InstallGlobalFunction( PPP_Greater, 
   function( obj1, obj2 )

      if PPP_Equal( obj1, obj2 ) then return false;
      elif PPP_Smaller( obj1, obj2 ) then return false;
      else return true;
      fi;

   end);

#############################################################################
##
#M PPP_Add( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2
##
## Output: the sum of obj1 and obj2.
##
InstallGlobalFunction( PPP_Add, 
   function( obj1, obj2 )
      local Zero0, obj;

      if IsInt( obj1 ) and IsInt( obj2 ) then 
         Error( "No underlying prime is known." ); 
      fi;

      if IsInt( obj1 ) then obj1 := Int2PPowerPoly( obj2[1], obj1 ); fi;

      if IsInt( obj2 ) then obj2 := Int2PPowerPoly( obj1[1], obj2 ); fi;

      if obj1[1] <> obj2[1] then 
         Error( "The underlying primes are different." );
      fi;

      # catch trivial cases
      Zero0 := PPP_ZeroNC( obj1 );
      if PPP_Equal( obj1, Zero0 )  then
         return obj2;
      elif PPP_Equal( obj2, Zero0 ) then
         return obj1;
      fi;

      ## add coefficients and asign values
      obj := [];
      obj[1] := obj1[1];
      obj[2] := obj1[2]+obj2[2];

      ## check for p-divisibility
      if Length( obj1 ) > 3 and obj1[3] and Length( obj2 ) > 3 and obj2[3] then
          obj[3] := true;
      fi; 

      return PPP_Check( obj );
   end);

#############################################################################
##
#M PPP_Subtract( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2.
##
## Output: the differenz obj1-obj2.
##
InstallGlobalFunction( PPP_Subtract,
   function( obj1, obj2 )
      local obj;

      if IsInt( obj2 ) then 
         obj := -obj2;
      else obj := PPP_AdditiveInverse( obj2 );
      fi;

      return PPP_Add( obj1, obj );
   end);

#############################################################################
##
#M  PPP_Mult( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2.
##
## Output: the product of obj1 and obj2.
##
InstallGlobalFunction( PPP_Mult,
   function( obj1, obj2 )
      local Zero0, One1, c1, c2, c, i, j, obj, l, p, coeffs;

      if IsRat( obj1 ) and IsRat( obj2 ) then 
         Error( "No underlying prime is known." ); 
      fi;

      if IsInt( obj1 ) then obj1 := Int2PPowerPoly( obj2[1], obj1 ); fi;

      if IsInt( obj2 ) then obj2 := Int2PPowerPoly( obj1[1], obj2 ); fi;

      ## do rational cases
      if IsRat( obj1 ) then 
         p := obj2[1];
         coeffs := obj2[2];

         ## check
         if not IsPDivRat( obj1, p ) then return Error( "TODO" ); fi;
         if not IsInt( coeffs[1] * obj1 ) then return Error( "TODO" ); fi;

         coeffs := List( coeffs, x -> x*obj1 );

         return [p, coeffs];
      fi;

      if IsRat( obj2 ) then 
         p := obj1[1];
         coeffs := obj1[2];

         ## check
         if not IsPDivRat( obj2, p ) then return Error( "TODO" ); fi;
         if not IsInt( coeffs[1] * obj2 ) then return Error( "TODO" ); fi;

         coeffs := List( coeffs, x -> x*obj2 );

         return [p, coeffs];
      fi;

      ## check underlying primes
      if obj1[1] <> obj2[1] then 
         Error( "The underlying primes are different." );
      fi;

      ## catch trivial cases
      Zero0 := PPP_ZeroNC( obj1 );
      One1 := PPP_OneNC( obj1 );
      if PPP_Equal( obj1, One1 ) then
         return obj2;
      elif PPP_Equal( obj2, One1 ) then
         return obj1;
      elif PPP_Equal( obj1, Zero0 ) then
         return Zero0;
      elif PPP_Equal( obj2, Zero0 ) then
         return Zero0;
      fi;

      ## initialize
      c1 := obj1[2]; 
      c2 := obj2[2];
      l := Length( c1 ) - 1 + Length( c2 ) - 1;
      c := List( [0..l], x -> 0 );

      ## multiply
      for i in [0..l] do
         for j in [0..i] do
            if IsBound( c1[j+1] ) and IsBound( c2[i-j+1] ) then
               c[i+1] := c[i+1] + ( c1[j+1] * c2[i-j+1] );
            fi;
         od;
      od;

      obj := [obj1[1], c ];

      ## check for p-divisibility
      if Length( obj1 ) > 2 and Length( obj2 ) > 2 then
         if obj1[3] or obj2[3] then
            obj[3] := true;
         fi;
         if Length( obj1 ) > 3 and Length( obj2 ) > 3 then
            obj[4] := obj1[4] + obj2[4];
         fi;
      fi;

      return PPP_Check( obj );
   end);

#############################################################################
##
#M PPP_AdditiveInverse( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: the additive inverse of obj.
##
InstallGlobalFunction( PPP_AdditiveInverse,
    function( obj )
       local objinv;

       if PPP_Equal( obj, PPP_ZeroNC( obj ) ) then return obj; fi;

       ## get inverse
       objinv := ShallowCopy( obj );
       objinv[2] := -objinv[2];

       return objinv;
   end);

###############################################################################
##
#M EvaluatePPowerPoly( obj, n )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)] and a not
##        negative integer n.
##
## Output: the value of the p-power-poly element obj at n.
##
InstallGlobalFunction( EvaluatePPowerPoly, 
   function( obj , n )
      local res, p, c, i;

      if not IsInt( n ) or n < 0 then 
         Error( "The second input has to be non-negative integer." );
      fi;

      ## initialize
      res := 0;
      p := obj[1];
      c := obj[2];

      ## evaluate
      for i in [1..Length( c )] do
         res := res + c[i] * p^((i-1)*n);
      od;

      return res;
   end);

###############################################################################
##
#M PPP_AbsValue( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: the absolute value of obj as p-power-poly element.
##
InstallGlobalFunction( PPP_AbsValue, 
   function( obj )
      local lead_c;

      if PPP_Equal( obj, PPP_ZeroNC( obj ) ) then return obj; fi;

      ## check if element is < or > zero
      lead_c := obj[2][Length(obj[2])];
      if lead_c < 0 then 
          return PPP_AdditiveInverse( obj ); 
      else
          return obj;
      fi;

   end);

###############################################################################
##
#M PadicValueRatNC( q, p )
##
## Input: a rational q and a prime p which is not checked.
##
## Output: the p-adic value of q.
##
InstallMethod( PadicValueRatNC, [ IsRat, IsInt ], 
   function( q, p )
      local a, b;

      ## get p-power-divisor of numerator and denominator and compare
      a := AbsoluteValue( NumeratorRat(q) );
      a := Length(Filtered(Factors(a), x -> x = p));
      b := DenominatorRat(q);
      b := Length(Filtered(Factors(b), x -> x = p));

   return a-b;
end);

###############################################################################
##
#M PPP_PadicValue( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: the p-adic value [i,j] of obj, i.e., the largest p-power 
##         p^{i+jx} dividing obj.
##
InstallGlobalFunction( PPP_PadicValue, 
   function( obj )
      local i, s;

      if not IsPDivisiblePPP( obj ) then return fail; fi;

      ##check if already computed
      if IsBound( obj[4] ) then return obj[4]; fi;

      if obj[2] = [] then return [ infinity, infinity ]; fi;

      ## get smallest p^((i-1)x) and then p-adic value of that coefficient
      i := PositionNonZero( obj[2] );
      s := PadicValueRatNC( obj[2][i], obj[1] );

      return [ i-1, s ];
   end);

###############################################################################
##
#M PPartPoly( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: largest p-power p^{i+jx} dividing obj as p-power-poly element.
##
InstallGlobalFunction( PPartPoly, 
   function( obj )
      local e, l;

      if not IsPDivisiblePPP( obj ) then return fail; fi;

      ## catch trivial cases
      if PPP_Equal( obj, PPP_OneNC( obj ) ) then return obj; fi;
      if PPP_Equal( obj, PPP_ZeroNC( obj ) ) then return Error( "Wrong input, zero.!" ); fi;

      ## get p-part and make that into element
      e := PPP_PadicValue( obj );
      l := 0*[0..e[1]];
      l[e[1]+1] := obj[1]^e[2];

      return [obj[1], l, true, e ];
   end);

###############################################################################
##
#M PPrimePartPoly( obj )
##
## Input: a p-power-poly element obj = [p,coeffs(,ispdiv,pval)].
##
## Output: the p-prime-part of obj as a p-power-poly element, i.e., an 
##         element b such that a = bc where c is the p-part of obj.
##
InstallGlobalFunction( PPrimePartPoly, 
   function( obj )
      local p, e, c, n, Zero0;

      if not IsPDivisiblePPP( obj ) then return fail; fi;

      ## catch trivial case
      if PPP_Equal( obj, PPP_OneNC( obj ) ) then return obj; fi;
      Zero0 := PPP_ZeroNC( obj ); 
      if PPP_Equal( obj, Zero0 ) then 
         return Error( "Wrong input, zero.!" ); 
      fi;

      ## get p-part-poly
      p := obj[1];
      e := PPP_PadicValue( obj );
      c := obj[2];

      ## divide by p^(ix) by eliminating the first entries in the list 
      ## and then divide by remaining integer part of p-part
      n := c{[e[1]+1..Length(c)]} / p^e[2];

      return [p, n, true, [0,0] ];
   end);

###############################################################################
##
#M DivPPartPoly( obj1, obj2 )
##
## Input: p-power-poly elements obj1 and obj2.
##
## Output: the division of obj1 by obj2 as p-power-poly element, where obj2 
##         is equal to its p-part and the p-adic value of obj1 is greater or 
##         equal to the p-adic value of obj2.
##
InstallGlobalFunction( DivPPartPoly, 
   function( obj1, obj2 )
      local padicval, c, p, obj, One1;

      ## check
      p := obj1[1];
      if p <> obj2[1] then 
         return Error( "The underlying primes are different." ); 
      fi;

      padicval := PPP_PadicValue( obj2 );
      if PPP_PadicValue( obj1 ) < padicval then
         return Error( "The second object does not divide the first one." );
      fi;
      if not PPP_Equal( PPartPoly( obj2 ), obj2 ) then 
         return Error( "The second object is not equal to its p-part TODO." );
      fi;

      ## trivial cases
      One1 := PPP_OneNC( obj1 );
      if obj1[2] = [] then return obj1; fi;
      if PPP_Equal( obj1, obj2 ) then return One1; fi;
      if PPP_Equal( obj2, One1 ) then return obj1; fi;

      ## divide by shifting
      c := obj1[2]{ [padicval[1]+1..Length(obj1[2])] };
      c := c/p^(padicval[2]);

      return [ p, c, true, PPP_PadicValue( obj1 ) - padicval ];
   end);

#E ppowerpoly.gi . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
