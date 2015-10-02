###############################################################################
##
#F ppowerpolyloc.gi          The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
## For a/b where a and b are p-power-polys elements and b is not divisible by 
## p, the underlying prime. 
##

###############################################################################
##
#M PPPL_Check( elm_in )
##
## Input: p-power-poly-loc element elm_in = [ elm1, elm2 ] where elm1 and
##        elm2 are p-power-poly elements
##
## Output: [ elm1, elm2 ], where elm1/elm2 is probably reduced, or an Error 
##         occurs if the input does not represent a p-power-poly-loc element. 
##
InstallGlobalFunction( PPPL_Check, 
   function( elm_in )
      local elm1, elm2, p, Zero0, One1, test, elm, list, gcd_d, gcd_n, gcd, 
            ec1_num, ec2_num, i;

      p := elm_in[1][1];
      if p <> elm_in[2][1] then 
         Error("Wrong input. The underlying primes are different."); 
      fi;

      Zero0 := PPP_ZeroNC( elm_in[1] ); 
      One1 := PPP_OneNC( elm_in[1] ); 

      if PPP_PadicValue( elm_in[2] ) <> [ 0, 0 ] then
         Error("Wrong input. The denominator shall not be divisible by the underlying prime. "); 
      fi;

      if PPP_Smaller( elm_in[2], Zero0 ) then
         elm1 := PPP_AdditiveInverse( elm_in[1] );
         elm2 := PPP_AdditiveInverse( elm_in[2] );
      else
         elm1 := elm_in[1];
         elm2 := elm_in[2];
      fi;

      list := PPP_QuotientRemainder( elm1, elm2 );
      if PPP_Equal( list[2], Zero0 ) then
         elm1 := list[1];
         elm2 := One1;
      fi;

      ## check if we can cancel
      if not PPP_Equal( elm1, Zero0 ) then
         ## take the numerators of the coefficients
         ec1_num := [];
         for i in [1..Length( elm1[2] )] do
            ec1_num[i] := NumeratorRat( elm1[2][i] );
         od;
         ec2_num := [];
         for i in [1..Length( elm2[2] )] do
            ec2_num[i] := NumeratorRat( elm2[2][i] );
         od;
         ## check if the gcds are non trivial
         gcd_n := Gcd( ec1_num );
         gcd_d := Gcd( ec2_num );
         if gcd_n <> 1 and gcd_d <> 1 then
            gcd := Gcd( gcd_d, gcd_n );
            elm1[2] := elm1[2] / gcd;
            elm2[2] := elm2[2] / gcd;
         fi;
      else elm2 := One1;
      fi;

      return [elm1, elm2]; 
   end);

###############################################################################
##
#M PPPL_CheckNC( elm_in )
##
## Input: p-power-poly-loc element elm_in = [ elm1, elm2 ] where elm1 and
##        elm2 are p-power-poly elements
##
## Output: [ elm1, elm2 ] or an Error occurs if the input does not represent 
##         a p-power-poly-loc element. 
##
InstallGlobalFunction( PPPL_CheckNC, 
   function( elm_in )
      local elm1, elm2, p, Zero0, One1, test, elm, list, gcd_d, gcd_n, gcd, 
            ec1_num, ec2_num, i;

      p := elm_in[1][1];
      if p <> elm_in[2][1] then 
         Error("Wrong input. The underlying primes are different."); 
      fi;

      Zero0 := PPP_ZeroNC( elm_in[1] ); 
      One1 := PPP_OneNC( elm_in[1] ); 

      if PPP_PadicValue( elm_in[2] ) <> [ 0, 0 ] then
         Error("Wrong input. The denominator shall not be divisible by the underlying prime. "); 
      fi;

      if PPP_Smaller( elm_in[2], Zero0 ) then
         elm1 := PPP_AdditiveInverse( elm_in[1] );
         elm2 := PPP_AdditiveInverse( elm_in[2] );
      else
         elm1 := elm_in[1];
         elm2 := elm_in[2];
      fi;

      ## check if we can cancel
      if not PPP_Equal( elm1, Zero0 ) then
         ## take the numerators of the coefficients
         ec1_num := [];
         for i in [1..Length( elm1[2] )] do
            ec1_num[i] := NumeratorRat( elm1[2][i] );
         od;
         ec2_num := [];
         for i in [1..Length( elm2[2] )] do
            ec2_num[i] := NumeratorRat( elm2[2][i] );
         od;
         ## check if the gcds are non trivial
         gcd_n := Gcd( ec1_num );
         gcd_d := Gcd( ec2_num );
         if gcd_n <> 1 and gcd_d <> 1 then
            gcd := Gcd( gcd_d, gcd_n );
            elm1[2] := elm1[2] / gcd;
            elm2[2] := elm2[2] / gcd;
         fi;
      else elm2 := One1;
      fi;

      return [elm1, elm2]; 
   end);

