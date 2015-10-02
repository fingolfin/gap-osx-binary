#############################################################################
##
#W  tmdbattr.g            GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,   RWTH Aachen,  Germany
##
##  We have to postpone most of the constructions needed by the function
##  `BrowseTomLibInfo' because we need the *value* of `LIBTOMLIST',
##  which is available only after the TomLib package has been completely
##  read.
##  Therefore, we turn `BrowseTomLibInfo' into an autoreadable variable,
##  but we notify it to `BrowseGapData' already before it has been read.
##


#############################################################################
##
#F  BrowseTomLibInfo()
##
##  <#GAPDoc Label="BrowseTomLibInfo_man">
##  <ManSection>
##  <Func Name="BrowseTomLibInfo" Arg=""/>
##
##  <Returns>
##  nothing.
##  </Returns>
##
##  <Description>
##  This function shows the contents of the &GAP; Library of Tables of Marks
##  (the <Package>TomLib</Package> package, see <Cite Key="TomLib"/>)
##  in a browse table.
##  <P/>
##  The first call may take substantial time (about <M>40</M> seconds),
##  because the data files of the <Package>TomLib</Package> package are
##  evaluated.
##  This could be improved by precomputing and caching the values.
##  Another possibility would be to call <Ref Func="BrowseTomLibInfo"/> once
##  before creating a &GAP; workspace.
##  The subsequent calls are not expensive.
##  <P/>
##  The table rows correspond to the tables of marks,
##  one column of row labels shows the identifier of the table.
##  The columns of the table contain information about the group order,
##  the number of conjugacy classes of subgroups,
##  the identifiers of tables of marks with fusions to and from the given
##  table, and the name of the file that contains the table of marks data.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> c:= [ NCurses.keys.ENTER ];;
##  gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "scrrsc",   # categorize the list by source tables of fusions,
##  >        "srdd",     # choose a source table,
##  >        "x",        # expand the list of targets of fusions
##  >        n,
##  >        "!",        # revert the categorization
##  >        "q",        # leave the mode in which a row is selected
##  >        "scrrrrsc", # categorize the list by filenames
##  >        "X",        # expand all categories
##  >        n,
##  >        "!",        # revert the categorization
##  >        "scso",     # sort the list by group order
##  >        n,
##  >        "!q",       # revert the sorting and selection
##  >        "?",        # open the help window
##  >        n,
##  >        "Q",        # close the help window
##  >        "/A5", c,   # search for the first occurrence of "A5"
##  >        n,
##  >        "Q" ) );;   # and quit the browse table
##  gap> BrowseTomLibInfo();
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAutoreadableVariables( "Browse", "app/tmdbatt2.g",
    [ "BrowseTomLibInfo" ] );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "Overview of the GAP Library of Tables of Marks",
    function() BrowseTomLibInfo(); end, false, "\
an overview of the GAP library of tables of marks, \
shown in a browse table whose rows correspond to the tables of marks, \
and whose columns contain information about the group order, \
the number of conjugacy classes of subgroups, \
the identifiers of tables of marks with fusions to and from \
the given table, \
and the name of the file that contains the table of marks data" );


#############################################################################
##
#E

