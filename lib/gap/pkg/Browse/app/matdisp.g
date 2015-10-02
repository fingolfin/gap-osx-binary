#############################################################################
##
#W  matdisp.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2011,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  NCurses.BrowseDenseList( <list>, <arec> )
#M  Browse( <list> )
##
##  <#GAPDoc Label="Matrix_section">
##  <Section Label="sec:matrixdisp">
##  <Heading>Matrix Display</Heading>
##
##  The &GAP; library provides several <Ref Oper="Display" BookName="ref"/>
##  methods for matrices.
##  In order to cover the functionality of these methods,
##  &Browse; provides the function <Ref Func="NCurses.BrowseDenseList"/>
##  that uses the standard facilities of the function
##  <Ref Func="NCurses.BrowseGeneric"/>, i.&nbsp;e.,
##  one can scroll in the matrix, searching and sorting are provided etc.
##  <P/>
##  The idea is to customize this function for different special cases,
##  and to install corresponding <Ref Oper="Browse"/> methods.
##  Examples are methods for matrices over finite fields and residue
##  class rings of the rational integers,
##  see <Ref Meth="Browse" Label="for a list of lists"/>.
##  <P/>
##  The code can be found in the file <F>app/matdisp.g</F> of the package.
##
##  <ManSection>
##  <Func Name="NCurses.BrowseDenseList" Arg="list, arec"/>
##
##  <Returns>
##  nothing.
##  </Returns>
##
##  <Description>
##  Let <A>list</A> be a dense list whose entries are lists,
##  for example a matrix, and let <A>arec</A> be a record.
##  This function displays <A>list</A> in a window, as a two-dimensional
##  array with row and column positions as row and column labels,
##  respectively.
##  <P/>
##  The following components of <A>arec</A> are supported.
##  <List>
##  <Mark><C>header</C></Mark>
##  <Item>
##    If bound, the value must be a valid value of the <C>work.header</C>
##    component of a browse table,
##    see <Ref Func="BrowseData.IsBrowseTable"/>;
##    for example, the value can be a list of strings.
##    If this component is not bound then the browse table has no header.
##  </Item>
##  <Mark><C>convertEntry</C></Mark>
##  <Item>
##    If bound, the value must be a unary function that returns a string
##    describing its argument.
##    The default is the operation <Ref Func="String" BookName="ref"/>.
##    Another possible value is <C>NCurses.ReplaceZeroByDot</C>, which
##    returns the string <C>"."</C> if the argument is a zero element
##    in the sense of <Ref Func="IsZero" BookName="ref"/>,
##    and returns the <Ref Func="String" BookName="ref"/> value otherwise.
##    For each entry in a row of <A>list</A>, the <C>convertEntry</C> value
##    is shown in the browse table.
##  </Item>
##  <Mark><C>labelsRow</C></Mark>
##  <Item>
##    If bound, the value must be a list of row label rows for
##    <A>list</A>, as described in Section
##    <Ref Func="BrowseData.IsBrowseTable"/>.
##    The default is <C>[ [ "1" ], [ "2" ], ... ]</C>.
##  </Item>
##  <Mark><C>labelsCol</C></Mark>
##  <Item>
##    If bound, the value must be a list of column label rows for
##    <A>list</A>, as described in Section
##    <Ref Func="BrowseData.IsBrowseTable"/>.
##    The default is <C>[ [ "1", "2", ... ] ]</C>.
##  </Item>
##  </List>
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  </Description>
##  </ManSection>
##
##  <ManSection>
##  <Meth Name="Browse" Arg="list" Label="for a list of lists"/>
##
##  <Returns>
##  nothing.
##  </Returns>
##
##  <Description>
##  Several methods for the operation <Ref Oper="Browse"/> are installed for
##  the case that the argument is a list of lists.
##  These methods cover a default method for lists of lists and the
##  <Ref Oper="Display" BookName="ref"/> methods for matrices over
##  finite fields and residue class rings of the rational integers.
##  Note that matrices over finite prime fields, small extension fields, and
##  large extension fields are displayed differently,
##  and the same holds for the corresponding <Ref Oper="Browse"/> methods.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14, 14 ];;
##  gap> input:= Concatenation( n, n, n, "Q" );;  # ``do nothing and quit''
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, Integers ) );
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, GF(3) ) );
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, GF(4) ) );
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, Integers mod 6 ) );
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, GF( NextPrimeInt( 2^16 ) ) ) );
##  gap> BrowseData.SetReplay( input );
##  gap> Browse( RandomMat( 10, 10, GF( 2^20 ) ) );
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
NCurses.ReplaceZeroByDot:= function( val )
    if IsZero( val ) then
      return ".";
    else
      return String( val );
    fi;
    end;

NCurses.BrowseDenseList:= function( list, arec )
      local m, n, r;

      if IsEmpty( list ) or not ForAll( list, IsList ) then
        TryNextMethod();
      fi;

      m:= Length( list );
      n:= Maximum( List( list, Length ) );

      # Create the default table.
      r:= rec(
        work:= rec(
          align:= "c",

          # Avoid computing strings for all entries in advance.
          main:= [],
          Main:= function( t, i, j )
            if IsBound( list[i][j] ) then
              return r.work.convertEntry( list[i][j] );
            else
              return "";
            fi;
          end,
          m:= m,
          n:= n,

          labelsRow:= List( [ 1 .. m ], i -> [ String( i ) ] ),
          labelsCol:= [ List( [ 1 .. n ], String ) ],
          sepLabelsCol:= [ "", "-" ],
          sepLabelsRow:= [ "", " |" ],
          sepCol:= Concatenation( List( [ 1 .. n ], x -> " " ), [ "" ] ),
          SpecialGrid:= BrowseData.SpecialGridLineDrawPlus,
        ),
      );

      # Customize the browse table.
      if IsBound( arec.header ) then
        r.work.header:= arec.header;
      fi;
      if IsBound( arec.labelsRow ) then
        r.work.labelsRow:= arec.labelsRow;
      fi;
      if IsBound( arec.labelsCol ) then
        r.work.labelsCol:= arec.labelsCol;
      fi;
      if IsBound( arec.convertEntry ) then
        r.work.convertEntry:= arec.convertEntry;
      else
        r.work.convertEntry:= String;
