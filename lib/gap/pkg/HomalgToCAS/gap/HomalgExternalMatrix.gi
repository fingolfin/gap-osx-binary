#############################################################################
##
##  HomalgExternalMatrix.gi   HomalgToCAS package            Mohamed Barakat
##                                                            Simon Goertzen
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg matrices.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( homalgPointer,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( M )
    
    return homalgPointer( Eval( M ) ); ## here we must evaluate
    
end );

##
InstallMethod( homalgExternalCASystem,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystem( R ); ## avoid evaluating the matrix
    else
        return homalgExternalCASystem( Eval( M ) );
    fi;
    
end );

##
InstallMethod( homalgExternalCASystemVersion,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystemVersion( R ); ## avoid evaluating the matrix
    else
        return homalgExternalCASystemVersion( Eval( M ) );
    fi;
    
end );

##
InstallMethod( homalgStream,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgStream( R ); ## avoid evaluating the matrix
    else
        return homalgStream( Eval( M ) );
    fi;
    
end );

##
InstallMethod( homalgExternalCASystemPID,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( M )
    local R;
    
    R := HomalgRing( M );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystemPID( R ); ## avoid evaluating the matrix
    else
        return homalgExternalCASystemPID( Eval( M ) );
    fi;
    
end );

##
InstallMethod( SetMatElm,
        "for homalg external matrices",
        [ IsHomalgMatrix and IsMutable, IsPosInt, IsPosInt, IsHomalgExternalRingElementRep ],
        
  function( M, r, c, s )
    
    SetMatElm( M, r, c, homalgPointer( s ), HomalgRing( M ) );
    
end );

##
InstallMethod( SetMatElm,
        "for homalg external matrices",
        [ IsHomalgMatrix and IsMutable, IsPosInt, IsPosInt, IsHomalgExternalRingElementRep, IsHomalgExternalRingRep ],
        
  function( M, r, c, s, R )
    
    SetMatElm( M, r, c, homalgPointer( s ), R );
    
end );

## MatrixBaseChange to an external ring
InstallMethod( \*,
        "for homalg matrices",
        [ IsHomalgExternalRingRep, IsHomalgMatrix ],
        
  function( R, m )
    local RP, mat;
    
    RP := homalgTable( R );
    
    if not IsIdenticalObj( HomalgRing( m ), R ) and
       IsHomalgExternalRingRep( HomalgRing( m ) ) and
       IsIdenticalObj( homalgStream( HomalgRing( m ) ), homalgStream( R ) ) and
       IsBound( RP!.CopyMatrix ) then	## make a "copy" over a different ring
        
        Eval( m );	## enforce evaluation
        
        mat := HomalgMatrix( R );
        
        ## this is quicker and safer than calling the
        ## constructor HomalgMatrix with all arguments
        SetEval( mat, RP!.CopyMatrix( m, R ) );
        
        BlindlyCopyMatrixProperties( m, mat );
        
        return mat;
        
    fi;
    
    TryNextMethod( );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

##
InstallMethod( ConvertHomalgMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsHomalgRing ],
        
  function( M, R )
    
    if IsBound( M!.ConvertHomalgMatrixViaFile ) and M!.ConvertHomalgMatrixViaFile = false then
        TryNextMethod( );
    elif IsBound( M!.ConvertHomalgMatrixViaSparseString ) and M!.ConvertHomalgMatrixViaSparseString = true then
        return ConvertHomalgMatrixViaSparseString( M, R );
    fi;
    
    return ConvertHomalgMatrixViaFile( M, R );
    
end );

##
InstallMethod( ConvertHomalgMatrix,
        "for homalg matrices",
        [ IsHomalgMatrix, IsInt, IsInt, IsHomalgRing ],
        
  function( M, r, c, R )
    
    if IsBound( M!.ConvertHomalgMatrixViaFile ) and M!.ConvertHomalgMatrixViaFile = false then
        TryNextMethod( );
    elif IsBound( M!.ConvertHomalgMatrixViaSparseString ) and M!.ConvertHomalgMatrixViaSparseString = true then
        return ConvertHomalgMatrixViaSparseString( M, r, c, R );
    fi;
    
    return ConvertHomalgMatrixViaFile( M, R );
    
end );

