#############################################################################
##
#W  brdbattr.gi           GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the implementations for tools for database handling.
##


#############################################################################
##
#F  DatabaseIdEnumerator( <arec> )
##
InstallGlobalFunction( DatabaseIdEnumerator, function( arec )
    local comps, entry;

    arec:= ShallowCopy( arec );

    # Check for the presence of the mandatory components.
    comps:= [ [ "identifiers", "list", IsList ],
              [ "entry", "function", IsFunction ],
            ];
    for entry in comps do
      if not IsBound( arec.( entry[1] ) )
         or not entry[3]( arec.( entry[1] ) ) then
        Error( "<arec>.", entry[1], " must be bound to a ", entry[2] );
      fi;
    od;

    # Set default values for the optional components.
    comps:= [ [ "attributes", "record", IsRecord, rec() ],
              [ "isUpToDate", "function", IsFunction, ReturnTrue ],
              [ "version", "object", IsObject, "" ],
              [ "update", "function", IsFunction, ReturnTrue ],
              [ "viewLabel", "table cell data object",
                BrowseData.IsBrowseTableCellData, "name" ],
              [ "viewValue", "function", IsFunction, String ],
              [ "viewSort", "function", IsFunction, \< ],
              [ "sortParameters", "list", IsList, [] ],
              [ "widthCol", "positive integer", IsPosInt ],
              [ "align", "string", IsString, "r" ],
              [ "categoryValue", "function", IsFunction ],
              [ "isSorted", "boolean", IsBool, false ],
            ];
    for entry in comps do
      if IsBound( arec.( entry[1] ) ) then
        if not entry[3]( arec.( entry[1] ) ) then
          Error( "<arec>.", entry[1], ", if bound, must be a ", entry[2] );
        fi;
      elif IsBound( entry[4] ) then
        arec.( entry[1] ):= entry[4];
      fi;
    od;
    if not IsBound( arec.categoryValue ) then
      arec.categoryValue:= arec.viewValue;
    fi;

    # Set the "self" attribute.
    DatabaseAttributeAdd( arec, rec(
        identifier:= "self",
        description:= "the identifiers themselves",
        type:= "values",
        data:= arec.identifiers,
        version:= arec.version,
        update:= function( a )
            a.data:= a.idenumerator.identifiers;
            return true;
          end,
        viewLabel:= arec.viewLabel,
        viewValue:= arec.viewValue,
        viewSort:= arec.viewSort,
        sortParameters:= arec.sortParameters,
        align:= arec.align,
        categoryValue:= arec.categoryValue,
      ) );
    if IsBound( arec.widthCol ) then
      arec.attributes.self.widthCol:= arec.widthCol;
    fi;

    return arec;
end );


