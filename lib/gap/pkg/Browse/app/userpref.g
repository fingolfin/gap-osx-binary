#############################################################################
##
#W  userpref.g            GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2013,  Lehrstuhl D für Mathematik,   RWTH Aachen,  Germany
##
##  This application is preliminary, several questions are open:
##  - Editing GAP code inside a dialog box is not foolproof
##    because we cannot catch all syntax and runtime errors.
##  - What shall happen if several user preferences are declared together,
##    and at least one of them provides a values list?
##  - In case of a list of choices, if the defaults are not a subset of the
##    current choices then opening the selection and keeping the current
##    choices yields another list than the initial value.
##    (This happens for the 'PackagesToLoad' preference if not all default
##    packages are installed.)
##  - Should lists of choices be sorted in the selection box?
##    (If yes then should the result revert this sorting, in order to achieve
##    stable values if nothing was changed?)
##


#############################################################################
##
#F  BrowseData.TryEval( <str> )
##
##  Use a preliminary hack (suggested by Frank and Burkhard) until we can
##  safely evaluate an input string which may be syntactically incorrect
##  or which may cause runtime errors.
##  We wrap the assignment into a function in order not to assign the value
##  if the syntax is corrupted.
##
BrowseData.TryEval:= function( str )
    local breakOnError, errorInner, errmsg, res;

    # Temporarily disable the break loop.
    breakOnError:= BreakOnError;
    BreakOnError:= false;

    # Temporarily modify 'ErrorInner', in order to get the error message.
    errorInner:= ErrorInner;
    MakeReadWriteGlobal( "ErrorInner" );
    errmsg:= false;
    ErrorInner:= function( arg )
      errmsg:= Concatenation( arg[2] );
      CallFuncList( errorInner, arg );
    end;

    # Try to evaluate the input.
    Unbind( BrowseData.TryEvalResult );
    str:= Concatenation( "CallFuncList( function() ",
              "BrowseData.TryEvalResult:=", str,
              "; return true; end, [] );\n" );
    Read( InputTextString( str ) );

    # Reset the global values.
    ErrorInner:= errorInner;
    MakeReadOnlyGlobal( "ErrorInner" );
    BreakOnError:= breakOnError;

    if IsBound( BrowseData.TryEvalResult ) then
      res:= rec( value:= BrowseData.TryEvalResult, success:= true );
    elif errmsg = false then
      res:= rec( success:= false, reason:= "Syntax error" );
    else
      res:= rec( success:= false, reason:= errmsg );
    fi;

    Unbind( BrowseData.TryEvalResult );
    return res;
end;


#############################################################################
##
#F  BrowseData.FormattedUserPreferenceDescription( <data>, <values>, <width> )
##
BrowseData.FormattedUserPreferenceDescription:= function( data, values, width )
    local string, suff, paragraph, values_eval, default, len, i, line;

    string:= "";

    if data = fail then
      # The preference (only one) is not declared.
      suff:= "";
      Append( string, "(undeclared preference)\n" );
    else
      # Show the description text.
      for paragraph in data.description do
        Append( string, FormatParagraph( paragraph, width, "left" ) );
      od;

      if IsBound( data.values_strings ) then
        values_eval:= List( data.values_strings, BrowseData.TryEval );
        if ForAny( values_eval, x -> x.success = false ) then
          Unbind( values_eval );
        else
          values_eval:= List( values_eval, x -> x.value );
        fi;
      fi;

      # Show the default value(s), with indent 2.
      if IsString( data.name ) then
        suff:= "";
      else
        suff:= "s";
      fi;
      Append( string, "\ndefault" );
      Append( string, suff );
      if IsFunction( data.default ) then
        Append( string, " (computed at runtime)" );
      fi;
      Append( string, ":\n" );
      default:= data.default;
      if IsFunction( default ) then
        default:= default();
      fi;
      if suff = "" then
        default:= [ default ];
      fi;

      len:= Length( default );
      for i in [ 1 .. len ] do
        if IsBound( values_eval ) then
          line:= Position( values_eval, default[i] );
          if line = fail then
            line:= default[i];
            if IsStringRep( line ) then
              line:= Concatenation( "\"", line, "\"" );
            else
              line:= String( line, 0 );
            fi;
          else
            line:= data.values_strings[ line ];
          fi;
        else
          line:= default[i];
          if IsStringRep( line ) then
            line:= Concatenation( "\"", line, "\"" );
          else
            line:= String( line, 0 );
          fi;
        fi;
        if i < len then
          Add( line, ',' );
        fi;
        Append( string, FormatParagraph( String( line ), width - 2, "left",
                                         [ "  ", "" ] ) );
      od;
    fi;

    # Show the current value(s), with indent 2.
    Append( string, "\ncurrent value" );
    Append( string, suff );
    Append( string, ":\n" );
    if data <> fail and default = values then
      Append( string, "  equal to the default" );
      Append( string, suff );
      Append( string, "\n" );
    else
      len:= Length( values );
      for i in [ 1 .. len ] do
        if IsBound( values_eval ) then
          line:= Position( values_eval, values[i] );
          if line = fail then
            line:= values[i];
            if IsStringRep( line ) then
              line:= Concatenation( "\"", line, "\"" );
            else
              line:= String( line, 0 );
            fi;
          else
            line:= data.values_strings[ line ];
          fi;
        else
          line:= values[i];
          if IsStringRep( line ) then
            line:= Concatenation( "\"", line, "\"" );
          else
            line:= String( line, 0 );
          fi;
        fi;
        if i < len then
          Add( line, ',' );
        fi;
        Append( string, FormatParagraph( String( line ), width - 2, "left",
                                         [ "  ", "" ] ) );
      od;
    fi;

    return string;