##
InstallMethod( ConvertHomalgMatrixViaFile,
        "convert an external matrix into an external ring via file saving and loading",
        [ IsHomalgMatrix, IsHomalgRing ],
        
  function( M, RR )
    
    local R, r, c, separator, directory, pointer, pid, file, filename, fs, remove, MM;
    
    R := HomalgRing( M ); # the source ring
    
    r := NrRows( M );
    c := NrColumns( M );
    
    ## figure out the directory separtor:
    if IsBound( GAPInfo.UserHome ) then
        separator := GAPInfo.UserHome[1];
    else
        separator := '/';
    fi;
    
    if IsBound( HOMALG_IO.DirectoryForTemporaryFiles ) then
        directory := HOMALG_IO.DirectoryForTemporaryFiles;
        if directory[Length(directory)] <> separator then
            directory[Length(directory) + 1] := separator;
        fi;
    else
        directory := "";
    fi;
    
    if IsHomalgExternalMatrixRep( M ) then
        pointer := homalgPointer( M );
        pid := Concatenation( "_PID_", String( homalgExternalCASystemPID( R ) ) );
    else
        if IsBound( HOMALG_IO.FileNameCounter ) then
            pointer := Concatenation( "homalg_file_", String( HOMALG_IO.FileNameCounter ) );
            HOMALG_IO.FileNameCounter := HOMALG_IO.FileNameCounter + 1;
        else
            Error( "HOMALG_IO.FileNameCounter is not bound, filename creation for internal object failed.\n" );
        fi;
        
        if not IsBound( HOMALG_IO.PID ) or not IsInt( HOMALG_IO.PID ) then
            HOMALG_IO.PID := 99999; #this is not the real PID!
        fi;
        
        pid := Concatenation( "_PID_", String( HOMALG_IO.PID ) );
        
    fi;
    
    file := Concatenation( pointer, pid );
    
    filename := Concatenation( directory, file );
    
    fs := IO_File( filename, "w" );
    
    if fs = fail then
        if not ( IsBound( HOMALG_IO.DoNotFigureOutAnAlternativeDirectoryForTemporaryFiles ) 
                 and HOMALG_IO.DoNotFigureOutAnAlternativeDirectoryForTemporaryFiles = true ) then
            directory := FigureOutAnAlternativeDirectoryForTemporaryFiles( file );
            if directory <> fail then
                filename := Concatenation( directory, file );
                fs := IO_File( filename, "w" );
            else
                Error( "unable to (find alternative directories to) open the file ", filename, " for writing\n" );
            fi;
        else
            Error( "unable to open the file ", filename, " for writing\n" );
        fi;
        HOMALG_IO.DirectoryForTemporaryFiles := directory;
    fi;
    
    if IO_Close( fs ) = fail then
        Error( "unable to close the file ", filename, "\n" );
    fi;
    
    Exec( Concatenation( "/bin/rm -f \"", filename, "\"" ) );
    
    remove := SaveHomalgMatrixToFile( filename, M );
    
    MM := LoadHomalgMatrixFromFile( filename, r, c, RR ); # matrix in target ring
    
    ResetFilterObj( MM, IsVoidMatrix );
    
    if not ( IsBound( HOMALG_IO.DoNotDeleteTemporaryFiles ) and HOMALG_IO.DoNotDeleteTemporaryFiles = true ) then
        if not IsBool( remove ) then
            if IsList( remove ) and ForAll( remove, IsString ) then
                for file in remove do
                    Exec( Concatenation( "/bin/rm -f \"", file, "\"" ) );
                od;
            else
                Error( "expecting a list of strings indicating file names to be deleted\n" );
            fi;
        else
            Exec( Concatenation( "/bin/rm -f \"", filename, "\"" ) );
        fi;
    fi;
    
    return MM;
    
end );

