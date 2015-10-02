#############################################################################
##
##  fus.gi                  The SpinSym Package                 Lukas Maas
##
##  Class fusion maps between some subgroups of 2.Sym(n)                     
##  Copyright (C) 2012 Lukas Maas
##
#############################################################################

## SOURCE ................ DEST ................ FUNCTION                  
## 2.Alt(n) .............. 2.Sym(n) ............ SpinSymClassFusion2Ain2S
## 2.Sym(k) .............. 2.Sym(n) ............ SpinSymClassFusion2Sin2S
## 2.Alt(k) .............. 2.Alt(n) ............ SpinSymClassFusion2Ain2A
## 2.Sym(n-2) ............ 2.Alt(n) ............ SpinSymClassFusion2Sin2A
## 2.(Sym(k) x Sym(l)) ... 2.Sym(k+l) .......... SpinSymClassFusion2SSin2S
## 2.(Sym(k) x Alt(l)) ... 2.(Sym(k) x Sym(l)) . SpinSymClassFusion2SAin2SS
## 2.(Alt(k) x Sym(l)) ... 2.(Sym(k) x Sym(l)) . SpinSymClassFusion2ASin2SS
## 2.(Alt(k) x Alt(l)) ... 2.(Sym(k) x Alt(l)) . SpinSymClassFusion2AAin2SA
## 2.(Alt(k) x Alt(l)) ... 2.(Alt(k) x Sym(l)) . SpinSymClassFusion2AAin2AS
## 2.(Alt(k) x Alt(l)) ... 2.Alt(k+l) .......... SpinSymClassFusion2AAin2A

## for m=n,k,l we denote:
## Sym(m) .... Sm
## Alt(m) .... Am	
## 2.Sym(m) .. 2Sm
## 2.Alt(m) .. 2Sm

#############################################################################
## HELPER FUNCTIONS          

## SPINSYM_IsAPD( <tau> ) ....... { All Parts Distinct }
## INPUT .... a list <tau> of integers
## OUTPUT ... true iff <tau> has pairwise distinct entries

BindGlobal( "SPINSYM_IsAPD", function( tau )

  return Length( Set( tau ) ) = Length( tau );

end );


## SPINSYM_IsAPO( <tau> ) ......... { All Parts Odd }
## INPUT ....	a list <tau> of integers
## OUTPUT ... true iff all entries of <tau> are odd

BindGlobal( "SPINSYM_IsAPO", function( tau )

  return ForAll( tau, IsOddInt );

end );


#############################################################################
## USER FUNCTIONS

## SpinSymClassFusion2Ain2S( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.Alt(n) 
## .......... class parameters <cclY> of 2.Sym(n) 
## see \cite{Maas2011}*{(5.4.1)}

InstallGlobalFunction( SpinSymClassFusion2Ain2S, function( cclX, cclY )
  local fus, x, y, z;
	
  fus:= [];
  for x in cclX do
    if '+' in x[2] or '-' in x[2] then
      y:= x[2][1];
    else
      y:= x[2];
    fi;
    if SPINSYM_IsAPO( y ) and SPINSYM_IsAPD( y ) then
      ## y in O(n)\cap D^+(n): 
      ## +\- split classes of corresponding type (1\2) fuse in 2.Sym(n) 
      z:= [ x[1], y ];
    elif SPINSYM_IsAPO(y) then
      ## y in O(n) but not in D^+(n):
      ## there is a class in 2.Sym(n) of corresponding type (1\2)
      z:= [ x[1], y ];
    else 
      ## y in D^+(n) but not in O(n), or y is not in O(n)\cup D(n):
      ## either the classes of type 1 and 2 fuse in 2.Sym(n), 
      ## or there is only one class of type 1 in both 2.Alt(n) and 2.Sym(n)
      z:= [ 1, y ];
    fi;
    Add( fus, Position( cclY, z ) );
  od;	
  return fus;

end );


## SpinSymClassFusion2Sin2S( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.Sym(k) 
## .......... class parameters <cclY> of 2.Sym(n) for k<n
## see \cite{Maas2011}*{(5.4.2)}

