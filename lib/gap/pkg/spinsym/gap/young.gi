#############################################################################
##
##  young.gi                  The SpinSym Package                 Lukas Maas
##
##  Character tables of maximal Young subgroups of 2.Sym(n) and 2.Alt(n) 
##  Copyright (C) 2012 Lukas Maas
##
#############################################################################

## @Thomas:
## CharacterTable( "DoubleCoverMaximalYoungSubgroup", k, l )
## CharacterTable( "DoubleCoverMaximalYoungSubgroupSymmetric", k, l )
## CharacterTable( "DoubleCoverMaximalYoungSubgroupAlternatingSymmetric", k, l )
## CharacterTable( "DoubleCoverMaximalYoungSubgroupSymmetricAlternating", k, l )
## CharacterTable( "DoubleCoverMaximalYoungSubgroupAlternating", k, l )

#############################################################################

## returns true if the preimage of the conjugacy class 
## of type <clpar> = [ pi, tau ] in Alt(k) x Alt(l) 
## splits into a union of two distinct classes in 
## 2.(Alt(k) x Alt(l)), false otherwise.

BindGlobal( "SPINSYM_YNG_IsSplitAA", function( clpar )
	local c1, c2;
	c1:= Filtered( Flat( clpar[1] ), IsInt );
  c2:= Filtered( Flat( clpar[2] ), IsInt );
	return ( SPINSYM_IsAPO( c1 ) or SPINSYM_IsAPD( c1 ) )
	   and ( SPINSYM_IsAPO( c2 ) or SPINSYM_IsAPD( c2 ) );
	end );


## returns true if the preimage of the conjugacy class 
## of type <clpar> = [ pi, tau ] in Alt(k) x Sym(l) 
## splits into a union of two distinct classes in 
## 2.(Alt(k) x Sym(l)), false otherwise.

BindGlobal( "SPINSYM_YNG_IsSplitAS", function( clpar )
	local c1;
	c1:= Filtered( Flat( clpar[1] ), IsInt ); 
	# clpar[1] might contain '+' or '-' 
	return ( SPINSYM_IsAPO( c1 ) or SPINSYM_IsAPD( c1 ) )
	   and ( SPINSYM_IsAPO( clpar[2] ) or 
	   				( SPINSYM_IsAPD( clpar[2] ) and 
	   					SignPartition( clpar[2] ) = -1 ) );
	end );


## returns true if the preimage of the conjugacy class 
## of type <clpar> = [ pi, tau ] in Sym(k) x Alt(l) 
## splits into a union of two distinct classes in 
## 2.(Sym(k) x Alt(l)), false otherwise.

BindGlobal( "SPINSYM_YNG_IsSplitSA", function( clpar )
	local c2;
	c2:= Filtered( Flat( clpar[2] ), IsInt );
	# clpar[2] might contain '+' or '-' 
	return ( SPINSYM_IsAPO( c2 ) or SPINSYM_IsAPD( c2 ) )
	   and ( SPINSYM_IsAPO( clpar[1] ) or 
	   				( SPINSYM_IsAPD( clpar[1] ) and 
	   					SignPartition( clpar[1] ) = -1 ) );
	end );


## returns true if the preimage of the conjugacy class 
## of type <clpar> = [ pi, tau ] in Sym(k) x Sym(l) 
## splits into a union of two distinct classes in 
## 2.(Sym(k) x Sym(l)), false otherwise.

BindGlobal( "SPINSYM_YNG_IsSplitSS", function( clpar )
	local sgn1, sgn2;
	
	if SPINSYM_IsAPO( clpar[1] ) and SPINSYM_IsAPO( clpar[2] ) then
		return true;
	elif SPINSYM_IsAPD( clpar[1] ) and SPINSYM_IsAPD( clpar[2] ) then
		sgn1:= SignPartition( clpar[1] );
		sgn2:= SignPartition( clpar[2] );
		return Set( [sgn1,sgn2] ) = [-1,1];
	else
		return false;
	fi;  
	
	end );


## just a wrapping function

BindGlobal( "SPINSYM_YNG_IsSplit", function( clpar, type )	
	if type = "AA" then
		return SPINSYM_YNG_IsSplitAA( clpar );
	elif type = "AS" then
		return SPINSYM_YNG_IsSplitAS( clpar );
	elif type = "SA" then
		return SPINSYM_YNG_IsSplitSA( clpar );
	else
		return SPINSYM_YNG_IsSplitSS( clpar );
	fi;
	end );
	  
	
## SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts( cl1, cl2, o1, o2 )
##   cl1 : partition of k
##   cl2 : partition of l
##   o1  : order of first standard representative t1 of type cl1
##   o2  : order of first standard representative t2 of type cl2
## returns the order of the element t1*t2 in 2.(Sym(k) x Sym(l))

InstallGlobalFunction( 
	SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts,
	function( cl1, cl2, o1, o2 )
		local c1, c2, cl, m, i, mo, m4;
	
		# remove possible '+' or '-' from cl1 and cl2
  	c1:= Filtered( Flat( cl1 ), IsInt );
  	c2:= Filtered( Flat( cl2 ), IsInt );
  	cl:= Concatenation( c1, c2 );
    m:= 1;
    for i in [1..Length(cl)] do
    	m:= LcmOp( Integers, m, cl[i] );
    od;
    # now m is the l.c.m. of the orders of images of the 
    # Schur lifts of type cl1 and cl2 in Sym(n) 

    mo:= [ m mod o1, m mod o2 ];
    if SignPartition(c1) = -1 and SignPartition(c2) = -1 then
		# c1 and c2 are odd
		m4:= m mod 4;
		if m4 in [0,1] then
			if mo = [0,0] or not 0 in mo then
				return m;
			else
				return 2*m;
			fi;
		else # m4 = 2 or 3
			if mo <> [0,0] and 0 in mo then
				return m;
			else
				return 2*m;
			fi;
		fi;
	else
		if mo = [0,0] or not 0 in mo then
			return m;
		else
			return 2*m;
		fi;
	fi;
	end );


