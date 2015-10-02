#############################################################################
##
#W  transbrowse.g         GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2008,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#V  TransitiveGroupsData
##
##  <#GAPDoc Label="TransitiveGroupsData_man">
##  <ManSection>
##  <Var Name="TransitiveGroupsData"/>
##
##  <Description>
##  This is a record that contains the data needed by
##  <Ref Func="BrowseTransitiveGroupsInfo"/>,
##  <Ref Func="TransitiveGroupsData.AllTransitiveGroups"/>, and
##  <Ref Func="TransitiveGroupsData.OneTransitiveGroup"/>.
##  The component <C>IdEnumerator</C> contains a database id enumerator
##  (see <Ref Subsect="subsect:dbidenum"/>)
##  for the &GAP; Library of Transitive Permutation Groups.
##  <P/>
##  Note that although <Ref Func="NrTransitiveGroups" BookName="Ref"/>
##  returns <C>1</C> when it is called with the argument <C>1</C>,
##  <Ref Func="TransitiveGroup" BookName="Ref"/> runs into an error when
##  it is called with first argument equal to <C>1</C>,
##  and the degree <C>1</C> is explicitly excluded from results of
##  <Ref Func="AllTransitiveGroups" BookName="Ref"/> and
##  <Ref Func="OneTransitiveGroup" BookName="Ref"/>.
##  For the sake of consistency with this inconsistency in the &GAP;
##  Library of Transitive Permutation Groups,
##  we exclude the degree <C>1</C> from <Ref Var="TransitiveGroupsData"/>.
##  (Those who want to include this degree can change the value of
##  <C>TransitiveGroupsData.MinimalDegree</C> from its default value <C>2</C>
##  to <C>1</C> in the file <F>app/transbrowse.g</F> of the package.)
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "TransitiveGroupsData", rec() );


#############################################################################
##
##  Provide utilities for the computation of database attribute values.
##
TransitiveGroupsData.MinimalDegree:= 2;

TransitiveGroupsData.Props:= function( id )
  if not IsBound( TRANSPROPERTIES[ id[1] ] ) or
     not IsBound( TRANSPROPERTIES[ id[1] ][ id[2] ] ) then
    TransGrpLoad( id[1], id[2] );
  fi;
  return TRANSPROPERTIES[ id[1] ][ id[2] ];
end;

TransitiveGroupsData.sym:= List( [ 1 .. TRANSDEGREES ], Factorial );

TransitiveGroupsData.cumul:= function()
    local result, i;

    result:= [ 0, 0 ];
    i:= 0;
    for i in [ TransitiveGroupsData.MinimalDegree .. TRANSDEGREES-1 ] do
      result[ i+1 ]:= result[i] + NrTransitiveGroups( i );
    od;
    return result;
    end;
TransitiveGroupsData.cumul:= TransitiveGroupsData.cumul();

TransitiveGroupsData.Position:= id -> TransitiveGroupsData.cumul[ id[1] ]
                                      + id[2];


