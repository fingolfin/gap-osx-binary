#############################################################################
##
#W  small.gi                       Smallsemi - a GAP library of semigroups
#Y  Copyright (C) 2008-2012            Andreas Distler & James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

## $Id$

###########################################################################
##
#M  EquivalenceSmallSemigroup( S );
##	
##  returns an isomorphism to a semigroup from the library if such exists
##  and an anti-isomorphism otherwise 
##

InstallMethod( EquivalenceSmallSemigroup, "for a 'small semigroup'", 
[IsSmallSemigroup], sgrp -> IdentityMapping( sgrp ));

InstallMethod( EquivalenceSmallSemigroup, "for a semigroup", [IsSemigroup],
function( S )
    local size, nr, mt, stab, orbit, diag, perm, Sn, diaglits, pos, translits,
        n, k, strlist, offset, line, i, tbllits, phi, small, transorbit, isIso,
        equi, LitNum, NumLit, tbl2lits, diag2lits, onLiterals, is3nilpotent,
        BinInt, imglist, ListToMatrix;

    LitNum := function(ln, n)
        return [QuoInt(ln-1,n^2)+1,QuoInt((ln-1) mod n^2,n)+1,(ln-1) mod n+1];
    end;
 
    NumLit := function(lit,n)
        # lit = [ row, col, val ]
        return (lit[1]-1)*n^2 + (lit[2]-1)*n + lit[3];
    end;

    diag2lits := function(diag,n)
        return List( [1..n], i -> NumLit( [i,i,diag[i]], n ) );
    end;

    tbl2lits := function(table,n)
        local i,j,literals, val;
        literals := [];
        for i in [1..n] do
            for j in [1..n] do
                val :=  table[i][j];
                Add(literals, NumLit([i,j,val],n));
            od;
        od;

        return literals;
    end;

    onLiterals := n->function(ln,pi)
        local lit,imlit;
        lit := LitNum(ln,n);
        imlit := OnTuples(lit,pi);
        if (n+1)^pi = n+2 then
                imlit := Permuted(imlit,(1,2));
        fi;
        return NumLit(imlit,n);
    end;

    is3nilpotent := function( table )
        local n, zero, entries, i;

        n := Size( table );
        zero := First( [1..n], i -> table[i] = ListWithIdenticalEntries(n, i)
                        and table{[1..n]}[i] = ListWithIdenticalEntries(n, i));
        if zero = fail then
            return false;
        else
            entries := Difference( Unique( Flat( table )), [ zero ] );
            # zero semigroup is 2-nilpotent
            if entries = [ ] then return false; fi;
            for i in entries do
                if table[i] <> ListWithIdenticalEntries(n, zero) or
                   table{[1..n]}[i] <> ListWithIdenticalEntries(n, zero) then
                    return false;
                fi;
            od;
        fi;

        return true;               
    end;

    BinInt := function( str, bas )
        local int,pot,c;

        int := 0;
        pot := 1;
        str := Reversed( str );
        for c in str do
            int := int + pot*Int([c]);
            pot := pot*bas;
        od;

        return int;
    end;

    ListToMatrix := function( line )
        local mat, ord, i;

        ord := RootInt( Length( line ) );
        mat := EmptyPlist( ord );

        for i in [ 1..ord ] do
            Add( mat, line{[ 1+(i-1)*ord .. i*ord ]} );
        od;

        return mat; 
    end;

    if Size( S ) > 8 then
        Error("only semigroups with up to 8 elements are contained in",
              " the library.");
    fi;

    # special case trivial semigroup
    if Size( S ) = 1 then
        small := SmallSemigroup(1, 1);
        equi := SemigroupHomomorphismByImagesNC(S, small, Elements(S));
        SetIsBijective( equi, true );

        return equi;
    fi;

    n := Size( S );
    mt := MultiplicationTable( S );
    diag := DiagonalOfMat( mt );
    phi := ActionHomomorphism( SymmetricGroup(n), [1..n^3], onLiterals(n) );

    # get minimal representative of diagonal
    diaglits := diag2lits( diag, n );
    orbit := Orbit( Image(phi), diaglits, OnSets );
    perm := RepresentativeAction(Image(phi), diaglits, Minimum(orbit), OnSets);
    diag := List( Minimum(orbit), x->LitNum(x,n)[3] );

    # work with stabiliser of new diagonal on changed table
    tbllits := tbl2lits( mt, n );
    tbllits := OnSets( tbllits, perm );
    translits := List( tbllits, lit -> LitNum(lit,n) );
    translits := List( translits, lit -> NumLit( [lit[2],lit[1],lit[3]], n ) );
    translits := AsSet( translits );
    stab := Stabilizer( Image(phi), Minimum(orbit), OnSets);

    # search in list of isomorphic multiplication tables with same diagonal
    orbit := Orbit( stab, tbllits, OnSets );
    # ... and anti-isomorphic
    transorbit := Orbit( stab, translits, OnSets );

    # determine whether minimum is isomorphic or anti-isomorphic
    if Minimum( orbit ) > Minimum( transorbit ) then
        isIso := false;
        perm:=perm*RepresentativeAction(Image(phi),
                                        translits,
                                        Minimum(transorbit),
                                        OnSets);
        # the equivalent table stored in smallsemi as list
        mt := List( Minimum(transorbit), x -> LitNum(x,n)[3]);
    else
        isIso := true;
        perm:=perm*RepresentativeAction(Image(phi),
                                        tbllits,
                                        Minimum(orbit),
                                        OnSets);
        # the equivalent table stored in smallsemi as list
        mt := List( Minimum(orbit), x -> LitNum(x,n)[3]);
    fi;

    # rest of code expects a matrix, not a list
    mt := ListToMatrix( mt );

    size := n;
    # extract from the minimal table the string which is stored in the library
    if size <= 7 or not is3nilpotent( mt ) then
        pos := Position( MOREDATA2TO8[size].diags, diag );
        offset := MOREDATA2TO8[size].endpositions[pos];
        # ensure data is loaded
        RecoverMultiplicationTableNC(size,offset+1);
        if size <= 7 then
            strlist := DATA2TO7[size-1];
            strlist := List( strlist, st -> st{[offset+1..Length(st)]});
            # translate table to string
            line := Concatenation(List( Flat( mt-1 ), int -> String(int)));
            # first entry is always equal 1 and thus not stored 
            Remove( line, 1 );
        else
            strlist := DATA8[pos];
            line := Concatenation(List( Flat( mt-1 ), int -> String(int)));
            # all non-diagonal entries are stored
            for i in [1..8] do
                Remove( line, 1+(i-1)*8 );
            od;
        fi;
    else
        k := First( [1..8], i -> mt[i] <> [1,1,1,1,1,1,1,1] or
                                 mt{[1..8]}[i] <> [1,1,1,1,1,1,1,1] );
    ##    # special case 2 nilpotent semigroup
    ##    if k = fail then return [ size, NrSmallSemigroups(8) ]; fi;
        pos := Position( MOREDATA2TO8[8].3nildiags, diag{[k..8]} );
        offset := MOREDATA2TO8[8].3nilendpositions[pos] + 11433106;
        # ensure data is loaded
        RecoverMultiplicationTableNC(size,offset+1);
        strlist := 3NIL_DATA.strlist;;
        # only non-diagonal entries of the non zero row-columns are stored
        line := Concatenation( List( Flat( mt{[k..8]}{[k..8]} - 1 ),
                                     int -> String(int) ) );
        for i in [1..8-k+1] do
            Remove( line, 1+(i-1)*(8-k+1) );
        od;
    fi;

    # search for the position of the string in the data lists
    if size <= 7 or not is3nilpotent( mt ) then
        pos := 1;
        for i in [ 1..Length( line ) ] do
            while strlist[i][pos] < line[i] do
                pos := pos + 1;
            od;
        od;
    else
        pos := 1;
        for i in [ 1..Length( line ) ] do
            while IsBound(strlist[i][pos]) and strlist[i][pos] < line[i] 
                  and ( not IsBound(strlist[i][pos+1]) 
                        or strlist[i][pos] <= strlist[i][pos+1] ) do
                pos := pos + 1;
            od;
            if not IsBound(strlist[i][pos]) or strlist[i][pos]>line[i] then
                pos := pos - 1;
            fi;
        od;
    fi;

    # fine tuning
    while List(strlist, st -> st[pos]) < line and IsBound(strlist[1][pos+1]) do
        pos := pos+1;
    od;
    while List( strlist, st -> st[pos] ) > line do
        pos := pos-1;
    od;

    # correct number in current data (depending on diagonal) by offset
    if size <= 7 or not is3nilpotent( mt ) then
        nr := pos + offset;
    else
        nr := 3NIL_DATA.positions[pos] + offset + BinInt(line, k-1 )
              - BinInt( List( strlist, st -> st[pos] ), k-1 );
        # for safety reasons ...
        while mt <> RecoverMultiplicationTableNC( 8, nr ) do
            Info( InfoSmallsemi, 1,
                  "IdSmallSemigroup: That shouldn't really happen.");
            nr := nr+1;
        od;
    fi; 

    # the bijection mapping the input or its transposed to a small semigroup
    equi := PreImages(phi,[perm])[1];
    small := SmallSemigroup( size, nr );
    imglist := Permuted(AsSSortedList(small), equi^-1);
    if isIso then
        equi := SemigroupHomomorphismByImagesNC(S, small, imglist);
        SetIsBijective( equi, true );
    else
        equi := MappingByFunction(S, small, 
                                  function(x)
                                      local pos;
                                      pos := Position(AsSSortedList(S),x);
                                      return imglist[pos];
                                  end );
        SetRespectsMultiplication( equi, false );
        SetIsBijective( equi, true );
    fi;

    return equi;
end);