## SPINSYM_YNG_HEAD( k, l, type [, CT1, CT2] )
##   k    : an integer greater than 1
##   l    : an integer greater than 1
##   type : a string "AA", "AS", "SA", or "SS" 
## returns the 'head' of an ordinary character table of
## 2.(Alt(k) x Alt(l)), 2.(Alt(k) x Sym(l)), 2.(Sym(k) x Alt(l)),
## or 2.(Sym(k) x Sym(l)), respectively, depending on the value
## of type. 
## The appropriate ordinary character tables of 2.Alt(k), 2.Alt(l), 
## 2.Sym(k), or 2.Sym(l) may be given as optional arguments CT1, CT2. 

InstallGlobalFunction( SPINSYM_YNG_HEAD, 
	function( arg )
	local k, l, type,
				tbl, 				# the table head that will be returned 
				NAME, name, # identifiers of 2.(X1 x X2) and X1 x X2	  
				CT1, CT2, 	# generic character tables of 2.X1 and 2.X2
				CCL1, ccl1, CCL2, ccl2, CCL,							# class parameters
				CEN1, cen1, CEN2, cen2, CEN, 							# sizes of centralizers
				ORD1, ORD2, o1, o2, ORD,									# orders of class reps
				NR1, nr1, NR2, nr2, NR, 									# counter
				FUS, 				# fusion map from 2.(X1 x X2) onto X1 x X2
				ORIGIN, pos1, pos2, split1, split2, 			
				1ST, 2ND,	i, j, cl1, cl2, c, info;	

	k:= arg[ 1 ]; 
	l:= arg[ 2 ]; 
	type:= arg[ 3 ];
	
	if type = "AA" then
  	NAME:= Concatenation( "2.(Alt(", String(k), 
  										     ")xAlt(", String(l), "))" );
	 	name:= Concatenation( "Alt(", String(k), 
	  										  ")xAlt(", String(l), ")" );
	  if Length( arg ) = 5 then	
	  	CT1:= arg[ 4 ];
	  	CT2:= arg[ 5 ];
	  else 
	  	CT1:= CharacterTable( "DoubleCoverAlternating", k ); 
	  	CT2:= CharacterTable( "DoubleCoverAlternating", l );
	  fi;

	elif type = "AS" then

		NAME:= Concatenation( "2.(Alt(", String(k), 
  										     ")xSym(", String(l), "))" );
  	name:= Concatenation( "Alt(", String(k), 
	  										  ")xSym(", String(l), ")" );
	  if Length( arg ) = 5 then	
	  	CT1:= arg[ 4 ];
	  	CT2:= arg[ 5 ];
	  else 
	  	CT1:= CharacterTable( "DoubleCoverAlternating", k ); 
	  	CT2:= CharacterTable( "DoubleCoverSymmetric", l );
	  fi;		
	
	elif type = "SA" then
		
		NAME:= Concatenation( "2.(Sym(", String(k), 
	  									     ")xAlt(", String(l), "))" );
	  name:= Concatenation( "Sym(", String(k), 
	  									  ")xAlt(", String(l), ")" );
	  if Length( arg ) = 5 then	
	  	CT1:= arg[ 4 ];
	  	CT2:= arg[ 5 ];
	  else 
	  	CT1:= CharacterTable( "DoubleCoverSymmetric", k ); 
	  	CT2:= CharacterTable( "DoubleCoverAlternating", l );
	  fi;		
	
	elif type = "SS" then
	  
	 	NAME:= Concatenation( "2.(Sym(", String(k), 
	 										     ")xSym(", String(l), "))" );
	 	name:= Concatenation( "Sym(", String(k), 
	 										  ")xSym(", String(l), ")" );
	 	if Length( arg ) = 5 then	
	 		CT1:= arg[ 4 ];
	 		CT2:= arg[ 5 ];
	 	else 
	 		CT1:= CharacterTable( "DoubleCoverSymmetric", k ); 
	 		CT2:= CharacterTable( "DoubleCoverSymmetric", l );
	 	fi;
	 	
  fi;	
			
	tbl:= ConvertToCharacterTableNC( 
				rec( UnderlyingCharacteristic:= 0 ) );
		
	SetIdentifier( tbl, NAME );
	SetSize( tbl, Size( CT1 ) * Size( CT2 ) / 2 );
	
	CCL1:= ClassParameters( CT1 );
	CCL2:= ClassParameters( CT2 );
  NR1:=  NrConjugacyClasses( CT1 );
  NR2:=  NrConjugacyClasses( CT2 );
  CEN1:= SizesCentralizers( CT1 );
  CEN2:= SizesCentralizers( CT2 );
  ORD1:= OrdersClassRepresentatives( CT1 );
  ORD2:= OrdersClassRepresentatives( CT2 );
    
  # collect data of the factor group X_i from 2.X_i for i=1,2
  cen1:= [];
  ccl1:= [];
  nr1:= 0;
  pos1:= [];
  split1:= [];
  for i in [ 1 .. NR1 ] do
   	if CCL1[i][1] = 1 then
   		nr1:= nr1 + 1;
   		pos1[ nr1 ]:= i;
   		ccl1[ nr1 ]:= CCL1[i][2];
			cen1[ nr1 ]:= CEN1[i];
			split1[ nr1 ]:= false;
   	else # CCL1[i][1] = 2
   	  cen1[ nr1 ]:= CEN1[i] / 2;
   		split1[ nr1 ]:= true;
   	fi;
  od;
  cen2:= [];
  ccl2:= [];
  nr2:= 0;
  pos2:= [];
  split2:= [];
  for i in [ 1 .. NR2 ] do
    if CCL2[i][1] = 1 then
    	nr2:= nr2 + 1;
    	pos2[ nr2 ]:= i;
    	ccl2[ nr2 ]:= CCL2[i][2];
			cen2[ nr2 ]:= CEN2[i];
			split2[ nr2 ]:= false;
    else # CCL2[i][1] = 2
    	cen2[ nr2 ]:= CEN2[i] / 2;
    	split2[ nr2 ]:= true;
    fi;
  od;

	# classes, centralizers and fusion map
  CCL:= [];
  NR:=  0;
  CEN:= [];
  ORD:= [];
  FUS:= [];
  1ST:= [];
  2ND:= [];
  ORIGIN:= [];
  for i in [ 1 .. nr1 ] do
  	for j in [ 1 .. nr2 ] do
  		NR:= NR + 1;
  		cl1:= ccl1[i];
  		cl2:= ccl2[j];
			CCL[ NR ]:= [ 1, [ cl1, cl2 ] ];
			Add( 1ST, NR );
			FUS[ NR ]:= Length( 1ST );
			ORIGIN[ NR ]:= [ i, j ];	
			o1:= ORD1[ pos1[i] ];
			o2:= ORD2[ pos2[j] ];
			ORD[ NR ]:= SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts( 
													cl1, cl2, o1, o2 );
			c:= cen1[i] * cen2[j];
    	if SPINSYM_YNG_IsSplit( [ cl1, cl2 ], type ) then 
    		c:= 2 * c;
        CEN[ NR ]:= c;
    		FUS[ NR + 1 ]:= FUS[ NR ];
    		NR:= NR + 1;
        CCL[ NR ]:= [ 2, [ cl1, cl2 ] ];
        Add( 2ND, NR );
        ORIGIN[ NR ]:= [ i, j ];
        # determine order of (zx)y or x(zy)
        if split1[i] then 
         	o1:= ORD1[ pos1[i] + 1 ];
					ORD[ NR ]:= SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts( 
															cl1, cl2, o1, o2 );
				elif split2[j] then
         	o2:= ORD2[ pos2[j]+1 ];
					ORD[ NR ]:= SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts( 
															cl1, cl2, o1, o2 );
        fi;
    	fi;
    	CEN[ NR ]:= c;
    od;
  od;

	SetClassParameters( tbl, CCL );
  SetNrConjugacyClasses( tbl, NR );
	SetSizesCentralizers( tbl, CEN );
	SetOrdersClassRepresentatives( tbl, ORD );
	SetComputedClassFusions( tbl,  [ rec( name:= name, map:= FUS ) ] );
	
	# keep some information on the ingredients
	info:= rec( k:= k, 
              l:= l,
              type:= type,
              ORIGIN:= ORIGIN,
              pos1:= pos1,
              pos2:= pos2,
              nr1:=  nr1,
              nr2:=  nr2,
              1ST:=  1ST, 
              2ND:=  2ND );
  
  if type <> "SS" then
		SetSpinSymIngredients( tbl, [ CT1, CT2, info ] );
	else
		SetSpinSymIngredients( tbl, [ CT1, CT2, info,
				CharacterTable( "DoubleCoverAlternating", k ),
	  	  CharacterTable( "DoubleCoverAlternating", l ) ] );
	fi;
	
	return tbl;
	end );