###############################################################################
##
#M PPPL_Print( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the function prints elm in an easy to read way.
##
InstallGlobalFunction( PPPL_Print, 
    function( elm )

       Print( " (" );
       PPP_Print( elm[1] );
       Print( ") / (" );
       PPP_Print( elm[2] );
       Print( ") " );
    end);

###############################################################################
##
#M PPPL_PrintMat( obj )
##
## Input: a matrix obj with p-power-poly-loc entries.
##
## Output: the function prints obj in an easy to read way.
##
InstallGlobalFunction( PPPL_PrintMat, 
    function( obj )
    local i, j;

       Print( "[" );
       for i in [1..Length( obj )] do
          Print( "[ " );
          PPPL_Print( obj[i][1] );
          for j in [2..Length( obj[i] )] do
             Print( ", " );
             PPPL_Print( obj[i][j] );
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
#M PPPL_PrintRow( obj )
##
## Input: a row of p-power-poly-loc elements.
##
## Output: the function prints obj in an easy to read way.
##
InstallGlobalFunction( PPPL_PrintRow, 
    function( obj )
    local i, j;

       Print( "[ " );
       if IsInt( obj[1] ) then 
          Print( obj[1] );
       else PPPL_Print( obj[1] );
       fi;
       for i in [2..Length( obj )] do
          Print( ", " );
          if IsInt( obj[i] ) then
             Print( obj[i] );
          else PPPL_Print( obj[i] );
          fi;
      od;
      Print( " ]\n" );

   end);

#############################################################################
##
#M PPPL_Equal( elm1, elm2 )
##
## Input: p-power-poly-loc elements elm1 and elm2.
##
## Output: a boolean, indicating whether elm1 is equal to elm2.
##
InstallGlobalFunction( PPPL_Equal, 
   function( elm1, elm2 )
      local num1, num2, denom1, denom2;

      num1 := elm1[1];
      num2 := elm2[1];
      denom1 := elm1[2];
      denom2 := elm2[2];

      if num1[1] <> num2[1] then 
         return false; 
      fi;

      return PPP_Equal( PPP_Mult( num1, denom2 ), PPP_Mult( num2, denom1 ) );
   end);

#############################################################################
##
#M PPPL_Smaller( elm1, elm2 )
##
## Input: p-power-poly-loc elements
##
## Output: a boolean, indicating whether elm1 is smaller than elm2.
##
InstallGlobalFunction( PPPL_Smaller, 
   function( elm1, elm2 )
      local num1, num2, denom1, denom2; 

      num1 := elm1[1];
      num2 := elm2[1];
      denom1 := elm1[2];
      denom2 := elm2[2];      

      if PPPL_Equal( elm1, elm2 ) then return false; fi;

      if num1[1] < num2[1] then 
         return true; 
      elif num1[1] > num2[1] then 
         return false; 
      fi;

      return PPP_Smaller( PPP_Mult( num1, denom2 ), PPP_Mult( num2, denom1 ) );
   end);

#############################################################################
##
#M PPPL_Greater( elm1, elm2 )
##
## Input: p-power-poly-loc elements
##
## Output: a boolean, indicating whether elm1 is greater than elm2.
##
InstallGlobalFunction( PPPL_Greater, 
   function( elm1, elm2 )
      local num1, num2, denom1, denom2; 

      num1 := elm1[1];
      num2 := elm2[1];
      denom1 := elm1[2];
      denom2 := elm2[2];      

      if PPPL_Equal( elm1, elm2 ) then return false; fi;

      if num1[1] > num2[1] then 
         return true; 
      elif num1[1] < num2[1] then 
         return false; 
      fi;

      return PPP_Greater( PPP_Mult( num1, denom2 ), PPP_Mult( num2, denom1 ) );
   end);

#############################################################################
##
#M  PPPL_Add( elm1, elm2 )
##
## Input: p-power-poly-loc elements elm1 and elm2.
##
## Output: the sum of elm1 and elm2.
##
InstallGlobalFunction( PPPL_Add, 
   function( elm1, elm2 )
      local num1, num2, denom1, denom2, num, Zero0, One1, denom, list, elm, p,
            Zero0Loc;

      ## catch trivial case
      if Length( elm1 ) = 4 and Length( elm2 ) = 4 then
         return [ PPP_Add( elm1, elm2 ), PPP_OneNC( elm1 ) ];
      fi;
      if IsInt( elm1 ) and IsInt( elm2 ) then
         Error( "No underlying prime is known." );
      fi;

      ## check input
      if Length( elm1 ) = 4 then
         One1 := PPP_OneNC( elm1 );
         elm1 := [ elm1, One1 ];
      elif IsInt( elm1 ) then
         if Length( elm2 ) = 4 then
            p := elm2[1];
            One1 := PPP_OneNC( elm2 );
         else p := elm2[1][1];
            One1 := PPP_OneNC( elm2[1] );
         fi;
         elm1 := [ Int2PPowerPoly( p, elm1 ), One1 ];
      fi;
      if Length( elm2 ) = 4 then
         One1 := PPP_OneNC( elm2 );
         elm2 := [ elm2, One1 ];
      elif IsInt( elm2 ) then
         if Length( elm1 ) = 4 then
            p := elm1[1];
            One1 := PPP_OneNC( elm1 );
         else p := elm1[1][1];
            One1 := PPP_OneNC( elm1[1] );
         fi;
         elm2 := [ Int2PPowerPoly( p, elm2 ), One1 ];
      fi;

      ## initialize
      num1 := StructuralCopy( elm1[1] );
      num2 := StructuralCopy( elm2[1] );
      denom1 := StructuralCopy( elm1[2] );
      denom2 := StructuralCopy( elm2[2] );

      ## check
      if num1[1] <> num2[1] then 
         Error( "The underlying primes are different." );
      fi;
 
      Zero0 := PPP_ZeroNC( num1 );
      One1 := PPP_OneNC( denom1 );
      Zero0Loc := PPPL_ZeroNC( elm1 );

      ## same denominator, so only add numerators
      if PPP_Equal( denom1, denom2 ) then
         num := PPP_Add( num1, num2 );
         denom := denom1;
         if PPP_Equal( num, Zero0 ) then
            return Zero0Loc;
         else 
            ## check if we can cancel
            list := PPP_QuotientRemainder( num, denom );
            if PPP_Equal( list[2], Zero0 ) then
               num := list[1];
               denom := One1;
            fi;
            return PPPL_CheckNC( [ num, denom ] );
         fi;
      else
         ## fractional arithmetic
         num := PPP_Add( PPP_Mult( denom2, num1 ), PPP_Mult( denom1, num2 ) );
         denom := PPP_Mult( denom1, denom2 );
         if PPP_Equal( num, Zero0 ) then
            return Zero0Loc; 
         else 
            ## check if we can cancel
            list := PPP_QuotientRemainder( num, denom );
            if PPP_Equal( list[2], Zero0 ) then
               num := list[1];
               denom := One1;
            fi;
            return PPPL_CheckNC( [ num, denom ] );
         fi;
      fi;
   end);

#############################################################################
##
#M PPPL_Subtract( elm1, elm2 )
##
## Input: p-power-poly-loc elements elm1 and elm2.
##
## Output: the difference elm1 - elm2.
##
InstallGlobalFunction( PPPL_Subtract, 
   function( elm1, elm2 )

      return PPPL_Add( elm1, PPPL_AdditiveInverse( elm2 ) );
   end);

#############################################################################
##
#M PPPL_Mult( elm1, elm2 )
##
## Input: p-power-poly-loc elements elm1 and elm2.
##
## Output: the product of elm1 and elm2.
##
InstallGlobalFunction( PPPL_Mult, 
   function( elm1, elm2 )
      local num1, num2, denom1, denom2, num, denom, elm, Zero0, One1, list_1, 
            list_2, p;

      ## catch trivial case
      if Length( elm1 ) = 4 and Length( elm2 ) = 4 then
         return [ PPP_Mult( elm1, elm2 ), PPP_OneNC( elm1 ) ];
      fi;
      if IsInt( elm1 ) and IsInt( elm2 ) then
         Error( "No underlying prime is known." );
      fi;

      ## check input
      if Length( elm1 ) = 4 then
         One1 := PPP_OneNC( elm1 );
         elm1 := [ elm1, One1 ];
      elif IsInt( elm1 ) then
         if Length( elm2 ) = 4 then
            p := elm2[1];
            One1 := PPP_OneNC( elm2 );
         else p := elm2[1][1];
            One1 := PPP_OneNC( elm2[1] );
         fi;
         elm1 := [ Int2PPowerPoly( p, elm1 ), One1 ];
      fi;
      if Length( elm2 ) = 4 then
         One1 := PPP_OneNC( elm2 );
         elm2 := [ elm2, One1 ];
      elif IsInt( elm2 ) then
         if Length( elm1 ) = 4 then
            p := elm1[1];
            One1 := PPP_OneNC( elm1 );
         else p := elm1[1][1];
            One1 := PPP_OneNC( elm1[1] );
         fi;
         elm2 := [ Int2PPowerPoly( p, elm2 ), One1 ];
      fi;

      ## initialize
      num1 := StructuralCopy( elm1[1] );
      num2 := StructuralCopy( elm2[1] );
      denom1 := StructuralCopy( elm1[2] );
      denom2 := StructuralCopy( elm2[2] );

      ## check
      if num1[1] <> num2[1] then return fail; fi;
 
      Zero0 := PPP_ZeroNC( num1 );
      One1 := PPP_OneNC( denom1 );

      ## check if we can cancel
      list_1 := PPP_QuotientRemainder( num1, denom2 );
      list_2 := PPP_QuotientRemainder( num2, denom1 );
      if PPP_Equal( list_1[2], Zero0 ) then
         num := list_1[1];
         denom := One1;
      else 
         num := num1;
         denom := denom2;
      fi;
      if PPP_Equal( list_2[2], Zero0 ) then
         num := PPP_Mult( num,  list_2[1] );
      else
         num := PPP_Mult( num, num2 );
         denom := PPP_Mult( denom, denom1 );
      fi;

      return PPPL_CheckNC( [ num, denom ] );
   end);

###############################################################################
##
## PPPL_OneNC( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the corresponding one p-power-poly-loc element.
##
InstallGlobalFunction( PPPL_OneNC, 
    function( elm )
       local One1;
   
       One1 := PPP_OneNC( elm[1] );

       return [ One1, One1 ];
    end);

###############################################################################
##
## PPPL_ZeroNC( elm )
##
## Input: a p-power-poly-loc element.
##
## Output: the corresponding zero p-power-poly-loc element.
##
InstallGlobalFunction( PPPL_ZeroNC, 
   function( elm )
      local Zero0, One1;

      Zero0 := PPP_ZeroNC( elm[1] );
      One1 := PPP_OneNC( elm[1] );

      return [ Zero0, One1 ];
   end);

#############################################################################
##
#M PPPL_AdditiveInverse( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the additive inverse of elm.
##
InstallGlobalFunction( PPPL_AdditiveInverse, 
    function( elm )
       local num, denom;

       num := elm[1];
       denom := elm[2];

       return [ PPP_AdditiveInverse( num ), denom ];
   end);

###############################################################################
##
#M PPPL_AbsValue( elm )
##
## Input: a p-power-poly-loc element.
##
## Output: the absolute value of elm.
##
InstallGlobalFunction( PPPL_AbsValue, 
   function( elm )
      local num, denom, p, One1, Zero0Quot, coeffs;

      ## initialize
      num := elm[1];

      ## make sure lead-coefficient of numerator is positive
      coeffs := num[2];
      if coeffs[Length( coeffs) ] < 0 then
         return PPPL_AdditiveInverse( elm );
      else return elm;
      fi;
   end);

###############################################################################
##
#M PPPL_PadicValue( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the p-adic value of elm, which is the p-adic value of the numerator.
##
InstallGlobalFunction( PPPL_PadicValue, 
   function( elm )

      if not IsPDivisiblePPP( elm[2] ) then return fail; fi;

      return PPP_PadicValue( elm[1] );
   end);

###############################################################################
##
#M PPartPolyLoc( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the p-part of elm as a p-power-poly-loc element.
##
InstallGlobalFunction( PPartPolyLoc, 
   function( elm )
      local num, One1, ppart_num;

      if not IsPDivisiblePPP( elm[2] ) then return fail; fi;

      num := elm[1];
      One1 := One( num );

      ppart_num := PPartPoly( num );

      return [ ppart_num, One1 ];
   end);

###############################################################################
##
#M PPrimePartPolyLoc( elm )
##
## Input: a p-power-poly-loc element elm.
##
## Output: the p-prime part of elm as a p-power-poly-loc element.
##
InstallGlobalFunction( PPrimePartPolyLoc, 
   function( elm )
      local pprimepart_num;

      if not IsPDivisiblePPP( elm[2] ) then return fail; fi;

      pprimepart_num := PPrimePartPoly( elm[1] );

      return [ pprimepart_num, elm[2] ];
   end);

###############################################################################
##
## PPowerPolyMat2PPowerPolyLocMat( M )
##
## Inpput: a matrix M with p-power-poly entries.
##
## Output: a matrix where the entries are the corresponding p-power-poly-loc
##         elements.
##
InstallMethod( PPowerPolyMat2PPowerPolyLocMat, [ IsList ], 
   function( M )
      local One1, M_Q, i, j;

      One1 := Int2PPowerPoly( M[1][1][1], 1 );

      M_Q := [];
      for i in [1..Length(M)] do
         M_Q[i] := [];
         for j in [1..Length(M[i])] do
            M_Q[i][j] := [ M[i][j], One1 ];
         od;
      od;

      return M_Q;
   end);

###############################################################################
##
#M PPPL_MatrixMult( A, B )
##
## Input: p-power-poly-loc matrices A and B.
##
## Ouput: a matrix which is the product of A and B.
##
InstallGlobalFunction( PPPL_MatrixMult, 
   function( A, B )
      local C, n_A, m_A, n_B, m_B, i, j, k, Zero0Loc;

      n_A := Length( A );
      m_A := Length( A[1] );
      n_B := Length( B );
      m_B := Length( B[1] );

      if n_B <> m_A then
         Error( "The dimensions of the matrices do not fit together." );
      fi;

      Zero0Loc := PPPL_ZeroNC( A[1][1] );

      C := [];

      for i in [1..n_A] do
         C[i] := [];
         for j in [1..m_B] do
            C[i][j] := Zero0Loc;
            for k in [1..n_B] do
               C[i][j] := PPPL_Add( C[i][j], PPPL_Mult( A[i][k], B[k][j] ) );
            od;
         od;
      od;

      return C;
   end);

#E ppowerpolyloc.gi . . . . . . . . . . . . . . . . . . . . . . . .  ends here
