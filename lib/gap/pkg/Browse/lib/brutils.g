#############################################################################
##
#W  brutils.g             GAP 4 package `Browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains some utilities for Browse applications.
##


#############################################################################
##
#F  BrowseData.SortAsIntegers( <a>, <b> )
##
##  Assume that the two strings <a>, <b> represent integers.
##  This function compares these integers and not the strings themselves.
##
##  `BrowseData.SortAsIntegers' is NOT recommended as the value of the
##  `dynamic.sortFunctionsForColumns' entry for a column
##  when it may happen that the column values are turned into category rows
##  involving non-digit characters (typically a textual prefix).
##  In these cases, the generalization given by
##  `BrowseData.CompareAsNumbersAndNonnumbers' can be used instead.
##
BrowseData.SortAsIntegers:= function( a, b )
    local inta, intb;

    inta:= Int( a );
    intb:= Int( b );
    if IsInt( inta ) and IsInt( intb ) then
      return inta < intb;
    fi;
    return a < b;
end;


#############################################################################
##  
#F  BrowseData.ReplacedCharacterValueString( <val> )
#F  BrowseData.CompareCharacterValues( <a>, <b> )
##  
##  `BrowseData.CompareCharacterValues' is used to sort strings <a>, <b>
##  representing the display values of character table entries.
##  Strings involving the substring `" = "' (used in categories)
##  are replaced by the expression to the right of this substring,
##  strings representing integers are sorted by their values,
##  `"."' is regarded as zero,
##  other strings (denoting irrationalities) are larger than integers
##  and sorted lexicographically.
##  
BrowseData.ReplacedCharacterValueString:= function( val )
    local pos;

    pos:= PositionSublist( val, " = " );
    if   pos <> fail then
      val:= val{ [ pos+3 .. Length( val ) ] };
    fi;
    if val = "." then
      return 0;
    else
      return Int( val );
    fi;
end;

BrowseData.CompareCharacterValues:= function( a, b )
    local v1, v2; 

    v1:= BrowseData.ReplacedCharacterValueString( a );
    v2:= BrowseData.ReplacedCharacterValueString( b );
    if v1 <> fail then
      return v2 = fail or v1 < v2;
    elif v2 <> fail then
      return false;
    else
      return a < b;
    fi;
end;


#############################################################################
##
#F  BrowseData.SplitStringIntoNumbersAndNonnumbers( <str> )
##
##  This function was used (by comparing its results for two strings) in an
##  early version of `BrowseData.CompareAsNumbersAndNonnumbers'.
##  Since this approach is very inefficient, it is not recommended.
##  The function itself, however, may be interesting if one is interested in
##  the structure of the string <str>.
##  (One can view this function as an example of bad programming,
##  so we leave it in the code already for this purpose.)
##
##  Note, however, that in order to *sort a list of strings* w.r.t. the
##  function `BrowseData.CompareAsNumbersAndNonnumbers',
##  it may be more efficient to replace the given strings by the values
##  under `BrowseData.SplitStringIntoNumbersAndNonnumbers', and to sort this
##  list w.r.t. GAP's \< (using the kernel function) than to sort the given
##  strings with second argument `BrowseData.CompareAsNumbersAndNonnumbers'.
##
BrowseData.SplitStringIntoNumbersAndNonnumbers:= function( str )
  local len, result, i, ii;

  len:= Length( str );
  result:= [];
  i:= 1;
  while i <= len do
    ii:= i;
    while ii <= len and not str[ ii ] in DIGITS do
      ii:= ii + 1;
    od;
    Add( result, str{ [ i .. ii-1 ] } );
    i:= ii;
    while ii <= len and str[ ii ] in DIGITS do
      ii:= ii + 1;
    od;
    Add( result, Int( str{ [ i .. ii-1 ] } ) );
    i:= ii;
  od;
  return result;
end;