## SPINSYM_YNG_HEADREG( tbl, p )
##   tbl : an ordinary character table constructed by 
##         SpinSymCharacterTableOfMaximalYoungSubgroup
##   p   : an odd rational prime 
## returns the head of the p-regular part of tbl

InstallGlobalFunction( SPINSYM_YNG_HEADREG, 
	function( tbl, p )
	local CT1, CT2, info, AT1, AT2,
	 			modtbl, fus, ccl, i;
	  									 		
	CT1:= SpinSymIngredients( tbl )[ 1 ] mod p;
	CT2:= SpinSymIngredients( tbl )[ 2 ] mod p;
	info:= ShallowCopy( SpinSymIngredients( tbl )[ 3 ] );
	if info.type = "SS" then
		AT1:= SpinSymIngredients( tbl )[ 4 ] mod p;
		AT2:= SpinSymIngredients( tbl )[ 5 ] mod p;
	else AT1:= false; AT2:= false; fi;
	if CT1 = fail or CT2 = fail 
	or AT1 = fail or AT2 = fail then 
		Error( "missing Brauer tables; " );
		return fail;
	fi;
		
	modtbl:= ConvertToCharacterTableNC( 
						rec( UnderlyingCharacteristic:= p,
								 OrdinaryCharacterTable:= tbl ) );
	SetSize( modtbl, Size( tbl ) );	
	
	fus:= Filtered( [ 1 .. NrConjugacyClasses( tbl ) ],
				i-> OrdersClassRepresentatives( tbl )[i] mod p <> 0 ); 
		
	StoreFusion( modtbl, fus, tbl );
		
	Unbind( info.ORIGIN );
	info.pos1:= Positions( List( ClassParameters( CT1 ), 
																x-> x[1] ), 1 );
	info.pos2:= Positions( List( ClassParameters( CT2 ), 
																x-> x[1] ), 1 );
	info.nr1:= Length( info.pos1 );
	info.nr2:= Length( info.pos2 );
		
	ccl:= ClassParameters( tbl ){ fus };
	SetClassParameters( modtbl, ccl );
	info.1ST:= [ ];
	info.2ND:= [ ];
	for i in [ 1 .. NrConjugacyClasses( modtbl ) ] do
		if ccl[ i ][ 1 ] = 1 then
			Add( info.1ST, i );
		else
			Add( info.2ND, i );
		fi;
	od;

  if info.type <> "SS" then
		SetSpinSymIngredients( modtbl, [ CT1, CT2, info ] );
	else
		SetSpinSymIngredients( modtbl, [ CT1, CT2, info, AT1, AT2 ] );
	fi;
	
	return modtbl;
	end );


