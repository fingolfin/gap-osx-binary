#############################################################################
##
#W  zmodnz.gi                   GAP library                     Thomas Breuer
##
##
#Y  Copyright (C)  1997,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St Andrews, Scotland
#Y  Copyright (C) 2002 The GAP Group
##
##  This file contains methods for the elements of the rings $Z / n Z$
##  in their representation via the residue modulo $n$.
##  This residue is always assumed to be in the range $[ 0, 1 ..., n-1 ]$.
##
##  Each ring $\Z / n \Z$ contains the whole elements family if $n$ is not a
##  prime, and is embedded into the family of finite field elements of
##  characteristic $n$ otherwise.
##
##  If $n$ is not a prime then an external representation of elements is
##  defined.  For the element $k + n \Z$, it is the representative $k$,
##  chosen such that $0 \leq k \leq n - 1$.
##
##  The ordering of elements for nonprime $n$ is defined by the ordering of
##  the representatives.
##  For primes smaller than `MAXSIZE_GF_INTERNAL', the ordering of the
##  internal finite field elements must be respected, for larger primes
##  again the ordering of representatives is chosen.
##

#T for small residue class rings, avoid constructing new objects by
#T keeping an elements list, and change the constructor such that the
#T object in question is just fetched
#T (check performance for matrices over Z/4Z, say)

#############################################################################
##
#V  ZNZ_PURE_TYPE
##
##  position where the type of an object in $\Z \bmod n \Z$
##  stores the default type
##
DeclareSynonym( "ZNZ_PURE_TYPE", POS_FIRST_FREE_TYPE );


#############################################################################
##
#R  IsModulusRep( <obj> )
##
##  Objects in this representation are defined by a single data entry, an
##  integer at first position.
##
DeclareRepresentation( "IsModulusRep", IsPositionalObjectRep, [ 1 ] );


#############################################################################
##
##  1. The elements
##


#############################################################################
##
#M  ZmodnZObj( <Fam>, <residue> )
#M  ZmodnZObj( <residue>, <modulus> )
##
InstallMethod( ZmodnZObj,
    "for family of elements in Z/nZ (nonprime), and integer",
    [ IsZmodnZObjNonprimeFamily, IsInt ],
    function( Fam, residue )
    return Objectify( Fam!.typeOfZmodnZObj,
                   [ residue mod Fam!.modulus ] );
    end );

InstallOtherMethod( ZmodnZObj,
    "for family of FFE elements, and integer",
    [ IsFFEFamily, IsInt ],
    function( Fam, residue )
    local p;
    p:= Characteristic( Fam );
    if not IsBound( Fam!.typeOfZmodnZObj ) then

      # Store the type for the representation of prime field elements
      # via residues.
      Fam!.typeOfZmodnZObj:= NewType( Fam,
                                 IsZmodpZObjSmall and IsModulusRep );
      SetDataType( Fam!.typeOfZmodnZObj, p );
      Fam!.typeOfZmodnZObj![ ZNZ_PURE_TYPE ]:= Fam!.typeOfZmodnZObj;

    fi;
    return Objectify( Fam!.typeOfZmodnZObj, [ residue mod p ] );
    end );

InstallMethod( ZmodnZObj,
    "for a positive integer, and an integer -- check small primes",
    [ IsInt, IsPosInt ],
    function( residue, n )
    if n in PRIMES_COMPACT_FIELDS then
      return residue*Z(n)^0;
    else
      return ZmodnZObj( ElementsFamily( FamilyObj( ZmodnZ( n ) ) ), residue );
    fi;
    end );


#############################################################################
##
#M  ObjByExtRep( <Fam>, <residue> )
##
##  Note that finite field elements do not have an external representation.
##
InstallMethod( ObjByExtRep,
    "for family of elements in Z/nZ (nonprime), and integer",
    [ IsZmodnZObjNonprimeFamily, IsInt ],
    function( Fam, residue )
    return ZmodnZObj( Fam, residue mod Fam!.modulus );
    end );


