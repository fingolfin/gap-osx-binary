#############################################################################
##
##  GAPHomalg.gi              RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for the external computer algebra system GAP.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( HOMALG_IO_GAP,
        rec(
            cas := "gap",		## normalized name on which the user should have no control
            name := "GAP",
            executable := [ "gapL", "gap" ],	## this list is processed from left to right
            options := [ "-q", "-T", "-m", "128m", "-o", "15g" ],
            BUFSIZE := 1024,
            READY := "!$%&/(",
            CUT_POS_BEGIN := 1,		## these are the most
            CUT_POS_END := 4,		## delicate values!
            eoc_verbose := ";",
            eoc_quiet := ";;",
            show_banner := false,	## the GAP banner screws the display of several terminals :(
            define := ":=",
            delete := function( var, stream ) homalgSendBlocking( [ "Unbind( ", var, " )" ], "need_command", stream, HOMALG_IO.Pictograms.delete ); end,
            multiple_delete := _ExternalGAP_multiple_delete,
            garbage_collector := function( stream ) homalgSendBlocking( [ "GASMAN( \"collect\" )" ], "need_command", stream, HOMALG_IO.Pictograms.garbage_collector ); end,
            prompt := "\033[01mgap>\033[0m ",
            output_prompt := "\033[1;37;44m<gap\033[0m ",
            display_color := "\033[0;35m",
            init_string := "LoadPackage(\"HomalgToCAS\")",	## needed for LoadHomalgMatrixFromFile
            InitializeCASMacros := InitializeGAPHomalgMacros,
            time := function( stream, t ) return Int( homalgSendBlocking( [ "homalgTotalRuntimes( )" ], "need_output", stream, HOMALG_IO.Pictograms.time ) ) - t; end,
           )
);

HOMALG_IO_GAP.READY_LENGTH := Length( HOMALG_IO_GAP.READY );

####################################
#
# representations:
#
####################################

# a new subrepresentation of the representation IshomalgExternalRingObjectRep:
DeclareRepresentation( "IsHomalgExternalRingObjectInGAPRep",
        IshomalgExternalRingObjectRep,
        [  ] );

# a new subrepresentation of the representation IsHomalgExternalRingRep:
DeclareRepresentation( "IsHomalgExternalRingInGAPRep",
        IsHomalgExternalRingRep,
        [  ] );

####################################
#
# families and types:
#
####################################

# a new type:
BindGlobal( "TheTypeHomalgExternalRingObjectInGAP",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalRingObjectInGAPRep ) );

# a new type:
BindGlobal( "TheTypeHomalgExternalRingInGAP",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalRingInGAPRep ) );

####################################
#
# global functions and variables:
#
####################################

##
InstallGlobalFunction( _ExternalGAP_multiple_delete,
  function( var_list, stream )
    local str;
    
    str := [ "for _del in ", String( var_list ), " do UnbindGlobal( _del ); od" ];
    
    homalgSendBlocking( str, "need_command", stream, HOMALG_IO.Pictograms.multiple_delete );
    
end );

##
InstallValue( GAPHomalgMacros,
        rec(
            
            )

        );