#############################################################################
##
#F  DatabaseAttributeAdd( <dbidenum>, <arec> )
##
InstallGlobalFunction( DatabaseAttributeAdd, function( dbidenum, arec )
    local comps, entry;

    # Check `dbidenum'.
    if not IsRecord( dbidenum ) or not IsBound( dbidenum.attributes )
                                or not IsRecord( dbidenum.attributes ) then
      Error( "<dbidenum> must be a database id enumerator" );
    elif IsBound( arec.identifier ) and
         IsBound( dbidenum.attributes.( arec.identifier ) ) then
      Error( "an attribute with identifier `", arec.identifier,
             "' is already bound in <dbidenum>" );
    fi;
    arec:= ShallowCopy( arec );
    arec.idenumerator:= dbidenum;

    # Check for the presence of the mandatory components.
    comps:= [ [ "identifier", "string", IsString ],
              [ "type", "string", IsString ],
            ];
    for entry in comps do
      if not IsBound( arec.( entry[1] ) )
         or not entry[3]( arec.( entry[1] ) ) then
        Error( "<arec>.", entry[1], " must be bound to a ", entry[2] );
      fi;
    od;

    # Do more tests.
    if not arec.type in [ "values", "pairs" ] then
      Error( "<arec>.type must be one of `\"values\"', `\"pairs\"'" );
    fi;

    # Set default values for the optional components.
    comps:= [ 
              [ "description", "string", IsString, "" ],
              [ "name", "string", IsString ],
              [ "datafile", "string", IsString ],
              [ "attributeValue", "function", IsFunction,
                DatabaseAttributeValueDefault ],
              [ "dataDefault", "object", IsObject, "" ],
              [ "eval", "function", IsFunction ],
              [ "neededAttributes", "list", IsList, [] ],
              [ "prepareAttributeComputation", "function", IsFunction,
                ReturnTrue ],
              [ "cleanupAfterAttibuteComputation", "function", IsFunction,
                ReturnTrue ],
              [ "create", "function", IsFunction ],
              [ "string", "function", IsFunction,
     #          function( id, val ) return String( val ); end ],
                String ],
              [ "check", "function", IsFunction, ReturnTrue ],
              [ "viewLabel", "table cell data object",
                BrowseData.IsBrowseTableCellData ],
              [ "viewValue", "function", IsFunction, String ],
              [ "viewSort", "function", IsFunction, \< ],
              [ "sortParameters", "list", IsList, [] ],
              [ "widthCol", "positive integer", IsPosInt ],
              [ "align", "string", IsString, "r" ],
              [ "categoryValue", "function", IsFunction ],
            ];
    for entry in comps do
      if IsBound( arec.( entry[1] ) ) then
        if not entry[3]( arec.( entry[1] ) ) then
          Error( "<arec>.", entry[1], ", if bound, must be a ", entry[2] );
        fi;
      elif IsBound( entry[4] ) then
        arec.( entry[1] ):= entry[4];
      fi;
    od;

    # Do more tests.
    if IsBound( arec.data ) then
      if   arec.type = "values" and not IsList( arec.data ) then
        Error( "<arec>.type is \"values\", so <arec>.data must be a list" );
      elif arec.type = "pairs" and
        not ( IsRecord( arec.data ) and IsBound( arec.data.automatic ) and
                 IsBound( arec.data.nonautomatic ) ) then
        Error( "<arec>.type is \"pairs\", so <arec>.data must be a record ",
               "with the components `automatic' and `nonautomatic'" );
      fi;
    fi;
    if IsBound( arec.name ) then
      if not IsBoundGlobal( arec.name ) or
         not IsFunction( ValueGlobal( arec.name ) ) then
        Error( "<arec>.name must be the identifier of a global function" );
      fi;
    fi;
    if IsBound( arec.isSorted ) then
      if arec.type = "values" then
        Error( "<arec>.isSorted is valid only for <arec>.type = \"pairs\"" );
      elif not arec.isSorted in [ true, false ] then
        Error( "<arec>.isSorted must be `true' or `false'" );
      fi;
    elif arec.type = "pairs" then
      arec.isSorted:= false;
    fi;

    # Set default values for the optional components.
    if not IsBound( arec.create ) and IsBound( arec.name ) then
      arec.create:= function( attr, id )
        return ValueGlobal( arec.name )(
                 attr.idenumerator.entry( attr.idenumerator, id ) );
      end;
    fi;
    if not IsBound( arec.viewLabel ) then
      if IsBound( arec.name ) then
        arec.viewLabel:= arec.name;
      else
        arec.viewLabel:= arec.identifier;
      fi;
    fi;
    if not IsBound( arec.categoryValue ) then
      arec.categoryValue:= arec.viewValue;
    fi;
    if not IsBound( arec.version ) and not IsBound( arec.datafile ) then
      arec.version:= dbidenum.version;
    fi;

    dbidenum.attributes.( arec.identifier ):= arec;
#T update component for attributes!
#T (when can I set a default value?)
#T where do I just have to replace known values?
end );


#############################################################################
##
#F  DatabaseAttributeValueDefault( <attr>, <id> )
##
InstallGlobalFunction( DatabaseAttributeValueDefault, function( attr, id )
    local pos, comp, result;

    # If the `data' component is not bound then initialize it.
    if not IsBound( attr.data ) then
      if IsBound( attr.datafile ) and IsReadableFile( attr.datafile ) then
        Read( attr.datafile );
      else
        DatabaseAttributeCompute( attr.idenumerator, attr.identifier );
      fi;
    fi;
    if not IsBound( attr.data ) then
      Error( "<attr>.data is still not bound" );
    fi;

    if attr.type = "values" then
      if attr.idenumerator.isSorted then
        pos:= PositionSet( attr.idenumerator.identifiers, id );
      else
        pos:= Position( attr.idenumerator.identifiers, id );
      fi;
      if pos <> fail then
        if IsBound( attr.data[ pos ] ) then
          result:= attr.data[ pos ];
        elif IsBound( attr.name ) then
          result:= attr.create( attr, id );
          attr.data[ pos ]:= result;
        else
          result:= attr.dataDefault;
        fi;
      fi;
    elif attr.isSorted then
      for comp in [ attr.data.automatic, attr.data.nonautomatic ] do
        pos:= PositionSorted( comp, [ id ] );
        if pos <= Length( comp ) and comp[ pos ][1] = id then
          result:= comp[ pos ][2];
          break;
        fi;
      od;
    else
      for comp in [ attr.data.automatic, attr.data.nonautomatic ] do
        pos:= First( [ 1 .. Length( comp ) ], i -> comp[i][1] = id );
        if  pos <> fail then
          result:= comp[ pos ][2];
          break;
        fi;
      od;
    fi;

    if not IsBound( result ) then
      if IsBound( attr.dataDefault ) then
        result:= attr.dataDefault;
      else
        Error( "no `dataDefault' entry" );
      fi;
    fi;

    if IsBound( attr.eval ) then
      result:= attr.eval( attr, result );
    fi;
    return result;
end );


