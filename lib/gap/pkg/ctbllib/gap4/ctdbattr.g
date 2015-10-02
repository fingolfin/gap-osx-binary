#############################################################################
##
#W  ctdbattr.g           GAP 4 package CTblLib                  Thomas Breuer
##
#Y  Copyright (C)  2007,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the declarations for the database id enumerator
##  `CTblLib.Data.IdEnumerator' and its database attributes.
##  See the GAP package `Browse' for technical details.
##  Among others, this makes the data for the GAP attribute
##  `GroupInfoForCharacterTable' available.
##
##  The component `reverseEval' is used only by the function
##  `CharacterTableForGroupInfo', it is not needed by the database attribute
##  handling mechanism.
##


#############################################################################
##
#F  IsDihedralCharacterTable( <tbl> )
##
##  Let <A>tbl</A> be the character table of a group <M>G</M>, say.
##  Then <M>G</M> is a dihedral group if and only if
##  the order of <M>G</M> is an even integer <M>n</M>,
##  <M>G</M> contains a cyclic normal subgroup <M>N</M> of index two,
##  <M>G \setminus N</M> contains involutions,
##  and the table of <M>G</M> is real.
##
BindGlobal( "IsDihedralCharacterTable", function( tbl )
    local size, orders, nsg, ccl;

    size:= Size( tbl );
    if size mod 2 = 1 then
      return false;
    fi;
    orders:= OrdersClassRepresentatives( tbl );
    nsg:= Filtered( ClassPositionsOfNormalSubgroups( tbl ),
                    n -> size / 2 in orders{ n } );
    ccl:= [ 1 .. NrConjugacyClasses( tbl ) ];
    return ForAny( nsg, n -> 2 in orders{ Difference( ccl, n ) } )
           and PowerMap( tbl, -1 ) = ccl;
    end );


#############################################################################
##
#F  CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage( <tbl>,
#F      <classes> )
##
##  Let <tbl> be an ordinary character table, and <classes> be a list of
##  class positions for <tbl>.
##  `CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage' returns the
##  list of those library tables that store a class fusion to <tbl> having
##  image exactly <classes> and whose size equals the union of the
##  class lengths for <classes>.
##
CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage:=
    function( tbl, classes )
    local n, result, ids, name, subtbl, fus, next;

    n:= Sum( SizesConjugacyClasses( tbl ){ classes } );
    result:= [];
    ids:= [];
    for name in NamesOfFusionSources( tbl ) do
      subtbl:= CharacterTable( name );
      if subtbl <> fail and Size( subtbl ) mod n = 0 then
        fus:= GetFusionMap( subtbl, tbl );
        if Set( fus ) = classes and Size( subtbl ) = n then
          # The table itself satisfies the conditions.
          if not Identifier( subtbl ) in ids then
            Add( result, [ subtbl, fus ] );
            AddSet( ids, Identifier( subtbl ) );
          fi;
        elif ClassPositionsOfKernel( fus ) = [ 1 ]
             and IsSubset( fus, classes ) then
          # Maybe a subgroup fits, so enter a recursion.
          for next in
            CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage( subtbl,
              Filtered( [ 1 .. Length( fus ) ], i -> fus[i] in classes ) ) do
            if not Identifier( next[1] ) in ids then
              Add( result, [ next[1], fus{ next[2] } ] );
              AddSet( ids, Identifier( next[1] ) );
            fi;
          od;
        fi;
      fi;
    od;
    return result;
    end;


#############################################################################
##
#F  CTblLib.FindTableForGroup( <G>, <tbls>, <pos> )
##
##  Let <G> be a group, <tbls> be a list of ordinary character tables,
##  and <pos> be a position in this list such that <G> belongs to (at least)
##  one of these tables.
##  `CTblLib.FindTableForGroup' tries to decide whether <G> belongs to the
##  <pos>-th entry in <tbls>.
##  If this is possible then `true' or `false' is returned,
##  otherwise `fail' is returned.
##
CTblLib.FindTableForGroup:= function( G, tbls, pos )
    local funs, invs, rng, bound, k, g, i, val;

    # Use element orders and centralizer orders.
    funs:= [ Order,
             g -> Size( Centralizer( G, g ) ) ];
    invs:= List( tbls, t -> TransposedMat(
                                [ OrdersClassRepresentatives( t ),
                                  SizesCentralizers( t ) ] ) );

    # Can we decide the question, or is there a chance to fail?
    rng:= [ 1 .. Length( tbls ) ];
    if ForAll( rng, i -> i = pos or
                 not ( IsEmpty( Difference( invs[i], invs[ pos ] ) ) or
                       IsEmpty( Difference( invs[i], invs[ pos ] ) ) ) ) then
      bound:= infinity;
    else
      bound:= 100;
    fi;

    k:= 1;
    while k <= bound do
      g:= PseudoRandom( G );
      for i in [ 1 .. Length( funs ) ] do
        val:= funs[i]( g );
        rng:= Filtered( rng,
                        j -> ForAny( invs[j], tuple -> val = tuple[i] ) );
        if   rng = [ pos ] then
          return true;
        elif not pos in rng then
          return false;
        fi;
      od;
      k:= k + 1;
    od;

    return fail;
    end;


#T hier!

#############################################################################
##
##  Provide utilities for the computation of database attribute values.
##  They allow one to access table data without actually creating the tables.
##


##
##  default `string' function for printing database attributes to files
##
CTblLib.AttrDataString:= function( entry, default, withcomment )
    local encode, result, comment, data, l, x;

    encode:= function( value )
      if IsString( value ) then
        value:= ReplacedString( value, "\"", "\\\"" );
        value:= ReplacedString( value, "\n", "\\n" );
        value:= Concatenation( "\"", value, "\"" );
      elif IsList( value ) then
        value:= Concatenation( "[",
                    JoinStringsWithSeparator( List( value, encode ), "," ),
                    "]" );
      else
        value:= String( value );
        value:= ReplacedString( value, "\"", "\\\"" );
        value:= ReplacedString( value, "\n", "\\n" );
      fi;
      return value;
    end;

    # Default values need not be stored.
    if IsList( entry[2] ) and entry[2] = default then
      return "";
    fi;

    # The first entry is the identifier.
    result:= Concatenation( "[", encode( entry[1] ), "," );

    if withcomment then
      # A comment may be stored at the second position.
      comment:= entry[2][1];
      data:= entry[2][2];
      Append( result, Concatenation( "[", encode( comment ), "," ) );
    else
      data:= entry[2];
    fi;
    Append( result, encode( data ) );
    if withcomment then
      Append( result, "]" );
    fi;
    Append( result, "],\n" );
    return result;
end;


#############################################################################
##
#F  CTblLib.Data.InvariantByRecursion( <list>, <funcs> )
##
##  ... is used only for computing the `Size' and `NrConjugacyClasses' values
##
##  <funcs> is a record with the components
##    `gentablefunc'
##      a function that takes two arguments,
##      a generic character table and ...
##    `wreathsymmfunc'
##      a function ...
##    `cheaptest'
##      a function ...
##
CTblLib.Data.InvariantByRecursion:= function( list, funcs )
    local id, info, r, res, cen;

    id:= list[1];
    info:= LibInfoCharacterTable( id );
    id:= info.firstName;
    if info.fileName = "ctgeneri" then
      # Evaluate only part of the generic table.
      return funcs.gentablefunc( CharacterTable( info.firstName ), list );
    elif Length( list ) = 1
         and IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.CharacterTableInfo.( id );
      res:= funcs.cheaptest( r );
      if res <>  fail then
        return res;
      elif IsBound( r.ConstructionInfoCharacterTable )
           and IsList( r.ConstructionInfoCharacterTable ) then
        # Determine the size/nccl from the sizes/nccls of the input tables.
        if   r.ConstructionInfoCharacterTable[1] in
                  [ "ConstructDirectProduct", "ConstructIsoclinic" ] then
          r:= List( r.ConstructionInfoCharacterTable[2],
                    l -> CTblLib.Data.InvariantByRecursion( l, funcs ) );
          if fail in r then
            return fail;
          fi;
          return Product( r, 1 );
        elif r.ConstructionInfoCharacterTable[1] in
                  [ "ConstructPermuted", "ConstructAdjusted" ] then
          r:= CTblLib.Data.InvariantByRecursion(
                  r.ConstructionInfoCharacterTable[2], funcs );
          if r = fail then
            return fail;
          fi;
          return r;
        elif r.ConstructionInfoCharacterTable[1]
             = "ConstructWreathSymmetric" then
          id:= r.ConstructionInfoCharacterTable[3];
          r:= CTblLib.Data.InvariantByRecursion(
                  r.ConstructionInfoCharacterTable[2], funcs );
          if r = fail then
            return fail;
          fi;
          return funcs.wreathsymmfunc( r, id );
        elif r.ConstructionInfoCharacterTable[1]
             = "ConstructCentralProduct" then
          cen:= r.ConstructionInfoCharacterTable[3];
          r:= List( r.ConstructionInfoCharacterTable[2],
                    l -> CTblLib.Data.InvariantByRecursion( l, funcs ) );
          if fail in r then
            return fail;
          fi;
          return Product( r, 1 ) / Length( cen );
        fi;
      fi;
    fi;
    return fail;
end;


# a special component ...
CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable:= [];

CTblLib.Data.prepare:= function( attr )
  CTblLib.Data.unload:= UserPreference( "CTblLib", "UnloadCTblLibFiles" );
  SetUserPreference( "CTblLib", "UnloadCTblLibFiles", false );
end;

CTblLib.Data.cleanup:= function( attr )
  SetUserPreference( "CTblLib", "UnloadCTblLibFiles", CTblLib.Data.unload );
  Unbind( CTblLib.Data.unload );
end;

CTblLib.Data.MyIdFunc:= function( arg ); end;