##
InstallGlobalFunction( InitializeGAPHomalgMacros,
  function( stream )
    
    return InitializeMacros( GAPHomalgMacros, stream );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

##
InstallGlobalFunction( RingForHomalgInExternalGAP,
  function( arg )
    local nargs, ext_ring_obj_type, ar, a, type, R;
    
    nargs := Length( arg );
    
    ## passing the ring object type and ring type
    ## should be done using an option record and supported
    ## in all RingForHomalgIn* methods
    if IsType( arg[1] ) then
        ext_ring_obj_type := arg[1];
        arg := arg{[ 2 .. nargs ]};
        nargs := nargs - 1;
    else
        ext_ring_obj_type := TheTypeHomalgExternalRingObjectInGAP;
    fi;
    
    ar := [ arg[1] ];
    
    Add( ar, ext_ring_obj_type );
    
    ## passing the ring object type and ring type
    ## should be done using an option record and supported
    ## in all RingForHomalgIn* methods
    if nargs > 1 then
        for a in arg{[ 2 .. nargs ]} do
            if IsType( a ) then
                type := a;
            else
                Add( ar, a );
            fi;
        od;
    fi;
    
    if not IsBound( type ) then
        type := TheTypeHomalgExternalRingInGAP;
    fi;
    
    ar := [ ar, type ];
    
    Add( ar, "HOMALG_IO_GAP" );
    
    R := CallFuncList( CreateHomalgExternalRing, ar );
    
    if IsBound( HOMALG_MATRICES.PreferDenseMatrices ) then
        homalgSendBlocking( [ "HOMALG_MATRICES.PreferDenseMatrices := ", HOMALG_MATRICES.PreferDenseMatrices ], "need_command", R, HOMALG_IO.Pictograms.initialize );
    fi;
    
    return R;
    
end );

##
InstallGlobalFunction( HomalgRingOfIntegersInExternalGAP,
  function( arg )
    local nargs, l, c, R;
    
    nargs := Length( arg );
    
    if nargs > 0 and IsInt( arg[1] ) and arg[1] <> 0 then
        l := 2;
        ## characteristic:
        c := AbsInt( arg[1] );
    else
        if nargs > 0 and arg[1] = 0 then
            l := 2;
        else
            l := 1;
        fi;
        ## characteristic:
        c := 0;
    fi;
    
    R := [ "HomalgRingOfIntegers( ", c, " )" ];
    
    R := Concatenation( [ R, IsPrincipalIdealRing ], arg{[ l .. nargs ]} );
    
    R := CallFuncList( RingForHomalgInExternalGAP, R );
    
    SetIsResidueClassRingOfTheIntegers( R, true );
    
    SetRingProperties( R, c );
    
    return R;
    
end );

##
InstallGlobalFunction( HomalgFieldOfRationalsInExternalGAP,
  function( arg )
    local R;
    
    R := "HomalgFieldOfRationals( )";
    
    R := Concatenation( [ R ], [ IsPrincipalIdealRing ], arg );
    
    R := CallFuncList( RingForHomalgInExternalGAP, R );
    
    SetIsRationalsForHomalg( R, true );
    
    SetRingProperties( R, 0 );
    
    return R;
    
end );

##
InstallMethod( SetMatElm,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep and IsMutable, IsPosInt, IsPosInt, IsString, IsHomalgExternalRingInGAPRep ],
        
  function( M, r, c, s, R )
    
    homalgSendBlocking( [ "SetMatElm( ", M, r, c, ",", s, ",", R, " )" ], "need_command", HOMALG_IO.Pictograms.SetMatElm );
    
end );

##
InstallMethod( AddToMatElm,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep and IsMutable, IsPosInt, IsPosInt, IsHomalgExternalRingElementRep, IsHomalgExternalRingInGAPRep ],
        
  function( M, r, c, a, R )
    
    homalgSendBlocking( [ "AddToMatElm( ", M, r, c, a, R, " )" ], "need_command", HOMALG_IO.Pictograms.AddToMatElm );
    
end );

##
InstallMethod( CreateHomalgMatrixFromString,
        "constructor for homalg external matrices in GAP",
        [ IsString, IsHomalgExternalRingInGAPRep ],
        
  function( S, R )
    local ext_obj;
    
    ## external GAP sees S as a listlist (and not as a string)
    ext_obj := homalgSendBlocking( [ "HomalgMatrix( ", S, ", ", R, " )" ], HOMALG_IO.Pictograms.HomalgMatrix );
    
    return HomalgMatrix( ext_obj, R );
    
end );

##
InstallMethod( CreateHomalgMatrixFromString,
        "constructor for homalg external matrices in GAP",
        [ IsString, IsInt, IsInt, IsHomalgExternalRingInGAPRep ],
  function( S, r, c, R )
    local ext_obj;
    
    ext_obj := homalgSendBlocking( [ "CreateHomalgMatrixFromString( \"", S, "\", ", r, c , R, " )" ], HOMALG_IO.Pictograms.HomalgMatrix );
    
    return HomalgMatrix( ext_obj, r, c, R );
    
end );

##
InstallMethod( CreateHomalgMatrixFromSparseString,
        "constructor for homalg external matrices in GAP",
        [ IsString, IsInt, IsInt, IsHomalgExternalRingInGAPRep ],
  function( S, r, c, R )
    local ext_obj, s;
    
    s := homalgSendBlocking( [ "\"", S, "\"" ], R, HOMALG_IO.Pictograms.sparse );
    
    ext_obj := homalgSendBlocking( [ "CreateHomalgMatrixFromSparseString( ", s, r, c , R, " )" ], HOMALG_IO.Pictograms.HomalgMatrix );
    
    return HomalgMatrix( ext_obj, R );
    
end );