#############################################################################
##
#M  ExtRepOfObj( <obj> )
##
InstallMethod( ExtRepOfObj,
    "for element in Z/nZ (ModulusRep, nonprime)",
    [ IsZmodnZObjNonprime and IsModulusRep ],
    obj -> obj![1] );


#############################################################################
##
#M  PrintObj( <obj> ) . . . . . . . . . . .  for element in Z/nZ (ModulusRep)
##
InstallMethod( PrintObj,
    "for element in Z/nZ (ModulusRep)",
    IsZmodnZObjNonprimeFamily,
    [ IsZmodnZObj and IsModulusRep ],
    function( x )
    Print( "ZmodnZObj( ", x![1], ", ", DataType( TypeObj( x ) ), " )" );
    end );

InstallMethod( PrintObj,
    "for element in Z/pZ (ModulusRep)",
    [ IsZmodpZObj and IsModulusRep ],
    function( x )
    Print( "ZmodpZObj( ", x![1], ", ", Characteristic( x ), " )" );
    end );

InstallMethod( String,
    "for element in Z/nZ (ModulusRep)",
    IsZmodnZObjNonprimeFamily,
    [ IsZmodnZObj and IsModulusRep ],
    function( x )
      return Concatenation( "ZmodnZObj(", String(x![1]), ",", 
      String(DataType(TypeObj(x))), ")" );
    end );

InstallMethod( String,
    "for element in Z/pZ (ModulusRep)",
    [ IsZmodpZObj and IsModulusRep ],
    function( x )
      return Concatenation( "ZmodpZObj(", String(x![1]), ",", 
      String(Characteristic( x )), ")" );
    end );


#############################################################################
##
#M  \=( <x>, <y> )
#M  \<( <x>, <y> )
##
InstallMethod( \=,
    "for two elements in Z/nZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodnZObj and IsModulusRep, IsZmodnZObj and IsModulusRep ],
    function( x, y ) return x![1] = y![1]; end );

InstallMethod( \=,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObj and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y )
    return DegreeFFE( y ) = 1 and x![1] = IntFFE( y );
    end );

InstallMethod( \=,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObj and IsModulusRep ],
    function( x, y )
    return DegreeFFE( x ) = 1 and y![1] = IntFFE( x );
    end );

InstallMethod( \<,
    "for two elements in Z/nZ (ModulusRep, nonprime)",
    IsIdenticalObj,
    [ IsZmodnZObjNonprime and IsModulusRep,
      IsZmodnZObjNonprime and IsModulusRep ],
    function( x, y ) return x![1] < y![1]; end );

InstallMethod( \<,
    "for two elements in Z/pZ (ModulusRep, large)",
    IsIdenticalObj,
    [ IsZmodpZObjLarge and IsModulusRep,
      IsZmodpZObjLarge and IsModulusRep ],
    function( x, y ) return x![1] < y![1]; end );

InstallMethod( \<,
    "for two elements in Z/pZ (ModulusRep, small)",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep,
      IsZmodpZObjSmall and IsModulusRep ],
    function( x, y )
    local p, r;      # characteristic and primitive root
    if x![1] = 0 then
      return y![1] <> 0;
    elif y![1] = 0 then
      return false;
    else
      p:= Characteristic( x );
      r:= PrimitiveRootMod( p );
      return LogMod( x![1], r, p ) < LogMod( y![1], r, p );
    fi;
    end );

InstallMethod( \<,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y )
    return x![1] * One( Z( Characteristic( x ) ) ) < y;
    end );

InstallMethod( \<,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObjSmall and IsModulusRep ],
    function( x, y )
    return x < y![1] * One( Z( Characteristic( y ) ) );
    end );


#############################################################################
##
#M  \+( <x>, <y> )
#M  \-( <x>, <y> )
#M  \*( <x>, <y> )
#M  \/( <x>, <y> )
#M  \^( <x>, <n> )
##
##  The result of an arithmetic operation of
##  - two `ZmodnZObj' is again a `ZmodnZObj',
##  - a `ZmodnZObj' and a rational with acceptable denominator
##    is a `ZmodnZObj',
##  - a `ZmodpZObj' and an internal FFE in the same characteristic
##    is an internal FFE.
##
InstallMethod( \+,
    "for two elements in Z/nZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodnZObj and IsModulusRep, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] + y![1] ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \+,
    "for element in Z/nZ (ModulusRep) and integer",
    [ IsZmodnZObj and IsModulusRep, IsInt ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] + y ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \+,
    "for integer and element in Z/nZ (ModulusRep)",
    [ IsInt, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                      [ ( x + y![1] ) mod DataType( TypeObj( y ) ) ] );
    end );