## RECALL: the 1\2 split classes of 2.Sym(n) are parameterized by O(n)\cup D^-(n).

InstallGlobalFunction( SpinSymClassFusion2Sin2S, function( cclX, cclY )
  local m, fus, x, y, z;

  m:= Sum( cclY[1][2] ) - Sum( cclX[1][2] );
  m:= ListWithIdenticalEntries( m, 1 );
  fus:= [ ];
  for x in cclX do
    y:= Concatenation( x[2], m ); 
    if SPINSYM_IsAPO( y ) then 
      ## x is split in 2.Sym(k) and y is still split in 2.Sym(n) 
      z:= [ x[1], y ];
    elif SPINSYM_IsAPD( y ) and SignPartition(y)=-1 then 
      ## k=n-1 and no part of x equals 1:
      ## y is split in 2.Sym(n)
      z:= [ x[1], y ];
    else
      z:= [ 1, y ];
    fi;
    Add( fus, Position( cclY, z ) );
  od;
  return fus;

end );


## SpinSymClassFusion2Ain2A( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.Alt(k) 
## .......... class parameters <cclY> of 2.Alt(n) for k<n
## see \cite{Maas2011}*{(5.4.3)}

## RECALL: the 1\2 split classes of 2.Alt(n) are parameterized by O(n)\cup D^+(n);
## RECALL: the +\- split classes of Alt(n) are parameterized by O(n)\cap D^+(n).
## If x in O(n)\cap D^+(n), then there are the following four classes in 2.Alt(n):
##  1_x+ = [ 1, [ x, '+' ] ]
##  2_x+ = [ 2, [ x, '+' ] ]
##  1_x- = [ 1, [ x, '-' ] ]
##  2_x- = [ 2, [ x, '-' ] ]

InstallGlobalFunction( SpinSymClassFusion2Ain2A, function( cclX, cclY )
  local filt, m, fus, x, y, z;
  
  filt:= function(x)
		return Flat(Filtered(x,y->not IsChar(y)));
	end;
  m:= Sum( filt(cclY[1][2]) ) - Sum( filt(cclX[1][2]) );
  m:= ListWithIdenticalEntries( m, 1 );
  fus:= [ ];
  for x in cclX do
    if '+' in x[2] or '-' in x[2] then
      y:= Concatenation( x[2][1], m );
    else
      y:= Concatenation( x[2], m );
    fi;
    if SPINSYM_IsAPO( y ) and SPINSYM_IsAPD( y ) then	
      ## k = n-1 and 1 is not a part of x:
      ## then 1\2_x+- of 2.Alt(k) corresponds to 1\2_y+- in 2.Alt(n)
      z:= [ x[1], [ y, x[2][2] ] ];
    elif SPINSYM_IsAPO( y ) or SPINSYM_IsAPD( y ) then 	
      ## y is a 1\2 split class in 2.Alt(n); 
      ## the +\- split classes fuse in 2.Alt(n) in correspondence with their type 1\2
      z:= [ x[1], y ];
    else
      z:= [ 1, y ];
    fi;
    Add( fus, Position( cclY, z ) );
  od;
  return fus;

end );


## SpinSymClassFusion2Sin2A( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.Sym(n-2) 
## .......... class parameters <cclY> of 2.Alt(n) 
## see \cite{Maas2011}*{(5.4.4)}

InstallGlobalFunction( SpinSymClassFusion2Sin2A, function( cclX, cclY )
  local fus, x, y, z;
	
  fus:= [];
  for x in cclX do
    y:= x[2];
    if SignPartition( y ) = 1 then
      z:= Concatenation( y, [1,1] );
      if SPINSYM_IsAPO( y ) then
        z:= [ x[1], z ];
      else
        z:= [ 1, z ];
      fi;
    else ## SignPartition( y ) = -1
      z:= Reversed( SortedList( Concatenation( y, [2] ) ) );
      if SPINSYM_IsAPD( y ) and not 2 in y then
        z:= [ x[1], z ];
      else 
        z:= [ 1, z ];
      fi;
    fi;		
    Add( fus, Position( cclY, z ) );
  od;
  return fus;

end );
	