#############################################################################
##
#F  DatabaseAttributeSetData( <dbidenum>, <attridentifier>, <version>,
#F                            <data> )
##
InstallGlobalFunction( DatabaseAttributeSetData,
    function( dbidenum, attridentifier, version, data )
    local attr;

    if   not IsRecord( dbidenum ) or not IsBound( dbidenum.attributes )
                                or not IsRecord( dbidenum.attributes ) then
      Error( "usage: DatabaseAttributeSetData( <dbidenum>, ",
             "<attridentifier>,\n <version>, <data> )" );
    elif not IsBound( dbidenum.attributes.( attridentifier ) ) then
      Error( "<dbidenum> has no attribute `", attridentifier, "'" );
    fi;
    attr:= dbidenum.attributes.( attridentifier );
    if not ( ( attr.type = "values" and IsList( data ) ) or
             ( attr.type = "pairs" and IsRecord( data ) ) ) then
      Error( "<data> does not fit to the type of <attr>" );
    fi;
    if attr.type = "pairs" then
      if attr.isSorted = true and
         ( not IsSSortedList( data.automatic ) or
           not IsSSortedList( data.nonautomatic ) ) then
        Error( "the data lists are not strictly sorted" );
      fi;
      if not IsEmpty( Intersection( List( data.automatic, x -> x[1] ),
                          List( data.nonautomatic, x -> x[1] ) ) ) then
#T provide an NC variant that skips the tests?
        Error( "automatic and nonautomatic data are not disjoint" );
      fi;
      attr.data:= data;
    else
      if Length( dbidenum.identifiers ) < Length( data ) then
        Error( "automatic and nonautomatic data are not disjoint" );
      fi;
      attr.data:= data;
    fi;
    attr.version:= version;
#T What shall happen if the version does not fit to dbidenum?
end );


#############################################################################
##
#F  DatabaseIdEnumeratorUpdate( <dbidenum> )
##
InstallGlobalFunction( DatabaseIdEnumeratorUpdate, function( dbidenum )
    local name, attr;

    if dbidenum.update( dbidenum ) <> true then
      Info( InfoDatabaseAttribute, 1,
            "DatabaseIdEnumeratorUpdate: <dbidenum>.update returned ",
            "'false'" );
      return false;
    fi;

#T do this in the order prescribed by neededAttributes!
    for name in RecNames( dbidenum.attributes ) do
      attr:= dbidenum.attributes.( name );
      if not IsBound( attr.version ) then
        if IsBound( attr.datafile ) and IsReadableFile( attr.datafile ) then
          Read( attr.datafile );
        fi;
#T default value if `name' is bound?
        if not IsBound( attr.version ) then
          Error( "<attr>.version still not bound" );
        fi;
      fi;
      if attr.version <> dbidenum.version then
        if IsBound( attr.update ) and attr.update( attr ) = true then
          attr.version:= dbidenum.version;
        else
          Info( InfoDatabaseAttribute, 1,
                "DatabaseIdEnumeratorUpdate: <attr>.update for attribute '",
                name, "' returned 'false'" );
          return false;
        fi;
      fi;
    od;

    return true;
end );