InstallMethod( \+,
    "for element in Z/nZ (ModulusRep) and rational",
    [ IsZmodnZObj and IsModulusRep, IsRat ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( x ) );
    if GcdInt( DenominatorRat( y ), m ) = 1 then
      return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                        [ ( x![1] + y ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \+,
    "for rational and element in Z/nZ (ModulusRep)",
    [ IsRat, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( y ) );
    if GcdInt( DenominatorRat( x ), m ) = 1 then
      return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                        [ ( x + y![1] ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \+,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y ) return x![1] + y; end );

InstallMethod( \+,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObjSmall and IsModulusRep ],
    function( x, y ) return x + y![1]; end );


InstallMethod( \-,
    "for two elements in Z/nZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodnZObj and IsModulusRep, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] - y![1] ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \-,
    "for element in Z/nZ (ModulusRep) and integer",
    [ IsZmodnZObj and IsModulusRep, IsInt ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] - y ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \-,
    "for integer and element in Z/nZ (ModulusRep)",
    [ IsInt, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                      [ ( x - y![1] ) mod DataType( TypeObj( y ) ) ] );
    end );

InstallMethod( \-,
    "for element in Z/nZ (ModulusRep) and rational",
    [ IsZmodnZObj and IsModulusRep, IsRat ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( x ) );
    if GcdInt( DenominatorRat( y ), m ) = 1 then
      return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                        [ ( x![1] - y ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \-,
    "for rational and element in Z/nZ (ModulusRep)",
    [ IsRat, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( y ) );
    if GcdInt( DenominatorRat( x ), m ) = 1 then
      return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                        [ ( x - y![1] ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \-,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y ) return x![1] - y; end );

InstallMethod( \-,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObjSmall and IsModulusRep ],
    function( x, y ) return x - y![1]; end );


InstallMethod( \*,
    "for two elements in Z/nZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodnZObj and IsModulusRep, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] * y![1] ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \*,
    "for element in Z/nZ (ModulusRep) and integer",
    [ IsZmodnZObj and IsModulusRep, IsInt ],
    function( x, y )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                      [ ( x![1] * y ) mod DataType( TypeObj( x ) ) ] );
    end );

InstallMethod( \*,
    "for integer and element in Z/nZ (ModulusRep)",
    [ IsInt, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                      [ ( x * y![1] ) mod DataType( TypeObj( y ) ) ] );
    end );

InstallMethod( \*,
    "for element in Z/nZ (ModulusRep) and rational",
    [ IsZmodnZObj and IsModulusRep, IsRat ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( x ) );
    if GcdInt( DenominatorRat( y ), m ) = 1 then
      return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                        [ ( x![1] * y ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \*,
    "for rational and element in Z/nZ (ModulusRep)",
    [ IsRat, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( y ) );
    if GcdInt( DenominatorRat( x ), m ) = 1 then
      return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                        [ ( x * y![1] ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \*,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y ) return x![1] * y; end );

InstallMethod( \*,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObjSmall and IsModulusRep ],
    function( x, y ) return x * y![1]; end );


InstallMethod( \/,
    "for two elements in Z/nZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodnZObj and IsModulusRep, IsZmodnZObj and IsModulusRep ],
        function( x, y )
    local q;
    q := QuotientMod( Integers, x![1], y![1],
                 DataType( TypeObj( x ) ) );
    if q = fail then
        return fail;
    else
        # Avoid to touch the rational arithmetics.
        return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                       [ q ] );
    fi;
    end );

InstallMethod( \/,
    "for element in Z/nZ (ModulusRep) and integer",
    [ IsZmodnZObj and IsModulusRep, IsInt ],
    function( x, y )
    local q;
    q := QuotientMod( Integers, x![1], y,
                 DataType( TypeObj( x ) ) );
    if q = fail then
        return fail;
    else
        # Avoid to touch the rational arithmetics.
        return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                       [ q ] );
    fi;
end );

InstallMethod( \/,
    "for integer and element in Z/nZ (ModulusRep)",
    [ IsInt, IsZmodnZObj and IsModulusRep ],
        function( x, y )
    local q;
    q := QuotientMod( Integers, x, y![1],
                 DataType( TypeObj( y ) ) );
    if q = fail then
        return fail;
    else
        # Avoid to touch the rational arithmetics.
        return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                       [ q ] );
    fi;
end );

InstallMethod( \/,
    "for element in Z/nZ (ModulusRep) and rational",
    [ IsZmodnZObj and IsModulusRep, IsRat ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( x ) );
    if GcdInt( NumeratorRat( y ), m ) = 1 then
      return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                        [ ( x![1] / y ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \/,
    "for rational and element in Z/nZ (ModulusRep)",
    [ IsRat, IsZmodnZObj and IsModulusRep ],
    function( x, y )
    local m;
    m:= DataType( TypeObj( y ) );
    if GcdInt( DenominatorRat( x ), m ) = 1 then
      return Objectify( TypeObj( y )![ ZNZ_PURE_TYPE ],
                        [ ( x / y![1] ) mod m ] );
    else
      return fail;
    fi;
    end );

InstallMethod( \/,
    "for element in Z/pZ (ModulusRep) and internal FFE",
    IsIdenticalObj,
    [ IsZmodpZObjSmall and IsModulusRep, IsFFE and IsInternalRep ],
    function( x, y ) return x![1] / y; end );

InstallMethod( \/,
    "for internal FFE and element in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsFFE and IsInternalRep, IsZmodpZObjSmall and IsModulusRep ],
    function( x, y ) return x / y![1]; end );


InstallMethod( \^,
    "for element in Z/nZ (ModulusRep), and integer",
    [ IsZmodnZObj and IsModulusRep, IsInt ],
    function( x, n )
    return Objectify( TypeObj( x )![ ZNZ_PURE_TYPE ],
                  [ PowerModInt( x![1], n, DataType( TypeObj( x ) ) ) ] );
    end );


#############################################################################
##
#M  ZeroOp( <elm> ) . . . . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallMethod( ZeroOp,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj ],
    elm -> ZmodnZObj( FamilyObj( elm ), 0 ) );


#############################################################################
##
#M  AdditiveInverseOp( <elm> )  . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallMethod( AdditiveInverseOp,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj and IsModulusRep ],
    elm -> ZmodnZObj( FamilyObj( elm ), AdditiveInverse( elm![1] ) ) );


#############################################################################
##
#M  OneOp( <elm> )  . . . . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallMethod( OneOp,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj ],
    elm -> ZmodnZObj( FamilyObj( elm ), 1 ) );


#############################################################################
##
#M  InverseOp( <elm> )  . . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallMethod( InverseOp,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj and IsModulusRep ],
    function( elm )
    local inv;
    inv:= QuotientMod( Integers, 1, elm![1], ModulusOfZmodnZObj( elm ) );
    if inv <> fail then
      inv:= ZmodnZObj( FamilyObj( elm ), inv );
    fi;
    return inv;
    end );