#############################################################################
##
#F  BrowseData.CompareAsNumbersAndNonnumbers( <nam1>, <nam2> )
##
##  This is used for sorting a list of strings such that parts consisting of
##  digits are compared w.r.t. their values as integers.
##
##  Two typical applications are
##  - sorting category rows which represent integer values
##    but which have a prefix that is not an integer and
##  - sorting a list of group names such that for example
##    `"A9"' precedes `"A10"'.
##
BrowseData.CompareAsNumbersAndNonnumbers:= function( nam1, nam2 )
    local len1, len2, len, digit, comparenumber, i;

    # Essentially the code does the following, just more efficiently.
    # return BrowseData.SplitStringIntoNumbersAndNonnumbers( nam1 ) <
    #        BrowseData.SplitStringIntoNumbersAndNonnumbers( nam2 );

    len1:= Length( nam1 );
    len2:= Length( nam2 );
    len:= len1;
    if len2 < len then
      len:= len2;
    fi;
    digit:= false;
    comparenumber:= 0;
    for i in [ 1 .. len ] do
      if nam1[i] in DIGITS then
        if nam2[i] in DIGITS then
          digit:= true;
          if comparenumber = 0 then
            # first digit of a number, or previous digits were equal
            if nam1[i] < nam2[i] then
              comparenumber:= 1;
            elif nam1[i] <> nam2[i] then
              comparenumber:= -1;
            fi;
          fi;
        else
          # if digit then the current number in `nam2' is shorter,
          # so `nam2' is smaller;
          # if not digit then a number starts in `nam1' but not in `nam2',
          # so `nam1' is smaller
          return not digit;
        fi;
      elif nam2[i] in DIGITS then
        # if digit then the current number in `nam1' is shorter,
        # so `nam1' is smaller;
        # if not digit then a number starts in `nam2' but not in `nam1',
        # so `nam2' is smaller
        return digit;
      else
        # both characters are non-digits
        if digit then
          # first evaluate the current numbers (which have the same length)
          if comparenumber = 1 then
            # nam1 is smaller
            return true;
          elif comparenumber = -1 then
            # nam2 is smaller
            return false;
          fi;
          digit:= false;
        fi;
        # now compare the non-digits
        if nam1[i] <> nam2[i] then
          return nam1[i] < nam2[i];
        fi;
      fi;
    od;

    if digit then
      # The suffix of the shorter string is a number.
      # If the longer string continues with a digit then it is larger,
      # otherwise the first digits of the number decide.
      if len < len1 and nam1[ len+1 ] in DIGITS then
        # nam2 is smaller
        return false;
      elif len < len2 and nam2[ len+1 ] in DIGITS then
        # nam1 is smaller
        return true;
      elif comparenumber = 1 then
        # nam1 is smaller
        return true;
      elif comparenumber = -1 then
        # nam2 is smaller
        return false;
      fi;
    fi;

    # Now the longer string is larger.
    return len1 < len2;
end;


#############################################################################
##  
#F  BrowseData.CompareLenLex( <val1>, <val2> )
#F  BrowseData.CompareLenLexRev( <val1>, <val2> )
##
##  These functions can be useful for sorting nonnegative integer valued
##  columns by the integer values, w.r.t. ascending and descending ordering,
##  respectively.
##  Note that a constant prefix (which may occur in category rows)
##  need not be removed.
##
BrowseData.CompareLenLex := function( val1, val2 )
  if   Length( val1 ) < Length( val2 ) then
    return true;
  elif Length( val2 ) < Length( val1 ) then
    return false;
  fi;
  return val1 < val2;
end;

BrowseData.CompareLenLexRev := function( val1, val2 )
  if   Length( val2 ) < Length( val1 ) then
    return true;
  elif Length( val1 ) < Length( val2 ) then
    return false;
  fi;
  return val2 < val1;
end;


#############################################################################
##  
#F  BrowseData.HeaderWithRowCounter( <t>, <header>, <nrallrows> )
##
##  This function shows the string <header> underlined,
##  followed by the number of unhidden rows in the table <t> in brackets;
##  note that the number of shown rows can be larger if some rows appear
##  under several category rows.
##  <nrallrows> is the number of rows in the (uncategorized) table;
##  if the number of unhidden rows is smaller than this number then also
##  <nrallrows> is shown in the header.
##
BrowseData.HeaderWithRowCounter:= function( t, header, nrallrows )
    local shown, indir, i;

    shown:= []; 
    indir:= t.dynamic.indexRow;
    for i in [ 2, 4 .. Length( t.dynamic.isRejectedRow )-1 ] do
      if not t.dynamic.isRejectedRow[i] then
        Add( shown, indir[i] );
      fi;
    od;
    # Calling `AddSet' in the loop is much slower.
    shown:= Set( shown );
    if nrallrows = Length( shown ) then
      return [ "", [ NCurses.attrs.UNDERLINE, true, header,
                     NCurses.attrs.NORMAL,
                     " (", String( nrallrows ), " entries)" ],
               "" ]; 
    else
      return [ "", [ NCurses.attrs.UNDERLINE, true, header,
                     NCurses.attrs.NORMAL,
                     " (", String( Length( shown ) ), " out of ",
                     String( nrallrows ), " entries)" ],
               "" ];
    fi;