###########################################################################
##
#M  IdSmallSemigroup( <S> )
##
InstallMethod( IdSmallSemigroup, "for a semigroup", [IsSemigroup], 0, 
s -> IdSmallSemigroup( Range( EquivalenceSmallSemigroup( s ))));

###########################################################################
##
#V  InfoSmallsemi . . . info class for smallsemi, initial value 1
##
SetInfoLevel( InfoSmallsemi, 1 );


###########################################################################
##
#M  IsomorphismTransformationSemigroup( <table> );
##	
##  converts a small semigroup into an isomorphic transformation semigroup.
##
##  The reference documentation states monoids are embedded in T_n! AD 
##  
InstallOtherMethod(IsomorphismTransformationSemigroup, [IsSmallSemigroup], 
function(S)
local table, right, gens, T, elts, iso;

right:=x-> TransformationNC(Concatenation(table[x!.index], [x!.index]));

table:=MultiplicationTable(S);
gens:=List(MinimalGeneratingSet(S), right);
T:=Semigroup(gens);
SetSize(T, Size(S));
SetMultiplicationTable(T, table);
elts:=List(S, right);
SetAsSSortedList(T, elts);

SetIdSmallSemigroup(T, IdSmallSemigroup(S));
UseIsomorphismRelation(S, T);
iso:=SemigroupHomomorphismByImagesNC(S, T, elts);
SetIsBijective( iso, true );
#SetIsomorphismSmallSemigroup(T, iso^-1);

return iso;

end);