## SpinSymClassFusion2SSin2S( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Sym(k) x Sym(l))  
## .......... class parameters <cclY> of 2.Sym(n) for n=k+l 
## see \cite{Maas2011}*{(5.4.5)}

InstallGlobalFunction( SpinSymClassFusion2SSin2S, function( cclX, cclY )
  local fus, x, pi, tau, mu, y, pi_o, pi_e, tau_o, tau_e, o, e, s;
	
  fus:= [];
  for x in cclX do
    pi:=  x[2][1];
    tau:= x[2][2];
    mu:= Reversed( SortedList( Concatenation( pi, tau ) ) );
    if SPINSYM_IsAPO( mu ) then
      y:= [ x[1], mu ];
    elif SPINSYM_IsAPD( mu ) and SignPartition( mu ) = -1 then
      pi_o:= Filtered( pi, k-> k mod 2 = 1 );
      pi_e:= Filtered( pi, k-> k mod 2 = 0 );
      tau_o:= Filtered( tau, k-> k mod 2 = 1 );
      tau_e:= Filtered( tau, k-> k mod 2 = 0 );
      ## number of shuffles (i,j) -> (j,i) with i=j=1 mod 2:
      o:= List( tau_o, i-> Number( pi_o, j-> j<i ) );
      ## number of shuffles (i,j) -> (j,i) with i=j=0 mod 2:
      e:= List( tau_e, i-> Number( pi_e, j-> j<i ) );
      s:= ( Sum(o) + Sum(e) ) mod 2;
      if s = 0 then
        y:= [ x[1], mu ];
      else ## 1\2_x corresponds to 2\1_mu
        y:= [ x[1] mod 2 + 1, mu ];
      fi;
    else ## mu is not in O(n) or D^-(n)
      y:= [ 1, mu ];
    fi;
    Add( fus, Position( cclY, y ) );
  od;
  return fus;

end );


## SpinSymClassFusion2SAin2SS( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Sym(k) x Alt(l))  
## .......... class parameters <cclY> of 2.(Sym(k) x Sym(l))
## see \cite{Maas2011}*{(5.4.6)}

InstallGlobalFunction( SpinSymClassFusion2SAin2SS, function( cclX, cclY )
  local fus, x, pi, xtau, tau, y;
	
  fus:= [];
  for x in cclX do
    pi:=   x[2][1];
    xtau:= x[2][2];
    if '+' in xtau or '-' in xtau then
      tau:= xtau[1];
    else
      tau:= xtau;
    fi;
    if SPINSYM_IsAPO( pi ) and SPINSYM_IsAPO( tau ) then		
      if not SPINSYM_IsAPD( tau ) then 
        ## (pi,tau) is in O(k) x (O(l)\D^+(l))
        y:= [ x[1], [ pi, tau ] ];
      else 
        ## (pi,tau) is in O(k) x (O(l)\cap D^+(l))
        if '+' in xtau then
          y:= [ x[1], [ pi, tau ] ]; 
        else ## '-' in xtau
          y:= [ x[1], [ pi, tau ] ]; ## since pi is even 
        fi; 
      fi;
    elif SPINSYM_IsAPD( pi ) and SignPartition( pi ) = -1 and SPINSYM_IsAPD( tau ) then
      ## now (pi,tau) is in D(k)^- x D^+(k)
      if not SPINSYM_IsAPO( tau ) then 
        y:= [ x[1], [ pi, tau ] ];
      else 
        ## (pi,tau) is in D^-(k) x (O(l)\cap D^+(l))
        if '+' in xtau then
          y:= [ x[1], [ pi, tau ] ]; 
        else ## '-' in xtau 
          y:= [ x[1] mod 2 + 1, [ pi, tau ] ]; ## since pi is odd
        fi;
      fi;
    else
      ## (pi,tau) is not split in 2.(Sym(k) x Sym(l))
      y:= [ 1, [ pi, tau ] ];
    fi;
    Add( fus, Position( cclY, y ) );
  od;
  return fus;

end );
	