#############################################################################
##
##  Create the database id enumerator to which the database attributes refer.
##  The version number corresponds to `GAPInfo.LoadedComponents.trans'.
##
TransitiveGroupsData.IdEnumerator:= DatabaseIdEnumerator( rec(
    identifiers:= Concatenation( List( [ TransitiveGroupsData.MinimalDegree
                                         .. TRANSDEGREES ],
      d -> List( [ 1 .. NrTransitiveGroups( d ) ], i -> [ d, i ] ) ) ),
    entry:= function( enum, id )
      if id[1] = 1 and id[2] = 1 then
        # `TransitiveGroup( 1, 1 )' is not supported.
        return SymmetricGroup( 1 );
      fi;
      return TransitiveGroup( id[1], id[2] );
    end,
    version:= "1.0",
    update:= idenum -> idenum.version = GAPInfo.LoadedComponents.trans,
    isSorted:= true,
      ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.degree
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "degree",
  type:= "values",
  name:= "NrMovedPoints",
  viewLabel:= "d",
  align:= "tr",
  create:= function( attr, id ) # used by `DatabaseAttributeValueDefault'
    return id[1];
  end,
  viewSort:= BrowseData.CompareLenLex,
  categoryValue:= value -> Concatenation( "degree ", String( value ) ),
  widthCol:= Length( String( TRANSDEGREES ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.size
##
##  The width of the column is smaller than the string of the largest group
##  order that occurs.
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "size",
  type:= "values",
  name:= "Size",
  viewLabel:= "|G|",
  data:= [],
  attributeValue:= function( attr, id )
    local pos;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      attr.data[ pos ]:= TransitiveGroupsData.Props( id )[1];
    fi;
    return attr.data[ pos ];
  end,
  viewSort:= BrowseData.CompareLenLex,
  categoryValue:= value -> Concatenation( "order ", String( value ) ),
  align:= "tr",
  widthCol:= 24,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.names
##
##  We copy existing code for creating names.
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "names",
  type:= "values",
  viewLabel:= "Names",
  data:= [],
  attributeValue:= function( attr, id )
    local pos, data, name, l;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      data:= TransitiveGroupsData.Props( id );
      if   data[1] = TransitiveGroupsData.sym[ id[1] ] then
        name:= Concatenation( "S", String( id[1] ) );
      elif data[1] * 2 = TransitiveGroupsData.sym[ id[1] ] then
        name:= Concatenation( "A", String( id[1] ) );
      else
        l:= TRANSGRP[ id[1] ][ id[2] ];
        name:= l[ Length( l ) ];
        if name = "" then
          name:= Concatenation( "t", String( id[1] ),
                                "n", String( id[2] ) );
        fi;
      fi;
      attr.data[ pos ]:= name;
    fi;
    return attr.data[ pos ];
  end,
  viewSort:= BrowseData.CompareAsNumbersAndNonnumbers,
  viewValue:= x -> rec( rows:= List( SplitString( x, "=" ),
                                     NormalizedWhitespace ),
                        align:= "tl" ),
  categoryValue:= value -> JoinStringsWithSeparator( value, " = " ),
  align:= "lt",
  widthCol:= 31,
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.prim
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "prim",
  type:= "values",
  name:= "IsPrimitive",
  viewLabel:= "P",
  data:= [],
  attributeValue:= function( attr, id )
    local pos;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      attr.data[ pos ]:= BrowseData.ReplacedEntry(
        TransitiveGroupsData.Props( id )[2], [ 0, 1 ], [ false, true ] );
    fi;
    return attr.data[ pos ];
  end,
  viewValue:= x -> BrowseData.ReplacedEntry( x,
                     [ false, true ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ false, true ], [ "imprimitive", "primitive" ] ),
  align:= "ct",
  widthCol:= 1,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.trans
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "trans",
  type:= "values",
  name:= "Transitivity",
  viewLabel:= "T",
  data:= [],
  attributeValue:= function( attr, id )
    local pos;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      attr.data[ pos ]:= TransitiveGroupsData.Props( id )[3];
    fi;
    return attr.data[ pos ];
  end,
  viewSort:= BrowseData.CompareLenLex,
  categoryValue:= value -> Concatenation( "transitivity ", String( value ) ),
  align:= "ct",
  widthCol:= Length( String( TRANSDEGREES ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.sign
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "sign",
  type:= "values",
  name:= "SignPermGroup",
  viewLabel:= "S",
  data:= [],
  attributeValue:= function( attr, id )
    local pos;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      attr.data[ pos ]:= TransitiveGroupsData.Props( id )[4];
    fi;
    return attr.data[ pos ];
  end,
  viewValue:= x -> BrowseData.ReplacedEntry( x, [ -1, 1 ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ -1, 1 ], [ "sign -", "sign +" ] ),
  align:= "ct",
  widthCol:= 1,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.IsSolvableGroup
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "IsSolvableGroup",
  type:= "values",
  datafile:= Filename( DirectoriesPackageLibrary( "Browse", "app" ),
                       "transdbattr.g" ),
  name:= "IsSolvableGroup",
  viewLabel:= "Sol",
  viewValue:= value -> BrowseData.ReplacedEntry( value,
                [ false, true ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ false, true ], [ "nonsolvable", "solvable" ] ),
  align:= "ct",
  widthCol:= 3,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.IsPerfectGroup
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "IsPerfectGroup",
  type:= "values",
  name:= "IsPerfectGroup",
  data:= [],
  neededAttributes:= [ "IsSolvableGroup" ],
  attributeValue:= function( attr, id )
    local pos, idenum, att;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      idenum:= TransitiveGroupsData.IdEnumerator;
      att:= idenum.attributes.IsSolvableGroup;
      if att.attributeValue( att, id ) then
        attr.data[ pos ]:= ( id[1] = 1 );
      else
        attr.data[ pos ]:= IsPerfectGroup( idenum.entry( idenum, id ) );
      fi;
    fi;
    return attr.data[ pos ];
  end,
  viewLabel:= "Prf",
  viewValue:= value -> BrowseData.ReplacedEntry( value,
                [ false, true ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ false, true ], [ "nonperfect", "perfect" ] ),
  align:= "ct",
  widthCol:= 3,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.IsSimpleGroup
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "IsSimpleGroup",
  type:= "values",
  name:= "IsSimpleGroup",
  data:= [],
  neededAttributes:= [ "size", "IsSolvableGroup" ],
  attributeValue:= function( attr, id )
    local pos, idenum, att;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      idenum:= TransitiveGroupsData.IdEnumerator;
      att:= idenum.attributes.size;
      if IsPrimeInt( att.attributeValue( att, id ) ) then
        attr.data[ pos ]:= true;
      else
        att:= idenum.attributes.IsSolvableGroup;
        if att.attributeValue( att, id ) then
          attr.data[ pos ]:= false;
        else
          attr.data[ pos ]:= IsSimpleGroup( idenum.entry( idenum, id ) );
        fi;
      fi;
    fi;
    return attr.data[ pos ];
  end,
  viewLabel:= "Sim",
  viewValue:= value -> BrowseData.ReplacedEntry( value,
                [ false, true ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ false, true ], [ "nonsimple", "simple" ] ),
  align:= "ct",
  widthCol:= 3,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  TransitiveGroupsData.IdEnumerator.attributes.IsAbelian
##
DatabaseAttributeAdd( TransitiveGroupsData.IdEnumerator, rec(
  identifier:= "IsAbelian",
  type:= "values",
  name:= "IsAbelian",
  data:= [],
  neededAttributes:= [ "IsSolvableGroup" ],
  attributeValue:= function( attr, id )
    local pos, idenum, att;

    pos:= TransitiveGroupsData.Position( id );
    if not IsBound( attr.data[ pos ] ) then
      idenum:= TransitiveGroupsData.IdEnumerator;
      att:= idenum.attributes.IsSolvableGroup;
      if not att.attributeValue( att, id ) then
        attr.data[ pos ]:= false;
      else
        attr.data[ pos ]:= IsAbelian( idenum.entry( idenum, id ) );
      fi;
    fi;
    return attr.data[ pos ];
  end,
  viewLabel:= "Ab",
  viewValue:= value -> BrowseData.ReplacedEntry( value,
                [ false, true ], [ "-", "+" ] ),
  categoryValue:= value -> BrowseData.ReplacedEntry( value,
                    [ false, true ], [ "nonabelian", "abelian" ] ),
  align:= "ct",
  widthCol:= 3,
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#F  BrowseTransitiveGroupsInfo( [<arec>] )
##
##  <#GAPDoc Label="BrowseTransitiveGroupsInfo_man">
##  <ManSection>
##  <Func Name="BrowseTransitiveGroupsInfo" Arg="[arec]"/>
##
##  <Returns>
##  the list of <Q>clicked</Q> groups.
##  </Returns>
##
##  <Description>
##  This function shows the contents of the &GAP; Library of Transitive
##  Permutation Groups in a browse table.
##  <P/>
##  The table rows correspond to the groups.
##  If no argument is given then the columns of the table contain information
##  about the degree of the permutation representation, group order, names
##  for the group, primitivity, transitivity, and sign.
##  Otherwise, the argument <A>arec</A> must be a record; the component
##  <C>choice</C> of <A>arec</A> can be used to prescribe columns,
##  the value of this component must then be a list of strings that are
##  <C>identifier</C> values of database attributes
##  (see <Ref Subsect="subsect:dbattr"/>) for the <C>IdEnumerator</C>
##  component of <Ref Var="TransitiveGroupsData"/>,
##  see Section <Ref Subsect="subsect:transdbattr"/> for examples.
##  <P/>
##  The return value is the list of transitive groups whose table rows have
##  been <Q>clicked</Q> in visual mode.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> c:= [ NCurses.keys.ENTER ];;
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "scrrrr/5", c,     # search for transitivity 5,
##  >        "nn", c,           # go to the third occurrence, click on it,
##  >        "Q" ) );;          # and quit the browse table
##  gap> BrowseTransitiveGroupsInfo();
##  [ M(12) ]
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "BrowseTransitiveGroupsInfo", function( arg )
    local choice, idenum, nams, ids, sel_action, table, ret;

    choice:= [ "degree", "size", "names", "prim", "trans", "sign" ];
    if   Length( arg ) = 1 and IsRecord( arg[1] ) then
      if IsBound( arg[1].choice ) and IsList( arg[1].choice ) then
        choice:= arg[1].choice;
      fi;
    elif Length( arg ) <> 0 then
      Error( "usage: BrowseTransitiveGroupsInfo( [<arec>] )" );
    fi;

    idenum:= TransitiveGroupsData.IdEnumerator;
    nams:= RecNames( idenum.attributes );
    choice:= Filtered( choice, x -> x in nams );
    ids:= idenum.identifiers;

    sel_action:= rec(
        helplines:= [ "add the transitive group to the result list" ],
        action:= function( t )
          if t.dynamic.selectedEntry <> [ 0, 0 ] then
            Add( t.dynamic.Return,
                 t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2 );
          fi;
        end );

    # Construct and customize the browse table.
    table:= BrowseTableFromDatabaseIdEnumerator(
                idenum, [], choice,
                t -> BrowseData.HeaderWithRowCounter( t,
                       "The GAP Library of Transitive Groups",
                       Length( ids ) ) );
    table.work.cacheEntries:= true;
    table.work.Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
          select_column_and_entry:= sel_action,
          select_row_and_entry:= sel_action,
        );
    table.dynamic.Return:= [];

    # Show the table.
    ret:= DuplicateFreeList( NCurses.BrowseGeneric( table ) );

    # Construct the return value.
    return List( ret, i -> idenum.entry( idenum, ids[i] ) );
    end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "Overview of the GAP Library of Transitive Groups",
    BrowseTransitiveGroupsInfo, true, "\
an overview of the GAP library of transitive groups, \
shown in a browse table whose rows correspond to the groups, \
and whose columns contain information about the degree of the permutation \
representation, group order, names for the group, primitivity, \
transitivity, and sign; \
the return value is the list of transitive groups whose table rows \
have been ``clicked'' in visual mode" );


#############################################################################
##
#F  TransitiveGroupsData.AllTransitiveGroups( <fun>, <res>, ... )
#F  TransitiveGroupsData.OneTransitiveGroup( <fun>, <res>, ... )
##
##  <#GAPDoc Label="TransitiveGroupsData.SelectTransitiveGroups_man">
##  <ManSection>
##  <Func Name="TransitiveGroupsData.AllTransitiveGroups"
##   Arg="fun, res[, ...]"/>
##  <Func Name="TransitiveGroupsData.OneTransitiveGroup"
##   Arg="fun, res[, ...]"/>
##
##  <Returns>
##  the list of groups from the &GAP; Library of Transitive Permutation
##  Groups with the given properties, or one such group, or <K>fail</K>.
##  </Returns>
##
##  <Description>
##  These functions are analogues of
##  <Ref Func="AllTransitiveGroups" BookName="Ref"/> and
##  <Ref Func="OneTransitiveGroup" BookName="Ref"/>.
##  The only difference is that they are based on the database attributes
##  that are defined in <Ref Var="TransitiveGroupsData"/>.
##  <P/>
##  Besides those &GAP; attributes such as <Ref Attr="Size" BookName="Ref"/>
##  and <Ref Prop="IsPrimitive" BookName="Ref"/> for which special support is
##  provided in <Ref Func="AllTransitiveGroups" BookName="Ref"/> and
##  <Ref Func="OneTransitiveGroup" BookName="Ref"/>,
##  database attributes are defined for some other &GAP; properties,
##  see <Ref Subsect="subsect:transdbattr"/>.
##  One could speed up <Ref Func="TransitiveGroupsData.AllTransitiveGroups"/>
##  for given conditions by adding further precomputed database attributes.
##  <P/>
##  After defining a database attribute, it is automatically used
##  in calls to <Ref Func="TransitiveGroupsData.AllTransitiveGroups"/>.
##  In order to make the values appear in the table shown by
##  <Ref Func="BrowseTransitiveGroupsInfo"/>,
##  one has to enter an argument record that contains the name of the
##  database attributes in its <C>choice</C> list.
##  <Example><![CDATA[
##  gap> TransitiveGroupsData.AllTransitiveGroups(
##  >      NrMovedPoints, [ 5 .. 28 ],
##  >      IsSimpleGroup, true, IsAbelian, true );
##  [ C(5) = 5, C(7) = 7, C(11)=11, C(13)=13, C(17)=17, C(19)=19, C(23) ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  (Prescribing also the conditions `NrMovedPoints, IsPrimeInt,' would make
##  `AllTransitiveGroups' also very fast.)
##
TransitiveGroupsData.SelectTransitiveGroups:= function( arglis, all )
    local deg, f, pos, val, gut, i, attrs, idenum, nam, attr, hard, cond, d,
          grp, nr, g;

    if not IsEvenInt( Length( arglis ) ) then
      Error( "the number of arguments must be even" );
    fi;

    deg:= [ TransitiveGroupsData.MinimalDegree .. TRANSDEGREES ];
    f:= true;
    pos:= Position( arglis, NrMovedPoints );
    while pos <> fail do
      val:= arglis[ pos+1 ];
      if IsInt( val ) then
        val:= [ val ];
      fi;
      if IsList( val ) then
        if IsSubset( deg, val ) then
          f:= false;
        fi;
        deg:= Intersection( deg, val );
      else
        deg:= Filtered( deg, val );
      fi;
      pos:= Position( arglis, NrMovedPoints, pos );
    od;
    if f then
      Info( InfoWarning, 1,
            "SelectTransitiveGroups: Degree restricted to [ ",
            TransitiveGroupsData.MinimalDegree, " .. ",
            TRANSDEGREES, " ]" );
    fi;

    gut:= [];
    for d in deg do
      if not IsBound( TRANSLENGTHS[d] ) then
        TransGrpLoad( d, 0 );
      fi;
      gut[d]:= [ 1 .. TRANSLENGTHS[d] ];
    od;

    # special treatment for Size for degrees larger than 15
    pos:= Position( arglis, Size );
    while pos <> fail do
      val:= arglis[ pos+1 ];
      for d in Filtered( deg, i -> i > 15 and not IsPrimeInt(i) ) do
        if IsFunction( val ) then
          gut[d]:= Filtered( gut[d], j -> val( TRANSSIZES[d][j] ) );
        elif IsList( val ) then
          gut[d]:= Filtered( gut[d], j -> TRANSSIZES[d][j] in val );
        else
          gut[d]:= Filtered( gut[d], j -> TRANSSIZES[d][j] = val );
        fi;
      od;
      pos:= Position( arglis, Size, pos );
    od;

    # Deal with the conditions covered by database attributes.
    attrs:= [ [], [] ];
    idenum:= TransitiveGroupsData.IdEnumerator;
    for nam in RecNames( idenum.attributes ) do
      attr:= idenum.attributes.( nam );
      if IsBound( attr.name ) then
        Add( attrs[1], ValueGlobal( attr.name ) );
        Add( attrs[2], attr );
      fi;
    od;

    hard:= [];
    for i in [ 2, 4 .. Length( arglis ) ] do
      cond:= arglis[ i-1 ];
      if cond = NrMovedPoints or cond = Size then
        # This has been treated above.
      else
        pos:= Position( attrs[1], cond );
        val:= arglis[i];
        if pos <> fail then
          # We have a database attribute for this condition.
          attr:= attrs[2][ pos ];
          for d in deg do
            if IsFunction( val ) then
              gut[d]:= Filtered( gut[d],
                         j -> val( attr.attributeValue( attr, [ d, j ] ) ) );
            elif IsList( val ) then
              gut[d]:= Filtered( gut[d],
                         j -> attr.attributeValue( attr, [ d, j ] ) in val );
            else
              gut[d]:= Filtered( gut[d],
                         j -> attr.attributeValue( attr, [ d, j ] ) = val );
            fi;
          od;
        else
          # This condition will be checked individually.
          Add( hard, [ cond, val ] );
        fi;
      fi;
    od;

    # For the remaining conditions, we construct the groups.
    grp:= [];
    for d in deg do
      for nr in gut[d] do
        g:= idenum.entry( idenum, [ d, nr ] );
        if ForAll( hard, pair -> STGSelFunc( pair[1]( g ), pair[2] ) ) then
          if all then
            Add( grp, g );
          else
            return g;
          fi;
        fi;
      od;
    od;

    if all then
      return grp;
    else
      return fail;
    fi;
end;

TransitiveGroupsData.AllTransitiveGroups:= function( arg )
  return TransitiveGroupsData.SelectTransitiveGroups( arg, true );
end;

TransitiveGroupsData.OneTransitiveGroup:= function( arg )
  return TransitiveGroupsData.SelectTransitiveGroups( arg, false );
end;


#############################################################################
##
#E