#############################################################################
##
#M  Order( <obj> )  . . . . . . . . . . . . . . . . . . . . for `IsZmodpZObj'
##
InstallMethod( Order,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj and IsModulusRep ],
    function( elm )
    local ord;
    ord := OrderMod( elm![1], ModulusOfZmodnZObj( elm ) );
    if ord = 0  then
        Error( "<obj> is not invertible" );
    fi;
    return ord;
    end );

#############################################################################
##
#M  DegreeFFE( <obj> )  . . . . . . . . . . . . . . . . . . for `IsZmodpZObj'
##
InstallMethod( DegreeFFE,
    "for element in Z/pZ (ModulusRep)",
    [ IsZmodpZObj and IsModulusRep ],
    z -> 1 );


#############################################################################
##
#M  LogFFE( <n>, <r> )  . . . . . . . . . . . . . . . . . . for `IsZmodpZObj'
##
InstallMethod( LogFFE,
    "for two elements in Z/pZ (ModulusRep)",
    IsIdenticalObj,
    [ IsZmodpZObj and IsModulusRep, IsZmodpZObj and IsModulusRep ],
    function( n, r )
    return LogMod( n![1], r![1], Characteristic( n ) );
    end );


#############################################################################
##
#M  Int( <obj> )  . . . . . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallMethod( Int,
    "for element in Z/nZ (ModulusRep)",
    [ IsZmodnZObj and IsModulusRep ],
    z -> z![1] );