## SPINSYM_YNG_POWERMAPS( tbl )
##   tbl : the character table head returned by 
##         SPINSYM_YNG_HEAD( k, l, type )
## computes the p-powermaps for all primes p <= k+l
## and sets the attribute ComputedPowerMaps( tbl )

InstallGlobalFunction( SPINSYM_YNG_POWERMAPS, 
	function( tbl )
  local POW1, POW2, info, k, l, pprimepowermap, 
  			res, CLPAR, signs, pow, p, powk, powl, 
  			cl, cl1, cl2, pos, i, c, d, j1, j2; 

	if not HasSpinSymIngredients( tbl ) then
	 	Error( "the ingredients of <tbl> must be known; " );
		return;
	fi;

	# shortcuts
	POW1:= ComputedPowerMaps( SpinSymIngredients( tbl )[1] );
	POW2:= ComputedPowerMaps( SpinSymIngredients( tbl )[2] );
	info:= SpinSymIngredients( tbl )[3];
	k:= info.k;
	l:= info.l;
	 	
  pprimepowermap:= function( irr, p )
  # returns the p-powermap when p is 
  # coprime to the group order 
  	local n, trans1, trans2, perm;	
  	n:= Length(irr);
  	trans1:= List( [1..n], i-> irr{[1..n]}[i] );
  	trans2:= GaloisCyc( trans1, p );
  	perm:= PermListList( trans2, trans1 );
  	return Permuted( [1..n], perm );
  end;
  	
  res:= function( cl, clpar )
  # returns the position of the Sym-class parameter 
  # cl in a list of Alt-class parameters
  	if SPINSYM_IsAPO( cl ) and SPINSYM_IsAPD( cl ) then
  	  # cl splits in Alt()
  	  return Position( clpar, [ 1, [ cl, '+' ] ] );
  	else
  		return Position( clpar, [ 1, cl ] );
  	fi;
  end;
  	
  CLPAR:= ClassParameters( tbl );
  signs:= List( CLPAR, 
   				x-> [ SignPartition(Filtered( Flat( x[2][1] ), IsInt )),
  						 	SignPartition(Filtered( Flat( x[2][2] ), IsInt )) ] );
  pow:= [];
  for p in Set( FactorsInt( Size( tbl ) ) ) do
  	
  	if p > k then 
  		POW1[ p ]:= pprimepowermap( Irr( SpinSymIngredients( tbl )[1] ), p );
  	fi;
  	if p > l then 
  		POW2[ p ]:= pprimepowermap( Irr( SpinSymIngredients( tbl )[2] ), p );
  	fi;
  		
    pow[ p ]:= [ ];
		powk:= POW1[ p ];
		powl:= POW2[ p ];
 
    for i in [ 1 .. NrConjugacyClasses( tbl ) ] do
			cl:= CLPAR[i];
			if cl[1] = 1 or p = 2 then
				c:= 1;
			else 
				c:= -1;
			fi;
			if signs[i][1] = -1 and signs[i][2] = -1 
				and ( p = 2 or p mod 4 = 3 ) then
				c:= -c;
			fi;
			j1:= powk[ info.pos1[ info.ORIGIN[i][1] ] ];
    	j2:= powl[ info.pos2[ info.ORIGIN[i][2] ] ];   	
    	cl1:= ClassParameters( SpinSymIngredients( tbl )[1] )[j1];
    	cl2:= ClassParameters( SpinSymIngredients( tbl )[2] )[j2];
   		if cl1[1] <> cl2[1] then
   			c:= -c;
   		fi;
			if info.type <> "SS" then
				pos:= fail;
				if c = -1 then
					pos:= Position( CLPAR, [ 2, [ cl1[2], cl2[2] ] ] );	
				fi;
				if c = 1 or pos = fail then 
			  	pos:= Position( CLPAR, [ 1, [ cl1[2], cl2[2] ] ] );	
				fi;
				Add( pow[p], pos );
			else # SS
				signs[i][1]:= SignPartition( cl1[2] );
				signs[i][2]:= SignPartition( cl2[2] );
				if signs[i][1] = -1 and signs[i][2] = 1 then
					# find cl2 in 2.Alt(l) = SpinSymIngredients( tbl )[5]
					pos:= res( cl2[2], ClassParameters( SpinSymIngredients( tbl )[5] ) );
					pos:= PowerMap( SpinSymIngredients( tbl )[5], p )[ pos ];
					d:= ClassParameters( SpinSymIngredients( tbl )[5] )[ pos ];
					if d[1] = 2 then
						c:= -c;
					fi;
					if '-' in d[2] then 
						c:= -c;
					fi;
				elif signs[i][1] = 1 and signs[i][2] = -1 then
					# find cl1 in 2.Alt(k) = SpinSymIngredients( tbl )[4]
					pos:= res( cl1[2], ClassParameters( SpinSymIngredients( tbl )[4] ) );
					pos:= PowerMap( SpinSymIngredients( tbl )[4], p )[ pos ];
					d:= ClassParameters( SpinSymIngredients( tbl )[4] )[ pos ];
					if d[1] = 2 then
						c:= -c;
					fi;
					if '-' in d[2] then 
						c:= -c;
					fi;
				fi;
				pos:= fail;
				if c = -1 then
					pos:= Position( CLPAR, [ 2, [ cl1[2], cl2[2] ] ] );	
				fi;
				if c = 1 or pos = fail then 
			  	pos:= Position( CLPAR, [ 1, [ cl1[2], cl2[2] ] ] );	
				fi;
				pow[ p ][ i ]:= pos;
			fi;
		od;
	od;
	
	SetComputedPowerMaps( tbl, pow );
	
	end );


