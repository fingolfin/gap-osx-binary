#############################################################################
##
#W  packages.g            GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,   RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseGapPackages()
##
##  The code looks a bit clumsy:
##  <List>
##  <Item>
##    Essentially no assumption can be made about the components of the
##    records in the lists stored in <C>GAPInfo.PackagesInfo</C>,
##    since non-public packages may be involved.
##    (We do use the component <C>PackageName</C>.)
##  </Item>
##  <Item>
##    In order to deal with encoding problems concerning the contents of the
##    <F>PackageInfo.g</F> files,
##    which may involve unicode characters such as umlauts, 
##    an explicit encoding is performed for those components that may
##    contain non-ASCII characters.
##  </Item>
##  </List>
##
BindGlobal( "BrowseGapPackages", function()
    local dependencies, ps, lowernames, needed, suggested, maxauthorswidth,
          maxdescriptionwidth, packages, authorswidth, i, name, r, auth, pr,
          description, year, status, version, categories, sel_action, table,
          ret, result, pos;

    dependencies:= function( lowernames, comp )
      local names, dependent, nam, r, closures, changed, i, next, j;

      names:= List( lowernames,
                    nam -> GAPInfo.PackagesInfo.( nam )[1].PackageName );
      dependent:= [];
      for nam in lowernames do
        r:= GAPInfo.PackagesInfo.( nam )[1];
        if IsBound( r.Dependencies ) and
           IsBound( r.Dependencies.( comp ) ) then
          Add( dependent, List( r.Dependencies.( comp ),
                                x -> LowercaseString( x[1] ) ) );
        else
          Add( dependent, [] );
        fi;
      od;
      closures:= List( dependent, l -> Intersection( l, lowernames ) );
      changed:= true;
      while changed do
        changed:= false;
        for i in [ 1 .. Length( closures ) ] do
          next:= Union( List( closures[i],
                          nam -> closures[ Position( lowernames, nam ) ] ) );
          if not IsSubset( closures[i], next ) then
            changed:= true;
            UniteSet( closures[i], next );
          fi;
        od;
      od;
      for i in [ 1 .. Length( closures ) ] do
        RemoveSet( closures[i], lowernames[i] );
        for j in [ 1 .. Length( closures[i] ) ] do
          if closures[i][j] in dependent[i] then
            closures[i][j]:= names[ Position( lowernames, closures[i][j] ) ];
          else
            closures[i][j]:= Concatenation( "(",
                names[ Position( lowernames, closures[i][j] ) ], ")" );
          fi;
        od;
      od;
      return closures;
    end;

    ps:= function( str )
      str:= BrowseData.SimplifiedString( str );
      # What follows now is a hack ...
#T is this needed at all?
      str:= ReplacedString( str, "&auml;", "ae" );
      str:= ReplacedString( str, "&ouml;", "oe" );
      str:= ReplacedString( str, "&uuml;", "ue" );

      return str;
    end;

    lowernames:= RecNames( GAPInfo.PackagesInfo );
    needed:= dependencies( lowernames, "NeededOtherPackages" );
    suggested:= dependencies( lowernames, "SuggestedOtherPackages" );

    maxauthorswidth:= 35;
    maxdescriptionwidth:= 35;

    # Evaluate the package information.
    packages:= [];
    authorswidth:= 0;
    for i in [ 1 .. Length( lowernames ) ] do
      name:= lowernames[i];
      r:= GAPInfo.PackagesInfo.( name )[1];
      auth:= [];
      if IsBound( r.Persons ) and IsList( r.Persons ) then
        for pr in r.Persons do
          if ( ( IsBound( pr.IsAuthor ) and pr.IsAuthor = true ) or
               ( IsBound( pr.IsMaintainer ) and pr.IsMaintainer = true ) ) and
             IsBound( pr.LastName ) and IsBound( pr.FirstNames ) and
             IsString( pr.LastName ) and IsString( pr.FirstNames ) then
            Add( auth, Concatenation( pr.LastName, ", ", pr.FirstNames ) );
          fi;
        od;
      fi;
      if IsEmpty( auth ) then
        auth:= [ "(unknown)" ];
      fi;
      authorswidth:= Maximum( authorswidth,
                              MaximumList( List( auth, Length ) ) );
      if maxauthorswidth < authorswidth then
        authorswidth:= maxauthorswidth;
        auth:= Concatenation( List( auth, l -> SplitString(
          FormatParagraph( BrowseData.SimplifiedString( l ),
                           maxauthorswidth, "left" ),
          "\n" ) ) );
      fi;
      if IsBound( r.Subtitle ) and IsString( r.Subtitle ) then
        description:= SplitString( FormatParagraph( r.Subtitle,
                                     maxdescriptionwidth,
                                     "left" ), "\n" );
      else
        description:= [ "(no Subtitle)" ];
      fi;
      if IsBound( r.Date ) and IsString( r.Date ) then
        year:= r.Date;
        while '/' in year do
          year:= year{ [ Position( year, '/' ) + 1 .. Length( year ) ] };
        od;
      else
        year:= "????";
      fi;
      if IsBound( r.Status ) then
        status:= r.Status;
      else
        status:= "(unknown)";
      fi;
      if IsBound( r.Version ) then
        version:= r.Version;
      else
        version:= "(unknown)";
      fi;
      Add( packages, [ rec( rows:= [ r.PackageName ], align:= "tl" ),
                rec( rows:= List( auth, ps ), align:= "tl" ),
                rec( rows:= List( description, ps ), align:= "tl" ),
                rec( rows:= List( needed[i], ps ), align:= "tl" ),
                rec( rows:= List( suggested[i], ps ), align:= "tl" ),
                status,
                version,
                year,
              ] );
    od;

    categories:= function( entries, verb )
      local cats, entry;

      if Length( entries ) = 0 then
        return [ Concatenation( "(packages ", verb, " no other package)" ) ];
      else
        cats:= [];
        for entry in entries do
          if entry[1] = '(' then
            Add( cats, Concatenation( "packages ", verb, " ",
                           entry{ [ 2 .. Length( entry )-1 ] },
                           " indirectly" ) );
          else
            Add( cats, Concatenation( "packages ", verb, " ",
                           entry, " directly" ) );
          fi;
        od;
      fi;

      return cats;
    end;

    sel_action:= rec(
      helplines:= [ "add the XML entry to the result list" ],
      action:= function( t )
      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        Add( t.dynamic.Return,
             t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2 );
      fi;
    end );

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= t -> BrowseData.HeaderWithRowCounter( t, "GAP Packages",
                          Length( packages ) ),
        CategoryValues:= function( t, i, j )
          if   j = 8 then
            return categories( t.work.main[ i/2 ][4].rows, "needing" );
          elif j = 10 then
            return categories( t.work.main[ i/2 ][5].rows, "suggesting" );
          else
            return BrowseData.defaults.work.CategoryValues( t, i, j );
          fi;
        end,

        main:= packages,
        labelsCol:= [ [ rec( rows:= [ "name" ], align:= "l" ),
                        rec( rows:= [ "authors/maintainers" ], align:= "l" ),
                        rec( rows:= [ "description" ], align:= "l" ),
                        rec( rows:= [ "needed" ], align:= "l" ),
                        rec( rows:= [ "suggested" ], align:= "l" ),
                        rec( rows:= [ "status" ], align:= "r" ),
                        rec( rows:= [ "version" ], align:= "r" ),
                        rec( rows:= [ "year" ], align:= "r" ),
        ] ],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= [ "| ", " | ", " | ", " | ", " | ", " | ", " | ", " | ",
                   " |" ],

        # Set widths for the authors and description columns.
        widthCol:= [ ,,, authorswidth,, maxdescriptionwidth ],
        SpecialGrid:= BrowseData.SpecialGridLineDraw,
        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),
      ),
      dynamic:= rec(
        Return:= [],
      ),
    );

    # Customize the sort parameters for the authors, needed, suggested,
    # and year columns.
    BrowseData.SetSortParameters( table, "column", 2,
        [ "hide on categorizing", "no",
          "add counter on categorizing", "yes",
          "split rows on categorizing", "yes" ] );
    BrowseData.SetSortParameters( table, "column", 4,
        [ "hide on categorizing", "no",
          "add counter on categorizing", "yes",
          "split rows on categorizing", "yes" ] );
    BrowseData.SetSortParameters( table, "column", 5,
        [ "hide on categorizing", "no",
          "add counter on categorizing", "yes",
          "split rows on categorizing", "yes" ] );
    BrowseData.SetSortParameters( table, "column", 8,
        [ "direction", "descending",
          "add counter on categorizing", "yes" ] );

    # Show the table.
    ret:= DuplicateFreeList( NCurses.BrowseGeneric( table ) );
    result:= rec( entries:= [],
                  strings:= [],
                  entities:= [] );

    # Construct the return value (see `BrowseBibliography').
    if not IsEmpty( ret ) then
      for pos in ret do
        ParseBibXMLextString( BibEntry( lowernames[ pos ] ), result ); 
      od;
    fi;

    return result;
end );


BrowseGapDataAdd( "GAP Packages", BrowseGapPackages, true, "\
the list of installed GAP packages, \
shown in a browse table whose columns contain the package name, \
the names of author/maintainers, \
a short description, \
the needed and the suggested other packages, \
status, version, and relearse year; \
the information is extracted from the PackageInfo.g files of the packages; \
the return value is a record encoding the bibliography entries \
of the clicked packages, \
in the same format as the return value of BrowseBibliography" );


#############################################################################
##
#E