CTblLib.Data.TABLE_ACCESS_FUNCTIONS:= [
  rec(),
  rec(
       LIBTABLE := rec( LOADSTATUS := rec(), clmelab := [], clmexsp := [] ),

       # These functions are used in the data files.
       GALOIS := CTblLib.Data.MyIdFunc,
       TENSOR := CTblLib.Data.MyIdFunc,
       ALF := CTblLib.Data.MyIdFunc,
       ACM := CTblLib.Data.MyIdFunc,
       ARC := CTblLib.Data.MyIdFunc,
       ALN := CTblLib.Data.MyIdFunc,
       MBT := CTblLib.Data.MyIdFunc,
       MOT := CTblLib.Data.MyIdFunc,
      ) ];

CTblLib.Data.SaveTableAccessFunctions := function()
  local name;

  if CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1] <> rec() then
    Info( InfoDatabaseAttribute, 1, "functions were already saved" );
    return;
  fi;

  Info( InfoDatabaseAttribute, 1, "before saving global variables" );
  for name in RecNames( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2] ) do
    if IsBoundGlobal( name ) then
      if IsReadOnlyGlobal( name ) then
        MakeReadWriteGlobal( name );
        CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ):=
            [ ValueGlobal( name ), "readonly" ];
      else
        CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ):=
            [ ValueGlobal( name ) ];
      fi;
      UnbindGlobal( name );
    fi;
    ASS_GVAR( name, CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2].( name ) );
  od;
end;

CTblLib.Data.RestoreTableAccessFunctions := function()
  local name;

  if CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1] = rec() then
    Info( InfoDatabaseAttribute, 1, "cannot restore without saving" );
    return;
  fi;

  for name in RecNames( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2] ) do
    UnbindGlobal( name );
    if IsBound( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) ) then
      ASS_GVAR( name, CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name )[1] );
      if Length( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) ) = 2 then
        MakeReadOnlyGlobal( name );
      fi;
      Unbind( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) );
    fi;
  od;
  Info( InfoDatabaseAttribute, 1, "after restoring global variables" );
end;


#############################################################################
##
#F  CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
#F      <neededcomponents>, <providedcomponents>, <pairs> )
##
##  If `CTblLib.Data.knownComponents' contains all entries of the list
##  <neededcomponents> then nothing is done.
##
##  Otherwise, ...
##
##  The argument <A>pairs</A> must be a list of pairs
##  <C>[ <A>nam</A>, <A>fun</A> ]</C>
##  where <A>nam</A> is the name of a function to be reassigned during the
##  reread process (such as <C>"MOT"</C>, <C>"ARC"</C>),
##  and <A>fun</A> is the corresponding value.
##
CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles :=
    function( neededcomponents, providedcomponents, pairs )
    local filenames, pair, name;

    # Check if we have to do something.
    if IsBound( CTblLib.Data.knownComponents ) and
       IsSubset( CTblLib.Data.knownComponents, neededcomponents ) then
      return;
    fi;

    # Remember the names of all character table library files.
    filenames:= LIBLIST.files;

    # Disable the table library access.
    CTblLib.Data.SaveTableAccessFunctions();

    # Define appropriate access functions.
    for pair in pairs do
      ASS_GVAR( pair[1], pair[2] );
    od;

    # Clear the cache.
    CTblLib.Data.CharacterTableInfo:= rec();

    # Loop over the library files.
    for name in filenames do
      if name[1] = '/' then
        # private extension
        Read( Concatenation( name, ".tbl" ) );
      else
        ReadPackage( "ctbllib", Concatenation( "data/", name, ".tbl" ) );
      fi;
    od;

    # Restore the ordinary table library access.
    CTblLib.Data.RestoreTableAccessFunctions();

    # Replace the component list for the next call.
    CTblLib.Data.knownComponents:= providedcomponents;
    end;