#############################################################################
##
#F  DatabaseAttributeCompute( <dbidenum>, <attridentifier>[, <what>] )
##
InstallGlobalFunction( DatabaseAttributeCompute, function( arg )
    local idenum, attridentifier, what, attr, attrid, attr2, i, new,
          oldnonautomatic, oldautomatic, automatic, newautomatic, id;

    idenum:= arg[1];
    attridentifier:= arg[2];
    what:= "automatic";
    if Length( arg ) = 3 and arg[3] in [ "all", "automatic", "new" ] then
      what:= arg[3];
    fi;

    if not IsRecord( idenum ) or
       not IsBound( idenum.attributes ) or
       not IsRecord( idenum.attributes ) or
       not IsString( attridentifier ) or
       not IsBound( idenum.attributes.( attridentifier ) ) then
      Info( InfoDatabaseAttribute, 1,
            "<idenum> has no component <attridentifier>" );
      return false;
    fi;
    attr:= idenum.attributes.( attridentifier );

    if not IsBound( attr.create ) then
      Info( InfoDatabaseAttribute, 1,
            "<attr> has no component <create>" );
      return false;
    fi;

    # Update the needed attributes if necessary.
    for attrid in attr.neededAttributes do
      attr2:= idenum.attributes.( attrid );
      if not IsBound( attr2.version ) and not IsBound( attr2.data ) and
         IsBound( attr2.datafile ) and IsReadableFile( attr2.datafile ) then
        Read( attr2.datafile );
      fi;
      if not IsBound( attr2.version ) or attr2.version <> idenum.version then
        Info( InfoDatabaseAttribute, 1,
              "DatabaseAttributeCompute for attribute ", attridentifier,
              ":\n#I  compute needed attribute ", attrid );
        DatabaseAttributeCompute( idenum, attrid, what );
      fi;
    od;

    attr.prepareAttributeComputation( attr );

    if attr.type = "values" then
      if what = "automatic" then
        what:= "all";
      fi;
      if not IsBound( attr.data ) then
        # Fetch the known values; if necessary then initialize.
        if IsBound( attr.datafile ) and IsReadableFile( attr.datafile ) then
          Read( attr.datafile );
        else
          attr.data:= [];
        fi;
      fi;

      Info( InfoDatabaseAttribute, 1,
            "DatabaseAttributeCompute: start for attribute ",
            attridentifier );

      for i in [ 1 .. Length( idenum.identifiers ) ] do
        if ( not IsBound( attr.data[i] ) ) or ( what <> "new" ) then
          new:= attr.create( attr, idenum.identifiers[i] );
          if IsBound( attr.data[i] ) then
            if IsBound( attr.dataDefault ) and new = attr.dataDefault then
              Info( InfoDatabaseAttribute, 2,
                    "difference in recompute for ", idenum.identifiers[i],
                     ":\n#E  deleting entry\n", attr.data[i] );
              Unbind( attr.data[i] );
            elif new <> attr.data[i] then
              Info( InfoDatabaseAttribute, 2,
                    "difference in recompute for ", idenum.identifiers[i],
                     ":\n#E  replacing entry\n#E  ", attr.data[i],
                     "\n#E  by\n#E  ", new );
              attr.data[i]:= new;
            fi;
          elif not IsBound( attr.dataDefault ) or new <> attr.dataDefault then
            Info( InfoDatabaseAttribute, 2,
                  "recompute: new entry for ", idenum.identifiers[i],
                  ":\n#I  ", new );
            attr.data[i]:= new;
          fi;
        fi;
      od;

      Info( InfoDatabaseAttribute, 1,
            "DatabaseAttributeCompute: done for attribute ",
            attridentifier );

      attr.version:= idenum.version;
    else
      if not IsBound( attr.data ) then
        # Fetch the known values; if necessary then initialize.
        if IsBound( attr.datafile ) and IsReadableFile( attr.datafile ) then
          Read( attr.datafile );
        else
          attr.data:= rec( automatic:= [], nonautomatic:= [] );
        fi;
      fi;
      oldnonautomatic:= List( attr.data.nonautomatic, x -> x[1] );
      oldautomatic:= List( attr.data.automatic, x -> x[1] );
      automatic:= [];
      newautomatic:= [];

      Info( InfoDatabaseAttribute, 1,
            "DatabaseAttributeCompute: start for attribute ",
            attridentifier );

      for id in idenum.identifiers do
        if not ( ( what in [ "automatic", "new" ] and id in oldnonautomatic ) or
           ( what = "new" and id in oldautomatic ) ) then
          new:= attr.create( attr, id );
          if new <> attr.dataDefault then
            Add( automatic, [ id, new ] );

            # Handle the case that a nonautomatic value becomes automatic.
            if what = "all" and id in oldnonautomatic then
              Info( InfoDatabaseAttribute, 2,
                    "recompute: formerly nonautomatic value for ", id,
                    "#I  is now automatic" );
              Add( newautomatic, id );
            fi;
          fi;
        fi;
      od;
      attr.data.automatic:= automatic;
      if newautomatic <> [] then
        attr.data.nonautomatic:= Filtered( attr.data.nonautomatic,
            pair -> not pair[1] in newautomatic );
      fi;

      Info( InfoDatabaseAttribute, 1,
            "DatabaseAttributeCompute: done for attribute ",
            attridentifier );

      attr.version:= idenum.version;
    fi;

    attr.cleanupAfterAttibuteComputation( attr );

    return true;
end );