###########################################################################
##
#F  RecoverMultiplicationTable( <size>, <nr> )
#F  RecoverMultiplicationTableNC( <size>, <nr> )
##
InstallGlobalFunction( RecoverMultiplicationTable, function( size, nr )
    local numbers;

    # numbers of semigroups of sizes 1-8
    numbers := [ 1, 4, 18, 126, 1160, 15973, 836021, 1843120128 ];

    if size > 8 or nr > numbers[ size ] then
        return fail;
    else
        return RecoverMultiplicationTableNC( size, nr );
    fi;
end);

InstallGlobalFunction( RecoverMultiplicationTableNC, function( size, nr )
    local flatmat, ListToMatrix, i, data, file, pos, diag, k, mat,
        int, rem, line, BinInt, m, j;

    if size = 1 then
        return [[ 1 ]];
    fi;

    # converts a list into the corresponding multiplication table
    ListToMatrix := function( line )
        local mat,i;

        mat := EmptyPlist( size );

        for i in [ 1..size ] do
            Add( mat, line{[ 1+(i-1)*size .. i*size ]} );
        od;

        return mat; 
    end;

    # returns the integer represented by <str> with characters in [0-<bas>]
    BinInt := function( str, bas )
        local int,pot,c;

        int := 0;
        pot := 1;
        str := Reversed( str );
        for c in str do
            int := int + pot*Int([c]);
            pot := pot*bas;
        od;

        return int;
    end;

    # check whether data is already available, read otherwise
    if size < 8 then
        if not IsBound( DATA2TO7[ size-1 ] ) then
            if size = 7 then
                Info( InfoSmallsemi, 1,
                      "Smallsemi: loading data for semigroups of size 7." );
            fi;
            file := Filename( DirectoriesPackageLibrary( "smallsemi", 
                                                         "data/data2to7" ),
                              Concatenation( "data", String(size), ".gl" ));
            DATA2TO7[ size-1 ] := SplitString( StringFile( file ), "\n" );
            # remove copyright
            Remove( DATA2TO7[ size-1 ], 1 );
        fi;
        data := DATA2TO7[ size-1 ];

    elif nr <= 11433106 then # size = 8
        pos := PositionProperty( MOREDATA2TO8[8].endpositions, i -> i >= nr );
        diag := MOREDATA2TO8[8].diags[ pos-1 ];
        if pos-1 <> PositionBound( DATA8 ) then
            if IsInt( PositionBound( DATA8 )) then
                Unbind( DATA8[ PositionBound( DATA8 ) ] );
            fi;
            Info( InfoSmallsemi, 1,
                  "Smallsemi: loading data for semigroups of size 8." );
            file := Filename( DirectoriesPackageLibrary( "smallsemi", 
                                                         "data/data8" ),
                              Concatenation( "8diag", 
                                             Concatenation(List(diag,String)),
                                             ".gl" ));
            DATA8[ pos-1 ] := SplitString( StringFile( file ), "\n" );
            # remove copyright
            Remove( DATA8[ pos-1 ], 1 );
        fi;
        data := DATA8[ pos-1 ];
        nr := nr - MOREDATA2TO8[8].endpositions[ pos-1 ];

    else # 3-nilpotent semigroup
        # CODE HAS TO BE REVISED, UGLY CODING AND MISLEADING VARIABLE NAMES AD
        # get correct diagonal, adjust number
        nr :=  nr - 11433106;
        pos := PositionProperty( MOREDATA2TO8[8].3nilendpositions, i->i>=nr );
        diag := MOREDATA2TO8[8].3nildiags[ pos-1 ];
        if diag <> 3NIL_DATA.diag then
            Info( InfoSmallsemi, 1,
                  "Smallsemi: loading data for semigroups of size 8." );
            READ_3NIL_DATA( diag );
        fi;
        nr := nr - MOREDATA2TO8[8].3nilendpositions[pos-1];
        # search from which stored solution to start from
        for pos in [ 3NIL_DATA.next..Length(3NIL_DATA.positions) ] do
            if 3NIL_DATA.positions[ pos-1 ] <= nr 
               and 3NIL_DATA.positions[ pos ] > nr then 
                3NIL_DATA.next := pos;
                pos := pos-1;
                break; 
            fi;
        od;
        if Length(3NIL_DATA.positions) = 1 then pos := 1; fi;
        if 3NIL_DATA.positions[ pos ] > nr then
            for pos in [ 1..3NIL_DATA.next - 1 ] do
                if 3NIL_DATA.positions[ pos ] > nr then
                    3NIL_DATA.next := pos;
                    pos := pos-1;
                    break; 
                fi;
            od;
        elif 3NIL_DATA.next <> pos+1 then
            3NIL_DATA.next := pos;
        fi;

        m := Length( 3NIL_DATA.diag );
        line := List( [ 1..m^2-m ], i -> 3NIL_DATA.strlist[i][pos] );
    
        int := BinInt( line, 8-m );
        int := int + ( nr - 3NIL_DATA.positions[pos] );

        mat := StructuralCopy( BLUEPRINT_MATS[8-m] );

        # based on 'IntBit' but putting values directly into matrix
        for i in [ 1..m ] do
            for j in [ 1..i-1 ] do
                rem := RemInt( int, 8-m );
                int := (int - rem) / (8-m);
                mat[9-i][9-j] := rem + 1;
            od;
            mat[9-i][9-i] := 3NIL_DATA.diag[m-i+1];       
            for j in [ i+1..m ] do
                rem := RemInt( int, 8-m );
                int := (int - rem) / (8-m);
                mat[9-i][9-j] := rem + 1;
            od;
        od;

        return mat;
    fi;

    # set up list with first idempotent
    flatmat := EmptyPlist( size^2 );

    flatmat[1] := 1;
    if size = 8 then
        for i in [ 1..7 ] do
            for k in [ 1..8 ] do
                flatmat[ 1+k+9*(i-1) ] := INT_CHAR(data[ k+8*(i-1) ][nr])-47;
            od;
            flatmat[ 1+9*i ] := diag[i+1];
        od;
    else
        for i in [ 2..size^2 ] do
            flatmat[i] := INT_CHAR( data[i-1][nr] ) - 47;
        od;
    fi;

    return ListToMatrix( flatmat );
end);