#############################################################################
##
##  Create the database id enumerator to which the database attributes refer.
##
CTblLib.Data.IdEnumerator:= DatabaseIdEnumerator( rec(
    identifiers:= Set( AllCharacterTableNames() ),
    isSorted:= true,
    entry:= function( idenum, id ) return CharacterTable( id ); end,
    version:= LIBLIST.lastupdated,
    update:= function( idenum )
      idenum.identifiers:= Set( AllCharacterTableNames() );
      idenum.version:= LIBLIST.lastupdated;
      return true;
      end,
#   isUpToDate:= idenum -> idenum.version = LIBLIST.lastupdated,
#T note: notifying a new table should then change the lastupdated field!
    viewSort:= BrowseData.CompareAsNumbersAndNonnumbers,
    align:= "lt",
  ) );;


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.Size
##
AddSet( CTblLib.SupportedAttributes, "Size" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "Size",
  description:= "sizes of GAP library character tables",
  type:= "pairs",
  name:= "Size",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_size.dat" ),
  dataDefault:= fail,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "SizesCentralizers" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local r, other;

    if IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.InvariantByRecursion( [ id ],
              rec( gentablefunc:= function( gentable, list)
                     return gentable.size( list[2] );
                   end,
                   cheaptest:= function( r )
                     if IsList( r.SizesCentralizers ) then
                       return r.SizesCentralizers[1];
                     fi;
                     return fail;
                   end,
                   wreathsymmfunc:= function( subval, n )
                     return subval^n * Factorial( n );
                   end,
                 ) );
    else
      r:= fail;
    fi;
    if r = fail then
      Info( InfoDatabaseAttribute, 1,
            "hard test for Size computation of ", id );
      return Size( CharacterTable( id ) );
    else
      return r;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "size",
  viewSort:= BrowseData.CompareLenLex,
  categoryValue:= res -> Concatenation( "size = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 25,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable
##
DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IdentifierOfMainTable",
  description:= "identifier of the table for which the current table is a duplicate",
  type:= "pairs",
  name:= "IdentifierOfMainTable",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_main.dat" ),
  dataDefault:= fail,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local r, t;

    r:= fail;
    if IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      t:= CTblLib.Data.CharacterTableInfo.( id );
      if IsBound( t.ConstructionInfoCharacterTable ) then
        r:= t.ConstructionInfoCharacterTable;
      fi;
    else
      t:= CharacterTable( id );
      if HasConstructionInfoCharacterTable( t ) then
        r:= ConstructionInfoCharacterTable( t );
      fi;
    fi;
    if IsList( r ) and r[1] = "ConstructPermuted" and Length( r[2] ) = 1 then
      r:= r[2][1];
    else
      r:= fail;
    fi;

    return r;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "main",
  categoryValue:= res -> Concatenation( "main table = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 12,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsDuplicateTable
##
AddSet( CTblLib.SupportedAttributes, "IsDuplicateTable" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsDuplicateTable",
  description:= "are GAP library character tables duplicates of others",
  type:= "values",
  name:= "IsDuplicateTable",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "duplicate";
    else
      return "not duplicate";
    fi;
    end,
  neededAttributes:= [ "IdentifierOfMainTable" ],
  create:= function( attr, id )
    local main;

    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    return IsString( main.attributeValue( main, id ) );
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "duplicate?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables
##
AddSet( CTblLib.SupportedAttributes, "IdentifiersOfDuplicateTables" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IdentifiersOfDuplicateTables",
  description:= "identifiers of GAP library character tables that are duplicates",
  type:= "pairs",
  name:= "IdentifiersOfDuplicateTables",
  dataDefault:= [],
  neededAttributes:= [ "IdentifierOfMainTable" ],
  prepareAttributeComputation:= function( attr )
      local main, id, mainid;

      main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
      CTblLib.IdentifiersOfDuplicateTables:= rec();

      for id in CTblLib.Data.IdEnumerator.identifiers do
        mainid:= main.attributeValue( main, id );
        if mainid <> fail then
          if not IsBound( CTblLib.IdentifiersOfDuplicateTables.( mainid ) ) then
            CTblLib.IdentifiersOfDuplicateTables.( mainid ):= [ id ];
          else
            AddSet( CTblLib.IdentifiersOfDuplicateTables.( mainid ), id );
          fi;
        fi;
      od;
    end,
  cleanupAfterAttributeComputation:= function( attr )
      Unbind( CTblLib.IdentifiersOfDuplicateTables );
    end,
  create:= function( attr, id )
    if IsBound( CTblLib.IdentifiersOfDuplicateTables.( id ) ) then
      return CTblLib.IdentifiersOfDuplicateTables.( id );
    else
      return [];
    fi;
    end,
  viewLabel:= "duplicates",
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.NrConjugacyClasses
##
AddSet( CTblLib.SupportedAttributes, "NrConjugacyClasses" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "NrConjugacyClasses",
  description:= "class numbers of GAP library character tables",
  type:= "pairs",
  name:= "NrConjugacyClasses",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_nccl.dat" ),
  dataDefault:= fail,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "SizesCentralizers" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local r, other;

    if IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.InvariantByRecursion( [ id ],
              rec( gentablefunc:= function( gentable, list )
                     return Sum( List( gentable.classparam,
                                       p -> Length( p( list[2] ) ) ), 0 );
                   end,
                   cheaptest:= function( r )
                     if IsList( r.SizesCentralizers ) then
                       return Length( r.SizesCentralizers );
                     fi;
                     return fail;
                   end,
                   wreathsymmfunc:= function( subval, n )
                     return NrPartitionTuples( n, subval );
                   end,
                 ) );
    else
      r:= fail;
    fi;
    if r = fail then
      return NrConjugacyClasses( CharacterTable( id ) );
    else
      return r;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "nccl",
  viewSort:= BrowseData.CompareLenLex,
  categoryValue:= res -> Concatenation( "nccl = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 4,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.InfoText
##
##  This is used for creating the group overviews
##  (plain strings or Browse tables or HTML files).
##
AddSet( CTblLib.SupportedAttributes, "InfoText" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "InfoText",
  description:= "info text of GAP library character tables",
  type:= "pairs",
  name:= "InfoText",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_text.dat" ),
  dataDefault:= "",
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "InfoText" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local info, r;

    if IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      info:= LibInfoCharacterTable( id );
      id:= info.firstName;
      if info.fileName = "ctgeneri" then
        # Evaluate only part of the generic table.
        return CharacterTable( info.firstName ).text;
      else
        r:= CTblLib.Data.CharacterTableInfo.( id );
        if IsList( r.InfoText ) then
          return Concatenation( r.InfoText );
        fi;
        return "";
      fi;
    else
      r:= CharacterTable( id );
      if HasInfoText( r ) then
        return InfoText( r );
      else
        return "";
      fi;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, "", false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "info",
  widthCol:= 20,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.Maxes
##
AddSet( CTblLib.SupportedAttributes, "Maxes" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "Maxes",
  description:= "maxes lists of GAP library character tables",
  type:= "pairs",
  name:= "Maxes",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_maxes.dat" ),
  dataDefault:= fail,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "Maxes" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    if IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ).Maxes ) then
      return CTblLib.Data.CharacterTableInfo.( id ).Maxes;
    else
      return fail;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "maxes",
  widthCol:= 25,
  ) );


#############################################################################
##
#V  CTBlLibData.IdEnumerator.attributes.NamesOfFusionSources
##
AddSet( CTblLib.SupportedAttributes, "NamesOfFusionSources" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "NamesOfFusionSources",
  description:= "fusions from other character tables to the given one",
  type:= "values",
  name:= "NamesOfFusionSources",
  align:= "tl",
  create:= function( attr, id )
    local pos;

    pos:= Position( LIBLIST.firstnames, id );
    if pos <> fail then
      return LIBLIST.fusionsource[ pos ];
    fi;
    return [];
    end,
  version:= CTblLib.Data.IdEnumerator.version,
  viewValue:= x -> rec( rows:= x, align:= "tl" ),
  viewLabel:= "fusions -> G",
  categoryValue:= function( val )
    if IsEmpty( val ) then
      return "(no fusions to these tables)";
    fi;
    return List( val, x -> Concatenation( "fusions from ", x ) );
    end,
  sortParameters:= [ "add counter on categorizing", "yes",
                     "split rows on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.FusionsTo
##
DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "FusionsTo",
  description:= "fusions from the given character table to other ones",
  type:= "values",
  align:= "tl",
  categoryValue:= function( val )
    if IsEmpty( val ) then
      return "(no fusions from these tables)";
    fi;
    return List( val, x -> Concatenation( "fusions to ", x ) );
    end,
  prepareAttributeComputation:= function( attr )
    local i, nam, src;

    CTblLib.Data.sortedfirstnames:= ShallowCopy( LIBLIST.firstnames );
    CTblLib.Data.position:= [ 1 .. Length( LIBLIST.firstnames ) ];
    SortParallel( CTblLib.Data.sortedfirstnames, CTblLib.Data.position );
    CTblLib.Data.FusionInfo:= List( [ 1 .. Length( LIBLIST.firstnames ) ],
                                   i -> [] );
    for i in [ 1 .. Length( LIBLIST.firstnames ) ] do
      nam:= LIBLIST.firstnames[i];
      for src in LIBLIST.fusionsource[i] do
        Add( CTblLib.Data.FusionInfo[ PositionSet(
               CTblLib.Data.sortedfirstnames, src ) ], nam );
      od;
    od;
    end,
  create:= function( attr, id )
    local pos;

    pos:= PositionSet( CTblLib.Data.sortedfirstnames, id );
    if pos <> fail then
      return CTblLib.Data.FusionInfo[ pos ];
    fi;
    return [];
    end,
  viewValue:= x -> rec( rows:= x, align:= "tl" ),
  viewLabel:= "fusions G ->",
  sortParameters:= [ "add counter on categorizing", "yes",
                     "split rows on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.atlas
##
##  The mapping between the GAP Character Table Library and the AtlasRep
##  package is provided only if the two packages are available.
##
##  The mapping relies on the coincidence of group names.
##
if IsPackageMarkedForLoading( "atlasrep", "" ) then

Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "atlas" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "atlas",
  description:= "mapping between CTblLib and AtlasRep, via group names",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_atlas.dat" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
    local result, entry;

    result:= [];
    for entry in l do
      if Length( entry ) = 1 then
        Add( result, [ "AtlasGroup", entry ] );
      elif IsInt( entry[2] ) then
        Add( result, [ "AtlasSubgroup", entry ] );
      else
        Add( result, [ "AtlasStabilizer", entry ] );
      fi;
    od;
    return result;
    end,
  reverseEval:= function( attr, info )
    local entry;

    if ( info[1] = "AtlasGroup" and Length( info[2] ) = 1 ) or
       ( info[1] = "AtlasSubgroup" and Length( info[2] ) = 2 ) or
       ( info[1] = "AtlasStabilizer" and Length( info[2] ) = 2 ) then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for entry in Concatenation( attr.data.automatic,
                                  attr.data.nonautomatic ) do
        if info[2] in entry[2] then
          return entry[1];
        fi;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_atlas:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_atlas );
    end,
  create:= function( attr, id )
    local main, mainid, dupl, names, result, name, admissible, entry, 
          permrepinfo, tbl, r, super, sadmissible, maxpos, prefix, i, ii,
          pos, prog, arec, repname, info;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_atlas.( id ) ) then
      return CTblLib.Data.attrvalues_atlas.( id );
    fi;

    # Now we know that we have to work.
    dupl:= CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables;
    names:= Concatenation( [ id ], dupl.attributeValue( dupl, id ) );
    result:= [];
    permrepinfo:= AtlasOfGroupRepresentationsInfo.permrepinfo;

    for name in names do
      if Position( LIBLIST.firstnames, name ) = fail then
        Info( InfoDatabaseAttribute, 1,
              "illegal construction source for ", id, ": ", name );
      else
        # Check whether a name belongs to an Atlas group.
        admissible:= LIBLIST.allnames{ CTblLib.Data.invposition[
            Position( LIBLIST.firstnames, name ) ] };
        entry:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       l -> LowercaseString( l[1] ) in admissible );
        if entry <> fail and
           OneAtlasGeneratingSetInfo( entry[1] ) <> fail then
          Add( result, [ entry[1] ] );
        fi;

        # Check whether a name belongs to a maximal subgroup of an
        # Atlas group such that one of the following is available:
        # - any representation of the group and a straight line program
        #   for the subgroup,
        # - a permutation representation of the group such that the subgroup
        #   is a point stabilizer.
        tbl:= CharacterTable( name );
        for r in ComputedClassFusions( tbl ) do
          if Length( ClassPositionsOfKernel( r.map ) ) = 1 then
            super:= CharacterTable( r.name );
            if super <> fail then
              sadmissible:= LIBLIST.allnames{ CTblLib.Data.invposition[
                  Position( LIBLIST.firstnames, Identifier( super ) ) ] };
              entry:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                             l -> LowercaseString( l[1] ) in sadmissible );
              if entry <> fail then
                maxpos:= [];
                if HasMaxes( super ) then
                  # Try to find `tbl' among the maxes of `super'.
                  maxpos:= Positions( Maxes( super ), Identifier( tbl ) );
                else
                  # Try to find relative admisible names of `tbl' as a
                  # maximal subgroup of `super'.
                  prefix:= Concatenation(
                               LowercaseString( Identifier( super ) ), "m" );
                  admissible:= Filtered( admissible,
                      x -> Length( x ) > Length( prefix ) and
                           x{ [ 1 .. Length( prefix ) ] } = prefix );
                  for i in admissible do
                    ii:= Int( i{ [ Length( prefix ) + 1 .. Length( i ) ] } );
                    if ii <> fail then
                      Add( maxpos, ii );
                    fi;
                  od;
                fi;
                for pos in maxpos do
                  prog:= AtlasProgram( entry[1], "maxes", pos );
                  if prog <> fail and
                     OneAtlasGeneratingSetInfo( entry[1],
                         prog.standardization ) <> fail then
                    Add( result, [ entry[1], pos ] );
                  fi;
                  for arec in AllAtlasGeneratingSetInfos( entry[1],
                                  IsPermGroup, true ) do
                    repname:= arec.repname;
                    if IsBound( permrepinfo.( repname ) ) then
                      info:= permrepinfo.( repname );
                      if IsBound( info.isPrimitive ) and
                         info.isPrimitive = true and
                         IsBound( info.maxnr ) and info.maxnr = pos then
                        Add( result, [ entry[1], repname ] );
                      fi;
                    fi;
                  od;
                od;
              fi;
            fi;
          fi;
        od;
      fi;
    od;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_atlas.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );

fi;


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.basic
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "basic" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "basic",
  description:= "mapping between CTblLib and GAP's basic groups libraries",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_basic.dat" ),
  dataDefault:= [],
  isSorted:= true,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] in [ "AlternatingGroup", "CyclicGroup",
                    "DihedralGroup", "MathieuGroup", "POmega", "PSL",
                    "PSU", "PSp", "ReeGroup", "SuzukiGroup",
                    "SymmetricGroup" ] then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:=  function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_basic:= rec();
    CTblLib.Data.prepare( attr );
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_basic );
    CTblLib.Data.cleanup( attr );
    end,
  create:= function( attr, id )
    local main, mainid, dupl, names, result, tbl, type, r, nsg, simp, cen,
          name;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_basic.( id ) ) then
      return CTblLib.Data.attrvalues_basic.( id );
    fi;

    # Now we know that we have to work.
    dupl:= CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables;
    names:= Concatenation( [ id ], dupl.attributeValue( dupl, id ) );
    result:= [];

    # No duplicates are needed for the criteria for perfect groups.
    tbl:= CharacterTable( id );
    if   IsSimpleCharacterTable( tbl ) then
      type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
      if   type.series = "A" then
        Add( result, [ "AlternatingGroup", [ type.parameter ] ] );
        if   type.parameter = 5 then
          Add( result, [ "PSL", [ 2, 4 ] ] );
          Add( result, [ "PSL", [ 2, 5 ] ] );
        elif type.parameter = 6 then
          Add( result, [ "PSL", [ 2, 9 ] ] );
        elif type.parameter = 8 then
          Add( result, [ "PSL", [ 4, 2 ] ] );
        fi;
      elif type.series = "B" then
        Add( result,
             [ "POmega", [ 2 * type.parameter[1] + 1, type.parameter[2] ] ] );
        if IsEvenInt( type.parameter[2] ) or type.parameter[1] = 2 then
          Add( result,
               [ "PSp", [ 2 * type.parameter[1], type.parameter[2] ] ] );
        fi;
        if type.parameter = [ 2, 3 ] then
          Add( result, [ "PSU", [ 4, 2 ] ] );
          Add( result, [ "POmega", [ -1, 6, 2 ] ] );
        fi;
      elif type.series = "C" then
        Add( result,
             [ "PSp", [ 2 * type.parameter[1], type.parameter[2] ] ] );
        if type.parameter[1] = 2 then
          Add( result, [ "POmega", [ 5, type.parameter[2] ] ] );
        fi;
      elif type.series = "D" then
        Add( result,
             [ "POmega", [ 1, 2 * type.parameter[1], type.parameter[2] ] ] );
      elif type.series = "L" then
        Add( result, [ "PSL", type.parameter ] );
        if   type.parameter[1] = 2 then
          Add( result, [ "POmega", [ 3, type.parameter[2] ] ] );
          Add( result, [ "PSp", type.parameter ] );
          Add( result, [ "PSU", type.parameter ] );
          r:= RootInt( type.parameter[2] );
          if r^2 = type.parameter[2] then
            Add( result, [ "POmega", [ -1, 4, r ] ] );
          fi;
          if type.parameter[2] = 7 then
            Add( result, [ "PSL", [ 3, 2 ] ] );
          fi;
        elif type.parameter[1] = 4 then
          Add( result, [ "POmega", [ 1, 6, type.parameter[2] ] ] );
        fi;
      elif type.series = "2A" then
        Add( result,
             [ "PSU", [ type.parameter[1] + 1, type.parameter[2] ] ] );
        if type.parameter[1] = 3 then
          Add( result, [ "POmega", [ -1, 6, type.parameter[2] ] ] );
        fi;
      elif type.series = "2B" then
        Add( result, [ "SuzukiGroup", [ type.parameter ] ] );
      elif type.series = "2D" then
        Add( result,
             [ "POmega", [ -1, 2 * type.parameter[1], type.parameter[2] ] ] );
      elif type.series = "2G" then
        Add( result, [ "ReeGroup", [ type.parameter ] ] );
      elif type.series = "Spor" then
        if   type.name = "M(11)" then
          Add( result, [ "MathieuGroup", [ 11 ] ] );
        elif type.name = "M(12)" then
          Add( result, [ "MathieuGroup", [ 12 ] ] );
        elif type.name = "M(22)" then
          Add( result, [ "MathieuGroup", [ 22 ] ] );
        elif type.name = "M(23)" then
          Add( result, [ "MathieuGroup", [ 23 ] ] );
        elif type.name = "M(24)" then
          Add( result, [ "MathieuGroup", [ 24 ] ] );
        fi;