#############################################################################
##
#M IntFFE( <obj> )  . .  . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##

InstallMethod(IntFFE,
        [IsZmodpZObj and IsModulusRep],
        x->x![1]);
        


#############################################################################
##
#M  IntFFESymm( <obj> )  . . . . . . . . . . . . . . . . . . . for `IsZmodnZObj'
##
InstallOtherMethod(IntFFESymm,"Z/nZ (ModulusRep)",
  [IsZmodnZObj and IsModulusRep],
function(z)
local p;
  p:=DataType(TypeObj(z));
  if 2*z![1]>p then
    return z![1]-p;
  else
    return z![1];
  fi;
end);

#############################################################################
##
#M  Z(p) ... return a primitive root
##

InstallMethod(ZOp,
        [IsPosInt],
        function(p)
    local   f;
    if p <= MAXSIZE_GF_INTERNAL then
        TryNextMethod(); # should never happen
    fi;
    if not IsProbablyPrimeInt(p) then
        TryNextMethod();
    fi;
    f := FFEFamily(p);
    if not IsBound(f!.primitiveRootModP) then
        f!.primitiveRootModP := PrimitiveRootMod(p);
    fi;
    return ZmodnZObj(f!.primitiveRootModP,p);
end);

        


#############################################################################
##
##  2. The collections
##


#############################################################################
##
#M  InverseOp( <mat> )  . . . . . . . . . . . . for ordinary matrix over Z/nZ
#M  InverseSM( <mat> )  . . . . . . . . . . . . for ordinary matrix over Z/nZ
##
##  For a nonprime integer $n$, the residue class ring $\Z/n\Z$ has zero
##  divisors, so the standard algorithm to invert a matrix over $\Z/n\Z$
##  cannot be applied.
##
#T  The method below should of course be replaced by a method that uses
#T  inversion modulo the maximal prime powers dividing the modulus,
#T  this ``brute force method'' is only preliminary!
##
InstallMethod( InverseOp,
    "for an ordinary matrix over a ring Z/nZ",
    [ IsMatrix and IsOrdinaryMatrix and IsZmodnZObjNonprimeCollColl ],
    function( mat )
    local one;

    one:= One( mat[1][1] );
    mat:= InverseOp( List( mat, row -> List( row, Int ) ) );
    if mat <> fail then
      mat:= mat * one;
    fi;
    if not IsMatrix( mat ) then
      mat:= fail;
    fi;
    return mat;
    end );

InstallMethod( InverseSM,
    "for an ordinary matrix over a ring Z/nZ",
    [ IsMatrix and IsOrdinaryMatrix and IsZmodnZObjNonprimeCollColl ],
    function( mat )
    local inv, row;

    inv:= InverseOp( mat );
    if inv <> fail then
      if   not IsMutable( mat ) then
        MakeImmutable( inv );
      elif not IsMutable( mat[1] ) then
        for row in inv do
          MakeImmutable( row );
        od;
      fi;
    fi;
    return inv;
    end );


InstallMethod( TriangulizeMat,
    "for a mutable ordinary matrix over a ring Z/nZ",
    [ IsMatrix and IsMutable and IsOrdinaryMatrix
               and IsZmodnZObjNonprimeCollColl ],
    function( mat )
    local imat, i;
    imat:= List( mat, row -> List( row, Int ) );
    TriangulizeMat( imat );
    imat:= imat * One( mat[1][1] );
    for i in [ 1 .. Length( mat ) ] do
      mat[i]:= imat[i];
    od;
    end );


