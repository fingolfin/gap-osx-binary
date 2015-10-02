##############################################################################
##
##  Assume that the old version (which may be hand edited) of the bibliography
##  is stored in `gap-publishednicer.bib',
##  and that the new version (from St Andrews)
##  is stored in `gap-publishednicer.bib.new'.
##
##  The old version is renamed to `gap-publishednicer.bib~',
##  and a corrected version of the new version (using the entries in the old
##  version) is written to `gap-publishednicer.bib'.
##
CorrectGAPBibliography:= function()
    local dirs, fileold, filenew, parseold, parsenew, valid, entry, oldentry,
          stringnew, pos, sc;

    dirs:= DirectoriesPackageLibrary( "Browse", "bibl" );
    fileold:= Filename( dirs, "gap-publishednicer.bib" );
    filenew:= Filename( dirs, "gap-publishednicer.bib.new" );

    parseold:= ParseBibFiles( fileold );
    parsenew:= ParseBibFiles( filenew );

    valid:= [];
    for entry in parsenew[1] do
      if StringBibAsXMLext( entry, parsenew[2], parsenew[3] ) = fail then
#T is there another function just for this purpose?
        # Check if the old file contains a valid entry with the same key,
        # and if yes then take this one.
        oldentry:= First( parseold[1], r -> r.Label = entry.Label );
        if oldentry <> fail and
           StringBibAsXMLext( oldentry, parseold[2], parseold[3] ) <> fail then
          Print( "#I  replacing invalid entry '", entry.Label, "'\n" );
          Add( valid, oldentry );
        else
          Print( "#E  omitting invalid entry '", entry.Label, "'\n" );
        fi;
      else
        # Take this entry, no matter whether the old file contains it.
        Add( valid, entry );
      fi;
    od;

    SortParallel(List(valid, x-> x.Label), valid);
    Exec( Concatenation( "mv ", fileold, " ", fileold, "~" ) );
    WriteBibFile( fileold, [ valid, parsenew[2], parsenew[3] ] );

    stringnew:= StringFile( filenew );;
    pos:= PositionSublist( stringnew, "\n%%%%%" );
    if pos <> fail then
      sc:= SizeScreen();
      SizeScreen( [ 200 ] );
      AppendTo( fileold, stringnew{ [ pos+1 .. Length( stringnew ) ] } );
      SizeScreen( sc );
    fi;
end;