##
InstallMethod( SaveHomalgMatrixToFile,
        "for two arguments instead of three",
        [ IsString, IsHomalgMatrix ],
        
  function( filename, M )
    local fs;
    
    fs := IO_File( filename, "r" );
    
    if fs <> fail then
        if IO_Close( fs ) = fail then
            Error( "unable to close the file ", filename, "\n" );
        fi;
        Error( "the file ", filename, " already exists, please delete it first and then type return; to continue\n" );
        return SaveHomalgMatrixToFile( filename, M );
    fi;
    
    fs := IO_File( filename, "w" );
    
    if fs = fail then
        Error( "unable to open the file ", filename, " for writing\n" );
    fi;
    
    if IO_Close( fs ) = fail then
        Error( "unable to close the file ", filename, "\n" );
    fi;
    
    Exec( Concatenation( "/bin/rm -f \"", filename, "\"" ) );
    
    return SaveHomalgMatrixToFile( filename, M, HomalgRing( M ) );
    
end );

##
InstallMethod( SaveHomalgMatrixToFile,
        "for an internal homalg matrix",
        [ IsString, IsHomalgInternalMatrixRep, IsHomalgInternalRingRep ],
        
  function( filename, M, R )
    local mode, fs;
    
    if not IsBound( M!.SaveAs ) then
        mode := "ListList";
    else
        mode := M!.SaveAs; ## FIXME: not yet supported
    fi;
    
    if mode = "ListList" then
        
        fs := IO_File( filename, "w" );
        
        if fs = fail then
            Error( "unable to open the file ", filename, " for writing\n" );
        fi;
        
        if IO_WriteFlush( fs, GetListListOfHomalgMatrixAsString( M ) ) = fail then
            Error( "unable to write in the file ", filename, "\n" );
        fi;
        
        if IO_Close( fs ) = fail then
            Error( "unable to close the file ", filename, "\n" );
        fi;
        
    fi;
    
    return true;
    
end );

##
InstallMethod( LoadHomalgMatrixFromFile,
        "for an internal homalg ring",
        [ IsString, IsHomalgInternalRingRep ],
        
  function( filename, R )
    local mode, fs, str, z, M;
    
    if not IsBound( R!.LoadAs ) then
        mode := "ListList";
    else
        mode := R!.LoadAs; ## FIXME: not yet supported
    fi;
    
    if mode = "ListList" then
        
        fs := IO_File( filename, "r" );
        
        if fs = fail then
            Error( "unable to open the file ", filename, " for reading\n" );
        fi;
        
        str := IO_ReadUntilEOF( fs );
        
        if str = fail then
            Error( "unable to read lines from the file ", filename, "\n" );
        fi;
        
        if IO_Close( fs ) = fail then
            Error( "unable to close the file ", filename, "\n" );
        fi;
        
        if IsBound( R!.NameOfPrimitiveElement ) and
           HasCharacteristic( R ) and Characteristic( R ) > 0 and
           HasDegreeOverPrimeField( R ) and DegreeOverPrimeField( R ) > 1 then
            z := R!.NameOfPrimitiveElement;
            
            if IsBoundGlobal( z ) then
                Error( z, " is globally bound\n" );
            fi;
            
            BindGlobal( z, Z( Characteristic( R ) ^ DegreeOverPrimeField( R ) ) );
            
            str := EvalString( str );
            
            MakeReadWriteGlobal( z );
            
            UnbindGlobal( z );
            
        else
            M := EvalString( str );
        fi;
        
        M := HomalgMatrix( str, R );
        
        #if HasCharacteristic( R ) and HasCharacteristic( R ) > 0 then
            M := One( R ) * M;
        #fi;
    fi;
    
    return M;
    
end );

##
InstallMethod( LoadHomalgMatrixFromFile,
        "for an internal homalg ring",
        [ IsString, IsInt, IsInt, IsHomalgRing ], 0, ## lowest rank method
        
  function( filename, r, c, R )
    
    return LoadHomalgMatrixFromFile( filename, R );
    
    ## do not set NrRows and NrColumns for safety reasons
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( Display,
        "for homalg external matrices",
        [ IsHomalgExternalMatrixRep ], 0, ## never higher!!!
        
  function( o )
    
    Print( homalgSendBlocking( [ o ], "need_display", HOMALG_IO.Pictograms.Display ) );
    
end );