#T more series of simple groups?
      fi;
    elif IsPerfectCharacterTable( tbl ) then
      # Detect nonsolvable groups SL(2,q), for odd q.
      cen:= ClassPositionsOfCentre( tbl );
      if Size( cen ) = 2 then
        simp:= tbl / cen;
        if IsSimpleCharacterTable( simp ) then
          type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
          if type.series = "L" and type.parameter[1] = 2 then
            Add( result, [ "SL", type.parameter ] );
          fi;
        fi;
      fi;
    fi;

    # Detect nonsolvable symmetric groups.
#T Can this be done without the character table of the socle?
    for name in names do
      if IsAlmostSimpleCharacterTable( tbl ) and
         not IsSimpleCharacterTable( tbl ) then
        nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
        simp:= CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage(
                   tbl, nsg );
        if not IsEmpty( simp ) then
          simp:= simp[1][1];
          type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
          if   type.series = "A" and
               ( type.parameter <> 6
                 or not 8 in OrdersClassRepresentatives( tbl ) ) then
            Add( result, [ "SymmetricGroup", [ type.parameter ] ] );
            if type.parameter = 6 then
              Add( result, [ "PSp", [ 4, 2 ] ] );
              Add( result, [ "POmega", [ 5, 2 ] ] );
            fi;
          fi;
        fi;
        if Size( tbl ) = 720 and NrConjugacyClasses( tbl ) = 8 then
          Add( result, [ "MathieuGroup", [ 10 ] ] );
        fi;
      fi;
    od;

    # Detect some solvable groups.
    if   Size( tbl ) = 12 and NrConjugacyClasses( tbl ) = 4 then
      Add( result, [ "AlternatingGroup", [ 4 ] ] );
      Add( result, [ "PSL", [ 2, 3 ] ] );
      Add( result, [ "PSU", [ 2, 3 ] ] );
      Add( result, [ "PSp", [ 2, 3 ] ] );
    elif Size( tbl ) = 20 and NrConjugacyClasses( tbl ) = 5 then
      Add( result, [ "SuzukiGroup", [ 2 ] ] );
    elif Size( tbl ) = 24 and NrConjugacyClasses( tbl ) = 5 then
      Add( result, [ "SymmetricGroup", [ 4 ] ] );
    elif Size( tbl ) = 72 and NrConjugacyClasses( tbl ) = 6 then
      Add( result, [ "MathieuGroup", [ 9 ] ] );
      Add( result, [ "PSU", [ 3, 2 ] ] );
    fi;

    if IsCyclic( tbl ) then
      Add( result, [ "CyclicGroup", [ Size( tbl ) ] ] );
      if Size( tbl ) = 3 then
        Add( result, [ "AlternatingGroup", [ 3 ] ] );
      fi;
    fi;

    if IsDihedralCharacterTable( tbl ) then
      Add( result, [ "DihedralGroup", [ Size( tbl ) ] ] );
      if Size( tbl ) = 6 then
        Add( result, [ "SymmetricGroup", [ 3 ] ] );
        Add( result, [ "PSL", [ 2, 2 ] ] );
        Add( result, [ "PSU", [ 2, 2 ] ] );
        Add( result, [ "PSp", [ 2, 2 ] ] );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_basic.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );
#T SigmaL, PSigmaL, GammaL, PGammaL?
#T SL, GL?


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.perf
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "perf" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "perf",
  description:= "mapping between CTblLib and  GAP's library of perfect groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_perf.dat" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
           return List( l, val -> [ "PerfectGroup", val ] );
         end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "PerfectGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_perf:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_perf );
    end,
  create:= function( attr, id )
    local main, mainid, tbl, result, n, nr, pos, type, i, G;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_perf.( id ) ) then
      return CTblLib.Data.attrvalues_perf.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    result:= [];
    if IsPerfectCharacterTable( tbl ) then
      n:= Size( tbl );
      nr:= NumberPerfectLibraryGroups( n );
      if nr <> 0 then
        if   NumberPerfectGroups( n ) = 1 then
          # If there is only one perfect group of this order
          # (and we believe this) then we assign the table name to it.
          pos:= 1;
        elif IsSimpleCharacterTable( tbl ) then
          # If the table is simple then compare isomorphism types.
          type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
          for i in [ 1 .. nr ] do
            G:= Image( IsomorphismPermGroup( PerfectGroup( n, i ) ) );
            if IsSimpleGroup( G ) and
               IsomorphismTypeInfoFiniteSimpleGroup( G ) = type then
              pos:= i;
              break;
            fi;
          od;
        else
          # Do the hard test.