## SPINSYM_YNG_TSR( tbl, IRR1, IRR2, CHPAR1, CHPAR2, c, d )
##   tbl    : the character table head returned by 
##            SPINSYM_YNG_HEAD( k, l, type, CT1, CT2 )
##   IRR1   : subset of (spin) characters of Irr( CT1 )
##   IRR2   : subset of (spin) characters of Irr( CT2 )
##   CHPAR1 : character parameters for the elements of IRR1 
##   CHPAR2 : character parameters for the elements of IRR2
##   c      : -1 if spin characters are handled, otherwise 1
##   d      :  2 if spin characters are handled, otherwise 1
## returns a record with components IRR and CHPAR 
## containing irreducible (spin) characters of tbl and their 
## parameters, respectively

InstallGlobalFunction( SPINSYM_YNG_TSR, 
	function( tbl, IRR1, IRR2, CHPAR1, CHPAR2, c, d )
	 	# c = 1 (for non-spin chars) or -1 (for spin chars)
		# and d = 1 or 2, respectively
	 	local info, IRR, CHPAR, 1ST, 2ND, pos1, pos2, pos, T,
	 				i1, i2, phi, psi, chi, nr, j1, j2;
	 		
	 	info:= SpinSymIngredients( tbl )[3];
	
		# irreducible characters and their parameters			
		IRR:= [];
		CHPAR:= [];
		1ST:=  info.1ST;
		2ND:=  info.2ND;
		pos1:= info.pos1;
 		pos2:= info.pos2;		
		pos:= List( 2ND, i-> i-1 );
		T:= []; # information on the inertia subgroups (for type SS only) 
			
		for i1 in [ 1 .. Length( IRR1 ) ] do
			for i2 in [ 1 .. Length( IRR2 ) ] do
				phi:= IRR1[ i1 ];
				psi:= IRR2[ i2 ];
				chi:= [ ];
				nr:= 0;
				for j1 in pos1 do
					for j2 in pos2 do
						nr:= nr+1;
						chi[ 1ST[ nr ] ]:= phi[ j1 ] * psi[ j2 ];
					od;
				od;
				chi{ 2ND }:= c * chi{ pos };
				Add( IRR, Character( tbl, chi ) );
				Add( CHPAR, [ d, [ CHPAR1[ i1 ][ 2 ], CHPAR2[ i2 ][ 2 ] ] ] );
				if info.type = "AAspinonly" then 
					Add( T, [ '+' in CHPAR1[ i1 ][ 2 ] or '-' in CHPAR1[ i1 ][ 2 ],
										'+' in CHPAR2[ i2 ][ 2 ] or '-' in CHPAR2[ i2 ][ 2 ] ] );
				fi;
			od;
		od;
			
		if info.type = "AAspinonly" then
    	info.T:= T;	# remember T for the construction of type SS
 		fi;
		return rec( IRR:= IRR, CHPAR:= CHPAR );
	
	end );
	
	
## SPINSYM_YNG_IND( tbl )
##   tbl    : the character table head returned by 
##            SPINSYM_YNG_HEAD( k, l, "SS" )
## returns a record with components IRR and CHPAR 
## containing irreducible spin characters of tbl and 
## their parameters, respectively