end;
  
  
#############################################################################
##
#F  BrowseData.ReallyFormatParagraph( <str>[, <len>][, <flush>][...] )
##
##  In addition to `FormatParagraph',
##  break also too long words that do not contain whitespace.
##
BrowseData.ReallyFormatParagraph:= function( arg )
    local max, flush, result, line, linelen, rest, offset;

    if Length( arg ) = 1 or not IsInt( arg[2] ) then
      max:= 78;
    else
      max:= arg[2];
    fi;
    if Length( arg ) >= 2 and IsString( arg[2] ) then
      flush:= arg[2];
    elif Length( arg ) >= 3 and IsString( arg[3] ) then
      flush:= arg[3];
    else
      flush:= "both";
    fi;

    result:= [];
    for line in SplitString( CallFuncList( FormatParagraph, arg ), "\n" ) do
      linelen:= Length( line );
      if linelen <= max then
        Add( result, line );
      elif flush <> "left" then
        rest:= linelen mod max;
        offset:= 0;
        if rest <> 0 then
          Add( result, String( line{ [ 1 .. rest ] }, max ) );
          offset:= rest;
        fi;
        repeat
          Add( result, line{ [ 1 .. max ] + offset } );
          offset:= offset + max;
        until offset >= linelen;
      else
        offset:= 0;
        repeat
          Add( result, line{ [ 1 .. max ] + offset } );
          offset:= offset + max;
        until offset + max >= linelen;
        if offset < linelen then
          Add( result, line{ [ 1 + offset .. linelen ] } );
        fi;
      fi;
    od;
    return JoinStringsWithSeparator( result, "\n" );
end;


#############################################################################
##
#F  BrowseData.ReplacedEntry( <value>, <from>, <to> )
##
BrowseData.ReplacedEntry:= function( value, from, to )
    local pos;

    pos:= Position( from, value );
    if pos <> fail then
      value:= to[ pos ];
    fi;

    return value;
end;


#############################################################################
##
#F  BrowseData.SimplifiedString( <string> )
##
##  Replace non-ASCII unicode characters by approximations
##  involving only ASCII characters.
##  (This may become unnecessary in the future.)
##
##  This function is used in `BrowseBibliography', `BrowseGapManuals',
##  and `BrowseGapPackages',
##  since non-ASCII characters may look strange in visual mode,
##  and they may mess up line length computations in browse tables,
##
BrowseData.SimplifiedString:= function( string )
    local uni;

    uni:= Unicode( string );
    if uni = fail then
      uni:= Unicode( string, "latin1" );
    fi;
    return Encode( SimplifiedUnicodeString( uni, "ASCII" ),
                   GAPInfo.TermEncoding );
end;


#############################################################################
##
#F  BrowseData.SimplifiedSubgroupName( <name> )
##
##  Apply some heuristics to the string <name>, and return a simplified name.
##
BrowseData.SimplifiedSubgroupName:= function( name )
    local pos, pos2, namereplacements, pair;

    # Replace `{<n>}' by <n> if <n> is an integer, and by `(<n>)' otherwise.
    pos:= Position( name, '{' );
    while pos <> fail do
      pos2:= Position( name, '}', pos );
      if Int( name{ [ pos+1 .. pos2-1 ] } ) <> fail then
        name:= Concatenation( name{ [ 1 .. pos-1 ] },
                              name{ [ pos+1 .. pos2-1 ] },
                              name{ [ pos2+1 .. Length( name ) ] } );
      else
        name:= Concatenation( name{ [ 1 .. pos-1 ] }, "(",
                              name{ [ pos+1 .. pos2-1 ] }, ")",
                              name{ [ pos2+1 .. Length( name ) ] } );
      fi;
      pos:= Position( name, '{' );
    od;

    # Strip LaTeX markup from subgroup names.
    namereplacements:= [
      [ "\\leq", "<" ],
      [ "\\times", "x" ],
      [ "\\rightarrow", "->" ],
      [ "^(\\prime)", "'" ],
      [ "^\\prime", "'" ],
      [ "$", "" ],
      [ "2_1", "2&uscore;1" ],
      [ "3_1", "3&uscore;1" ],
      [ "2_2", "2&uscore;2" ],
      [ "3_2", "3&uscore;2" ],
      [ "2_3", "2&uscore;3" ],
      [ "_+", "&uscore;+" ],
      [ "_-", "&uscore;-" ],
      [ "2^2", "2&caret;2" ],
      [ "_", "" ],
      [ "^+", "+" ],
      [ "^-", "-" ],
      [ "^2E6", "2E6" ],
      [ "(^2F4(2)')", "2F4(2)'" ],
      [ "^2F4(2)'", "2F4(2)'" ],
      [ "(^3D4(2))", "3D4(2)" ],
      [ "F(3+)", "F3+" ],
      [ "&uscore;", "_" ],
      [ "&caret;", "^" ],
    ];
    for pair in namereplacements do
      name:= ReplacedString( name, pair[1], pair[2] );
    od;

    return NormalizedWhitespace( name );