###########################################################################
##
#F  SmallSemigroupCreator( <A> )
##

InstallGlobalFunction(SmallSemigroupCreator,
function ( A )
local elms, M;

M:=Objectify(SmallSemigroupType, rec(table:=A));;
SetIsAssociative(M, true);
SetSize( M, Length(A));

elms := Immutable( List( [1..Length(A)], function ( i ) return 
Objectify( SmallSemigroupEltType, rec( index:=i, semi:=M) ); end ) ); 

SetIsSSortedList( elms, true );
SetGeneratorsOfMagma(M, elms);
SetAsSSortedList( M, elms );
SetMultiplicationTable( M, A );

return M;
end);

###########################################################################
##
#F  SemigroupByMultiplicationTableNC( <A> )
##
InstallGlobalFunction( SemigroupByMultiplicationTableNC, function( A )
    A:= MagmaByMultiplicationTable( A );
    SetIsAssociative( A, true );

    return A;
end );

    
###########################################################################
##
#F  SmallSemigroup( <size>, <nr> )
##

InstallGlobalFunction( SmallSemigroup,  
function( arg )
local table, S, size, nr;

if Length(arg)=2 and ForAll(arg, IsPosInt) then 
	size:=arg[1];
	nr:=arg[2];
elif Length(arg)=1 and ForAll(arg[1], IsPosInt) then 
	size:=arg[1][1];
	nr:=arg[1][2];
else
	Error( "input must be 2 positive integers or a list of 2 positive integers" );
fi;

while size > 8 do;
    Error( "semigroups of size ", size, " are not available,\n",
           "you can change the value of <size> and 'return;'\n" );
od;

while nr > NrSmallSemigroups(size) do
    Error( "there are only ", NrSmallSemigroups(size), " semigroups of size ",
           size, ",\n",
           "you can change the value of <nr> and 'return;'\n" );
od;

return SmallSemigroupNC( size, nr );
end );