InstallGlobalFunction( SPINSYM_YNG_IND, 
	function( tbl )
	local AA, AS, SA, FUS, fus, T,
				rAS, rSA, inn, out, pos1,
				IRR, CHPAR, c, d, irr, 
				i, j1, j2, j, pos;

	AA:= SpinSymIngredients( tbl )[ 6 ];
	AS:= SpinSymIngredients( tbl )[ 7 ];
	SA:= SpinSymIngredients( tbl )[ 8 ];
		
	# fusion maps 
	FUS:= SpinSymClassFusion2AAin2AS( 
							ClassParameters( AA ), ClassParameters( AS ) );
	StoreFusion( AA, FUS, AS );
	# restrict spin characters of AS to AA
	rAS:= Irr( AS ){ [ 1 .. Length( Irr( AS ) ) ] }{ FUS };

	fus:= SpinSymClassFusion2AAin2SA( 
							ClassParameters( AA ), ClassParameters( SA ) );
	StoreFusion( AA, fus, SA );
	# restrict spin characters of SA to AA
	rSA:= Irr( SA ){ [ 1 .. Length( Irr( SA ) ) ] }{ fus };

	FUS:= SpinSymClassFusion2ASin2SS( 
							ClassParameters( AS ), ClassParameters( tbl ) );
	StoreFusion( AS, FUS, tbl );
	FUS:= SpinSymClassFusion2SAin2SS( 
							ClassParameters( SA ), ClassParameters( tbl ) );
	StoreFusion( SA, FUS, tbl );	
	FUS:= CompositionMaps( FUS, fus );
	StoreFusion( AA, FUS, tbl );
		
	T:= SpinSymIngredients( AA )[ 3 ].T;
	# now T[i] = [ true, true ]   means that T(chi)/AA = 1, i.e. T(chi)=AA
	# now T[i] = [ true, false ]  means that T(chi)/AA = <t2>, i.e. T(chi)=AS
	# now T[i] = [ false, true ]  means that T(chi)/AA = <t1>, i.e. T(chi)=SA
	# now T[i] = [ false, false ] means that T(chi)/AA = <t1> x <t2>
		
	inn:=  [];	# positions of inner classes, i.e. classes of AA in SS
	out:=  [];	# positions of outer classes, i.e. classes of SS \ AA
	pos1:= [];
	IRR:=  [];
	CHPAR:=[];
		 
	for i in [ 1 .. NrConjugacyClasses( tbl ) ] do
		c:= ClassParameters( tbl )[ i ][ 2 ];
		if SignPartition( c[ 1 ] ) = 1 and SignPartition( c[ 2 ] ) = 1 then
			Add( inn, i );
			Add( pos1, Position( FUS, i ) );
		else
			Add( out, i );
		fi;
	od;
	irr:= Irr( AA );
	
	for i in [ 1 .. Length( T ) ] do
		j1:= T[ i ][ 1 ];
		j2:= T[ i ][ 2 ];
		if j1 and j2 then
			c:= InducedClassFunction( irr[ i ], tbl ); 
			if not c in IRR then
				Add( IRR, Character( tbl, c ) );
				d:= CharacterParameters( AA )[ i ];
				Add( CHPAR, [ 2, [ [ d[2][1][1], "+-" ], [ d[2][2][1], "+-" ] ] ] );
			fi;
		elif j1 and not j2 then
			pos:= Positions( rAS, irr[ i ] );
			for j in pos do 
		 		c:= InducedClassFunction( Irr( AS )[ j ], tbl );
		 		if not c in IRR then
		 			Add( IRR, Character( tbl, c ) );
					d:= CharacterParameters( AS )[ j ];
					Add( CHPAR, [ 2, [ d[2][1][1], d[2][2] ] ] );
				fi;
			od;
		elif not j1 and j2 then
			pos:= Positions( rSA, irr[ i ] );
			for j in pos do 
				c:= InducedClassFunction( Irr( SA )[ j ], tbl );
				if not c in IRR then
			 		Add( IRR, Character( tbl, c ) );
	 				d:= CharacterParameters( SA )[ j ];
	 				Add( CHPAR, [ 2, [ d[2][1], d[2][2][1] ] ]  );
				fi;
			od;
		else
			# chi=irr[i]^SS vanishes outside AA and its restriction 
			# to AA is 2*phi=2*irr[i] 
			c:= irr[ i ];
			d:= [];
	 		for j in out do
				d[ j ]:= 0;
			od;
			for j in [ 1 .. Length( inn ) ] do
				d[ inn[ j ] ]:= 2 * c[ pos1[ j ] ];	
			od;	
			c:= Character( tbl, d );
			if not c in IRR then
				Add( IRR, Character( tbl, c ) );
				d:= CharacterParameters( AA )[ i ];
				Add( CHPAR, [ 2, [ d[2][1], d[2][2] ] ]  );
			fi;
		fi;
	od;

 	return rec( IRR:= IRR, CHPAR:= CHPAR );
	end );


## SPINSYM_YNG_IRR( tbl )
## constructs and stores the full set of irreducible 
## characters of tbl and the corresponding parameters