##
InstallMethod( MatElmAsString,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep, IsPosInt, IsPosInt, IsHomalgExternalRingInGAPRep ],
        
  function( M, r, c, R )
    
    return EvalString( homalgSendBlocking( [ "String( MatElm( ", M, r, c, R, " ) )" ], "need_output", HOMALG_IO.Pictograms.MatElm ) );
    
end );

##
InstallMethod( MatElm,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep, IsPosInt, IsPosInt, IsHomalgExternalRingInGAPRep ],
        
  function( M, r, c, R )
    local Mrc;
    
    Mrc := homalgSendBlocking( [ "MatElm( ", M, r, c, R, " )" ], HOMALG_IO.Pictograms.MatElm );
    
    return HomalgExternalRingElement( Mrc, R );
    
end );

##
InstallMethod( GetListOfHomalgMatrixAsString,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep, IsHomalgExternalRingInGAPRep ],
        
  function( M, R )
    local s, l;
    
    s := homalgSendBlocking( [ "GetListOfHomalgMatrixAsString( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.GetListOfHomalgMatrixAsString );
    
    l := Length( s );
    
    if l < 3 then
        return s;
    fi;
    
    return s{[ 2 .. l-1 ]};
    
end );

##
InstallMethod( GetListListOfHomalgMatrixAsString,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep, IsHomalgExternalRingInGAPRep ],
        
  function( M, R )
    local s, l;
    
    s := homalgSendBlocking( [ "GetListListOfHomalgMatrixAsString( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.GetListListOfHomalgMatrixAsString );
    
    l := Length( s );
    
    if l < 3 then
        return s;
    fi;
    
    return s{[ 2 .. l-1 ]};
    
end );

##
InstallMethod( GetSparseListOfHomalgMatrixAsString,
        "for homalg external matrices in Maple",
        [ IsHomalgExternalMatrixRep, IsHomalgExternalRingInGAPRep ],
        
  function( M, R )
    local s, l;
    
    s := homalgSendBlocking( [ "GetSparseListOfHomalgMatrixAsString( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.GetSparseListOfHomalgMatrixAsString );
    
    l := Length( s );
    
    if l < 3 then
        return s;
    fi;
    
    return s{[ 2 .. l-1 ]};
    
end );

##
InstallMethod( homalgSetName,
        "for homalg ring elements",
        [ IsHomalgExternalRingElementRep, IsString, IsHomalgExternalRingInGAPRep ],
        
  function( r, name, R )
    
    SetName( r, EvalString( homalgSendBlocking( [ "String( ", r, " )" ], "need_output", HOMALG_IO.Pictograms.homalgSetName ) ) );
    
end );

####################################
#
# transfer methods:
#
####################################

##
InstallMethod( SaveHomalgMatrixToFile,
        "for homalg external matrices in GAP",
        [ IsString, IsHomalgMatrix, IsHomalgExternalRingInGAPRep ],
        
  function( filename, M, R )
    local mode, command;
    
    if not IsBound( M!.SaveAs ) then
        mode := "ListList";
    else
        mode := M!.SaveAs; #not yet supported
    fi;
    
    if mode = "ListList" then
        command := [ "SaveHomalgMatrixToFile( \"", filename, "\", ", M, " )" ];
                
        homalgSendBlocking( command, "need_command", HOMALG_IO.Pictograms.SaveHomalgMatrixToFile );
        
    fi;
    
    return true;
    
end );

##
InstallMethod( LoadHomalgMatrixFromFile,
        "for external rings in GAP",
        [ IsString, IsHomalgExternalRingInGAPRep ],
        
  function( filename, R )
    local mode, command, M;
    
    if not IsBound( R!.LoadAs ) then
        mode := "ListList";
    else
        mode := R!.LoadAs; #not yet supported
    fi;
    
    M := HomalgVoidMatrix( R );
    
    if mode = "ListList" then
        
        command := [ M, " := LoadHomalgMatrixFromFile( \"", filename, "\", ", R, " )" ];
        
        homalgSendBlocking( command, "need_command", HOMALG_IO.Pictograms.LoadHomalgMatrixFromFile );
        
    fi;
    
    return M;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( Display,
        "for homalg external matrices in GAP",
        [ IsHomalgExternalMatrixRep ], 1,
        
  function( o )
    
    if IsHomalgExternalRingInGAPRep( HomalgRing( o ) ) then
        
        Print( homalgSendBlocking( [ "Display( ", o, " )" ], "need_display", HOMALG_IO.Pictograms.Display ) );
        
    else
        
        TryNextMethod( );
        
    fi;
    
end );
