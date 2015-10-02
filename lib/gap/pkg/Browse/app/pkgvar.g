#############################################################################
##
#W  pkgvar.g              GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2011,  Lehrstuhl D für Mathematik,   RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowsePackageVariables( <pkgname>[, <version>][, <arec>] )
#F  BrowsePackageVariables( <pkgname>, <info>[, <arec>] )
##
##  <#GAPDoc Label="BrowsePackageVariables_section">
##  <Section Label="sec:pkgvardisp">
##  <Heading>Variables defined in &GAP; packages&ndash;a Variant</Heading>
##
##  A &Browse; adapted way to list the variables that are defined in a
##  &GAP; package is to show the overview that is printed by the &GAP;
##  function <Ref Func="ShowPackageVariables" BookName="ref"/>
##  in a &Browse; table.
##
##  <ManSection>
##  <Func Name="BrowsePackageVariables" Arg="pkgname[, version][, arec]"/>
##
##  <Returns>
##  nothing.
##  </Returns>
##
##  <Description>
##  The arguments can be the same as for
##  <Ref Func="ShowPackageVariables" BookName="ref"/>, that is,
##  <A>pkgname</A> is the name of a &GAP; package,
##  and the optional arguments <A>version</A> and <A>arec</A> are a version
##  number of this package and a record used for customizing the output,
##  respectively.
##  <P/>
##  Alternatively, the second argument can be the output <C>info</C> of
##  <Ref Func="PackageVariablesInfo" BookName="ref"/> for the package in
##  question, instead of the version number.
##  <P/>
##  <Ref Func="BrowsePackageVariables"/> opens a Browse table that shows the
##  global variables that become bound and the methods that become installed
##  when &GAP; loads the package <A>pkgname</A>.
##  <P/>
##  The table is categorized by the kinds of variables (new or redeclared
##  operations, methods, info classes, synonyms, other globals).
##  The column <Q>Doc.?</Q> distinguishes undocumented and documented
##  variables, so one can use this column as a filter or for categorizing.
##  The column <Q>Filename</Q> shows the names of the package files.
##  Clicking a selected row of the table opens the relevant package file at
##  the code in question.
##  <P/>
##  The idea behind the argument <C>info</C> is that using the same arguments
##  as for <Ref Func="ShowPackageVariables" BookName="ref"/> does not allow
##  one to apply <Ref Func="BrowsePackageVariables"/> to packages that have
##  been loaded before the <Package>Browse</Package> package.
##  Thus one can compute the underlying data <C>info</C> first,
##  using <Ref Func="PackageVariablesInfo" BookName="ref"/>,
##  then load the <Package>Browse</Package> package,
##  and finally call <Ref Func="BrowsePackageVariables"/>.
##  <P/>
##  For example, the overview of package variables for
##  <Package>Browse</Package> can be shown by starting &GAP; without packages
##  and then entering the following lines.
##  <P/>
##  <Log><![CDATA[
##  gap> pkgname:= "Browse";;
##  gap> info:= PackageVariablesInfo( pkgname, "" );;
##  gap> LoadPackage( "Browse" );;
##  gap> BrowsePackageVariables( pkgname, info );
##  ]]></Log>
##  <P/>
##  If the arguments are the same as for
##  <Ref Func="ShowPackageVariables" BookName="ref"/> then
##  this function is actually called, with the consequence that the package
##  gets loaded when <Ref Func="BrowsePackageVariables"/> is called.
##  This is not the case if the output of
##  <Ref Func="PackageVariablesInfo" BookName="ref"/> is entered as the
##  second argument.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowsePackageVariables", function( arg )
    local pkgname, arec, info, prefix, matrix, jump, suffix, show,
          documented, undocumented, private, filenamewidth, namewidth,
          entry, subentry, nameandcomment, sel_action, t;

    if   Length( arg ) = 0 or not IsString( arg[1] ) then
      Error( "usage: BrowsePackageVariables( <pkgname>[, <info>]",
             "[, <arec>] )" );
    fi;
    pkgname:= LowercaseString( arg[1] );
    if not IsBound( GAPInfo.PackagesInfo.( pkgname ) ) then
      Error( "no package with name <pkgname>" );
    fi;
    pkgname:= GAPInfo.PackagesInfo.( pkgname )[1].PackageName;

    arec:= rec();
    if Length( arg ) = 1 then
      # BrowsePackageVariables( <pkgname> )
      info:= PackageVariablesInfo( pkgname, "" );
    elif Length( arg ) = 2 and IsString( arg[2] ) then
      # BrowsePackageVariables( <pkgname>, <version> )
      info:= PackageVariablesInfo( pkgname, arg[2] );
    elif Length( arg ) = 2 and IsRecord( arg[2] ) then
      # BrowsePackageVariables( <pkgname>, <arec> )
      info:= PackageVariablesInfo( pkgname, "" );
      arec:= arg[2];
    elif Length( arg ) = 3 and IsString( arg[2] ) and IsRecord( arg[3] ) then
      # BrowsePackageVariables( <pkgname>, <version>, <arec> )
      info:= PackageVariablesInfo( pkgname, arg[2] );
      arec:= arg[3];
    elif Length( arg ) = 2 and IsList( arg[2] ) then
      # BrowsePackageVariables( <pkgname>, <info> )
      info:= arg[2];
    elif Length( arg ) = 3 and IsList( arg[2] ) and IsRecord( arg[3] ) then
      # BrowsePackageVariables( <pkgname>, <info>, <arec> )
      info:= arg[2];
      arec:= arg[3];
    else
      Error( "usage: BrowsePackageVariables( <pkgname>[, <info>]",
             "[, <arec>] )" );
    fi;

    # If nothing is in the result then probably the package was already
    # loaded, and we have seen a message about it.
    if IsEmpty( info ) then
      return;
    fi;

    prefix:= Filename( DirectoriesPackageLibrary( pkgname, "" ), "" );
    matrix:= [];
    jump:= [];
    suffix:= function( filename )
      if filename = fail then
        return "(unknown)";
      elif Length( prefix ) < Length( filename ) and
           filename{ [ 1 .. Length( prefix ) ] } = prefix then
        return filename{ [ Length( prefix ) + 1 .. Length( filename ) ] };
      else
        # This happens for variables that get assigned (inside the package)
        # to a value that was created outside the package,
        # for example the function `HELP_SHOW_MATCHES_LIB' in `Browse'.
        return "(unknown)";
      fi;
    end;

    # Evaluate the optional record.
    if IsBound( arec.show ) and IsList( arec.show ) then
      show:= arec.show;
    else
      show:= List( info, entry -> entry[1] );
    fi;
    documented:= not IsBound( arec.showDocumented )
                 or arec.showDocumented <> false;
    undocumented:= not IsBound( arec.showUndocumented )
                   or arec.showUndocumented <> false;
    private:= not IsBound( arec.showPrivate )
              or arec.showPrivate <> false;

    filenamewidth:= 20;
    namewidth:= SizeScreen()[1] - filenamewidth - 4 - 5 - 6;

    for entry in info do
      if entry[1] in show then
        for subentry in entry[2] do
          if ( ( documented and subentry[1][3] = "" ) or
               ( undocumented and subentry[1][3] = "*" ) ) and
             ( private or not '@' in subentry[1][1] ) then
            nameandcomment:= BrowseData.ReallyFormatParagraph(
              Concatenation( subentry[1]{ [ 1, 2 ] } ), namewidth, "left" );
            if Length( subentry[1] ) = 4 and
               not IsEmpty( subentry[1][4] ) then
              Append( nameandcomment, "\n" );
              Append( nameandcomment, BrowseData.ReallyFormatParagraph(
                subentry[1][4], namewidth, "left" ) );
            fi;
            Add( matrix, [
              # kind of the variable
              rec( align:= "tl", rows:= [ entry[1] ] ),
              # variable name, arguments, and comment
              rec( align:= "tl", rows:= SplitString( nameandcomment, "\n" ) ),
              # documented?
              rec( align:= "tc", rows:= [ BrowseData.ReplacedEntry(
                    subentry[1][3], [ "*", "" ], [ "-", "+" ] ) ] ),
    
              # filename
              rec( align:= "tl", rows:= SplitString(
                BrowseData.ReallyFormatParagraph(
                    suffix( subentry[2][1] ), filenamewidth, "left" ), "\n" ) ),
            ] );
          fi;
          Add( jump, subentry[2] );
        od;
      fi;
    od;

    # Implement the ``click'' action.
    # (Essentially the same function is contained in `app/profile.g'
    # and `app/methods.g'.)
    sel_action:= rec(
      helplines:= [ "show the file with the chosen variable in a pager" ],
      action:= function( t )
        local pos, func, file, lines, stream;

        if t.dynamic.selectedEntry <> [ 0, 0 ] then
          pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
          file:= jump[ pos ][1];
          if file = fail or file = "*stdin*"
                         or not IsReadableFile( file ) then
            # Show the code in a pager.
            lines:= "";
            stream:= OutputTextString( lines, true );
            PrintTo( stream, func );
            CloseStream( stream );
          else
            # Show the file in a pager.
            lines:= rec( lines:= StringFile( file ),
                         start:= StartlineFunc( func ) );
          fi;
          if BrowseData.IsDoneReplay( t.dynamic.replay ) then
            NCurses.Pager( lines );
            NCurses.update_panels();
            NCurses.doupdate();
            NCurses.curs_set( 0 );
          fi;
        fi;
        return t.dynamic.changed;
      end );

    # Construct the browse table.
    t:= rec(
      work:= rec(
        align:= "tl",
        header:= t -> BrowseData.HeaderWithRowCounter( t,
                   Concatenation( "Variables of the GAP Package ", pkgname ),
                   Length( matrix ) ),
        main:= matrix,
        labelsCol:= [ [ rec( rows:= [ "Kind" ], align:= "l" ),
                        rec( rows:= [ "Name" ], align:= "l" ),
                        rec( rows:= [ "Doc.?" ], align:= "c" ),
                        rec( rows:= [ "Filename" ], align:= "l" ),
        ] ],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= [ "| ", " | ", " | ", " | ", " |" ],
#       sepCategories:= "",
# problem: first contents rows are not high enough!
        widthCol:= [ ,,, namewidth,, 5,, filenamewidth ],
        SpecialGrid:= BrowseData.SpecialGridLineDraw,

        CategoryValues:= function( t, i, j )
          if j = 6 then
            return [ BrowseData.ReplacedEntry( t.work.main[ i/2 ][3].rows[1],
                         [ "-", "+" ], [ "undocumented", "documented" ] ) ];
          else
            return t.work.main[ i/2 ][ j/2 ].rows;
          fi;
        end,

        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),
      ),
      dynamic:= rec(
        initialSteps:= "scsc",
      ),
    );

    # Customize the sort parameters.
    BrowseData.SetSortParameters( t, "column", 1,
        [ "add counter on categorizing", "yes" ] );

    # Show the browse table.
    NCurses.BrowseGeneric( t );
end );


#############################################################################
##
#E