InstallGlobalFunction( SPINSYM_YNG_IRR, function( tbl )
	local info, IRR, CHPAR, IRR1, IRR2, 
				CHPAR1, CHPAR2, R, NR1, NR2, 
				p, ordtbl, AA, AS, SA;
		
	info:= SpinSymIngredients( tbl )[ 3 ];
	IRR:= [];
	CHPAR:= [];
	if not IsSubset( info.type, "spinonly" ) then
			
		# get all irreducible (Brauer) characters
		IRR1:= Irr( SpinSymIngredients( tbl )[1] ){ [ 1 .. info.nr1 ] };
		IRR2:= Irr( SpinSymIngredients( tbl )[2] ){ [ 1 .. info.nr2 ] };
		CHPAR1:= CharacterParameters( SpinSymIngredients( tbl )[1] ){ [ 1 .. info.nr1 ] };
		CHPAR2:= CharacterParameters( SpinSymIngredients( tbl )[2] ){ [ 1 .. info.nr2 ] };
		R:= SPINSYM_YNG_TSR( tbl, IRR1, IRR2, CHPAR1, CHPAR2, 1, 1 );
		Append( IRR, R.IRR );
		Append( CHPAR, R.CHPAR );
		# now IRR contains all non-spin irreducibles		
		
	fi;
		
	if info.type{[1,2]} <> "SS" then
			
		# construct spin-characters (for type AA, AS, or SA)
		NR1:= NrConjugacyClasses( SpinSymIngredients( tbl )[1] );
		NR2:= NrConjugacyClasses( SpinSymIngredients( tbl )[2] );
		IRR1:= Irr( SpinSymIngredients( tbl )[1] ){ [ info.nr1 + 1 .. NR1 ] };
		IRR2:= Irr( SpinSymIngredients( tbl )[2] ){ [ info.nr2 + 1 .. NR2 ] };
  	CHPAR1:= CharacterParameters( SpinSymIngredients( tbl )[1] ){ [ info.nr1 + 1 .. NR1 ] };
		CHPAR2:= CharacterParameters( SpinSymIngredients( tbl )[2] ){ [ info.nr2 + 1 .. NR2 ] };
		R:= SPINSYM_YNG_TSR( tbl, IRR1, IRR2, CHPAR1, CHPAR2, -1, 2 );
		Append( IRR, R.IRR );
		Append( CHPAR, R.CHPAR );
    # now IRR contains all spin irreducibles		

	else # type SS
		
		# construct spin-characters of 2.(Sym(k)xSym(l))
		
		p:= UnderlyingCharacteristic( tbl );

		# we need some more ingredients: 
		# 	partial character tables of type AA, AS, SA 
    # 	(without power maps, spin chars only)
		if p = 0 then
			AA:= SPINSYM_YNG_HEAD( info.k, info.l, "AA" );
			AS:= SPINSYM_YNG_HEAD( info.k, info.l, "AS", 
						SpinSymIngredients( AA )[1], 			# 2.Alt(k)
						SpinSymIngredients( tbl )[2] );		# 2.Sym(l)
			SA:= SPINSYM_YNG_HEAD( info.k, info.l, "SA", 
						SpinSymIngredients( tbl )[1], 			# 2.Sym(k)
						SpinSymIngredients( AA )[2] );			# 2.Alt(l)
		else
			
			ordtbl:= OrdinaryCharacterTable( tbl );
			AA:= SPINSYM_YNG_HEADREG( SpinSymIngredients( ordtbl )[ 6 ], p );
			AS:= SPINSYM_YNG_HEADREG( SpinSymIngredients( ordtbl )[ 7 ], p );
			SA:= SPINSYM_YNG_HEADREG( SpinSymIngredients( ordtbl )[ 8 ], p );
			
		fi;
			
		SpinSymIngredients( AA )[ 3 ].type:= "AAspinonly";
		SPINSYM_YNG_IRR( AA );
				
		SpinSymIngredients( AS )[ 3 ].type:= "ASspinonly";
		SPINSYM_YNG_IRR( AS );

		SpinSymIngredients( SA )[ 3 ].type:= "SAspinonly";
		SPINSYM_YNG_IRR( SA );

		SpinSymIngredients( tbl )[ 6 ]:= AA;
		SpinSymIngredients( tbl )[ 7 ]:= AS;
		SpinSymIngredients( tbl )[ 8 ]:= SA;
	
		# now we are ready to construct the spin chars via 
		# inducing up to SS from AA (possibly along AS or SA)
			
		R:= SPINSYM_YNG_IND( tbl );
		Append( IRR, R.IRR );
		Append( CHPAR, R.CHPAR );
		
  fi; 
    
  SetIrr( tbl, IRR );
  SetCharacterParameters( tbl, CHPAR );
	return tbl;

 	end );


## SpinSymCharacterTableOfMaximalYoungSubgroup( k, l, type )
##   k    : an integer greater than 1
##   l    : an integer greater than 1
##   type : a string "Alternating", 
##                   "AlternatingSymmetric", 
##                   "SymmetricAlternating", or 
##                   "Symmetric"
## returns an ordinary character table of
## 2.(Alt(k) x Alt(l)), 2.(Alt(k) x Sym(l)), 2.(Sym(k) x Alt(l)),
## or 2.(Sym(k) x Sym(l)), respectively, depending on the value
## of type.  

InstallGlobalFunction( 
	SpinSymCharacterTableOfMaximalYoungSubgroup,
	function( k, l, type )
		local tbl, ty;

			if not IsInt(k) or not IsInt(l) or k < 2 or l < 2 then
	  		Error( "both <k> and <l> must be integers greater than 1; " );
			fi;
				
			if type = "Alternating" then
	  		ty:= "AA";
			elif type = "AlternatingSymmetric" then
	  		ty:= "AS";
			elif type = "SymmetricAlternating" then
    		ty:=	"SA";
			elif type = "Symmetric" then
	  		ty:= "SS";
	  	else
	  		Error( "<type> must be \"Alternating\", \"AlternatingSymmetric\",\
	  					 \"SymmetricAlternating\", or \"Symmetric\"; " );
	  		return fail;
	  	fi;	

			tbl:= SPINSYM_YNG_HEAD( k, l, ty );
			SPINSYM_YNG_POWERMAPS( tbl );
			SPINSYM_YNG_IRR( tbl );
			SetFilterObj( tbl, IsSpinSymTable );
			return tbl;
			
		end );
	