###########################################################################
##
#F  SmallSemigroupNC( <size>, <nr> )
##

InstallGlobalFunction( SmallSemigroupNC,  
function( size, nr )
local table, s;

table := RecoverMultiplicationTableNC( size, nr );
s:=SmallSemigroupCreator(table);
SetIdSmallSemigroup(s, [Size(s), nr]);
return s;
end );

############################################################################
##
#F  UnloadSmallsemiData( <use_later> )
##
InstallGlobalFunction( UnloadSmallsemiData, function( uselater )
     local pos;

     # unbind data for semigroups sizes 2 to 7
     for pos in [1..6] do
         Unbind( DATA2TO7[pos] );
     od;

     # unbind data for semigroups size 8 which are not 3-nilpotent 
     pos := PositionBound( DATA8 );
     if pos <> fail then
         Unbind( DATA8[pos] );
     fi;

     # unbind data for semigroups size 8 which are 3-nilpotent
     3NIL_DATA.diag := fail ;
     Unbind( 3NIL_DATA.strlist ); 
     Unbind( 3NIL_DATA.positions ); 
     Unbind( 3NIL_DATA.next ); 

     # unbind data essential for the use of smallsemi
     if not uselater then

         for pos in [2..7] do
             Unbind( BLUEPRINT_MATS[pos] );
         od;

         # unbind data records from info files
         for pos in [1..8] do
             Unbind( MOREDATA2TO8[pos] );
         od;

     fi;
end);