#############################################################################
##
#F  DatabaseAttributeString( idenum, idenumname, attridentifier )
##
InstallGlobalFunction( DatabaseAttributeString,
    function( idenum, idenumname, attridentifier )
    local attr, str, strfun, txt, comp, entry;

    if not IsBound( idenum.attributes.( attridentifier ) ) then
      Error( "<idenum> has no component <attridentifier>" );
    fi;
    attr:= idenum.attributes.( attridentifier );
    if not IsBound( attr.data ) then
      if IsBound( attr.datafile ) and IsReadableFile( attr.datafile ) then
        Read( attr.datafile );
      else
        DatabaseAttributeCompute( idenum, attridentifier );
      fi;
    fi;
    str:= Concatenation( "DatabaseAttributeSetData( ", idenumname, ", \"",
              attridentifier, "\",\n" );
    if IsString( attr.version ) then
      Append( str, Concatenation( "\"", attr.version, "\"," ) );
    else
      Append( str, Concatenation( String( attr.version ), "," ) );
    fi;
    if attr.type = "values" then
Print( "missing code!\n" );
    else
      Append( str, "rec(\nautomatic:=[\n" );
      if IsBound( attr.string ) then
        strfun:= attr.string;
      else
        strfun:= String;
      fi;
      txt:= "],\nnonautomatic:=[\n";
      for comp in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in comp do
          if entry[2] <> attr.dataDefault then
            Append( str, strfun( entry ) );
          fi;
        od;
        Append( str, txt );
        txt:= "]));\n";
      od;
    fi;

    return str;
end );


