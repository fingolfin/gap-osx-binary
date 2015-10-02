#############################################################################
##
##  mtx.gi                  The SpinSym Package                 Lukas Maas
##
##  Some MeatAxe-related functions for 2.Sym(n)                     
##  Copyright (C) 2012 Lukas Maas
##
#############################################################################

## SpinSymStandardRepresentative( <c>, <rep> ) 
## INPUT .... the second component of a parameter <c> of a conjugacy class 
## .......... of 2.Sym(n) or 2.Alt(n), i.e.
## .......... <c> = lambda  or <c> = [ lambda, sign ] where 
## .......... lambda is a partition of n, and sign is either '+' or '-';
## .......... a representation <rep> of 2.Sym(n) (n-1 generators)
## OUTPUT ... the standard representative of the first class of type <c>
## .......... under the representation <rep>, see \cite{Maas2011}*{(5.1.2)}
## NOTE ..... if <c> = [ lambda, '-' ], then t^<rep>[1] is returned, where t denotes
## .......... the standard representative of type [ lambda, '+' ] = lambda 
## .......... under <rep>
## .......... <rep> is not required to be faithful

InstallGlobalFunction( SpinSymStandardRepresentative, function( c, rep )
  local lambda, sign, pos, t, a, b, i;
		
  lambda:= c;
  if '+' in lambda or '-' in lambda then
    sign:= lambda[2];
    lambda:= lambda[1];
  else
    sign:= '+';
  fi;
  pos:= Position( lambda, 1 );
  if pos = 1 then ## <c> parameterizes one of the trivial classes {1} or {z} 
    t:= rep[1]^0; 
  else
    if pos <> fail then
      pos:= pos-1;
    else ## pos=fail: 1 is not a part of lambda
      pos:= Length( lambda );
    fi;
    a:= List( [1..pos], i-> Sum( lambda{ [1..i] } )-1 ); 
    b:= [1 .. a[1]];
    t:= Product( rep{ b } );
    for i in [2..pos] do ## pos = Length( a )
      b:= [ a[i-1]+2 .. a[i] ];
      t:= t * Product( rep{ b } );
    od;
  fi;
  if sign = '-' then
    t:= rep[1]^-1 * t * rep[1];
  fi;
  return t;
		
end );


## SpinSymStandardRepresentativeImage( <c> [, <j> ] ) 
## INPUT .... a class parameter <c> of a conjugacy class of 2.Sym(n) or 2.Alt(n), i.e.
## .......... <c> = lambda or <c> = [ lambda, sign ] where 
## .......... lambda is a partition of n and sign is either '+' or '-';
## .......... OPTIONAL: an integer <j> such that 0<j<n; by default, <j>=1.
## OUTPUT ... the image of the 2.Sym(n)-standard representative of type <c> in Sym(n)
## .......... under the epimorphism t_i -> (i,i+1) for i=<j>,...,n-1.
## NOTE ..... if <c> = [ lambda, '-' ], then s^(<j>,<j>+1) is returned, where s denotes
## .......... the image of the standard representative of type [ lambda, '+' ] =  lambda 

InstallGlobalFunction( SpinSymStandardRepresentativeImage, function( arg )
  local j, lambda, rep, s;
		
  if Length(arg) = 2 then
    lambda:= arg[1];
    j:= arg[2];
  else
    lambda:= arg[1];
    j:= 1;
  fi;
  if '+' in lambda or '-' in lambda then
    lambda:= lambda[1];
  fi;
  rep:= List( [j..j+Sum(lambda)-2], i-> (i,i+1) );
  s:= SpinSymStandardRepresentative( arg[1], rep );
  return s;
	
end );


## SpinSymBrauerCharacter( <ccl>, <ords>, <rep> ) 
## INPUT .... the list of class parameters <ccl> and the list of orders <ords>
## .......... of a modular SpinSym table of 2.Sym(n), and a list <rep> of   
## .......... images [t_1^R,...,t_(n-1)^R] of the generators of 2.Sym(n) under
## .......... a representation R of 2.Sym(n)
## OUTPUT ... the Brauer character afforded by R