## SpinSymClassFusion2ASin2SS( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Alt(k) x Sym(l))  
## .......... class parameters <cclY> of 2.(Sym(k) x Sym(l))

InstallGlobalFunction( SpinSymClassFusion2ASin2SS, function( cclX, cclY )
  local fus, x, xpi, pi, tau, y;
	
  fus:= [];
  for x in cclX do
    xpi:= x[2][1];
    tau:= x[2][2];
    if '+' in xpi or '-' in xpi then
      pi:= xpi[1];
    else
      pi:= xpi;
    fi;
    if SPINSYM_IsAPO( pi ) and SPINSYM_IsAPO( tau ) then
			   if not SPINSYM_IsAPD( pi ) then 
        y:= [ x[1], [ pi, tau ] ];
      else 
        if '+' in xpi then
          y:= [ x[1], [ pi, tau ] ]; 
        else ## '-' in xpi 
          y:= [ x[1], [ pi, tau ] ]; 
        fi; 
      fi;
    elif SPINSYM_IsAPD( pi ) and SPINSYM_IsAPD( tau ) and SignPartition( tau ) = -1 then
      if not SPINSYM_IsAPO( pi ) then 
        y:= [ x[1], [ pi, tau ] ];
      else 
        if '+' in xpi then
          y:= [ x[1], [ pi, tau ] ]; 
        else ## '-' in xpi 
          y:= [ x[1] mod 2 + 1, [ pi, tau ] ]; 
        fi;  
      fi;
    else
      y:= [ 1, [ pi, tau ] ];
    fi;
    Add( fus, Position( cclY, y ) );
  od;
  return fus;
  
end );	
	
	
## SpinSymClassFusion2AAin2SA( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Alt(k) x Alt(l))  
## .......... class parameters <cclY> of 2.(Sym(k) x Alt(l))
## see \cite{Maas2011}*{(5.4.7)}

InstallGlobalFunction( SpinSymClassFusion2AAin2SA, function( cclX, cclY )
  local fus, x, xpi, pi, tau, y, pos;

  fus:= [ ];
  for x in cclX do
    xpi:= x[2][1];
    tau:= x[2][2];
    if '+' in xpi or '-' in xpi then
      pi:= xpi[1];
    else
      pi:= xpi;
    fi;
    y:= [ x[1], [ pi, tau ] ];
    ## 1\2_x corresponds to 1\2_y if there are split classes 1_y and 2_y
    ## otherwise, 1\2_x fuse in 1_y
    pos:= Position( cclY, y );
    if pos = fail then
      y:= [ 1, [ pi, tau ] ];
      pos:= Position( cclY, y );
    fi;
    Add( fus, pos );
  od;
  return fus;

end );	


## SpinSymClassFusion2AAin2AS( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Alt(k) x Alt(l))  
## .......... class parameters <cclY> of 2.(Alt(k) x Sym(l))

InstallGlobalFunction( SpinSymClassFusion2AAin2AS, function( cclX, cclY )
  local fus, x, pi, xtau, tau, y, pos;
	
  fus:= [ ];
  for x in cclX do
    pi:= x[2][1];
    xtau:= x[2][2];
    if '+' in xtau or '-' in xtau then
      tau:= xtau[1];
    else
      tau:= xtau;
    fi;
    y:= [ x[1], [ pi, tau ] ];
    ## 1\2_x corresponds to 1\2_y if there are split classes 1_y and 2_y
    ## otherwise, 1\2_x fuse in 1_y   
    pos:= Position( cclY, y );
    if pos = fail then
      y:= [ 1, [ pi, tau ] ];
      pos:= Position( cclY, y );
    fi;
    Add( fus, pos );
  od;
  return fus;

end );	