#############################################################################
##
#F  BrowseTableFromDatabaseIdEnumerator( <dbidenum>, <labelids>, <columnids>
#F      [, <header>[, <footer>[, <choice>]]] )
##
InstallGlobalFunction( BrowseTableFromDatabaseIdEnumerator,
    function( arg )
    local dbidenum, labelids, columnids, header, footer, choice, aligned,
          identifiers, labels, columns, id, widthLabelsRow, widthCol,
          sortFunctions, categoryValues, formattedValue, i, table;

    # Get and check the arguments.
    if not Length( arg ) in [ 3 .. 6 ] then
      Error( "usage: BrowseTableFromDatabaseIdEnumerator( <dbidenum>,\n",
             "   <labelids>, <columnids>[, <header>[, <footer>",
             "[, <choice>]]] )" );
    fi;
    dbidenum:= arg[1];
    if not ( IsRecord( dbidenum ) and IsBound( dbidenum.attributes ) ) then
      Error( "<dbidenum> must be a database id enumerator" );
    fi;
    labelids:= arg[2];
    if not ( IsList( labelids ) and
             ForAll( labelids,
                     x -> IsBound( dbidenum.attributes.( x ) ) ) ) then
      Error( "<labelids> must be a list of attribute identifiers for ",
             "<dbidenum>" );
    fi;
    columnids:= arg[3];
    if not ( IsList( columnids ) and not IsEmpty( columnids ) and
             ForAll( columnids,
                     x -> IsBound( dbidenum.attributes.( x ) ) ) ) then
      Error( "<columnids> must be a nonempty list of attribute identifiers ",
             "for <dbidenum>" );
    fi;
    header:= [];
    footer:= [];
    choice:= dbidenum.identifiers;
    if   Length( arg ) = 4 then
      header:= arg[4];
    elif Length( arg ) = 5 then
      header:= arg[4];
      footer:= arg[5];
    elif Length( arg ) = 6 then
      header:= arg[4];
      footer:= arg[5];
      choice:= arg[6];
    fi;

    aligned:= function( list, align )
      local max;

      if IsEmpty( list ) then
        return list;
      fi;
      max:= Maximum( List( list, Length ) );
      if align = "left" then
        max:=  max;
      fi;
      return List( list, x -> String( x, max ) );
    end;

    labels:= List( labelids, id -> dbidenum.attributes.( id ) );
    columns:= List( columnids, id -> dbidenum.attributes.( id ) );

    widthLabelsRow:= [];
    for i in [ 1 .. Length( labels ) ] do
      if IsBound( labels[i].widthCol ) then
        widthLabelsRow[ 2*i ]:= labels[i].widthCol;
      fi;
    od;

    # Set fixed width where the attribute forces this.
    # Set sort functions.
    # Set alignments.
    # Set the functions for computing category values.
    widthCol:= [];
    sortFunctions:= List( columns, x -> x.viewSort );
    categoryValues:= List( columns, x -> x.categoryValue );
    for i in [ 1 .. Length( columns ) ] do
      if IsBound( columns[i].widthCol ) then
        widthCol[ 2*i ]:= columns[i].widthCol;
      fi;
    od;

    # Compute an attribute value, and the table cell data object.
    formattedValue:= function( attr, j, id, width )
      local val, align;

      # Compute the attribute value, and the table cell data object.
      val:= attr.viewValue( attr.attributeValue( attr, id ) );

      # Format the entry.
      if not IsRecord( val ) then
        if IsBound( width[ 2*j ] ) then
          if   'l' in attr.align then
            align:= "left";
          elif 'r' in attr.align then
            align:= "right";
          else
            align:= "";
          fi;
          if IsString( val ) then
            if align <> "" then
              # It is documented that non-strings need no additional
              # formatting if the column width is prescribed.
              val:= rec( rows:= aligned( SplitString(
                           BrowseData.ReallyFormatParagraph( val,
                                     width[ 2*j ], align ), "\n" ),
                             align ),
                         align:= attr.align );
            else
              val:= rec( rows:= [ val ], align:= attr.align );
            fi;
          fi;
        else
          val:= rec( rows:= [ val ], align:= attr.align );
        fi;
      fi;
      return val;
    end;

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= header,
        main:= [],
        Main:= function( t, i, j )
          return formattedValue( columns[j], j, choice[i], widthCol );
        end,
        m:= Length( choice ),
        n:= Length( columns ),
        corner:= [ List( labels, x -> rec( rows:= [ x.viewLabel ],
                                           align:= x.align ) ) ],
        labelsRow:= TransposedMat( List( [ 1 .. Length( labels ) ],
                           j -> List( choice,
               y -> formattedValue( labels[j], j, y, widthLabelsRow ) ) ) ),
        labelsCol:= [ List( columns,
                        x -> rec( rows:= [ x.viewLabel ],
                                  align:= x.align ) ) ],
        sepLabelsRow:= [],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= Concatenation( [ "| " ],
                                List( [ 2 .. Length( columns ) ], x -> " | " ),
                                [ " |" ] ),
        widthLabelsRow:= ShallowCopy( widthLabelsRow ),
        widthCol:= ShallowCopy( widthCol ),

        SpecialGrid:= BrowseData.SpecialGridLineDraw,
#        Click:= rec(
#          select_entry:= rec(
#            helplines:= [ "..." ],
#            action:= function( t ) 
#            if t.dynamic.selectedEntry <> [ 0, 0 ] then
#
#            fi;
#          end ),
#          select_row:= ~.work.Click.select_entry,
#        ),
# generic Click? (access value of dbidenum!)
# or per column?
        CategoryValues:= function( t, i, j )
          local val;

          i:= i / 2;
          j:= j / 2;
          val:= columns[j].attributeValue( columns[j], choice[i] );
          val:= categoryValues[j]( val );
          return BrowseData.CategoryValuesFromEntry( t, val, j );
        end,
      ),
      dynamic:= rec(
         sortFunctionsForColumns:= sortFunctions,
#        Return:= [],
      ),
    );

    if not IsEmpty( labels ) then
      table.work.sepLabelsRow:= Concatenation( [ "| " ],
                                List( [ 2 .. Length( labels ) ], x -> " | " ),
                                [ " |" ] );
    fi;

    # Customize the sort parameters for the columns.
    for i in [ 1 .. Length( columns ) ] do
      if not IsEmpty( columns[i].sortParameters ) then
        BrowseData.SetSortParameters( table, "column", i,
            columns[i].sortParameters );
      fi;
    od;

    # Return the browse table.
    return table;
end );


#############################################################################
##
#E

