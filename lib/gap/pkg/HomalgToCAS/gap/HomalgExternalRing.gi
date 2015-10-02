#############################################################################
##
##  HomalgExternalRing.gi     HomalgToCAS package            Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for external rings.
##
#############################################################################

##
DeclareRepresentation( "IshomalgExternalRingObjectRep",
        IshomalgExternalObjectRep,
        [ ] );

##  <#GAPDoc Label="IsHomalgExternalRingRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="R" Name="IsHomalgExternalRingRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The internal representation of &homalg; rings. <P/>
##      (It is a representation of the &GAP; category <C>IsHomalgRing</C>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgExternalRingRep",
        IsHomalgRing and IsHomalgRingOrFinitelyPresentedModuleRep,
        [ "ring", "homalgTable" ] );

##  <#GAPDoc Label="IsHomalgExternalRingElementRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="r" Name="IsHomalgExternalRingElementRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The representation of elements of external &homalg; rings. <P/>
##      (It is a representation of the &GAP; category <Ref Filt="IsHomalgRingElement"/>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgExternalRingElementRep",
        IsHomalgRingElement,
        [ ] );

# a new subrepresentation of the representation IsContainerForWeakPointersRep:
DeclareRepresentation( "IsContainerForWeakPointersOnHomalgExternalRingsRep",
        IsContainerForWeakPointersRep,
        [ "weak_pointers", "streams", "counter", "deleted" ] );

##  <#GAPDoc Label="IsHomalgExternalMatrixRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="A" Name="IsHomalgExternalMatrixRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The external representation of &homalg; matrices. <P/>
##      (It is a representation of the &GAP; category <Ref Filt="IsHomalgMatrix"/>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgExternalMatrixRep",
        IsHomalgMatrix,
        [ ] );

####################################
#
# families and types:
#
####################################

# a new type:
BindGlobal( "TheTypeHomalgExternalRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalRingRep ) );

# three new types:
BindGlobal( "TheTypeHomalgExternalRingElement",
        NewType( TheFamilyOfHomalgRingElements,
                IsHomalgExternalRingElementRep ) );

BindGlobal( "TheTypeHomalgExternalMatrix",
        NewType( TheFamilyOfHomalgMatrices,
                IsHomalgExternalMatrixRep ) );

# a new family:
BindGlobal( "TheFamilyOfContainersForWeakPointersOnHomalgExternalRings",
        NewFamily( "TheFamilyOfContainersForWeakPointersOnHomalgExternalRings" ) );

# a new type:
BindGlobal( "TheTypeContainerForWeakPointersOnHomalgExternalRings",
        NewType( TheFamilyOfContainersForWeakPointersOnHomalgExternalRings,
                IsContainerForWeakPointersOnHomalgExternalRingsRep ) );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( homalgPointer,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgPointer( R!.ring );
    
end );

##
InstallMethod( homalgExternalCASystem,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgExternalCASystem( R!.ring );
    
end );

##
InstallMethod( homalgExternalCASystemVersion,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgExternalCASystemVersion( R!.ring );
    
end );

##
InstallMethod( homalgStream,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgStream( R!.ring );
    
end );

##
InstallMethod( homalgExternalCASystemPID,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgExternalCASystemPID( R!.ring );
    
end );

##
InstallMethod( homalgLastWarning,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    homalgLastWarning( R!.ring );
    
end );

##
InstallMethod( homalgNrOfWarnings,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( R )
    
    return homalgNrOfWarnings( R!.ring );
    
end );

##
InstallMethod( homalgPointer,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( r )
    local e;
    
    e := EvalRingElement( r );	## here we must evaluate
    
    if IshomalgExternalObjectRep( e ) then
        return homalgPointer( e );
    elif IsString( e ) or IsFunction( e ) then
        return e;
    fi;
    
    Error( "the value of EvalRingElement of an external ring element must be either an external object, a string, or a function\n" );
    
end );

##
InstallMethod( homalgExternalCASystem,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( r )
    local R;
    
    R := HomalgRing( r );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystem( R ); ## avoid evaluating the ring element
    else
        return homalgExternalCASystem( EvalRingElement( r ) );
    fi;
    
end );

##
InstallMethod( homalgExternalCASystemVersion,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( r )
    local R;
    
    R := HomalgRing( r );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystemVersion( R ); ## avoid evaluating the ring element
    else
        return homalgExternalCASystemVersion( EvalRingElement( r ) );
    fi;
    
end );

##
InstallMethod( homalgStream,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( r )
    local R;
    
    R := HomalgRing( r );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgStream( R ); ## avoid evaluating the ring element
    else
        return homalgStream( EvalRingElement( r ) );
    fi;
    
end );

##
InstallMethod( homalgExternalCASystemPID,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( r )
    local R;
    
    R := HomalgRing( r );
    
    if IsHomalgExternalRingRep( R ) then
        return homalgExternalCASystemPID( R ); ## avoid evaluating the ring element
    else
        return homalgExternalCASystemPID( EvalRingElement( r ) );
    fi;
    
end );

##
InstallMethod( String,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  Name );

##
InstallMethod( homalgSetName,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep, IsString, IsHomalgExternalRingRep ],
        
  function( r, name, R )
    
    SetName( r, homalgSendBlocking( [ r ], "need_output", HOMALG_IO.Pictograms.homalgSetName ) );
    
end );