######################
## GLOBAL VARIABLES ##
######################

#############################################################################
##
#V  3NIL_DATA . . . record carrying the current 3-nilpotent data
##
InstallFlushableValue( 3NIL_DATA, rec( diag := fail ) );


#############################################################################
##
#V  DATA2TO7 . . . raw data for semigroup tables sizes 2-7
##
InstallFlushableValue( DATA2TO7, [ ] );


#############################################################################
##
#V  DATA8 . . . raw data for semigroup tables size 8
##
InstallFlushableValue( DATA8, [ ] );


########################
## INTERNAL FUNCTIONS ##
########################

#############################################################################
##
#F   GENERATE_BLUEPRINT_MATS
##
InstallGlobalFunction( GENERATE_BLUEPRINT_MATS, function( )
    local mats, k, i;

    mats := EmptyPlist( 7 );
    for k in [ 2..7 ] do
        # size 8 matrix
        mats[k] := EmptyPlist( 8 );
        # first k zero rows (the zero is '1')
        for i in [ 1..k ] do
            mats[k][i] := ListWithIdenticalEntries( 8, 1 );
        od;
        # zero columns (the zero is '1')
        for i in [ k+1..8 ] do
            mats[k][i] := ListWithIdenticalEntries( k, 1 );
        od;
    od;

    return mats;
end);


#############################################################################
##
#F  READ_3NIL_DATA( <diagonal> )
##
InstallGlobalFunction( READ_3NIL_DATA, function( diag )
    local diagstr, file, posdiffs, i;

    # set diagonal
    3NIL_DATA.diag := diag;
    diagstr := Concatenation( List( diag, String ));

    # read cayle table data
    file := Filename( DirectoriesPackageLibrary("smallsemi","data/data8-3nil"),
                      Concatenation( "diag", diagstr, ".gl" ));
    3NIL_DATA.strlist := SplitString( StringFile( file ), "\n" );;
    # remove copyright
    Remove( 3NIL_DATA.strlist, 1 );

    # read position differences information
    file := Filename( DirectoriesPackageLibrary("smallsemi","data/data8-3nil"),
                      Concatenation( "diag", diagstr, "pos.gl" ));
    posdiffs := EvalString( StringFile( file ));

    # create actual position list
    3NIL_DATA.positions := [ posdiffs[1] ];
    for i in [ 2..Length( posdiffs ) ] do
        3NIL_DATA.positions[i] := 3NIL_DATA.positions[i-1] + posdiffs[i];
    od;

    # reset counter
    3NIL_DATA.next := 2;
end);


###########################################################################
##
#F  READ_MOREDATA2TO8( )
##
InstallGlobalFunction( READ_MOREDATA2TO8, 
function()
local dir, files, md, n, file, i, prop;
dir:=DirectoriesPackageLibrary( "smallsemi", "data");

Info( InfoSmallsemi, 1,
      "Smallsemi: loading data for semigroup properties. Please be patient." );

md:=[];

for n in [1..8] do 
	file:=Filename(dir, Concatenation("info", String(n), ".g"));
	if not file=fail then 
		md[n]:=EvalString(StringFile(file));
	else
		md[n]:=rec();
	fi;
        for prop in Filtered( RecNames(md[n]),x->IsUpperAlphaChar(x[1])) do
                # for position lists with more than one entry the first entry
                # and the differences are stored; recover actual position list
                if Length( md[n].(prop) ) >= 2 then
                    for i in [ 2..Length( md[n].(prop) ) ] do
                        md[n].(prop)[i] := md[n].(prop)[i-1] + md[n].(prop)[i];
                    od;
                fi;
        od;
od;

return md;

end);


############################################################################
##
## Methods for 'Small Semigroups'
##
#############################################################################
##
#M  \=( <x>, <y> ) . . . for two objects in IsSmallSemigroup
##

InstallMethod( \=, "for two small semis", IsIdenticalObj,
  [ IsSmallSemigroup, IsSmallSemigroup ], 10,
  function( x, y ) 
  return IdSmallSemigroup(x)=IdSmallSemigroup(y); 
  end );

