#############################################################################
##
#W  filetree.g            GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
##  If the IO package is not installed then an error message is avoided
##  via the following assignment.
##
if not IsBound( IO_stat ) then
  IO_stat:= "dummy";
fi;


#############################################################################
##
#F  BrowseData.DirectoryContents( <startfile> )
##
##  The GAP function `DirectoryContents' runs into an error when the
##  directory cannot be opened.
##
BrowseData.DirectoryContents:= function( startfile )
    local files;

    files:= STRING_LIST_DIR( USER_HOME_EXPAND( startfile ) );
    if files = fail then
      return fail;
    fi;
    return SplitStringInternal( files, "", "\000" );
end;


#############################################################################
##
#F  BrowseData.DirectoryTree( <startpath>, <filename>, <inoknown> )
##
##  This function is called by `BrowseDirectory'
##  The return value is a list [ name, files, [ entry1, ..., entryn ] ],
##  where entryi is a list of the same structure or a string (denoting a
##  file name that is not a directory)
##
BrowseData.DirectoryTree:= function( startpath, filename, inoknown )
    local startfile, ino, files, nondirs, dirs, startdir, file;

    startfile:= Filename( Directory( startpath ), filename );
    if not IsExistingFile( startfile ) then
      return fail;
    elif IsDirectoryPath( startfile ) then
      ino:= IO_stat( startfile ).ino;
      if ino in inoknown then
        return Concatenation( filename, " (link to a file met already)" );
      fi;
      AddSet( inoknown, ino );
      files:= BrowseData.DirectoryContents( startfile );
      if files = fail then
        return fail;
      fi;
      files:= Filtered( files, x -> not x in [ ".", ".." ] );
      Sort( files );
      nondirs:= [];
      dirs:= [];
      startdir:= Directory( startfile );
      for file in files do
        # `Filename' runs into an error if the name contains `\' or `:'.
        if not ( '\\' in file or ':' in file ) then
          if IsDirectoryPath( Filename( startdir, file ) ) then
            Add( dirs, file );
          else
            Add( nondirs, file );
          fi;
        fi;
      od;
      return [ filename, nondirs,
               List( dirs, x -> BrowseData.DirectoryTree( startfile, x,
                                    ShallowCopy( inoknown ) ) ) ];
    else
      return filename;
    fi;
end;

if IsString( IO_stat ) then
  Unbind( IO_stat );
fi;