end;


#############################################################################
##
#F  BrowseUserPreferences( [...] )
##
##  <#GAPDoc Label="BrowseUserPreferences_section">
##  <Section Label="sec:userpref">
##  <Heading>Configuring User preferences&ndash;a Variant</Heading>
##
##  A &Browse; adapted way to show and edit &GAP;'s user preferences
##  is to show the overview that is printed by the &GAP; function
##  <Ref Func="ShowUserPreferences" BookName="ref"/> in a &Browse; table.
##
##  <ManSection>
##  <Func Name="BrowseUserPreferences" Arg="package1, package2, ..."/>
##
##  <Returns>
##  nothing.
##  </Returns>
##
##  <Description>
##  The arguments are the same as for
##  <Ref Func="ShowUserPreferences" BookName="ref"/>, that is,
##  calling the function with no argument yields an overview of all known
##  user preferences,
##  and if one or more strings <A>package1</A>, <M>\ldots</M> are given
##  then only the user preferences for these packages are shown.
##  <P/>
##  <Ref Func="BrowseUserPreferences"/> opens a Browse table with the
##  following columns:
##  <List>
##  <Mark><Q>Package</Q></Mark>
##  <Item>
##    contains the names of the &GAP; packages to which the
##    user preferences belong,
##  </Item>
##  <Mark><Q>Pref. names</Q></Mark>
##  <Item>
##    contains the names of the user preferences, and
##  </Item>
##  <Mark><Q>Description</Q></Mark>
##  <Item>
##    contains the <C>description</C> texts from the
##    <Ref Func="DeclareUserPreference" BookName="ref"/> calls and
##    the default values (if applicable), and the actual values.
##  </Item>
##  </List>
##  <P/>
##  When one <Q>clicks</Q> on one of the table rows or entries then the
##  values of the user preference in question can be edited.
##  If a list of admissible values is known then this means that one can
##  choose from this list via <Ref Func="NCurses.Select"/>,
##  otherwise one can enter the desired value as text.
##  <P/>
##  The values of the user preferences are not changed before one closes the
##  Browse table.
##  When the table is left and if one has changed at least one value,
##  one is asked whether the changes shall be applied.
##  <P/>
##  The code can be found in the file <F>app/userpref.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseUserPreferences", function( arg )
    local prefrec, pkglist, columnheaders, colwidths, preflist, pkgname,
          done, name, data, names, nam, entry, winwidth, descriptionwidth,
          matrix, i, descr, sel_action, table, changed, items, index;

    prefrec:= GAPInfo.UserPreferences;
    if 0 < Length( arg ) then
      pkglist:= List( arg, LowercaseString );
    else
      # If no list is given then use all packages with preferences,
      # show "gap" first.
      pkglist:= Concatenation( [ "gap" ],
                    Difference( RecNames( prefrec ), [ "gap" ] ) );
    fi;