## SpinSymClassFusion2AAin2A( <cclX>, <cclY> )
## INPUT .... class parameters <cclX> of 2.(Alt(k) x Alt(l))  
## .......... class parameters <cclY> of 2.Alt(n) for n=k+l 
## see \cite{Maas2011}*{(5.4.8)}

## RECALL: the 1\2 split classes of 2.Alt(n) are parameterized by O(n)\cup D^+(n);
## RECALL: the +\- split classes of Alt(n) are parameterized by O(n)\cap D^+(n).

InstallGlobalFunction( SpinSymClassFusion2AAin2A, function( cclX, cclY )
  local splittype, fus, x, xpi, xtau, pi, tau, sgnpi, sgntau, 
        mu, y, pi_o, pi_e, tau_e, o, e, f, type;
	
  splittype:= function( tau )
  	if SPINSYM_IsAPO( tau ) and SPINSYM_IsAPD( tau ) then
    	return [ tau, '+' ];
  	else
    	return tau;
  	fi;
	end;
  
  fus:= [];
  for x in cclX do
    xpi:= x[2][1];
    xtau:= x[2][2];
    if '+' in xpi or '-' in xpi then
      pi:= xpi[1];
      sgnpi:= xpi[2];
    else
      pi:= xpi;
      sgnpi:= '+';
    fi;
    if '+' in xtau or '-' in xtau then
      tau:= xtau[1];
      sgntau:= xtau[2];
    else
      tau:= xtau;
      sgntau:= '+';
    fi;
    mu:= Reversed( SortedList( Concatenation( pi, tau ) ) );
		
    if not SPINSYM_IsAPO( mu ) and not SPINSYM_IsAPD( mu ) then
    
      y:= [ 1, mu ];
    
    else
    
      pi_o:= Filtered( pi, t-> t mod 2 = 1 );
      pi_e:= Filtered( pi, t-> t mod 2 = 0 );
      tau_e:= Filtered( tau, t-> t mod 2 = 0 );
      e:= Sum( List( tau_e, i-> Number( pi, j-> j<i ) ) );
      o:= Sum( List( tau, i-> Number( pi_o, j-> j<i ) ) );
      f:= Length( pi_e ) + Length( tau_e );
      type:= Set( [ sgnpi, sgntau ] ); ## "+-", "+", or "-"
      if x[1] = 2 then
        e:= e+1; ## second class 
      fi;
      
      if type = "+" or type = "-" then
				    
				    if o mod 2 = 0 then
          y:= [ e, splittype(mu)  ];
        elif f > 0 then ## o is odd 
          y:= [ e+f-1, mu ]; 
        elif not SPINSYM_IsAPD(mu) then ## o is odd and f=0
          y:= [ e, mu ];
        else
          y:= [ e, [ mu, '-' ] ];
        fi;

      else # type = "+-"

        if o mod 2 = 1 then
          y:= [ e, splittype( mu ) ];
        elif f > 0 then ## o is even
          y:= [ e+f-1, mu ]; 
        elif not SPINSYM_IsAPD(mu) then ## o is even and f=0
          y:= [ e, mu  ];
        else 
          y:= [ e, [ mu, '-' ] ];
        fi;

      fi;
			
			   ## y[1]=1 if the exponent of z in even, y[2]=2 otherwise
      y:= [ y[1] mod 2 + 1, y[2] ];
			
    fi;
		  Add( fus, Position( cclY, y ) );
  od;
  return fus;

end );		
		

#############################################################################
## MAIN USER FUNCTION
## SpinSymClassFusion( <X>, <Y> )
## INPUT .... (ordinary or modular) 'generic' character table <X> of SOURCE  
## .......... (ordinary or modular) 'generic' character table <Y> of DEST 
## .......... where the possible pairs of SOURCE and DEST are
## .......... ...............................................
## .......... SOURCE ................ DEST ..................
## .......... 2.Alt(n) .............. 2.Sym(n) 
## .......... 2.Sym(k) .............. 2.Sym(n) 
## .......... 2.Alt(k) .............. 2.Alt(n)
## .......... 2.Sym(n-2) ............ 2.Alt(n) 
## .......... 2.(Sym(k) x Sym(l)) ... 2.Sym(k+l) 
## .......... 2.(Sym(k) x Alt(l)) ... 2.(Sym(k) x Sym(l)) 
## .......... 2.(Alt(k) x Sym(l)) ... 2.(Sym(k) x Sym(l))  
## .......... 2.(Alt(k) x Alt(l)) ... 2.(Sym(k) x Alt(l))  
## .......... 2.(Alt(k) x Alt(l)) ... 2.(Alt(k) x Sym(l))  
## .......... 2.(Alt(k) x Alt(l)) ... 2.Alt(k+l)  