#############################################################################
##
#F  BrowseDirectory( [<startpath>] )
##
##  <#GAPDoc Label="Filetree_section">
##  <Section Label="sec:filetree">
##  <Heading>Navigating in a Directory Tree</Heading>
##
##  A natural way to visualize the contents of a directory is via a tree
##  whose leaves denote plain files,
##  and the other vertices denote subdirectories.
##  &Browse; provides a function based on <Ref Func="NCurses.BrowseGeneric"/>
##  for displaying such trees;
##  the leaves correspond to the data rows, and the other vertices correspond
##  to category rows.
##
##  <ManSection>
##  <Func Name="BrowseDirectory" Arg="[startpath]"/>
##
##  <Returns>
##  a list of the <Q>clicked</Q> filenames.
##  </Returns>
##
##  <Description>
##  If no argument is given then the contents of the current directory is
##  shown, see <Ref Func="DirectoryCurrent" BookName="ref"/>.
##  If a string <A>startpath</A> is given as the only argument then it is
##  understood as a directory path,
##  in the sense of <Ref Oper="Directory" BookName="ref"/>,
##  and the contents of this directory is shown.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "q",                                  # leave the selection
##  >        "X",                                  # expand all categories
##  >        "/filetree", [ NCurses.keys.ENTER ],  # search for "filetree"
##  >        n, "Q" ) );                           # and quit
##  gap> dir:= Filename( DirectoriesPackageLibrary( "Browse", "" ), "" );;
##  gap> if IsBound( BrowseDirectory ) then
##  >      BrowseDirectory( dir );
##  >    fi;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The browse table has a static header, no footer, no row or column labels,
##  and exactly one data column.
##  The category rows are precomputed, i.&nbsp;e.,
##  they do not arise from a table column.
##  The tree structure is visualized via a special grid that is shown in the
##  separator column in front of the table column; the width of this column
##  is computed from the largest nesting depth of files.
##  For technical reasons,
##  category rows representing <E>empty</E> directories
##  are realized via <Q>dummy</Q> table rows; a special <C>ShowTables</C>
##  function guarantees that these rows are always hidden.
##  <P/>
##  When a data row or an entry in this row is selected,
##  <Q>click</Q> adds the corresponding filename to the result list.
##  Initially, the first row is selected.
##  (So if you want to search in the whole tree then you should quit this
##  selection by hitting the <B>q</B> key.)
##  <P/>
##  The category hierarchy is computed using
##  <Ref Func="DirectoryContents" BookName="ref"/>.
##  <P/>
##  This function is available only if the &GAP; package
##  <Package>IO</Package> (see&nbsp;<Cite Key="IO"/>) is available,
##  because the check for cycles uses the function
##  <Ref Func="IO_stat" BookName="io"/> from this package.
##  <P/>
##  The code can be found in the file <F>app/filetree.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseDirectory", function( arg )
    local startpath, data, width, cats, files, paths, hidden, i, maxdepth,
          sep, evaltree, show, modes, mode, isCollapsedRow, sel_action,
          collapse;

    if   Length( arg ) = 0 then
      startpath:= ".";
    elif Length( arg ) = 1 then
      startpath:= arg[1];
    else
      Error( "usage: BrowseDirectory( [<startpath>] )" );
    fi;

    data:= BrowseData.DirectoryTree( startpath, "", [] );
    if data = fail then
      Error( "<startpath> does not describe a readable directory" );
    fi;

    width:= NCurses.getmaxyx( 0 )[2];
    cats:= [];
    files:= [];
    paths:= [];
    hidden:= [];
    i:= 1;
    maxdepth:= 1;
    sep:= "";

    evaltree:= function( tree, depth, path )
      local subtree, file;

      if maxdepth < depth then
        maxdepth:= maxdepth + 1;
      fi;
      if IsString( tree ) then
        Add( files, [ rec( align:= "l", rows:= [ tree ] ) ] );
        Add( paths, Concatenation( path, "/", tree ) );
        i:= i + 1;
      else
        Add( cats, rec( pos:= 2*i,
                        level:= depth,
                        value:= tree[1],
                        separator:= sep,
                        isUnderCollapsedCategory:= false,
                        isRejectedCategory:= false ) );
        for file in tree[2] do
          Add( files, [ rec( align:= "l", rows:= [ file ] ) ] );
          Add( paths, Concatenation( path, "/", file ) );
          i:= i + 1;
        od;
        if IsEmpty( tree[2] ) then
          Add( files, [ rec( align:= "l", rows:= [ "HIDDEN ROW" ] ) ] );
          Add( paths, "DUMMY" );
          Add( hidden, 2*i );
          Add( hidden, 2*i+1 );
          i:= i + 1;
        fi;
        if tree[3] <> fail then
          for subtree in tree[3] do
            evaltree( subtree, depth + 1,
                      Concatenation( path, "/", subtree[1] ) );
          od;
        fi;
      fi;
    end;

    evaltree( data, 1, startpath );
    cats[1].value:= startpath;

    # Provide a `ShowTables' function that hides the dummy rows.
    show:= function( t )
      local hiddenrow, indexrow, i, pos;

      hiddenrow:= t.dynamic.isCollapsedRow;
      indexrow:= t.dynamic.indexRow;
      for i in hidden do
        for pos in [ 1 .. Length( indexrow ) ] do
          if indexrow[ pos ] = i then
            hiddenrow[ pos ]:= true;
          fi;
        od;
      od;
      BrowseData.ShowTables( t );
    end;

    # Adjust the mode records.
    modes:= List( BrowseData.defaults.work.availableModes,
                  BrowseData.ShallowCopyMode );
    for mode in modes do
      mode.ShowTables:= show;
    od;

    isCollapsedRow:= List( [ 1 .. 2*Length( files ) + 1 ], x -> true );
    isCollapsedRow[1]:= false;

    sel_action:= rec(
      helplines:= [ "add the filename to the result list" ],
      action:= function( t ) 
      local pos;

      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
        if not paths[ pos ] in t.dynamic.Return then
          Add( t.dynamic.Return, paths[ pos ] );
        fi;
      fi;
    end );

    collapse:= List( [ 1 .. maxdepth ],
        i -> Concatenation( [ RepeatedString( ' ', 2 * ( i-1 ) ) ],
                            [ NCurses.attrs.BOLD, true ] ) );

    # Construct and show the browse table.
    return NCurses.BrowseGeneric( rec(
      work:= rec(
        align:= "tl",
        header:= [ [ NCurses.attrs.UNDERLINE, true, "Directory contents of ",
                     startpath ], "" ],
        main:= files,
        sepCol:= [ ListWithIdenticalEntries( maxdepth, ' ' ), "" ],
        widthCol:= [ 2 * maxdepth, width - 2 * maxdepth, 0 ],
        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),
        sepCategories:= sep,
        startCollapsedCategory:= collapse,
        startExpandedCategory:= collapse,
        availableModes:= modes,
        SpecialGrid:= BrowseData.SpecialGridTreeStyle,
      ),
      dynamic:= rec(
        initialSteps:= [ 115, 114 ],
        categories:= [ List( cats, x -> x.pos ), cats, [] ],
        activeModes:= [ First( modes, x -> x.name = "browse" ) ],
        isCollapsedRow:= isCollapsedRow,
        Return:= [],
      ),
    ) );
end );


#############################################################################
##
#E