#############################################################################
##
#M  ViewObj( <R> )  . . . . . . . . . . . . . . . . method for full ring Z/nZ
#M  PrintObj( <R> ) . . . . . . . . . . . . . . . . method for full ring Z/nZ
##
InstallMethod( ViewObj,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ], SUM_FLAGS,
    function( obj )
    Print( "(Integers mod ", Size( obj ), ")" );
    end );

InstallMethod( PrintObj,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ], SUM_FLAGS,
    function( obj )
    Print( "(Integers mod ", Size( obj ), ")" );
    end );


#############################################################################
##
#M  AsSSortedList( <R> ) . . . . . . . . . . . .  set of elements of Z mod n Z
#M  AsList( <R> ) . . . . . . . . . . . . . . .  set of elements of Z mod n Z
##
InstallMethod( AsList,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ],
    RankFilter( IsRing ),
    function( R )
    local F;
    F:= ElementsFamily( FamilyObj( R ) );
    F:= List( [ 0 .. Size( R ) - 1 ], x -> ZmodnZObj( F, x ) );
    SetAsSSortedList( R, F );
    SetIsSSortedList( F, true );
    return F;
    end );

InstallMethod( AsSSortedList,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ],
    RankFilter( IsRing ),
    function( R )
    local F;
    F:= ElementsFamily( FamilyObj( R ) );
    F:= List( [ 0 .. Size( R ) - 1 ], x -> ZmodnZObj( F, x ) );
    SetIsSSortedList( F, true );
    return F;
    end );


#############################################################################
##
#M  Random( <R> ) . . . . . . . . . . . . . . . . . method for full ring Z/nZ
##
InstallMethod( Random,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ],
    RankFilter( IsRing ),
    R -> ZmodnZObj( ElementsFamily( FamilyObj( R ) ),
                    Random( [ 0 .. Size( R ) - 1 ] ) ) );


#############################################################################
##
#M  Size( <R> ) . . . . . . . . . . . . . . . . . . method for full ring Z/nZ
##
InstallMethod( Size,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ],
    RankFilter( IsRing ),
    R -> ElementsFamily( FamilyObj( R ) )!.modulus );


#############################################################################
##
#M  IsIntegralRing( <obj> )  . . . . . . . . . .  method for subrings of Z/nZ
##
InstallImmediateMethod( IsIntegralRing,
    IsZmodnZObjNonprimeCollection and IsRing, 0,
    ReturnFalse );


#############################################################################
##
#M  IsUnit( <obj> )  . . . . . . . . . . . . . . . . . . .  for `IsZmodpZObj'
##
InstallMethod( IsUnit,
    "for element in Z/nZ (ModulusRep)",
    IsCollsElms,
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily and IsRing, IsZmodnZObj and IsModulusRep ],
    function( R, elm )
    return GcdInt( elm![1], ModulusOfZmodnZObj( elm ) ) = 1;
    end );

#############################################################################
##
#M  Units( <R> )  . . . . . . . . . . . . . . . . . method for full ring Z/nZ
##
InstallMethod( Units,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily and IsRing ],
    function( R )
    local   G,  gens;
    
    gens := GeneratorsPrimeResidues( Size( R ) ).generators;
    if not IsEmpty( gens )  and  gens[ 1 ] = 1  then
        gens := gens{ [ 2 .. Length( gens ) ] };
    fi;
    gens := Flat( gens ) * One( R );
    G := GroupByGenerators( gens, One( R ) );
    SetIsAbelian( G, true );
    SetSize( G, Product( List( gens, Order ) ) );
    SetIsHandledByNiceMonomorphism(G,true);
    return G;
end );

#InstallTrueMethod( IsHandledByNiceMonomorphism,
#        IsGroup and IsZmodnZObjNonprimeCollection );
#T what is going on here?