## HACKUSERPREF temporary until all packages are adjusted
    pkglist:= Filtered( pkglist, a -> not a in [ "Pager", "ReadObsolete" ] );

    columnheaders:= [ "Package", "Pref. names", "Description" ];
    colwidths:= List( columnheaders, Length );

    # The entries of 'preflist' have the form
    # '[ pkg, names, datarecord, currvalues, newvalues ]'.
    preflist:= [];
    for pkgname in pkglist do
      done:= [];
      if IsBound( prefrec.( pkgname ) )
         and IsRecord( prefrec.( pkgname ) ) then
        for name in Set( RecNames( prefrec.( pkgname ) ) ) do
          if not name in done then
            data:= First( GAPInfo.DeclarationsOfUserPreferences,
                          r -> r.package = pkgname and
                               ( name = r.name or name in r.name ) );
            if data = fail or data.name = name then
              names:= [ name ];
            else
              names:= data.name;
            fi;
            UniteSet( done, names );
            Add( preflist, [ pkgname, names, data,
                   List( names, x -> UserPreference( pkgname, x ) ) ] );
            for nam in names do
              colwidths[2]:= Maximum( colwidths[2], Length( nam ) );
            od;
          fi;
        od;
        colwidths[1]:= Maximum( colwidths[1], Length( pkgname ) );
      fi;
    od;

    if IsEmpty( preflist ) then
      return;
    fi;

    for entry in preflist do
      entry[5]:= entry[4];
    od;

    winwidth:= NCurses.getmaxyx( 0 )[2];
    descriptionwidth:= winwidth - colwidths[1] - colwidths[2] - 10;

    # Create the rows of the table.
    matrix:= [];
    for i in [ 1 .. Length( preflist ) ] do
      # Adjust the case of the name if possible.
      pkgname:= preflist[i][1];
      if IsBound( GAPInfo.PackagesInfo.( pkgname ) ) then
        nam:= GAPInfo.PackagesInfo.( pkgname )[1].PackageName;
      elif pkgname = "gap" then
        nam:= "GAP";
      else
        nam:= pkgname;
      fi;

      # Compute the formatted description.
      descr:= BrowseData.FormattedUserPreferenceDescription(
                  preflist[i][3], preflist[i][4], descriptionwidth );
      Add( matrix, [
           rec( rows:= [ nam ], align:= "tl" ),
           rec( rows:= ShallowCopy( preflist[i][2] ), align:= "tl" ),
           rec( rows:= SplitString( descr, "\n" ), align:= "tl" ),
           ] );
    od;

    sel_action:= rec(
      helplines:= [ "edit the current entry" ],
      action:= function( t )
      local i, names, data, currentvalues, newvalues, admissible, values,
            pref, index, prefs, n, j, header, ncols, hint, win, pan, results,
            val;

      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        i:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
        # Fetch the data of the selected user preference.
        names:= preflist[i][2];
        data:= preflist[i][3];
        currentvalues:= preflist[i][5];
        newvalues:= currentvalues;
        if data <> fail and IsBound( data.values ) then
#T this implies that names has length 1?
          # Bring up a list of choices.
          admissible:= data.values;
          if IsFunction( admissible ) then
            admissible:= admissible();
          fi;
          if IsBound( data.values_strings ) then
            values:= data.values_strings;
          else
            values:= List( admissible, String );
          fi;
          pref:= rec(
            items:= values,
            single:= not data.multi,
            none:= true,
            border:= NCurses.attrs.BOLD,
            align:= "c",
            size:= "fit",
          );
          if preflist[i][5][1] <> fail then
            if pref.single then
              pref.select:= [ Position( admissible, preflist[i][5][1] ) ];
            else
              pref.select:= List( preflist[i][5][1],
                                  x -> Position( admissible, x ) );
            fi;
          fi;
          index:= NCurses.Select( pref );
          if index <> false then
            if pref.single then
              newvalues:= [ admissible[ index ] ];
            else
              newvalues:= [ admissible{ index } ];
            fi;
          fi;
        else
          # Let the user edit the values.
          prefs:= [];
          n:= 3;
          for j in [ 1 .. Length( names ) ] do
            pref:= rec( prefix:= Concatenation( names[j], ": " ),
                        suffix:= "",
                        begin:= [ n + 2, 4 ],
                        ncols:= winwidth - 10,
                      );
            if IsStringRep( currentvalues[j] ) then
              pref.default:= Concatenation( "\"",
                  ReplacedString( currentvalues[j], "\"", "\\\"" ), "\"" );
            elif currentvalues[j] <> fail then
              pref.default:= String( currentvalues[j], 0 );
            fi;
            Add( prefs, pref );
            n:= n + 3;
          od;

          header:= [ NCurses.attrs.BOLD, "Edit user preferences",
                     NCurses.attrs.NORMAL ];
          if Length( currentvalues ) = 1 then
            hint:= [ NCurses.attrs.BOLD,
                     " [ <Return> done, <Esc> cancel, <F1> help ] ",
                     NCurses.attrs.NORMAL ];
          else
            hint:= [ NCurses.attrs.BOLD,
              " [ <Tab> move focus, <Return> done, <Esc> cancel, <F1> help ] ",
                     NCurses.attrs.NORMAL ];
          fi;
          ncols:= winwidth - 6;
          win:= NCurses.newwin( n+2, ncols, 2, 3 );
          pan:= NCurses.new_panel( win );
          NCurses.wattrset( win, NCurses.attrs.BOLD );
          NCurses.wborder( win, 0 );
          NCurses.wattrset( win, NCurses.attrs.NORMAL );
          NCurses.PutLine( win, 1, 2, header );
          NCurses.PutLine( win, n+1,
            Int( ( ncols - NCurses.WidthAttributeLine( hint ) ) / 2 ), hint );
          results:= NCurses.EditFields( win, prefs );
          NCurses.del_panel( pan);
          NCurses.delwin( win);

          if results <> fail then
            # Evaluate the strings and change the values as desired.
            newvalues:= [];
            for entry in results do
              val:= BrowseData.TryEval( entry );
              if val.success = false then
                # Switching from the string to a GAP object failed.
                NCurses.Alert( Concatenation( val.reason, " in '",
                                   entry, "'." ), 0 );
                newvalues:= fail;
                break;
              else
                Add( newvalues, val.value );
              fi;
            od;
            if IsList( newvalues ) then
              if data <> fail and IsBound( data.check )
                 and not CallFuncList( data.check, newvalues ) then
                # The new values are not admissible.
                NCurses.Alert( Concatenation( "The values '", entry,
                                   "' are not admissible." ), 0 );
                newvalues:= currentvalues;
              fi;
            else
              newvalues:= currentvalues;
            fi;
          fi;

          NCurses.update_panels();
          NCurses.doupdate();
        fi;

        if newvalues <> currentvalues then

          # Store the new values, they will be set later.
          preflist[i][5]:= newvalues;

          # Recompute the view value in the description column.
          # Note that the height of the table cell may have changed.
          descr:= BrowseData.FormattedUserPreferenceDescription(
                      preflist[i][3], newvalues, descriptionwidth );
          table.work.main[i][3].rows:= SplitString( descr, "\n" );
          Unbind( table.work.heightRow[ 2*i ] );

          # Recompute the marks in the column of the package name.
          for j in [ 1 .. Length( newvalues ) ] do
            if newvalues[j] = preflist[i][4][j] then
              matrix[i][2].rows[j]:= preflist[i][2][j];
            else
              matrix[i][2].rows[j]:= [ NCurses.ColorAttr( "red", -1 ),
                                       preflist[i][2][j] ];
#T REVERSE and STANDOUT are not suitable if the table cell is selected!
            fi;
          od;

        fi;
      fi;
    end );

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= t -> BrowseData.HeaderWithRowCounter( t,
                          "GAP User Preferences",
                          Length( matrix ) ),
        main:= matrix,
        cacheEntries:= false,
        labelsCol:= [ List( columnheaders,
                            x -> rec( rows:= [ x ], align:= "l" ) ) ],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= [ "| ", " | ", " | ", " |" ],

        # Set widths for the columns.
        widthCol:= [ , colwidths[1],, colwidths[2],, descriptionwidth ],
        SpecialGrid:= BrowseData.SpecialGridLineDraw,
        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),
      ),
    );

    # Customize the sort parameters for the two name columns.
    BrowseData.SetSortParameters( table, "column", 1,
        [ "hide on categorizing", "yes",
          "add counter on categorizing", "yes",
          "split rows on categorizing", "no" ] );
    BrowseData.SetSortParameters( table, "column", 2,
        [ "hide on categorizing", "no",
          "add counter on categorizing", "no",
          "split rows on categorizing", "yes" ] );

    # Show the table.
    NCurses.BrowseGeneric( table );

    # If some values have been changed then ask what the user wants.
    changed:= Filtered( preflist, entry -> entry[4] <> entry[5] );
    if not IsEmpty( changed ) then
      # The user may ignore the changes or save the changes.
      # If at least one change concerns a user preference
      # that belongs to the user's 'gap.ini' file then
      # the user may want to save the changes also in the 'gap.ini' file.
      items:= [ "cancel", "save values for the current GAP session" ];
      if ForAny( changed, x -> ( not IsRecord( x[3] ) ) or
                               x[3].omitFromGapIniFile = false ) then
        items[3]:= "save and store values in the gap.ini file";
      fi;

      index:= NCurses.Select( rec(
                items:= items,
                single:= true,
                none:= false,
                border:= NCurses.attrs.BOLD,
                align:= "c",
                size:= "fit",
              ) );
      if index >= 2 then
        for entry in preflist do
          if entry[4] <> entry[5] then
            for i in [ 1 .. Length( entry[2] ) ] do
              SetUserPreference( entry[1], entry[2][i], entry[5][i] );
            od;
          fi;
        od;
      fi;
      if index = 3 then
        WriteGapIniFile();
      fi;
    fi;
end );


BrowseGapDataAdd( "GAP User Preferences", BrowseUserPreferences, false, "\
the currently available user preferences, \
shown in a browse table whose columns contain the name of the package \
for which the user preference is declared, \
the name of the preference, \
and a description of its meaning, of possible values, \
of the default value, and of the current value, \
in a similar format as the the string printed by 'ShowUserPreferences'" );


#############################################################################
##
#E