## OUTPUT ... the fusion map fus from SOURCE to DEST as returned by  
## .......... SpinSymClassFusionSOURCEinDEST
## .......... the fusion map is stored only if there is no fusion map from 
## .......... SOURCE to DEST stored yet 

InstallGlobalFunction( SpinSymClassFusion, function( X, Y )
  local idX, idY, S, A, type, cclX, cclY, fus, storedfus;
	
  idX:= Identifier( X );
  idY:= Identifier( Y );

  S:= Filtered( idX, x-> x = 'S' );
  A:= Filtered( idX, x-> x = 'A' );
  if Length(S) = Length(A) then  ## type 2SA or 2AS
  	if Position( idX, 'S' ) < Position( idX, 'A' ) then
  		type:= Concatenation( "2", S, A );
  	else
  		type:= Concatenation( "2", A, S );
  	fi;
  else
  	type:= Concatenation( "2", S, A );
	fi;
  S:= Filtered( idY, x-> x = 'S' );
  A:= Filtered( idY, x-> x = 'A' );
  if Length(S) = Length(A) then  ## type 2SA or 2AS
  	if Position( idY, 'S' ) < Position( idY, 'A' ) then
  		type:= Concatenation( type, "fus", "2", S, A );
  	else
  		type:= Concatenation( type, "fus", "2", A, S );
  	fi;
  else
  	type:= Concatenation( type, "fus", "2", S, A );
	fi;
	
  cclX:= ClassParameters( X );
  cclY:= ClassParameters( Y );

  ## call the appropriate SpinSymClassFusionSOURCEinDEST function
  if type="2Afus2S" then
    fus:= SpinSymClassFusion2Ain2S( cclX, cclY );	
  elif type="2Sfus2S" then
    fus:= SpinSymClassFusion2Sin2S( cclX, cclY );
  elif type="2Afus2A" then
    fus:= SpinSymClassFusion2Ain2A( cclX, cclY );		
  elif type="2Sfus2A" then
    fus:= SpinSymClassFusion2Sin2A( cclX, cclY );
  elif type="2SSfus2S" then
    fus:= SpinSymClassFusion2SSin2S( cclX, cclY );
  elif type="2SAfus2SS" then
    fus:= SpinSymClassFusion2SAin2SS( cclX, cclY );
  elif type="2ASfus2SS" then
    fus:= SpinSymClassFusion2ASin2SS( cclX, cclY );
  elif type="2AAfus2SA" then
    fus:= SpinSymClassFusion2AAin2SA( cclX, cclY );
  elif type="2AAfus2AS" then
    fus:= SpinSymClassFusion2AAin2AS( cclX, cclY );
  elif type="2AAfus2A" then
    fus:= SpinSymClassFusion2AAin2A( cclX, cclY );
  else
    fus:= fail;
  fi;	
		
  ## now store the fusion only if there is no fusion map available
  storedfus:= GetFusionMap( X, Y );
  if storedfus <> fail then
    if storedfus <> fus then
      Print( "#I SpinSymClassFusion: WARNING\n", 
      "#I ................... a different fusion map from ", idX, " to ", 
      idY, " is stored already\n" ); 
    fi;	
  elif not fail in fus then
    StoreFusion( X, fus, Y );
    Print( "#I SpinSymClassFusion: stored fusion map from ", 
           idX, " to ", idY, "\n" ); 
  else
    return fail;
  fi;
  return fus;
 
end );