#T perhaps compare the lattice of normal subgroups first?
          for i in [ 1 .. nr ] do
            G:= Image( IsomorphismPermGroup( PerfectGroup( n, i ) ) );
            if NrConjugacyClasses( G ) = NrConjugacyClasses( tbl ) and
               IsRecord( TransformingPermutationsCharacterTables(
                         CharacterTable( G ), tbl ) ) then
              pos:= i;
              break;
            fi;
          od;
        fi;
        Add( result, [ n, pos ] );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_perf.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.prim
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "prim" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "prim",
  description:= "mapping between CTblLib and GAP's library of prim. groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_prim.dat" ),
  dataDefault:= [ "no information", [] ],
  isSorted:= true,
  eval:= function( attr, l )
      return List( l[2], val -> [ "PrimitiveGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "PrimitiveGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2][2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local result, i;

    CTblLib.Data.prepare( attr );

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_prim:= rec();

    # Reading library files causes frequent calls to `Factorial',
    # for numbers up to the largest primitive degree of the library.
    # The speedup gained by caching these numbers is remarkable,
    # at the cost of storing the values.
#T is this really still necessary?
    LIBTABLE.FactorialCACHE:= [];
    LIBTABLE.OldFactorial:= Factorial;
    MakeReadWriteGlobal( "Factorial" );
    UnbindGlobal( "Factorial" );
    BindGlobal( "Factorial", function( n )
        if n < 0 then
          Error( "<n> must be nonnegative" );
        elif IsBound( LIBTABLE.FactorialCACHE[n] ) then
          return LIBTABLE.FactorialCACHE[n];
        else
          return LIBTABLE.OldFactorial( n );
        fi;
    end );

    result:= 1;
    for i in [ 1 ..  PRIMRANGE[ Length( PRIMRANGE ) ] ] do
      result:= result * i;
      LIBTABLE.FactorialCACHE[i]:= result;
    od;
    end,

  cleanupAfterAttributeComputation:= function( attr )
    CTblLib.Data.cleanup( attr );

    UnbindGlobal( "Factorial" );
    BindGlobal( "Factorial", LIBTABLE.OldFactorial );
    Unbind( LIBTABLE.OldFactorial );
    Unbind( LIBTABLE.FactorialCACHE );
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_prim );
    end,

  create:= function( attr, id )
    local main, mainid, tbl, nsg, nsgsizes, n, solvmin, deg, cand, result,
          type, G, gcd, dupl, names, name, simp, outinfo, info, facttbl, der,
          socle, soclefact, tbls, tblpos, cand2, try, mustbesplit, fuscand,
          s, pos;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_prim.( id ) ) then
      return CTblLib.Data.attrvalues_prim.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );

    # Let $G$ be a primitive permutation group of degree $n$
    # that contains a *solvable* minimal normal subgroup $N$.
    # Then we have $|N| = n$, $|G|$ divides $|N|!$, $G$ is centerless
    # (Any point stabilizer $M$ is maximal in $G$, and $M \cap Z(G)$ is
    # contained in $Core_G(M)$, which is trivial; if $Z(G)$ is nontrivial
    # then $G = \langle M, Z(G) \rangle \cong M \times Z(G)$, contradiction.),
    # $N$ is the unique minimal normal subgroup of $G$,
    # and $G$ is a split extension of $N$.
    # (Proof:
    # Let $M$ be a core-free maximal subgroup of index $n$ in $G$.
    # Then $M \cap N$ is invariant under $M$ and (since $N$ is abelian)
    # under $N$, and because $N$ is not contained in $M$, we have $G = M N$,
    # so $M \cap N$ is normal in $G$ and hence $|M \cap N| = 1$.
    # This implies $n = [G:M] = |N|$, and clearly $G$ embeds into $Sym(n)$.
    # If $G$ would contain a nontrivial central subgroup $Z$ of prime order
    # then $|M \cap Z| = 1$ holds, which implies that $M$ is normal in $G$,
    # a contradiction.
    # Obviously $G$ cannot contain another *solvable* minimal normal
    # subgroup.  Suppose there is a nonsolvable minimal normal subgroup $T$,
    # say.  Then $T$ commutes with $N$, so $T \cap M$ is normal in $M$ and
    # commutes with $N$, hence is normal in $G$ and thus trivial --but this
    # implies that $G$ is a split extension of $T$ with $M$, hence the order
    # of $T$ is the prime power $n$, a contradiction.)

    # So we can immediately exclude tables with nontrivial centre,
    # as well as tables with a minimal normal subgroup $N$ of prime power
    # order that is either *larger* than the largest degree in the library
    # of primitive groups
    # or *too small* in the sense that the group order does not divide the
    # factorial of $|N|$.
    # Also note that for tables with a minimal normal subgroup $N$
    # of prime power order, the only possible degree is $|N|$,
    # and the table must admit a class fusion from the factor modulo $N$,
    # corresponding to the embedding of the point stabilizer
    # (so nonsplit extensions may be excluded using the character table).

    if 1 < Length( ClassPositionsOfCentre( tbl ) ) then
      CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      return attr.dataDefault;
    fi;
    nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl );
    nsgsizes:= List( nsg, x -> Sum( SizesConjugacyClasses( tbl ){ x } ) );
    n:= Size( tbl );
    solvmin:= Filtered( nsgsizes, IsPrimePowerInt );
    if   Length( solvmin ) >= 1 and Length( nsg ) > 1 then
      # A primitive group containing a solvable minimal subgroup cannot
      # contain another minimal normal subgroup.
      CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      return attr.dataDefault;
    elif Length( solvmin ) = 1 then
      # We know the possible degree.
      deg:= solvmin[1];
      if deg > PRIMRANGE[ Length( PRIMRANGE ) ]
         or Factorial( deg ) mod n <> 0 then
#T if this value is not cached then we can do better: n is much smaller than it!
        CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
        return attr.dataDefault;
      fi;
      # Use only those invariants that are already stored for the groups
      # in the GAP library of primitive groups;
      # for example, do not force computing the number of conjugacy classes.
      cand:= AllPrimitiveGroups(
                 NrMovedPoints, deg,
                 Size, n,
                 IsSimple, IsSimple( tbl ),
                 IsSolvable, IsSolvable( tbl ),
                 IsPerfect, IsPerfect( tbl ) );
    else
      # Use only those invariants that are already stored for the groups
      # in the GAP library of primitive groups;
      # for example, do not force computing the number of conjugacy classes.
      cand:= AllPrimitiveGroups(
                 # avoid the annoying ``Degree restricted to ...'' message.
                 NrMovedPoints, [ 1 .. PRIMRANGE[ Length( PRIMRANGE ) ] ],
                 Size, n,
                 IsSimple, IsSimple( tbl ),
                 IsSolvable, IsSolvable( tbl ),
                 IsPerfect, IsPerfect( tbl ) );
    fi;
    if cand = [] then
      CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      return attr.dataDefault;
    fi;
    result:= [];
    if   IsSimple( tbl ) then
      # The isomorphism type of simple tables can be determined.
      # Simply assign the name to the simple group.
      type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
      for G in cand do
        if IsomorphismTypeInfoFiniteSimpleGroup( G ) = type then
          Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
        fi;
      od;
      result:= [ "simple group", result ];
      CTblLib.Data.attrvalues_prim.( id ):= result;
      return result;
    elif IsPerfect( tbl ) and NumberPerfectGroups( n ) = 1 then
      # If there is a unique perfect group of this order then we are done.
      for G in cand do
        Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
      od;
      result:= [ "unique perfect group of its order", result ];
      CTblLib.Data.attrvalues_prim.( id ):= result;
      return result;
    fi;

    # For any minimal normal subgroup $N$ (not necessarily abelian)
    # in a primitive group, the degree of the action divides $|N|$ because
    # $N$ acts transitively.
    # So we can exclude all candidates that do not satisfy this condition.
    gcd:= Gcd( nsgsizes );
    cand:= Filtered( cand, G -> gcd mod NrMovedPoints( G ) = 0 );

    dupl:= CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables;
    names:= Concatenation( [ id ], dupl.attributeValue( dupl, id ) );

    if IsAlmostSimpleCharacterTable( tbl ) then
      for name in names do
        # Determine the isomorphism type of the socle.
        # If the character table library provides enough information about
        # the automorphic extensions of this group then try to determine the
        # isomorphism type of the almost simple group.
        tbl:= CharacterTable( name );
        nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl );
        simp:= CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage(
                   tbl, nsg[1] );
        if not IsEmpty( simp )
           and HasExtensionInfoCharacterTable( simp[1][1] ) then
          simp:= simp[1][1];
          type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
          # The following list contains pairs `[ <nam>, <indices> ]'
          # where <nam> runs over the suffixes of the names of
          # full automorphism groups of simple groups that occur in the
          # character table library, and <indices> is a list of orders of
          # socle factors for which the isomorphism type of the extension
          # is uniquely determined by these orders.
          outinfo:= [
                      [ "2",      [ 2 ] ],
                      [ "3",      [ 3 ] ],
                      [ "4",      [ 2, 4 ] ],
                      [ "2^2",    [ 4 ] ],
                      [ "5",      [ 5 ] ],
                      [ "6",      [ 2, 3, 6 ] ],
                      [ "3.2",    [ 2, 3, 6 ] ],
                      [ "(2x4)",  [ 8 ] ],
                      [ "D8",     [ 8 ] ],
                      [ "D12",    [ 3, 4, 12 ] ],
                      [ "(2xD8)", [ 16 ] ],
                      [ "(3xS3)", [ 2, 9, 18 ] ],
                      [ "5:4",    [ 2, 4, 5, 10, 20 ] ],
                      [ "S4",     [ 3, 6, 8, 12, 24 ] ],
                    ];
          info:= ExtensionInfoCharacterTable( simp )[2];
          info:= First( outinfo, x -> x[1] = info );
          facttbl:= tbl / nsg[1];
          if   info = fail then
            Print( "#E problem: is the table of ", id,
                   " really almost simple?\n ");
          elif    Size( tbl ) / Size( simp ) in info[2]
               or ( info[1] = "(2x4)" and Size( tbl ) / Size( simp ) = 4
                                      and not IsCyclic( facttbl ) )
               or ( info[1] = "D8" and Size( tbl ) / Size( simp ) = 4
                                   and IsCyclic( facttbl ) )
               or ( info[1] = "D12" and Size( tbl ) / Size( simp ) = 6
                                    and IsCyclic( facttbl ) )
               or ( info[1] = "(3xS3)" and Size( tbl ) / Size( simp ) = 6 )
               or ( info[1] = "S4" and Size( tbl ) / Size( simp ) = 4
                                   and IsCyclic( facttbl ) ) then
            # We can identify the group.
            for G in cand do
              if IsAlmostSimpleGroup( G ) then
                der:= DerivedSeriesOfGroup( G );
                socle:= der[ Length( der ) ];
                soclefact:= G / socle;
                if type = IsomorphismTypeInfoFiniteSimpleGroup( socle ) and
                   ( Size( tbl ) / Size( simp ) in info[2] or
                     ( info[1] = "(2x4)" and not IsCyclic( soclefact ) ) or
                     ( info[1] = "D8" and IsCyclic( soclefact ) ) or
                     ( info[1] = "D12" and IsCyclic( soclefact ) ) or
                     ( info[1] = "(3xS3)" and IsCyclic( soclefact )
                                          and IsCyclic( facttbl ) ) or
                     ( info[1] = "(3xS3)" and not IsCyclic( soclefact )
                                          and not IsCyclic( facttbl ) ) or
                     ( info[1] = "S4" and IsCyclic( soclefact ) ) ) then
                  Add( result, [ NrMovedPoints( G ),
                                 PrimitiveIdentification( G ) ] );
                fi;
              fi;
            od;

            result:= [ Concatenation( "unique almost simple group with the ",
                                      "given socle and socle factor" ),
                       result ];
            CTblLib.Data.attrvalues_prim.( id ):= result;
            return result;
          else
            # Try to identify the extension of the socle by excluding
            # all but one of the possibilities
            # if we have all tables for these possibilities.
            outinfo:= [
                        [ "2^2",    [ [ 2, [ "2_1", "2_2", "2_3" ] ] ] ],
                        [ "(2x4)",  [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 4, [ "2^2", "4_1", "4_2" ] ] ] ],
                        [ "D8",     [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 4, [ "4", "(2^2)_{122}",
                                             "(2^2)_{133}" ] ] ] ],
                        [ "D12",    [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 6, [ "6", "3.2_2", "3.2_3" ] ] ] ],
                        [ "(3xS3)", [ [ 3, [ "3_1", "3_2", "3_3" ] ] ] ],
                        [ "S4",     [ [ 2, [ "2_1", "2_2" ] ],
                                      [ 4, [ "4", "(2^2)_{111}",
                                             "(2^2)_{122}" ] ] ] ],
                      ];
            info:= First( outinfo, x -> x[1] = info[1] );
            if info <> fail then
              info:= First( info[2],
                            x -> x[1] = Size( tbl ) / Size( simp ) );
              if info <> fail then
                tbls:= List( info[2],
                             s -> CharacterTable( Concatenation(
                                      Identifier( simp ), ".", s ) ) );
                if ForAll( tbls, IsCharacterTable ) then
                  tblpos:= First( [ 1 .. Length( tbls ) ],
                               i -> TransformingPermutationsCharacterTables(
                                        tbl, tbls[i] ) <> fail );
                  cand2:= [];
                  for G in cand do
                    if IsAlmostSimpleGroup( G ) then
                      der:= DerivedSeriesOfGroup( G );
                      socle:= der[ Length( der ) ];
                      if type = IsomorphismTypeInfoFiniteSimpleGroup( socle )
                         then
                        try:= CTblLib.FindTableForGroup( G, tbls, tblpos );
                        if try = true then
                          Add( result, [ NrMovedPoints( G ),
                                         PrimitiveIdentification( G ) ] );
                        elif try = fail then
                          Add( cand2, G );
                        fi;
                      fi;
                    fi;
                  od;
                  if cand2 = [] then
                    result:= [ Concatenation( "almost simple group with ",
                        "the given socle and socle factor that fits" ),
                               result ];
                    CTblLib.Data.attrvalues_prim.( id ):= result;
                    return result;
                  else
