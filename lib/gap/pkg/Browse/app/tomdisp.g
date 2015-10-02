#############################################################################
##
#W  tomdisp.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#M  Browse( <tom>[, <options>] )
##
##  <#GAPDoc Label="Tom_section">
##  <Section Label="sec:tomdisp">
##  <Heading>Table of Marks Display</Heading>
##
##  The &GAP; library provides a <Ref Oper="Display" BookName="ref"/> method
##  for tables of marks
##  that breaks the table into columns fitting on the screen.
##  Similar to the situation with character tables,
##  see Section&nbsp;<Ref Sect="sec:ctbldisp"/>,
##  but with a much simpler implementation, &Browse; provides an alternative
##  based on the function <Ref Func="NCurses.BrowseGeneric"/>.
##  <P/>
##  <Ref Oper="Browse"/> can be called instead of
##  <Ref Oper="Display" BookName="ref"/> for tables of marks,
##  cf.&nbsp;<Ref Sect="Printing Tables of Marks" BookName="ref"/>.
##
##  <ManSection>
##  <Meth Name="Browse" Arg="tom[, options]" Label="for tables of marks"/>
##
##  <Description>
##  This method displays the table of marks <A>tom</A> in a window.
##  The optional record <A>options</A> describes what shall be displayed,
##  the supported components and the default values are described
##  in&nbsp;<Ref Sect="Printing Tables of Marks" BookName="ref"/>.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> if TestPackageAvailability( "TomLib" ) = true then
##  >      BrowseData.SetReplay( Concatenation(
##  >         # scroll in the table
##  >         "DDRRR",
##  >         # search for the (exact) value 100 (three times)
##  >         "/100",
##  >         [ NCurses.keys.DOWN, NCurses.keys.DOWN, NCurses.keys.RIGHT ],
##  >         [ NCurses.keys.DOWN, NCurses.keys.DOWN, NCurses.keys.DOWN ],
##  >         [ NCurses.keys.RIGHT, NCurses.keys.ENTER ], "nn",
##  >         # no more occurrences of 100, confirm
##  >         [ NCurses.keys.ENTER ],
##  >         # and quit the application
##  >         "Q" ) );
##  >      Browse( TableOfMarks( "A10" ) );
##  >      BrowseData.SetReplay( false );
##  >    fi;
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  Rows and columns are indexed by their positions.
##  The identifier of the table is used as the static header,
##  there is no footer.
##  <P/>
##  In order to keep the required space small also for large tables of marks,
##  caching of formatted matrix entries is disabled, and the
##  strings to be displayed are computed on demand with a <C>Main</C>
##  function in the <C>work</C> component of the browse table.
##  For the same reason, the constant height one for the table rows is set
##  in advance.
##  (For example, the table of marks of the group with identifier
##  <C>"O8+(2)"</C>, with <M>11171</M> rows and columns,
##  can be shown with <Ref Oper="Browse"/> in a &GAP; session requiring about
##  <M>100</M> MB.)
##  <P/>
##  The code can be found in the file <F>app/tomdisp.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
InstallMethod( Browse,
    [ "IsTableOfMarks" ],
    function( tom )
    Browse( tom, rec() );
    end );

InstallMethod( Browse,
    [ "IsTableOfMarks", "IsRecord" ],
    function( tom, options )
    local subs, ll, classes, vals, wt, i, heights;

    # Set default values.
    subs:= SubsTom( tom );
    ll:= Length(subs);
    classes:= [ 1 .. ll ];

    # Adjust parameters.
    if IsBound( options.classes ) and IsList( options.classes ) then
      classes:= options.classes;
    fi;
    if IsBound( options.form ) then
      if options.form = "supergroups" then
        vals:= ShallowCopy( vals );
        wt:= WeightsTom( tom );
        for i in [ 1 .. ll ] do
          vals[i]:= vals[i] / wt[i];
        od;
      elif options.form = "subgroups" then
        vals:= NrSubsTom( tom );
      fi;
    else
      vals:= MarksTom( tom );
    fi;

    heights:= ListWithIdenticalEntries( 2 * Length( classes ) + 1, 0 );
    for i in [ 2, 4 .. 2 * Length( classes ) ] do
      heights[i]:= 1;
    od;

    # Construct and show the browse table.
    NCurses.BrowseGeneric( rec(
      work:= rec(
        align:= "ct",
        header:= [ Identifier( tom ) ],
        CategoryValues:= function( t, i, j )
          return [ Concatenation( String( j/2 ), " = ",
                       t.work.Main( t, i/2, j/2 ) ) ];
          end,

        # Avoid computing strings for all entries in advance.
        main:= [],
        Main:= function( t, i, j )
          local pos;

          pos:= Position( subs[ classes[i] ], classes[j] );
          if pos = fail then
            return ".";
          else
            return String( vals[ classes[i] ][ pos ] );
          fi;
          end,
        m:= Length( classes ),
        n:= Length( classes ),

        labelsRow:= List( classes,
                          x -> [ Concatenation( String( x ), ": " ) ] ),
        labelsCol:= [ List( classes, String ) ],
        sepLabelsRow:= [ "" ],
        sepLabelsCol:= [],
        sepCol:= [ " " ],

        # Avoid computing all entries in a row for determining the heights.
        heightRow:= heights,

        corner := [],
      ),
      dynamic:= rec(
        sortFunctionForTableDefault:= BrowseData.CompareCharacterValues,
        sortFunctionForColumnsDefault:= BrowseData.CompareCharacterValues,
        sortFunctionForRowsDefault:= BrowseData.CompareCharacterValues,
      ),
    ) );
    end );


#############################################################################
##
#E

