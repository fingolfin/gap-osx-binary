##############################################################################
##
#W  map2arg.gi                   XMOD Package                    Chris Wensley
##
##  version 2.31, 08/11/2014 
##
#Y  Copyright (C) 2001-2014, Murat Alp and Chris Wensley,  
#Y  School of Computer Science, Bangor University, U.K. 

#############################################################################
##
#F  Mapping2ArgumentsByFunction( <D>, <E>, <fun> ) . create map from function
##
InstallGlobalFunction( Mapping2ArgumentsByFunction, function ( arg )
    local   map;        # mapping <map>, result

    if not ( Length( arg ) = 3 ) then
        # signal an error
        Error( "usage: Mapping2ArgumentsByFunction( <D>, <E>, <fun> )" );
    fi;
    # ensure that the entries in source and the range are domains
    if not ( IsList(arg[1]) and IsDomain(arg[1][1]) 
             and IsDomain(arg[1][2]) and IsDomain(arg[2]) ) then
	 Error("Mapping2ArgumentsByFunction: Source[1,2], Range not domains");
    fi;

    # make the general mapping
    map:= Objectify( TypeOfDefaultGeneralMapping( arg[1], arg[2],
                             IsNonSPMappingByFunctionRep
                         and IsSingleValued
                         and IsTotal ),
                       rec( fun:= arg[3] ) );
    SetIsMapping2ArgumentsByFunction( map, true );
    # deleted code re inverses

    return map;
end );

#############################################################################
##
#M  ImageElm( <map>, <elm> )  . . . . . . . . . . . . for mapping by function
##
InstallMethod( ImageElm, "for mapping by function", true, 
    [ IsMapping2ArgumentsByFunction, IsList ], 0,
    function ( map, elm )
    return map!.fun( elm );
    end );

#############################################################################
##
#E map2arg.gi . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