#T inhomogeneous: some groups are detected, others are not ...
#T (problem for the comment string ...)
                    result:= [];
                  fi;
                fi;
              fi;
            fi;
          fi;
        else
          # There are some cases where the table of the socle is not available,
          # and where the almost simple group is determined by its order.
          if Identifier( tbl ) in [ "O12+(2).2", "O12-(2).2" ] then
            for G in cand do
              if IsAlmostSimpleGroup( G ) then
                der:= DerivedSeriesOfGroup( G );
                socle:= der[ Length( der ) ];
                soclefact:= G / socle;
                type:= IsomorphismTypeInfoFiniteSimpleGroup( socle );
                if ( Identifier( tbl ) = "O12+(2).2" and
                     type.series = "D" and type.parameter = [ 6, 2 ] ) or
                   ( Identifier( tbl ) = "O12-(2).2" and
                     type.series = "2D" and type.parameter = [ 6, 2 ] ) then
                  Add( result, [ NrMovedPoints( G ),
                                 PrimitiveIdentification( G ) ] );
                fi;
              fi;
            od;
            result:= [ Concatenation( "unique almost simple group with the ",
                                      "given socle and socle factor" ),
                       result ];
            CTblLib.Data.attrvalues_prim.( id ):= result;
            return result;
          fi;
        fi;
      od;
    fi;

    cand:= Filtered( cand, G -> IsAlmostSimpleCharacterTable( tbl )
                                = IsAlmostSimpleGroup( G ) );

    # Now deal with the case that the given character table belongs to
    # a group $G$ with a unique minimal normal subgroup $N$ of prime power
    # $p^d$, such that $G$ is a *split* extension of $N$, with complement $C$.
    # (This can be concluded either from the fact that $|N|$ and $[G:N]$ are
    # coprime, or from the fact that fusions from $C$ to $G$ and from $G$
    # onto $C$ are stored, such that the image of the embedding intersects
    # the kernel of the projection trivially.)
    # Then $C$ is maximal in $G$, so $G$ acts primitively on the cosets
    # of $C$.
    # (Note that for any maximal subgroup $M$ of $G$ that properly contains
    # $C$, the intersection $M \cap N$ is not trivial, so $M$ and thus also
    # $G = M N$ normalizes $M \cap N$, a contradiction to the minimality of
    # $N$.)
    # So if there is a unique primitive group of degree $|N|$ and of order
    # $|G|$ then it must belong to the given table --we do not check this!
    if Length( nsg ) = 1 then
      for name in names do
        tbl:= CharacterTable( name );
        nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
        n:= Sum( SizesConjugacyClasses( tbl ){ nsg } );
        if IsPrimePowerInt( n ) then
          # The minimal normal subgroup is elementary abelian.
          mustbesplit:= false;
          if Gcd( Size( tbl ) / n, n ) = 1 then
            mustbesplit:= true;
          else
            fuscand:= First( ComputedClassFusions( tbl ),
                             r -> ClassPositionsOfKernel( r.map ) = nsg );
            if fuscand <> fail then
              s:= CharacterTable( fuscand.name );
              if s <> fail then
                fuscand:= First( ComputedClassFusions( s ),
                                 r -> r.name = Identifier( tbl ) );
                if fuscand = fail then
                  if IsEmpty( PossibleClassFusions( s, tbl ) ) then
                    # The table is a nonsplit extension, hence not primitive.
                    result:= attr.dataDefault;
                    CTblLib.Data.attrvalues_prim.( id ):= result;
                    return result;
                  fi;
                elif Intersection( fuscand.map, nsg ) = [ 1 ] then
                  # There is a subgroup fusion from the factor table,
                  # and the factor is really a complement.
                  mustbesplit:= true;
                fi;
              fi;
            else
              Info( InfoDatabaseAttribute, 1,
                    "primitivity test: factor fusion missing on ",
                    Identifier( tbl ) );
            fi;
          fi;
          if mustbesplit then
            # The table belongs to a split extension,
            # so we know that it belongs to a primitive group.
            cand:= Filtered( cand, G -> n = NrMovedPoints( G ) );
            if Length( cand ) = 1 then
              # There is a unique primitive group of the relevant
              # degree that fits to the table.
              G:= cand[1];
              result:= [ "prim. group on solv. minimal normal subgroup",
                         [ [ n, PrimitiveIdentification( G ) ] ] ];
              CTblLib.Data.attrvalues_prim.( id ):= result;
              return result;
            fi;

            cand:= Filtered( cand, G -> NrConjugacyClasses( G )
                                        = NrConjugacyClasses( tbl ) );
            if Length( cand ) = 1 then
              # There is a unique primitive group with the right number of
              # classes that fits to the table.
              G:= cand[1];
              result:= [
              "prim. group on solv. minimal normal subgroup (classes test)",
                  [ [ n, PrimitiveIdentification( G ) ] ] ];
              CTblLib.Data.attrvalues_prim.( id ):= result;
              return result;
            fi;
          fi;
        fi;
      od;
    fi;

    if not IsEmpty( cand ) then
      if Size( tbl ) <= 5 * 10^7 then
        Info( InfoDatabaseAttribute, 1,
              "primitivity test: hard test for ", Identifier( tbl ),
              " (", Length( cand ), " candidates)" );
        for G in cand do
          # Do the hard test.
          if NrConjugacyClasses( G ) = NrConjugacyClasses( tbl ) and
             IsRecord( TransformingPermutationsCharacterTables(
                       CharacterTable( G ), tbl ) ) then
            Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
          fi;
        od;
      else
        Info( InfoDatabaseAttribute, 1,
              "primitivity test: omit hard test for ", Identifier( tbl ) );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= [ "hard test", result ];
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_prim.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [ "no information", [] ],
                                            true ),
  check:= function( id )
    local pos, entry, tbl, degrees, nsg, result, cand, nam, subtbl, fus, deg,
          i;

    pos:= Position( CTblLib.Data.GROUPINFO.prim.data[1], id );
    if pos = fail then
      return true;
    fi;
    entry:= CTblLib.Data.GROUPINFO.prim.data[3][ pos ];
    tbl:= CharacterTable( id );
    if tbl = fail then
      Print( "#I  no character table for `", id, "'\n" );
      return false;
    elif ForAny( entry, pair -> Size( PrimitiveGroup( pair[1], pair[2] ) )
                                <> Size( tbl ) ) then
      Print( "#I  different sizes for `", id, "'\n" );
      return false;
    fi;
    degrees:= Set( List( entry, pair -> pair[1] ) );
    nsg:= ClassPositionsOfNormalSubgroups( tbl );
    result:= true;
    if HasMaxes( tbl ) then
      # Delegate to an equivalent table where appropriate.
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        tbl:= CharacterTable( ConstructionInfoCharacterTable( tbl )[2][1] );
      fi;
      # If the tables of all maximal subgroups are known then check that
      # the primitive degrees are exactly the indices of the core-free
      # maximal subgroups (without multiplicity).
      cand:= [];
      for nam in Maxes( tbl ) do
        subtbl:= CharacterTable( nam );
        if subtbl = fail then
          Print( "#I  no character table for `", id, "'\n" );
          result:= false;
        else
          fus:= GetFusionMap( subtbl, tbl );
          if fus = fail then
            Print( "#I  no fusion `", nam, "' -> `", id, "'\n" );
            result:= false;
          elif ClassPositionsOfKernel( fus ) = [ 1 ]
               and Number( nsg, n -> IsSubset( Set( fus ), n ) ) = 1 then
            deg:= Size( tbl ) / Size( subtbl );
            if deg <= PRIMRANGE[ Length( PRIMRANGE ) ] then
              if deg in degrees then
                AddSet( cand, deg );
              else
                Print( "#E  maximal subgroup `", Identifier( subtbl ),
                       "' should yield degree ", deg, "\n" );
                result:= false;
              fi;
            fi;
          fi;
        fi;
      od;
      if degrees <> cand then
        Print( "#E  different prim. degrees for `", id, "'\n" );
        result:= false;
      fi;
    else
      # The indices of known core-free maximal subgroups yield primitive
      # degrees.
      for i in [ 1 .. 100 ] do
        subtbl:= CharacterTable( Concatenation( id, "M", String(i) ) );
        if subtbl <> fail then
          fus:= GetFusionMap( subtbl, tbl );
          if fus <> fail and ClassPositionsOfKernel( fus ) = [ 1 ]
                  and Number( nsg, n -> IsSubset( Set( fus ), n ) ) = 1 then
            deg:= Size( tbl ) / Size( subtbl );
            if deg <= PRIMRANGE[ Length( PRIMRANGE ) ]
               and not deg in degrees then
              Print( "#E  maximal subgroup `", Identifier( subtbl ),
                     "' should yield degree ", deg, "\n" );
              result:= false;
            fi;
          fi;
        fi;
      od;
    fi;
    return result;
  end,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.small
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "small" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "small",
  description:= "mapping between CTblLib and GAP's library of small groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_small.dat" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
      return List( l, val -> [ "SmallGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "SmallGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "atlas", "basic", "perf", "prim", "tom", "trans",
                       "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_small:= rec();
    CTblLib.Data.prepare( attr );
    LIBTABLE.IsEquiv:= function( G, tbl )
      return IsRecord( TransformingPermutationsCharacterTables(
                           CharacterTable( G ), tbl ) );
      end;
    end,

  cleanupAfterAttributeComputation:= function( attr )
    CTblLib.Data.cleanup( attr );
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_small );
    Unbind( LIBTABLE.IsEquiv );
    end,

  create:= function( attr, id )
    local main, mainid, tbl, n, found, nam, result;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_small.( id ) ) then
      return CTblLib.Data.attrvalues_small.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    n:= Size( tbl );
    if   n in [ 512, 1024, 1536 ] then
      # We have no `IdGroup' value, so we would have to think about
      # a different encoding of the attribute values.
      Info( InfoDatabaseAttribute, 1,
            "small groups test: omit ", Identifier( tbl ),
            " (no IdGroup for order ", n, ")" );
      result:= attr.dataDefault;
    elif n <= 2000 then
      # For these orders, we have `IdGroup' values.
      # Perhaps some other attribute knows the group.
      found:= false;
      for nam in [ "atlas", "basic", "perf", "prim", "tom", "trans" ] do
        result:= DatabaseAttributeValueDefault(
                     CTblLib.Data.IdEnumerator.attributes.( nam ), id );
        if not IsEmpty( result ) then
          result:= Set( List( result,
                              p -> IdGroup( GroupForGroupInfo( p ) ) ) );
          found:= true;
          break;
        fi;
      od;
      if not found then
        if n in [ 1152, 1920 ] or n mod 256 = 0 then
          # The access to library groups would take too long.
          Info( InfoDatabaseAttribute, 1,
                "small groups test: omit ", Identifier( tbl ),
                " (too expensive for order ", n, ")" );
          result:= attr.dataDefault;
        else
          # Use the access via the small groups library.
          result:= IdsOfAllSmallGroups( Size, n,
                       IsAbelian, IsAbelian( tbl ),
                       IsNilpotentGroup, IsNilpotent( tbl ),
                       IsSupersolvableGroup, IsSupersolvable( tbl ),
                       IsSolvableGroup, IsSolvable( tbl ),
                       IsSimple, IsSimple( tbl ),
                       IsPerfect, IsPerfect( tbl ),
                       NrConjugacyClasses, NrConjugacyClasses( tbl ),
                       G -> LIBTABLE.IsEquiv( G, tbl ), true );
          # The following is necessary in a loop over several tables.
          UnloadSmallGroupsData();
          if IsEmpty( result ) then
            result:= attr.dataDefault;
          fi;
        fi;
      fi;
    else
      result:= attr.dataDefault;
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_small.( id ):= result;

    return result; 
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.tom
##
##  The mapping between the GAP Character Table Library and the
##  GAP Library of Tables of Marks is provided only if the two packages are
##  available.
##
if IsPackageMarkedForLoading( "tomlib", "" ) then

Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "tom" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "tom",
  description:= "mapping between CTblLib and GAP's library of tables of marks",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_tom.dat" ),
  dataDefault:= [],
  isSorted:= true,
  attributeValue:= function( attr, id )
    local pos, name, names;

    pos:= Position( LIBLIST.TOM_TBL_INFO[2], LowercaseString( id ) );
    if pos <> fail then
      name:= LIBLIST.TOM_TBL_INFO[1][ pos ];
      names:= NamesLibTom( name );
      if names <> fail and not IsEmpty( names ) then
        name:= names[1];
      fi;
      return Concatenation( [ [ "GroupForTom", [ name ] ] ],
                 DatabaseAttributeValueDefault( attr, id ) );
    else
      return DatabaseAttributeValueDefault( attr, id );
    fi;
    end,
  eval:= function( attr, l )
    return List( l, val -> [ "GroupForTom", val ] );
    end,
  reverseEval:= function( attr, info )
    local pos, data, entry;

    if info[1] = "GroupForTom" then
      if Length( info[2] ) = 1 then
        pos:= Position( LIBLIST.TOM_TBL_INFO[1],
                        LowercaseString( info[2][1] ) );
        if pos <> fail then
          return LIBLIST.TOM_TBL_INFO[2][ pos ];
        fi;
      else
        if not IsBound( attr.data )  then
          Read( attr.datafile );
        fi;
        for data in [ attr.data.automatic, attr.data.nonautomatic ] do
          for entry in data do
            if info[2] in entry[2] then
              return entry[1];
            fi;
          od;
        od;
      fi;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.prepare( attr );
    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_tom:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_tom );
    CTblLib.Data.cleanup( attr );
    end,
  create:= function( attr, id )
    local main, mainid, subgroupfits, dupl, names, result, name, tbl, r,
          super, tom, mx, pos, i, orders;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_tom.( id ) ) then
      return CTblLib.Data.attrvalues_tom.( id );
    fi;

    # Now we know that we have to work.
    subgroupfits:= function( tom, poss, tbl )
      return First( poss,
           function( i )
             local G;
             G:= RepresentativeTom( tom, i );
             return NrConjugacyClasses( G ) = NrConjugacyClasses( tbl ) and
#T provide a utility that compares more invariants?
                    IsRecord( TransformingPermutationsCharacterTables(
                                  CharacterTable( G ), tbl ) );
           end );
    end;

    dupl:= CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables;
    names:= Concatenation( [ id ], dupl.attributeValue( dupl, id ) );
    result:= [];

    for name in names do
      tbl:= CharacterTable( name );

      # Check for stored fusions into tables that know a table of marks.
      # (We need not store the table of marks of `tbl' itself,
      # because the `extract' function will deal with it.)
      for r in ComputedClassFusions( tbl ) do
        if Length( ClassPositionsOfKernel( r.map ) ) = 1 then
          super:= CharacterTable( r.name );
          if super <> fail and HasFusionToTom( super ) then
            # Identify the subgroup.
            tom:= TableOfMarks( super );
            if HasMaxes( super ) and id in Maxes( super ) then
              mx:= MaximalSubgroupsTom( tom );
              if Sum( SizesConjugacyClasses( super ){ Set( r.map ) } )
                   = Size( tbl ) then
                pos:= Filtered( [ 1 .. Length( mx[2] ) ],
                                i -> mx[2][i] = 1 );
              else
                pos:= Filtered( [ 1 .. Length( mx[2] ) ],
                          i -> mx[2][i] = Size( super ) / Size( tbl ) );
              fi;
              if Length( pos ) = 1 then
                # Omit the check.
                Add( result, [ Identifier( tom ), mx[1][ pos[1] ] ] );
              else
                i:= subgroupfits( tom, mx[1]{ pos }, tbl );
                if i <> fail then
                  Add( result, [ Identifier( tom ), i ] );
                fi;
              fi;
            else
              # Loop over all classes of subgroups of the right order.
              orders:= OrdersTom( tom );
              pos:= Filtered( [ 1 .. Length( orders ) ],
                        i -> orders[i] = Size( tbl ) );
              i:= subgroupfits( tom, pos, tbl );
              if i <> fail then
                Add( result, [ Identifier( tom ), i ] );
              fi;
            fi;
          fi;
        fi;
      od;
    od;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_tom.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );

