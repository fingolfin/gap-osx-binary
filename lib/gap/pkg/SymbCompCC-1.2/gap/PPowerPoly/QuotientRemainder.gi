###############################################################################
##
#F QuotientRemainder.gi      The SymbCompCC package     Dörte Feichtenschlager
##

###############################################################################
##
#M PPP_QuotientRemainder( x, y( , ReturnPos ) )
##
## Input: p-power-poly elements x and y as the first two input parameters
##        and optional a boolean ReturnPos which indicates whether a positive
##        remainder shall be returned.
##
## Output: a list [q, r] of p-power-poly elements such that x = y * q + r.
##
InstallGlobalFunction( PPP_QuotientRemainder, 
   function( arg )
      local p, Zero0, One1, test, q, c_y, l_y, c_test, l_test, r, 
            px_part, p_part, coeff, help, list, c_r, l_r, l, c, i, help1, 
            help2, x, y, ReturnPos;

      x := arg[1];
      y := arg[2];

      if Length( arg ) < 3 then 
         ReturnPos := true;
      else ReturnPos := arg[3];
      fi;

      ## checking
      if y[2] = [] then
         Error( "Wrong input, second element cannot be zero." );
      fi;

      ## initialize
      p := x[1];
      Zero0 := PPP_ZeroNC( x );
      One1 := PPP_OneNC( x );
      test := StructuralCopy( x );
      c_test := test[2];

      ## x = zero?
      if c_test = [] then
         return [ Zero0, Zero0 ];
      fi;
      l_test := Length( c_test );

      c_y := y[2];
      l_y := Length( c_y );

      ## catch trivial cases
      if PPP_Equal( y, One1 ) then
         return [x, Zero0];
      elif PPP_Equal( y, PPP_AdditiveInverse( One1 ) ) then
         return [ PPP_AdditiveInverse( x ), Zero0 ];
      fi;

      q := Zero0;

      ## get trivial case
      if PPP_Equal( test, Zero0 ) then
         return [q, Zero0];
      elif PPP_Equal( test, y ) then
         r := Zero0;
         q := PPP_Add( q, One1 );
         return [q,r];
      elif PPP_Equal( test, PPP_AdditiveInverse( y ) ) then
         r := Zero0;
         q := PPP_Subtract( q, One1 );
         return [q,r];
      elif l_test < l_y then
         r := test;
      elif l_test = l_y and AbsoluteValue( c_test[l_test] ) < AbsoluteValue( c_y[l_y] ) then
         r := test;
      fi;

      while not IsBound( r ) do
         if l_test > l_y and IsPDivRat( c_test[l_test]/c_y[l_y], p ) then
            l := l_test - l_y;
            c := [];
            c[l+1] := c_test[l_test] / c_y[l_y];
            for i in [l,l-1..1] do
               c[i] := 0;
            od;
            help := [ p, c, true, ];
            q := PPP_Add( q, help );
            test := PPP_Subtract( test, PPP_Mult( help, y ) );
         elif l_test = l_y and IsInt( c_test[l_test] / c_y[l_y] ) then
            coeff := c_test[l_test] / c_y[l_y];
            help := Int2PPowerPoly( p, coeff );
            q := PPP_Add( q, help );
            test := PPP_Subtract( test, PPP_Mult( help, y ) );
         elif l_test = l_y and AbsoluteValue( c_test[l_test] ) >= AbsoluteValue( c_y[l_y] ) then
            help1 := NumeratorRat(c_test[l_test])*DenominatorRat(c_y[l_y]);
            help2 := NumeratorRat(c_y[l_y])*DenominatorRat(c_test[l_test]);
            list := QuotientRemainder( help1, help2 );
            coeff := list[1];
            help := Int2PPowerPoly( p, coeff );
            q := PPP_Add( q, help );
            test := PPP_Subtract( test, PPP_Mult( help, y ) );
         else ## cannot divide
            r := test;
         fi;

         if PPP_Equal( test, Zero0 ) then
            return [q, Zero0];
         fi;

         c_test := test[2];
         l_test := Length( c_test );

         ## chck if we are done...
         if not IsBound( r ) then
            if PPP_Equal( test, y ) then
               r := Zero0;
               q := PPP_Add( q, One1 );
            elif PPP_Equal( test, PPP_AdditiveInverse( y ) ) then
               r := Zero0;
               q := PPP_Subtract( q, One1 );
            elif l_test < l_y then
               r := test;
            elif l_test = l_y and AbsoluteValue( c_test[l_test] ) < AbsoluteValue( c_y[l_y] ) then
               r := test;
            fi;
         fi;
      od;

      c_r := r[2];
      if PPP_Smaller( r, Zero0 ) or PPP_Greater( r, Zero0 ) then
         l_r := Length( c_r );
      else l_r := 0;
      fi;

      if ReturnPos then
         if PPP_Smaller( r, Zero0 ) and PPP_Greater( y, Zero0 ) and l_r <= l_y then
            while PPP_Smaller( r, Zero0 ) do
               r := PPP_Add( r, y );
               q := PPP_Subtract( q, One1 );
            od;
         fi;
      fi;

      return [q,r];
   end);

#E QuotientRemainder.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