#T support a user default
      fi;

      NCurses.BrowseGeneric( r );
    end;


##########################################################################
##
#M  Browse( <list> )
##
##  The default just shows row and column labels.
##  The table has no header, and `String' is used to convert entries.
##
InstallMethod( Browse,
    [ "IsDenseList" ],
    function( list )
      NCurses.BrowseDenseList( list, rec() );
    end );


##########################################################################
##
#M  Browse( <ffe-mat> )
##
##  This method corresponds to the `Display' method from `lib/matrix.gi'
##  that is installed with the condition "IsFFECollColl and IsMatrix".
##
InstallMethod( Browse,
    [ "IsFFECollColl and IsMatrix" ],
    function( m )
    local deg, chr, q, z;

    if Length( m[1] ) = 0 then
      TryNextMethod();
    fi;

    if IsZmodnZObj( m[1][1] ) then
      NCurses.BrowseDenseList( List( m, r -> List( r, i -> i![1] ) ),
          rec( header:= [ Concatenation( "matrix over Integers mod ",
                              String( DataType( TypeObj( m[1][1] ) ) ) ),
                          "" ],
               convertEntry:= NCurses.ReplaceZeroByDot,
             ) );
    else
      # get the degree and characteristic
      deg:= Lcm( List( m, DegreeFFE ) );
      chr:= Characteristic( m[1][1] );

      if deg = 1 then
        # if it is a finite prime field, use integers for display
        NCurses.BrowseDenseList( m,
            rec( header:= [ Concatenation( "matrix over prime field GF(",
                                String( chr ), ")" ), "" ],
                 convertEntry:= function( val )
                   val:= IntFFE( val );
                   if val = 0 then
                     return ".";
                   else
                     return String( val );
                   fi;
                 end,
               ) );
      else
        # if it is a finite extension field, use mixed integers/z notation
        q:= chr^deg;
        z:= Z(q);

        NCurses.BrowseDenseList( m,
            rec( header:= [ Concatenation( "finite field matrix, z = Z(",
                                String( q ), ")" ), "" ],
                 convertEntry:= function( val )
                   if DegreeFFE( val ) = 1 then
                     val:= IntFFE( val );
                     if val = 0 then
                       return ".";
                     else
                       return String( val );
                     fi;
                   else
                     return Concatenation( "z^", String( LogFFE( val, z ) ) );
                   fi;
                 end,
               ) );
      fi;
    fi;
    end );


##########################################################################
##
#M  Browse( <ZmodnZ-mat> )
##
##  This method corresponds to the `Display' method from `lib/matrix.gi'
##  that is installed with the condition
##  "IsZmodnZObjNonprimeCollColl and IsMatrix".
##
InstallMethod( Browse,
    [ "IsZmodnZObjNonprimeCollColl and IsMatrix" ],
    function( m )
    local deg, chr, q, z;

    if Length( m[1] ) = 0 then
      TryNextMethod();
    fi;

    NCurses.BrowseDenseList( List( m, r -> List( r, i -> i![1] ) ),
        rec( header:= [ Concatenation( "matrix over Integers mod ",
                            String( DataType( TypeObj( m[1][1] ) ) ) ),
                        "" ],
             convertEntry:= NCurses.ReplaceZeroByDot,
           ) );
    end );


##########################################################################
##
#M  Browse( <ffe-mat> )
##
##  This method corresponds to the `Display' method from `lib/ffeconway.gi'
##  that is installed with the condition "IsFFECollColl and IsMatrix".
##
InstallMethod( Browse,
    [ "IsFFECollColl and IsMatrix" ], 10, # prefer this to existing method
    function(m)
    local deg, chr;

    if Length( m ) = 0 or Length( m[1] ) = 0 then
      TryNextMethod();
    fi;

    deg:= Lcm( List( m, DegreeFFE ) );
    chr:= Characteristic( m[1][1] );
    if deg = 1 or chr^deg <= MAXSIZE_GF_INTERNAL then
      TryNextMethod();
    fi;

    NCurses.BrowseDenseList( m,
        rec( header:= [ Concatenation( "finite field matrix, z = Z(",
                            String( chr ), ", ", String( deg ),
                            "); z2 = z^2, etc." ), "" ],
             convertEntry:= function( val )
               local s, y, j, a;

               if IsZero( val ) then
                 return ".";
               else
                 s:= "";
                 y:= FFECONWAY.WriteOverLargerField( val, deg );
                 for j in [ 0 .. deg-1 ] do
                   a:= IntFFE( y![1][j+1] );
                   if a <> 0 then
                     if Length( s ) <> 0 then
                       Append( s, "+" );
                     fi;
                     if a <> 1 then
                       Append( s, String( a ) );
                     fi;
                     if j <> 0 then
                       Append( s, "z" );
                       if j <> 1 then
                         Append( s, String( j ) );
                       fi;
                     fi;
                   fi;
                 od;
                 return s;
               fi;
             end ) );
    end );


#############################################################################
##
#E