InstallGlobalFunction( SpinSymBrauerCharacter, 
	function( ccl, ords, rep )
		local brauercharactervalue, pos1, pos2, i, t, phi;
		
		## slightly changed version of Thomas Breuer's 
		## original function BrauerCharacterValue
		brauercharactervalue:= function( mat, order )
    	local  n, p, info, value, pair, f, nullity;
    
    	n:= order; # the only change 
    	if n = 1  then
        return Length( mat );
    	fi;
    	p := Characteristic( mat );
    	if n mod p = 0  then
        return fail;
    	fi;
    	info := ZevData( p ^ DegreeFFE( mat ), n );
    	value := 0;
    	for pair  in info  do
        f := pair[1];
        nullity := Length( NullspaceMat( ValuePol( f, mat ) ) );
        if nullity <> 0  then
            nullity := nullity / (Length( f ) - 1);
            Assert( 1, IsInt( nullity ), 
             "degree of <f> must divide <nullity>" );
             value := value + nullity * pair[2];
        fi;
    	od;
    	return value;
		end;

    pos1:= Filtered( [1 .. Length( ccl ) ], i-> ccl[i][1] = 1 );
    phi:= [];
		for i in pos1 do
			t:= SpinSymStandardRepresentative( ccl[i][2], rep );
			phi[i]:= brauercharactervalue( t, ords[i] );
			pos2:= Position( ccl, [ 2, ccl[i][2] ] );
			if pos2 <> fail then
				phi[ pos2 ]:= - phi[i];
			fi;
		od;
		return phi;

end );


## SpinSymBasicCharacter( <modtbl> ) 
## INPUT .... the head <modtbl> of a regular character table of 2.Sym(n) 
## OUTPUT ... a <p>-modular basic spin character of <modtbl> 

InstallGlobalFunction( SpinSymBasicCharacter, function( modtbl )
	local ccl, ords, rep;
	
	ccl:= ClassParameters( modtbl );
	ords:= OrdersClassRepresentatives( modtbl );
	rep:= BasicSpinRepresentationOfSymmetricGroup( Sum( ccl[1][2] ), 
														 UnderlyingCharacteristic( modtbl ) );
	return SpinSymBrauerCharacter( ccl, ords, rep );

end );


## SPINSYM_Transposition( <i>, <j>, <rep> )
## returns the transposition t_<i>,<j> under the matrix representation <rep>

BindGlobal( "SPINSYM_Transposition", 
	function( i, j, rep )
		local pos;
	
		if i <= j then
			pos:= [ i .. j-1 ];
			Append( pos, Reversed( [ i .. j-2 ] ) );
		else
			pos:= [ j .. i-1 ];
			Append( pos, Reversed( [ j .. i-2 ] ) );
		fi;
		return Product( rep{ pos } );
	end );


## SPINSYM_DecompositionInTranspositions( <pi> )
## writes a permutation <pi> as a product of transpositions
##
## returns	a list [ [i1,i2], [i3,i4], ... ] such that 
## pi = (i1,i2)(i3,i4)...

BindGlobal( "SPINSYM_DecompositionInTranspositions", 
	function( pi )
		local m, mp, pos, t, i, s, spos, j;
	
		if pi = () then
			return [];
		fi;
	
		m:= ListPerm( pi );
		mp:= MovedPoints( pi );
		pos:= List( mp, x-> Position( m, x ) );
		t:= [];
		while Length( pos ) > 1 do
			i:= pos[1];
			# get the orbit of pi starting from m[i]
			s:= [];
			spos:= [i];
			j:= i;
			while m[j] <> i  do
      	j := m[j];
      	Add( s, [ i, j ] );
      	Add( spos, j );
    	od;
    	pos:= DifferenceLists( pos, spos );
    	Append( t, s );
		od;
		return t;
	end );


## SpinSymPreimage( <pi>, <rep> )
## returns a (standard) preimage of the element <pi> of Sym(n)
## in 2.Sym(n) under the representation <rep>
##		<pi>  : an element of Sym(n) 
##		<rep> : a faithful representation of 2.Sym(n)

InstallGlobalFunction( SpinSymPreimage, function( pi, rep )
	local trans, PI, ij;
	
	trans:= SPINSYM_DecompositionInTranspositions( pi );
	PI:= rep[1]^0;
  for ij  in trans  do
  	PI:= PI * SPINSYM_Transposition( ij[1], ij[2], rep );
  od;
	return PI;

end );