##
InstallMethod( homalgSetName,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep, IsString ],
        
  function( r, name )
    
    homalgSetName( r, name, HomalgRing( r ) );
    
end );

##
InstallMethod( \=,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep, IsHomalgExternalRingElementRep ],
        
  function( r1, r2 )
    
    if not IsIdenticalObj( homalgStream( r1 ), homalgStream( r2 ) ) then
        return false;
    elif EvalRingElement( r1 ) = EvalRingElement( r2 ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallGlobalFunction( LetWeakPointerListOnExternalObjectsContainRingCreationNumbers,
  function( R )
    local container;
    
    container := homalgStream( R ).homalgExternalObjectsPointingToVariables;
    
    if not IsBound( container!.ring_creation_numbers ) then
        container!.ring_creation_numbers := [ ];
    fi;
    
end );

##
InstallGlobalFunction( AppendTohomalgTablesOfCreatedExternalRings,
  function( homalgTableForCAS, filter )
    local weak_pointers, i, R;
    
    weak_pointers := HOMALG_MATRICES.ContainerForWeakPointersOnHomalgExternalRings!.weak_pointers;
    
    for i in [ 1 .. Length( weak_pointers ) ] do
        R := ElmWPObj( weak_pointers, i );
        if R <> fail then
            if filter( R ) then
                AppendToAhomalgTable( homalgTable( R ), homalgTableForCAS );
            fi;
        fi;
    od;
    
end );

##
InstallMethod( \/,
        "for a homalg external ring element and a homalg external ring",
        [ IsHomalgExternalRingElementRep, IsHomalgExternalRingRep ],
        
  function( r, R )
    local RP;
    
    RP := homalgTable( R );
    
    if not IsIdenticalObj( HomalgRing( r ), R ) and
       IsHomalgExternalRingRep( HomalgRing( r ) ) and
       IsIdenticalObj( homalgStream( HomalgRing( r ) ), homalgStream( R ) ) and
       IsBound( RP!.CopyElement ) then	## make a "copy" over a different ring
        
        return HomalgExternalRingElement( RP!.CopyElement( r, R ), R );
        
    fi;
    
    TryNextMethod( );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

HOMALG_MATRICES.ContainerForWeakPointersOnHomalgExternalRings :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnHomalgExternalRings, [ "streams", [ ] ] );

##
InstallGlobalFunction( CreateHomalgExternalRing,
  function( arg )
    local nargs, r, l, HOMALG_IO_CAS, nar, stream, ring_type, ar, R, container, weak_pointers, deleted, streams;
    
    nargs := Length( arg );
    
    if nargs < 2 then
        Error( "expecting a ring object or arguments to pass to homalgSendBlocking as the first argument and a ring type as the second argument\n" );
    fi;
    
    r := arg[1];
    
    if IsList( r ) then
        
        l := 4;
        
        HOMALG_IO_CAS := arg[3];
        
        nar := Length( r );
        
        ## check whether the last argument already has a stream pointing to a running
        ## instance of the external CAS
        if nargs > 1 then
            if IsRecord( r[nar] ) and IsBound( r[nar].lines ) and IsBound( r[nar].pid ) then
                stream := r[nar];
            elif IshomalgExternalObjectRep( r[nar] ) or IsHomalgExternalRingRep( r[nar] ) then
                stream := homalgStream( r[nar] );
            fi;
        fi;
        
        ## if no such stream is found in the last argument, start and initialize
        ## a new instance of the external CAS
        if not IsBound( stream ) then
            
            if IsString( HOMALG_IO_CAS ) and IsBound( ValueGlobal( HOMALG_IO_CAS ).common_stream ) then
                
                HOMALG_IO_CAS := ValueGlobal( HOMALG_IO_CAS );
                
                ## use the stream stored in HOMALG_IO_CAS to
                ## avoid launching a new instance of the external CAS
                ## (suggested by Oleksandr Motsak)
                stream := HOMALG_IO_CAS.common_stream;
                
            elif IsRecord( HOMALG_IO_CAS ) and IsBound( HOMALG_IO_CAS.common_stream ) then
                
                ## use the stream stored in HOMALG_IO_CAS to
                ## avoid launching a new instance of the external CAS
                ## (suggested by Oleksandr Motsak)
                stream := HOMALG_IO_CAS.common_stream;
                
            else
                
                stream := LaunchCAS( HOMALG_IO_CAS );
                
                if IsString( HOMALG_IO_CAS ) then
                    HOMALG_IO_CAS := ValueGlobal( HOMALG_IO_CAS );
                fi;
                
                if IsBound( stream.init_string ) then
                    
                    ## send the init string
                    homalgSendBlocking( stream.init_string, "need_command", stream, HOMALG_IO.Pictograms.initialize );
                fi;
                
                ## initialize the macros
                if IsBound( stream.InitializeCASMacros ) then
                    stream.InitializeCASMacros( stream );
                fi;
                
                ## store stream as a common stream for later rings to
                ## avoid launching a new instance of the external CAS
                ## (suggested by Oleksandr Motsak)
                if ( IsBound( HOMALG_IO_CAS.use_common_stream ) and
                     HOMALG_IO_CAS.use_common_stream = true ) or
                   ( not ( IsBound( HOMALG_IO_CAS.use_common_stream ) and
                           HOMALG_IO_CAS.use_common_stream = false ) and
                     IsBound( HOMALG_IO.use_common_stream ) and
                     HOMALG_IO.use_common_stream = true ) then
                    HOMALG_IO_CAS.common_stream := stream;
                fi;
                
            fi;
            
        else
            r := r{[ 1 .. nar - 1 ]};
        fi;
        
        Append( r, [ stream, HOMALG_IO.Pictograms.CreateHomalgRing ] );
        
        r := CallFuncList( homalgSendBlocking, r );
        
    else
        l := 3;
    fi;
    
    ring_type := arg[2];
    
    ar := [ r, [ ring_type, TheTypeHomalgExternalMatrix ], HomalgExternalRingElement ];
    
    ar := Concatenation( ar, arg{[ l .. nargs ]} );
    
    ## create the external ring
    R :=  CallFuncList( CreateHomalgRing, ar );
    
    ## for the view methods:
    ## <A matrix over an external ring>
    R!.description := "n external";
    
    container := HOMALG_MATRICES.ContainerForWeakPointersOnHomalgExternalRings;
    
    weak_pointers := container!.weak_pointers;
    
    l := container!.counter;
    
    deleted := Filtered( [ 1 .. l ], i -> not IsBoundElmWPObj( weak_pointers, i ) );
    
    container!.deleted := deleted;
    
    l := l + 1;
    
    container!.counter := l;
    
    SetElmWPObj( weak_pointers, l, R );
    
    streams := container!.streams;
    
    if not homalgExternalCASystemPID( R ) in List( streams, s -> s.pid ) then
        Add( streams, homalgStream( R ) );
    fi;
    
    return R;
    
end );

##
InstallGlobalFunction( HomalgExternalRingElement,
  function( arg )
    local nargs, el, pointer, ring, cas, ar, properties, r;
    
    nargs := Length( arg );
    
    if nargs = 0 then
        Error( "empty input\n" );
    fi;
    
    if IsHomalgExternalRingElementRep( arg[1] ) then
        
        el := arg[1];
        
        ## rebuild an external ring element
        ## only if it does not already contain a ring and
        ## if a ring is provided as a second argument
        if not IsBound( el!.ring ) and
           nargs > 1 and IsHomalgRing( arg[2] ) then
            pointer := homalgPointer( el );
            ring := arg[2];
            if IsFunction( pointer ) then
                pointer := pointer( ring );
            fi;
            cas := homalgExternalCASystem( ring );
            ar := [ pointer, cas, ring ];
            properties := KnownTruePropertiesOfObject( el );
            Append( ar, List( properties, ValueGlobal ) );
            return CallFuncList( HomalgExternalRingElement, ar );
        fi;
        
        ## otherwise simply return it
        return el;
        
    fi;
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if not IsBound( cas ) and IsString( ar ) then
            cas := ar;
        elif not IsBound( ring ) and IsHomalgExternalRingRep( ar ) then
            ring := ar;
            cas := homalgExternalCASystem( ring );
        elif IsFilter( ar ) then
            Add( properties, ar );
        else
            Error( "this argument (now assigned to ar) should be in { IsString, IsHomalgExternalRingRep, IsFilter }\n" );
        fi;
    od;
    
    if IsString( arg[1] ) then
        pointer := function( R )
            local RP;
            RP := homalgTable( R );
            if IsBound( RP!.RingElement ) then
                return RP!.RingElement( R )( arg[1] );
            else
                return arg[1];
            fi;
            
        end;
    else
        pointer := arg[1];
    fi;
    
    if IsBound( ring ) then
        
        if IsFunction( pointer ) then
            pointer := pointer( ring );
        fi;
        
        r := rec( cas := cas, ring := ring );
    else
        r := rec( cas := cas );
    fi;
    
    ## Objectify:
    ObjectifyWithAttributes(
            r, TheTypeHomalgExternalRingElement,
            EvalRingElement, pointer );
    
    if properties <> [ ] then
        for ar in properties do
            Setter( ar )( r, true );
        od;
    fi;
    
    return r;
    
end );

##
InstallMethod( \in,
        "for a finite field element and an external ring",
        [ IsRingElement, IsHomalgExternalRingRep ],

  function( r, R )
    
    if not IsHomalgExternalRingElementRep( r ) then
        return false;
    elif not IsIdenticalObj( HomalgRing( r ), R ) then
        return false;
    fi;
    
    return true;
    
end );
        
##
InstallMethod( \/,
        "for a finite field element and an external ring",
        [ IsFFE, IsHomalgExternalRingRep ],
        
  function( r, R )
    local k, c, d, z;
    
    if HasCoefficientsRing( R ) then
        k := CoefficientsRing( R );
    else
        k := R;
    fi;
    
    if not ( HasCharacteristic( k ) and HasDegreeOverPrimeField( k ) ) then
        TryNextMethod( );
    fi;
    
    c := Characteristic( k );
    d := DegreeOverPrimeField( k );
    
    if d = 1 then
        return HomalgRingElement( String( Int( r ) ), R );
    fi;
    
    if not IsBound( k!.NameOfPrimitiveElement ) then
        Error( "no NameOfPrimitiveElement bound\n" );
    fi;
    
    z := k!.NameOfPrimitiveElement;
    
    return HomalgRingElement( FFEToString( r, c, d, z ), R );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg external ring objects",
        [ IshomalgExternalRingObjectRep ],
        
  function( o )
    
    Print( "<A homalg external ring object residing in the CAS " );
    Print( homalgExternalCASystem( o ), ">" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( o )
    local ring, stream, display_color, esc;
    
    ring := RingName( o );
    
    stream := homalgStream( o );
    
    if IsBound( stream.color_display ) then
        display_color := stream.color_display;
        esc := "\033[0m";
    else
        display_color := "";
        ## esc must be empty, otherwise GAPDoc's TestManualExamples will complain
        esc := "";
    fi;
    
    Print( display_color, ring, esc );
    
end );

##
InstallMethod( Display,
        "for homalg external rings",
        [ IsHomalgExternalRingRep ],
        
  function( o )
    Print( "<An external " );
    
    if IsPreHomalgRing( o ) then
        Print( "pre-homalg " );
    fi;
    
    Print( "ring" );
    
    if not ( IsBound( HOMALG_IO.suppress_CAS ) and HOMALG_IO.suppress_CAS = true ) then
        
        Print( " residing in the CAS " );
        
        if IsBound( homalgStream( o ).color_display ) then
            Print( "\033[1m" );
        fi;
        
        Print( homalgExternalCASystem( o ) );
        
        if not ( IsBound( HOMALG_IO.suppress_PID ) and HOMALG_IO.suppress_PID = true ) then
            
            Print( "\033[0m running with pid ", homalgExternalCASystemPID( o ) );
            
        fi;
        
    fi;
    
    Print( ">", "\n" );
    
end );

##
InstallMethod( Name,
        "for homalg external ring elements",
        [ IsHomalgExternalRingElementRep ],
        
  function( o )
    local pointer;
    
    pointer := homalgPointer( o );
    
    if not IsFunction( pointer ) then
        
        homalgSetName( o, pointer );
        
        return Name( o );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( ViewObj,
        "for containers of weak pointers on homalg external rings",
        [ IsContainerForWeakPointersOnHomalgExternalRingsRep ],
        
  function( o )
    local del;
    
    del := Length( o!.deleted );
    
    Print( "<A container of weak pointers on homalg external rings: active = ", o!.counter - del, ", deleted = ", del, ">" );
    
end );

##
InstallMethod( Display,
        "for containers of weak pointers on homalg external rings",
        [ IsContainerForWeakPointersOnHomalgExternalRingsRep ],
        
  function( o )
    local weak_pointers;
    
    weak_pointers := o!.weak_pointers;
    
    Print( List( [ 1 .. LengthWPObj( weak_pointers ) ], function( i ) if IsBoundElmWPObj( weak_pointers, i ) then return i; else return 0; fi; end ), "\n" );
    
end );