end;


#############################################################################
##
#F  BrowseData.StrippedPath( <filename> )
##
BrowseData.StrippedPath:= function( filename )
    local pos;

    pos:= Position( filename, '/' );
    while pos <> fail do
      filename:= filename{ [ pos+1 .. Length( filename ) ] };
      pos:= Position( filename, '/' );
    od;

    return filename;
end;


#############################################################################
##
#F  BrowseData.SortKeyFunctionBibRec( <record> )
##
#T  document what it is intended for!
##
BrowseData.SortKeyFunctionBibRec:= function( r )
    local key;

    key:= [];
    if IsBound( r.authorAsList ) then
  #     Add( key,  List( r.authorAsList, a -> LowercaseString( a[1] ) ) );
      Add( key,  List( r.authorAsList, a -> ( a[1] ) ) );
    elif IsBound( r.editorAsList ) then
  #     Add( key,  List( r.editorAsList, a -> LowercaseString( a[1] ) ) );
      Add( key,  List( r.editorAsList, a -> ( a[1] ) ) );
    else
      Add( key, [ "zzz" ] );
    fi;
key[1]:= List( key[1], x -> LowercaseString( BrowseData.SimplifiedString( x ) ) );
#T why??
    if IsBound( r.year ) then
      Add( key, r.year );
    else
      Add( key, "" );
    fi;
    if IsAlphaChar( r.Label[ Length( r.Label ) ] ) then
      Add( key, r.Label{ [ Length( r.Label ) ] } );
    else
      Add( key, "" );
    fi;
    if IsBound( r.title ) then
      Add( key, LowercaseString( NormalizedWhitespace( r.title ) ) );
    else
      Add( key, "" );
    fi;
    return key;
end;


#############################################################################
##
#F  BrowseGapDataAdd( <title>, <call>, <ret>, <documentation> )
##
##  <#GAPDoc Label="BrowseGapDataAdd_man">
##  <ManSection>
##  <Func Name="BrowseGapDataAdd" Arg="title, call, ret, documentation"/>
##
##  <Description>
##  This function extends the list <C>BrowseData.GapDataOverviews</C>
##  by a new entry.
##  The list is used by <Ref Func="BrowseGapData"/>.
##  <P/>
##  <A>title</A> must be a string of length at most <M>76</M>; it will be
##  shown in the browse table that is opened by <Ref Func="BrowseGapData"/>.
##  <A>call</A> must be a function that takes no arguments; it will be called
##  when <A>title</A> is <Q>clicked</Q>.
##  <A>ret</A> must be <K>true</K> if <A>call</A> has a return value
##  and if <Ref Func="BrowseGapData"/> shall return this value,
##  and <K>false</K> otherwise.
##  <A>documentation</A> must be a string that describes what happens when
##  the function <A>call</A> is called; it will be shown in the footer of
##  the table opened by <Ref Func="BrowseGapData"/>
##  when <A>title</A> is selected.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "BrowseGapDataAdd", function( title, call, ret, documentation )
    local currpkg, pos;

    if not IsBound( BrowseData.GapDataOverviews ) then
      BrowseData.GapDataOverviews:= [];
    fi;
    if   not ( IsString( title ) and Length( title ) <= 76 ) then
      Error( "<title> must be a string of length at most 76" );
    elif not IsFunction( call ) then
      Error( "<call> must be a function" );
    elif not ret in [ true, false ] then
      Error( "<ret> must be `true' or `false'" );
    elif not IsString( documentation ) then
      Error( "<documentation> must be a string" );
    fi;

    if IsBound( GAPInfo.PackageCurrent ) then
      currpkg:= GAPInfo.PackageCurrent.PackageName;
      if LowercaseString( currpkg ) <> "browse" then
        title:= Concatenation( title, " (", currpkg, ")" );
      fi;
    fi;

    pos:= PositionProperty( BrowseData.GapDataOverviews, x -> x[1] = title );
    if pos = fail then
      AddSet( BrowseData.GapDataOverviews,
              [ title, call, ret, documentation ] );
    elif REREADING then
      BrowseData.GapDataOverviews[ pos ]:=
            [ title, call, ret, documentation ];
    else
      Error( "an entry with title <title> is already stored" );
    fi;
end );


#############################################################################
##
#E

