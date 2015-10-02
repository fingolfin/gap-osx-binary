#############################################################################
##
#W  gapdata.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseGapData()
##
##  <#GAPDoc Label="GAPData_section">
##  <Section Label="sec:datadisp">
##  <Heading>Overview of &GAP; Data</Heading>
##
##  The &GAP; system contains several data collections such as libraries of
##  groups and character tables.
##  Clearly the function <Ref Func="NCurses.BrowseGeneric"/> can be used to
##  visualize interesting information about such data collections,
##  in the form of an <Q>overview table</Q> whose rows correspond to the
##  objects in the collection;
##  each column of the table shows a piece of information about the objects.
##  (One possibility to create such overviews is given by
##  <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>.)
##
##  <ManSection>
##  <Func Name="BrowseGapData" Arg=""/>
##
##  <Returns>
##  the return value of the chosen application if there is one.
##  </Returns>
##  <Description>
##  The function <Ref Func="BrowseGapData"/> shows the choices in the list
##  <C>BrowseData.GapDataOverviews</C>, in a browse table with one column.
##  When an entry is <Q>clicked</Q> then the associated function is called,
##  and the table of choices is closed.
##  <P/>
##  The idea is that each entry of <C>BrowseData.GapDataOverviews</C>
##  describes an overview of a data collection.
##  <P/>
##  The &Browse; package provides overviews of
##  <List>
##  <Item>
##      the current AMS Mathematics Subject Classification codes
##      (see <Ref Func="BrowseMSC"/>),
##  </Item>
##  <Item>
##      the contents of the <Package>AtlasRep</Package> package
##      <Cite Key="AtlasRep"/> (only if this package is loaded,
##      see Section&nbsp;<Ref Sect="sec:atlasdisp"/>),
##  </Item>
##  <Item>
##      <Index Key="BrowseConwayPolynomials" Subkey="see BrowseGapData">
##      <C>BrowseConwayPolynomials</C></Index>
##      the Conway polynomials in &GAP;
##      (calls <C>BrowseConwayPolynomials()</C>),
##  </Item>
##  <Item>
##      profile information for &GAP; functions
##      (see Section&nbsp;<Ref Sect="sec:profiledisp"/>),
##  </Item>
##  <Item>
##      the list of &GAP; related bibliography entries in the file
##      <F>bibl/gap-publishednicer.bib</F> of the <Package>Browse</Package>
##      package
##      (see Section&nbsp;<Ref Sect="sec:gapbibl"/>),
##  </Item>
##  <Item>
##      the &GAP; manuals (see Section&nbsp;<Ref Sect="sec:manualdisp"/>),
##  </Item>
##  <Item>
##      <Index Key="BrowseGapMethods" Subkey="see BrowseGapData">
##      <C>BrowseGapMethods</C></Index>
##      &GAP; operations and methods
##      (calls <C>BrowseGapMethods()</C>),
##  </Item>
##  <Item>
##      <Index Key="BrowseGapPackages" Subkey="see BrowseGapData">
##      <C>BrowseGapPackages</C></Index>
##      the installed &GAP; packages
##      (calls <C>BrowseGapPackages()</C>),
##  </Item>
##  <Item>
##      &GAP;'s user preferences
##      (see Section&nbsp;<Ref Sect="sec:userpref"/>),
##  </Item>
##  <Item>
##      the contents of the <Package>TomLib</Package> package
##      <Cite Key="TomLib"/> (only if this package is loaded,
##      see Section&nbsp;<Ref Sect="sect:tomlibinfo"/>),
##  </Item>
##  <Item>
##      &GAP;'s Library of Transitive Groups
##      (see Section&nbsp;<Ref Sect="sect:transgrps"/>).
##  </Item>
##  </List>
##  <P/>
##  Other &GAP; packages may add more overviews,
##  using the function <Ref Func="BrowseGapDataAdd"/>.
##  For example, there are overviews of
##  <List>
##  <Item>
##      the bibliographies in the <Package>ATLAS</Package> of Finite Groups
##      <Cite Key="CCN85"/> and in the
##      <Package>ATLAS</Package> of Brauer Characters <Cite Key="JLPW95"/>
##      (see
##      <Ref Func="BrowseBibliographySporadicSimple" BookName="atlasrep"/>),
##  </Item>
##  <Item>
##      atomic irrationalities that occur in character tables in the
##      <Package>ATLAS</Package> of Finite Groups <Cite Key="CCN85"/>
##      or the <Package>ATLAS</Package> of Brauer Characters
##      <Cite Key="JLPW95"/> (see
##      Section <Ref Func="BrowseCommonIrrationalities" BookName="ctbllib"/>),
##  </Item>
##  <Item>
##      the differences between the versions of the character table data
##      in the <Package>CTblLib</Package> package (see Section
##      <Ref Func="BrowseCTblLibDifferences" BookName="ctbllib"/>),
##  </Item>
##  <Item>
##      the information in the &GAP; Character Table Library
##      (see Section <Ref Func="BrowseCTblLibInfo" BookName="ctbllib"/>),
##  </Item>
##  <Item>
##      an overview of minimal degrees of representations of groups from the
##      <Package>ATLAS</Package> of Group Representations
##      (see Section <Ref Func="BrowseMinimalDegrees" BookName="atlasrep"/>).
##  </Item>
##  </List>
##  <!-- add reference to the MFER package? -->
##  <!-- as soon as BrowseMOSS becomes public, add it -->
##  <P/>
##  Except that always one table cell is selected,
##  the full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
##  gap> # open the overview of Conway polynomials
##  gap> BrowseData.SetReplay( Concatenation( "/Conway Polynomials",
##  >      [ NCurses.keys.ENTER, NCurses.keys.ENTER ], "srdddd", n, "Q" ) );
##  gap> BrowseGapData();;
##  gap> # open the overview of GAP packages
##  gap> BrowseData.SetReplay( Concatenation( "/GAP Packages",
##  >      [ NCurses.keys.ENTER, NCurses.keys.ENTER ], "/Browse",
##  >      [ NCurses.keys.ENTER ], "n", n, "Q" ) );
##  gap> BrowseGapData();;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The browse table has a static header, a dynamic footer showing the
##  description of the currently selected entry, no row or column labels,
##  and exactly one column of fixed width equal to the screen width.
##  If the chosen application has a return value then this is returned by
##  <Ref Func="BrowseGapData"/>, otherwise nothing is returned.
##  The component <C>work.SpecialGrid</C> of the browse table is used to
##  draw a border around the list of choices and another border around the
##  footer.
##  Only one mode is needed in which an entry is selected.
##  <P/>
##  The code can be found in the file <F>app/gapdata.g</F> of the package.
##  </Description>
##  </ManSection>
##
##  <#Include Label="BrowseGapDataAdd_man">
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseGapData", function()
    local width, height, footers, footerlength, emptyline, table;

    if not IsBound( BrowseData.GapDataOverviews ) then
      return;
    fi;

    width:= NCurses.getmaxyx( 0 )[2] - 4;
    height:= NCurses.getmaxyx( 0 )[1];
    footers:= List( BrowseData.GapDataOverviews,
                    x -> SplitString( FormatParagraph( x[4], width, "left",
                                        [ "  ", "  " ] ), "\n" ) );
    footerlength:= MaximumList( List( footers, Length ) ) + 3;
    emptyline:= ListWithIdenticalEntries( width, ' ' );
    footers:= List( footers, l -> Concatenation( [ emptyline, emptyline ],
                l,  ListWithIdenticalEntries( footerlength - Length( l ) - 3,
                 emptyline ) ) );

    # Construct and show the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= [ "",
                   [ NCurses.attrs.UNDERLINE, true, "GAP Data Overviews" ],
                   "",
                   "" ],
        footer:= t -> footers[ t.dynamic.indexRow[
                                   t.dynamic.selectedEntry[1] ] / 2 ],
        availableModes:= Filtered( BrowseData.defaults.work.availableModes,
                             x -> x.name in [ "select_entry", "help" ] ),
        main:= List( BrowseData.GapDataOverviews,
                     pair -> [ rec( rows:= [ pair[1] ], align:= "tl" ) ] ),
        sepCol:= [ "| ", " |" ],
        widthCol:= [ , width ],
        SpecialGrid:= function( t, data )
          local len;

          len:= data.footerLength + 1;
          data:= data.gridsInfo[1];
          NCurses.Grid( t.dynamic.window,
                        data.trow - 1, data.brow + 1, data.lcol, data.rcol,
                        [ data.trow - 1, data.brow + 1 ],
                        [ data.lcol, data.rcol ] );
          NCurses.Grid( t.dynamic.window,
                        data.brow + 2, data.brow + len, data.lcol, data.rcol,
                        [ data.brow + 2, data.brow + len ],
                        [ data.lcol, data.rcol ] );
        end,
        Click:= rec(
          select_entry:= rec(
            helplines:= [ "start the chosen Browse application" ],
            action:= function( t )
              local oldreplay, replay, currlog, steps, pos;

              # Cut off the done replay part.
              if IsBound( BrowseData.defaults.dynamic.replay ) then
                oldreplay:= BrowseData.defaults.dynamic.replay;
                replay:= t.dynamic.replay;
                currlog:= replay.logs[ replay.pointer ];
                steps:= currlog.steps{ [ currlog.position
                                         .. Length( currlog.steps ) ] };
                BrowseData.SetReplay( steps );
              fi;

              # Quit the current table, and start the application.
              BrowseData.actions.QuitTable.action( t );
              pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
              if BrowseData.GapDataOverviews[ pos ][3] then
                t.dynamic.Return:= BrowseData.GapDataOverviews[ pos ][2]();
              else
                BrowseData.GapDataOverviews[ pos ][2]();
              fi;

              # Reinstall the original replay value.
              if IsBound( oldreplay ) then
                BrowseData.defaults.dynamic.replay:= oldreplay;
              fi;
            end ),
        ),
      ),
      dynamic:= rec(
        selectedEntry:= [ 2, 2 ],
        activeModes:= [ First( BrowseData.defaults.work.availableModes,
                               x -> x.name = "select_entry" ) ],
      ),
    );

    NCurses.BrowseGeneric( table );
    if IsBound( table.dynamic.Return ) then
      return table.dynamic.Return;
    fi;
end );


#############################################################################
##
#E