InstallMethod( \<, "for two small semis", IsIdenticalObj, [IsSmallSemigroup,
  IsSmallSemigroup], 
  function( x , y )
  return IdSmallSemigroup(x)<IdSmallSemigroup(y);
  end );
  
  
#############################################################################
##
#M  Representative( <sgrp> ) . . . for an object in IsSmallSemigroup
##
InstallMethod( Representative, "for a small semigroup", [ IsSmallSemigroup ],
x-> Elements(x)[1] );

#############################################################################
##
#M  PrintObj( <sgrp> ) . . . for an object in IsSmallSemigroup
##
InstallMethod(PrintObj, "for a small semigroup", [IsSmallSemigroup],
function(x)
Print("<small semigroup of size ", Size(x) ,">");
return;
end);

#############################################################################
##
#M  String( <sgrp> ) . . . for an object in IsSmallSemigroup
##
InstallMethod(String, "for a small semigroup", [IsSmallSemigroup],
function(x)
return Concatenation("<small semigroup of size ", String(Size(x)) ,">");
end);

#############################################################################
##
#M  ViewObj( <sgrp> ) . . . for an object in IsSmallSemigroup
##
InstallMethod(ViewObj,  "for a small semigroup", [IsSmallSemigroup],
function(x)
Print("<small semigroup of size ", Size(x) ,">");
return;
end);


############################################################################
##
## Methods for 'Small Semigroup Elements'
##
#############################################################################
##
#M  \=( <x>, <y> ) . . . for two objects in IsSmallSemigroupElt
#M  \<( <x>, <y> ) . . . for two objects in IsSmallSemigroupElt
#M  \*( <x>, <y> ) . . . for two objects in IsSmallSemigroupElt
##
InstallMethod( \=,
    "for two elements of a small semi",
    IsIdenticalObj,
    [ IsSmallSemigroupElt,
      IsSmallSemigroupElt ],
    function( x, y ) return x!.index = y!.index and x!.semi=y!.semi; end );

InstallMethod( \<,
    "for two elements of a small semi",
    IsIdenticalObj,
    [ IsSmallSemigroupElt,
      IsSmallSemigroupElt ],
    function( x, y ) return x!.index < y!.index and x!.semi=y!.semi; end );

InstallMethod( \*,
    "for two elements of a small semi",
    IsIdenticalObj,
    [ IsSmallSemigroupElt,
      IsSmallSemigroupElt ],
    function( x, y )
    local table;
    if x!.semi=y!.semi then 
        table:=x!.semi!.table;
        return AsList(x!.semi)[table[ x!.index ][ y!.index ]];
    else
        Error( "cannot multiply elements from different semigroups in ",
               "'Smallsemi'" );
    fi;
    end );

#############################################################################
##
#M  OneOp( <elm> ) . . . for an object in IsSmallSemigroupElt
##
InstallOtherMethod(OneOp, "for a small semigroup elt", [ IsSmallSemigroupElt ],
function( x )
local table, pos;

table:=x!.semi!.table;
pos:=Position(table, [1..Length(table)]);

if not pos=fail then 
	if List(table, x-> x[pos])=[1..Length(table)] then 
		return AsList(x!.semi)[pos];
	fi;
fi;

return fail;
end);

#############################################################################
##
#M  PrintObj( <elm> ) . . . for an object in IsSmallSemigroupElt
##
InstallMethod(PrintObj,  "for a small semigroup elt", [IsSmallSemigroupElt],
function(x)
Print("s", x!.index);
return;
end);

#############################################################################
##
#M  String( <elm> ) . . . for an object in IsSmallSemigroupElt
##
InstallMethod(String,  "for a small semigroup elt", [IsSmallSemigroupElt],
function(x)
return Concatenation("s", String(x!.index));
end);

#############################################################################
##
#M  ViewObj( <elm> ) . . . for an object in IsSmallSemigroupElt
##
InstallMethod(ViewObj,  "for a small semigroup elt", [IsSmallSemigroupElt],
function(x)
Print("s", x!.index);
return;
end);


#JDM include InverseOp?