fi;


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.trans
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "trans" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "trans",
  description:= "mapping between CTblLib and GAP's library of trans. groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_trans.dat" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
    return List( l, val -> [ "TransitiveGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "TransitiveGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_trans:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_trans );
    end,
  create:= function( attr, id )
    local main, mainid, tbl, result, cand, G;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_trans.( id ) ) then
      return CTblLib.Data.attrvalues_trans.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    result:= [];

# If the table belongs to a transitive permutation group of degree $n$
# then there must be a nontrivial rationally irreducible character
# of degree at most $n-1$.
# Moreover, the intersection of kernels of the rationally irreducible
# characters of degree up to $n-1$ must be trivial.
# -> does this help?

# Try a class fusion of tbl into Sym( TRANSDEGREES ),
# using only orders and centralizer orders:
# TRANSDEGREES; # 30
# NrPartitions( 30 ); # 5604
# gen:= CharacterTable( "Symmetric" );
# cl:= gen.classparam[1]( TRANSDEGREES );;
# cent:= List( cl, x -> gen.centralizers[1]( TRANSDEGREES, x ) );;
# ord:= List( cl, x -> gen.orders[1]( TRANSDEGREES, x ) );;
# -> now InitFusion!
# -> does this help?

    # Just check the obvious invariants;
    # do not try `PermChars' for excluding some tables,
    # because computing the irreducibles is faster in most cases.
    cand:= AllTransitiveGroups(
      NrMovedPoints, [ 2 .. TRANSDEGREES ],
      Size, Size( tbl ),
      AbelianInvariants, AbelianInvariants( tbl ),
      G -> Size( Centre( G ) ), Length( ClassPositionsOfCentre( tbl ) ),
      NrConjugacyClasses, NrConjugacyClasses( tbl ) );
    for G in cand do
      if IsRecord( TransformingPermutationsCharacterTables(
                   CharacterTable( G ), tbl ) ) then
        Add( result, [ NrMovedPoints( G ), TransitiveIdentification( G ) ] );
      fi;
    od;
    if IsEmpty( result ) then
      result:= attr.dataDefault;
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_trans.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.factorsOfDirectProduct
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable,
     "factorsOfDirectProduct" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "factorsOfDirectProduct",
  description:= "direct factors of a direct product",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_dirprod.dat" ),
  isSorted:= true,
  eval:= function( attr, l )
    return List( l, val -> [ "DirectProductByNames", val ] );
    end,
  neededAttributes:= [],
  create:= function( attr, id )
    local tbl, dp, constr;

    tbl:= CharacterTable( id );
    dp:= ClassPositionsOfDirectProductDecompositions( tbl );
    if IsEmpty( dp ) then
      # The table is not a nontrivial direct product.
      return attr.dataDefault;
    elif HasConstructionInfoCharacterTable( tbl ) then
      constr:= ConstructionInfoCharacterTable( tbl );
      if constr[1] = "ConstructDirectProduct" then
        # The factorization is stored.
        return [ constr[2] ];
      elif constr[1] = "ConstructPermuted" and Length( constr[2] ) = 1 then
        # Delegate to a better table.
        return attr.create( attr, constr[2][1] );
      fi;
    fi;

    # The table is a nontrivial direct product, we do not know factors.
    return [ fail ];
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsNontrivialDirectProduct
##
AddSet( CTblLib.SupportedAttributes, "IsNontrivialDirectProduct" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsNontrivialDirectProduct",
  description:= "is this character table a direct product of smaller ones",
  type:= "values",
  name:= "IsNontrivialDirectProduct",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "nontrivial direct product";
    else
      return "not a nontrivial direct product";
    fi;
    end,
  neededAttributes:= [ "factorsOfDirectProduct" ],
  create:= function( attr, id )
    local otherattr;

    otherattr:= CTblLib.Data.IdEnumerator.attributes.factorsOfDirectProduct;
    return not IsEmpty( otherattr.attributeValue( otherattr, id ) );
    end,
  version:= CTblLib.Data.IdEnumerator.version,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "dir. prod.?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.KnowsSomeGroupInfo
##
AddSet( CTblLib.SupportedAttributes, "KnowsSomeGroupInfo" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "KnowsSomeGroupInfo",
  description:= "accumulated info about group info attributes",
  type:= "values",
  name:= "KnowsSomeGroupInfo",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "group info available";
    else
      return "no group info available";
    fi;
    end,
  neededAttributes:=
      CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable,
  create:= function( attr, id )
    local nam, otherattr;

    for nam in CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable do
      otherattr:= CTblLib.Data.IdEnumerator.attributes.( nam );
      if not IsEmpty( otherattr.attributeValue( otherattr, id ) ) then
        return true;
      fi;
    od;

    return false;
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "group?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsAbelian
##
AddSet( CTblLib.SupportedAttributes, "IsAbelian" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsAbelian",
  description:= "are GAP library character tables abelian",
  type:= "values",
  name:= "IsAbelian",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "abelian";
    else
      return "nonabelian";
    fi;
    end,
  neededAttributes:= [ "Size", "NrConjugacyClasses" ],
  create:= function( attr, id )
    local size, nccl;

    size:= CTblLib.Data.IdEnumerator.attributes.Size;
    nccl:= CTblLib.Data.IdEnumerator.attributes.NrConjugacyClasses;
    return size.attributeValue( size, id ) = nccl.attributeValue( nccl, id );
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "abelian?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.AbelianInvariants
##
AddSet( CTblLib.SupportedAttributes, "AbelianInvariants" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "AbelianInvariants",
  description:= "abelian invariants of GAP library character tables",
  type:= "pairs",
  name:= "AbelianInvariants",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_abinv.dat" ),
  dataDefault:= fail,
  neededAttributes:= [],
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "ab. inv.",
  widthCol:= 15,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsPerfect
##
AddSet( CTblLib.SupportedAttributes, "IsPerfect" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsPerfect",
  description:= "are GAP library character tables perfect",
  type:= "values",
  name:= "IsPerfect",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "perfect";
    else
      return "not perfect";
    fi;
    end,
  neededAttributes:= [ "AbelianInvariants" ],
  create:= function( attr, id )
    local abinv;

    abinv:= CTblLib.Data.IdEnumerator.attributes.AbelianInvariants;
    return IsEmpty( abinv.attributeValue( abinv, id ) );
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "perfect?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.almostSimpleInfo
##
DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "almostSimpleInfo",
  description:= "socle type and socle factor type of an almost simple group",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_asinfo.dat" ),
  isSorted:= true,
  dataDefault:= fail,
  neededAttributes:= [ "Size" ],
  create:= function( attr, id )
    local tbl, nsg, soclesize, cand, socle, cand2, soclefactor;

    tbl:= CharacterTable( id );
    if IsSimple( tbl ) and not IsPrimeInt( Size( tbl ) ) then
      # Replace the name by the "main" name.
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        id:= ConstructionInfoCharacterTable( tbl )[2][1];
      fi;
      return [ id, [ 1, 1 ] ];
    elif not IsAlmostSimple( tbl ) then
      # The table is not almost simple.
      return attr.dataDefault;
    fi;
    nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
    soclesize:= Sum( SizesConjugacyClasses( tbl ){ nsg }, 0 );
    cand:= AllCharacterTableNames( Size, soclesize );
    # Do not call `IsSimple' as a filter here,
    # because the `IsSimple' attribute is derived from the current one.
    cand:= Filtered( List( cand, CharacterTable ), IsSimple );
    if IsEmpty( cand ) then
      # We do not have the character table of the socle.
      Info( InfoDatabaseAttribute, 1, "socle not available for ", id );
      socle:= fail;
    else
      # Find the "main" table of the socle.
      cand:= Filtered( cand, t -> not (
               HasConstructionInfoCharacterTable( t ) and
               IsList( ConstructionInfoCharacterTable( t ) ) and
               ConstructionInfoCharacterTable( t )[1] = "ConstructPermuted" and
               Length( ConstructionInfoCharacterTable( t )[2] ) = 1 ) );
      if Length( cand ) <> 1 then
        # Take only those that admit a fusion into `tbl'.
        cand2:= Filtered( cand, t -> ForAny( ComputedClassFusions( t ),
                                             r -> r.name = id ) );
        if IsEmpty( cand2 ) then
          cand:= Filtered( cand, t -> PossibleClassFusions( t, tbl ) <> [] );
        else
          cand:= cand2;
        fi;
      fi;
      if Length( cand ) <> 1 then
        Info( InfoDatabaseAttribute, 1, "socle not identified for ", id );
        return fail;
      fi;
      socle:= Identifier( cand[1] );
    fi;
    soclefactor:= tbl / nsg;
    soclefactor:= First( AllSmallGroups( Size, Size( soclefactor ) ),
                         g -> TransformingPermutationsCharacterTables(
                                CharacterTable( g ), soclefactor ) <> fail );
    return [ socle, IdGroup( soclefactor ) ];
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsAlmostSimple
##
AddSet( CTblLib.SupportedAttributes, "IsAlmostSimple" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsAlmostSimple",
  description:= "are GAP library character tables almost simple",
  type:= "values",
  name:= "IsAlmostSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "almost simple";
    else
      return "not almost simple";
    fi;
    end,
  neededAttributes:= [ "almostSimpleInfo" ],
  create:= function( attr, id )
    local asinfo;

    asinfo:= CTblLib.Data.IdEnumerator.attributes.almostSimpleInfo;
    return asinfo.attributeValue( asinfo, id ) <> fail;
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "almost simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsSimple
##
AddSet( CTblLib.SupportedAttributes, "IsSimple" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsSimple",
  description:= "are GAP library character tables simple",
  type:= "values",
  name:= "IsSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "simple";
    else
      return "not simple";
    fi;
    end,
  neededAttributes:= [ "almostSimpleInfo", "Size" ],
  create:= function( attr, id )
    local size, asinfo;

    size:= CTblLib.Data.IdEnumerator.attributes.Size;
    if IsPrimeInt( size.attributeValue( size, id ) ) then
      return true;
    fi;
    asinfo:= CTblLib.Data.IdEnumerator.attributes.almostSimpleInfo;
    asinfo:= asinfo.attributeValue( asinfo, id );
    return asinfo <> fail and asinfo[2] = [ 1, 1 ];
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsSporadicSimple
##
AddSet( CTblLib.SupportedAttributes, "IsSporadicSimple" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsSporadicSimple",
  description:= "are GAP library character tables sporadic simple",
  type:= "values",
  name:= "IsSporadicSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "sporadic simple";
    else
      return "not sporadic simple";
    fi;
    end,
  neededAttributes:= [ "IsSimple", "Size" ],
  create:= function( attr, id )
    local issimple, size, info;

    issimple:= CTblLib.Data.IdEnumerator.attributes.IsSimple;
    if not issimple.attributeValue( issimple, id ) then
      return false;
    fi;
    size:= CTblLib.Data.IdEnumerator.attributes.Size;
    size:= size.attributeValue( size, id );
    info:= IsomorphismTypeInfoFiniteSimpleGroup( size );
    return     info <> fail
           and IsBound( info.series )
           and info.series = "Spor";
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.KnowsDeligneLusztigNames
##
AddSet( CTblLib.SupportedAttributes, "KnowsDeligneLusztigNames" );

DatabaseAttributeAdd( CTblLib.Data.IdEnumerator, rec(
  identifier:= "KnowsDeligneLusztigNames",
  description:= "availability of Deligne-Lusztig names",
  type:= "values",
  name:= "KnowsDeligneLusztigNames",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "Deligne-Lusztig names available";
    else
      return "no Deligne-Lusztig names available";
    fi;
    end,
  neededAttributes:= [],
  create:= function( attr, id )
    return DeltigLibGetRecord( id ) <> fail;
    end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "Deligne-Lusztig names?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#E