#############################################################################
##
#M  <res> in <G>  . . . . . . . . . . . for cyclic prime residue class groups
##
InstallMethod( \in,
    "for subgroups of Z/p^aZ, p<>2",
    IsElmsColls,
    [ IsZmodnZObjNonprime, IsGroup and IsZmodnZObjNonprimeCollection ],
    function( res, G )
    local   m;

    m := FamilyObj( res )!.modulus;
    res := Int( res );
    if GcdInt( res, m ) <> 1  then
        return false;
    elif m mod 2 <> 0  and  IsPrimePowerInt( m )  then
        return LogMod( res, PrimitiveRootMod( m ), m ) mod
               ( Phi( m ) / Size( G ) ) = 0;
    else
        TryNextMethod();
    fi;
end );


#############################################################################
##
#F  EnumeratorOfZmodnZ( <R> ). . . . . . . . . . . . . enumerator for Z / n Z
#M  Enumerator( <R> )  . . . . . . . . . . . . . . . . enumerator for Z / n Z
##
BindGlobal( "ElementNumber_ZmodnZ", function( enum, nr )
    if nr <= enum!.size then
      return Objectify( enum!.type, [ nr - 1 ] );
    else
      Error( "<enum>[", nr, "] must have an assigned value" );
    fi;
    end );

BindGlobal( "NumberElement_ZmodnZ", function( enum, elm )
    if IsCollsElms( FamilyObj( enum ), FamilyObj( elm ) ) then
      return elm![1] + 1;
    fi;
    return fail;
    end );

InstallGlobalFunction( EnumeratorOfZmodnZ, function( R )
    local enum;

    enum:= EnumeratorByFunctions( R, rec(
             ElementNumber := ElementNumber_ZmodnZ,
             NumberElement := NumberElement_ZmodnZ,

             size:= Size( R ),
             type:= ElementsFamily( FamilyObj( R ) )!.typeOfZmodnZObj ) );

    SetIsSSortedList( enum, true );
    return enum;
    end );

InstallMethod( Enumerator,
    "for full ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection and IsWholeFamily ], SUM_FLAGS,
    EnumeratorOfZmodnZ );


#############################################################################
##
#M  SquareRoots( <F>, <obj> )
##
##  (is used in the implementation of Dixon's algorithm ...)
##
InstallMethod( SquareRoots,
    "for prime field and object in Z/pZ",
    IsCollsElms,
    [ IsField and IsPrimeField, IsZmodpZObj and IsModulusRep ],
    function( F, obj )
    F:= FamilyObj( obj );
    return List( RootsMod( obj![1], 2, Characteristic( obj ) ),
                 x -> ZmodnZObj( F, x ) );
    end );


#############################################################################
##
#F  ZmodpZ( <p> ) . . . . . . . . . . . . . . .  construct `Integers mod <p>'
#F  ZmodpZNC( <p> ) . . . . . . . . . . . . . .  construct `Integers mod <p>'
##
InstallGlobalFunction( ZmodpZ, function( p )
    if not IsPrimeInt( p ) then
      Error( "<p> must be a prime" );
    fi;
    return ZmodpZNC( p );
end );

InstallGlobalFunction( ZmodpZNC, function( p )
    local pos, F;

    # Check whether this has been stored already.
    pos:= Position( Z_MOD_NZ[1], p );
    if pos = fail then

      # Get the family of element objects of our ring.
      F:= FFEFamily( p );

      # Make the domain.
      F:= FieldOverItselfByGenerators( [ ZmodnZObj( F, 1 ) ] );
      SetIsPrimeField( F, true );
      SetIsWholeFamily( F, false );

      # Store the field.
      Add( Z_MOD_NZ[1], p );
      Add( Z_MOD_NZ[2], F );
      SortParallel( Z_MOD_NZ[1], Z_MOD_NZ[2] );

    else
      F:= Z_MOD_NZ[2][ pos ];
    fi;

    # Return the field.
    return F;
end );