#############################################################################
##
##  taken from Thomas' ctadmin.tbi -- just a hack for the mod-2 case in order
##  to deal with character parameters
##  obsolete if Thomas agrees to add the part that is marked by #LM below 
##  to the original function
##
#F  SPINSYM_BrauerTableFromLibrary( <ordtbl>, <prime> )
##
InstallGlobalFunction( SPINSYM_BrauerTableFromLibrary, function( ordtbl, prime )
    local op, orders, nccl, entry, fusion, facttbl, mfacttbl, reg;

      op:= ClassPositionsOfPCore( ordtbl, prime );
      orders:= OrdersClassRepresentatives( ordtbl );
      nccl:= NrConjugacyClasses( ordtbl );
      for entry in ComputedClassFusions( ordtbl ) do
        fusion:= entry.map;
        if Filtered( [ 1 .. nccl ], i -> fusion[i] = 1 ) = op then

          # We found the ordinary factor for which the Brauer characters
          # are equal to the ones we need.
          facttbl:= CharacterTableFromLibrary( entry.name );
          if facttbl = fail then
            return fail;
          fi;
          mfacttbl:= BrauerTable( facttbl, prime );
          if mfacttbl = fail then
            return fail;
          fi;

          # Now we set up a *new* Brauer table since the ordinary table
          # as well as the blocks information for the factor group is
          # different from the one for the extension.
          reg:= CharacterTableRegular( ordtbl, prime );

          # Set the irreducibles.
          # Note that the ordering of classes is in general *not* the same,
          # so we must translate with the help of fusion maps.
          fusion:= CompositionMaps(
                    InverseMap( GetFusionMap( mfacttbl, facttbl ) ),
                    CompositionMaps( GetFusionMap( ordtbl, facttbl ),
                                     GetFusionMap( reg, ordtbl ) ) );
          SetIrr( reg, List( Irr( mfacttbl ),
              chi -> Character( reg,
                  ValuesOfClassFunction( chi ){ fusion } ) ) );

          # Set known attribute values that can be copied from `mfacttbl'.
          if HasAutomorphismsOfTable( mfacttbl ) then
            SetAutomorphismsOfTable( reg, AutomorphismsOfTable( mfacttbl )
                ^ Inverse( PermList( fusion ) ) );
          fi;
          if HasInfoText( mfacttbl ) then
            SetInfoText( reg, InfoText( mfacttbl ) );
          fi;
          if HasComputedIndicators( mfacttbl ) then
            SetComputedIndicators( reg, ComputedIndicators( mfacttbl ) );
          fi; 
      
       #LM starts here
          if HasCharacterParameters( mfacttbl ) then
            SetCharacterParameters( reg, CharacterParameters( mfacttbl ) );
          fi;
       #LM ends here

          # Return the table.
          return reg;

        fi;
      od;

	end );


#############################################################################


## SpinSymBrauerTableOfMaximalYoungSubgroup( ordtbl, p )
##   ordtbl : an ordinary character table constructed by 
##            SpinSymCharacterTableOfMaximalYoungSubgroup
##   p      : a rational prime 
## returns the p-modular character table of ordtbl

InstallGlobalFunction( 
	SpinSymBrauerTableOfMaximalYoungSubgroup,
	function( ordtbl, p )
		local modtbl, ct1, ct2, ct;

			if not IsPrimeInt( p ) then
	  		Error( "<p> must be a rational prime; " );
			fi;
			if not ( IsSpinSymTable( ordtbl ) and 
							 IsOrdinaryTable( ordtbl ) ) then
				Error( "<ordtbl> must be constructed by the function \
				SpinSymCharacterTableOfMaximalYoungSubgroup(); " );
			fi;
			
			# CTblLib construction for p = 2
			if p = 2 then
				modtbl:= CharacterTableRegular( ordtbl, p );
				SetClassParameters( modtbl, 
					 ClassParameters( ordtbl ){ GetFusionMap( modtbl, ordtbl ) } );				
				##ct1:= SpinSymIngredients( ordtbl )[ 1 ] mod p;
				##ct2:= SpinSymIngredients( ordtbl )[ 2 ] mod p;
				## remove the following two lines and uncomment the previous ones
				## as soon as the hack SPINSYM_BrauerTableFromLibrary disappears
				ct1:= SPINSYM_BrauerTableFromLibrary( SpinSymIngredients( ordtbl )[ 1 ], p);
				ct2:= SPINSYM_BrauerTableFromLibrary( SpinSymIngredients( ordtbl )[ 2 ], p);
				
				if ct1 = fail or ct2 = fail then
					return fail;
				else
					ct:= CharacterTableDirectProduct( ct1, ct2 );
					SetIrr( modtbl, Irr( ct ) );
					SetCharacterParameters( modtbl,
						Cartesian( CharacterParameters( ct1 ),
											 CharacterParameters( ct2 ) ) );
					return modtbl;
				fi;
			fi;
			
			# for p > 2 use the SpinSym construction					
			if not HasSpinSymIngredients( ordtbl ) then
				Error( "missing ingredients of <ordtbl>; " ); 
			fi;
		
			modtbl:= SPINSYM_YNG_HEADREG( ordtbl, p );
			SPINSYM_YNG_IRR( modtbl );
			
			Unbind( modtbl!.SpinSymIngredients );
			
			return modtbl;
		end );
		
	
## access the Brauer table via the `mod'-operator
	
InstallMethod( BrauerTableOp, 
  Concatenation( "for an ordinary character table created by ",
	              	"SpinSymCharacterTableOfMaximalYoungSubgroup() and a positive ",
                "rational prime") ,
  [ IsSpinSymTable, IsPosInt ], 
	function( ordtbl, p )
								
		return SpinSymBrauerTableOfMaximalYoungSubgroup( ordtbl, p );
						
  end );
							