#############################################################################
##
#F  ZmodnZ( <n> ) . . . . . . . . . . . . . . .  construct `Integers mod <n>'
##
InstallGlobalFunction( ZmodnZ, function( n )
    local pos,
          F,
          R;

    if not IsInt( n ) or n <= 0 then
      Error( "<n> must be a positive integer" );
    elif IsPrimeInt( n ) then
      return ZmodpZNC( n );
    fi;

    # Check whether this has been stored already.
    pos:= Position( Z_MOD_NZ[1], n );
    if pos = fail then

      # Construct the family of element objects of our ring.
      F:= NewFamily( Concatenation( "Zmod", String( n ) ),
                     IsZmodnZObj,
                     IsZmodnZObjNonprime and CanEasilySortElements
                                         and IsNoImmediateMethodsObject,
                     CanEasilySortElements);

      # Install the data.
      F!.modulus:= n;

      SetCharacteristic(F,n);

      # Store the objects type.
      F!.typeOfZmodnZObj:= NewType( F,     IsZmodnZObjNonprime
                                       and IsModulusRep );
      SetDataType( F!.typeOfZmodnZObj, n );
      F!.typeOfZmodnZObj![ ZNZ_PURE_TYPE ]:= F!.typeOfZmodnZObj;

      # as n is no prime, the family is no UFD
      SetIsUFDFamily(F,false);

      # Make the domain.
      R:= RingWithOneByGenerators( [ ZmodnZObj( F, 1 ) ] );
      SetIsWholeFamily( R, true );
      SetZero(F,Zero(R));
      SetOne(F,One(R));

      # Store the ring.
      Add( Z_MOD_NZ[1], n );
      Add( Z_MOD_NZ[2], R );
      SortParallel( Z_MOD_NZ[1], Z_MOD_NZ[2] );

    else
      R:= Z_MOD_NZ[2][ pos ];
    fi;

    # Return the ring.
    return R;
end );


#############################################################################
##
#M  \mod( Integers, <n> )
##
InstallMethod( \mod,
    "for `Integers', and positive integers",
    [ IsIntegers, IsPosInt ],
    function( Integers, n ) return ZmodnZ( n ); end );


#############################################################################
##
#M  ModulusOfZmodnZObj( <obj> )
##
##  For an element <obj> in a residue class ring of integers modulo $n$
##  (see~"IsZmodnZObj"), `ModulusOfZmodnZObj' returns the positive integer
##  $n$.
##
InstallMethod( ModulusOfZmodnZObj,
    "for element in Z/nZ (nonprime)",
    [ IsZmodnZObjNonprime ],
    res -> FamilyObj( res )!.modulus );

InstallMethod( ModulusOfZmodnZObj,
    "for element in Z/pZ (prime)",
    [ IsZmodpZObj ],
    Characteristic );

InstallOtherMethod( ModulusOfZmodnZObj,
    "for FFE",
    [ IsFFE ],
    function( ffe )
    if DegreeFFE( ffe ) = 1 then
      return Characteristic( ffe );
    else
      return fail;
    fi;
    end );


#############################################################################
##
#M  DefaultRingByGenerators( <zmodnzcoll> )
##
InstallMethod( DefaultRingByGenerators,
    "for a collection over a ring Z/nZ",
    [ IsZmodnZObjNonprimeCollection ],
    C -> ZmodnZ( ModulusOfZmodnZObj( Representative( C ) ) ) );


#############################################################################
##
#M  DefaultFieldOfMatrixGroup( <zmodnz-mat-grp> )
##
##  Is it possible to avoid this very special method?
##  In fact the whole stuff in the library is not very clean,
##  as the ``generic'' method for matrix groups claims to be allowed to
##  call `Field'.
##  The bad name of the function (`DefaultFieldOfMatrixGroup') may be the
##  reason for this bad behaviour.
##  Do we need to distinguish matrix groups over fields and rings that aren't
##  fields, and change the generic `DefaultFieldOfMatrixGroup' method
##  accordingly?
##
InstallMethod( DefaultFieldOfMatrixGroup,
    "for a matrix group over a ring Z/nZ",
    [ IsMatrixGroup and IsZmodnZObjNonprimeCollCollColl ],
    G -> ZmodnZ( ModulusOfZmodnZObj( Representative( G )[1][1] ) ) );


#############################################################################
##
#M  AsInternalFFE( <zmodpzobj> )
##
##  A ZmodpZ object can be a finite field element, but is never equal to
##  an internal FFE, so this method just returns fail
##
InstallMethod(AsInternalFFE, [IsZmodpZObj], ReturnFail);


#############################################################################
##
#E
