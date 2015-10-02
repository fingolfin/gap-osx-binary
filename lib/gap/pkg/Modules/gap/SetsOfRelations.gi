#############################################################################
##
##  SetsOfRelations.gi          homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Declaration stuff for sets of relations.
##
#############################################################################

####################################
#
# representations:
#
####################################

# a new representation for the GAP-category IsSetsOfRelations:
DeclareRepresentation( "IsSetsOfRelationsRep",
        IsSetsOfRelations,
        [ "ListOfPositionsOfKnownSetsOfRelations" ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "TheFamilyOfHomalgSetsOfRelations",
        NewFamily( "TheFamilyOfHomalgSetsOfRelations" ) );

# a new type:
BindGlobal( "TheTypeHomalgSetsOfRelations",
        NewType( TheFamilyOfHomalgSetsOfRelations,
                IsSetsOfRelationsRep ) );

####################################
#
# methods for operations:
#
####################################

InstallMethod( PositionOfLastStoredSetOfRelations,
        "for sets of relations",
        [ IsSetsOfRelationsRep ],
        
  function( rels )
    
    return Length( rels!.ListOfPositionsOfKnownSetsOfRelations );
    
end );


####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( CreateSetsOfRelationsForLeftModule,
  function( arg )
    local relations;
    
    if Length( arg ) = 1 then
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := arg[1] );
    elif IsString( arg[1] ) and Length( arg[1] ) > 2 and LowercaseString( arg[1]{[1..3]} ) = "unk" then
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := "unknown relations" );
    else
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := HomalgRelationsForLeftModule( arg[1], arg[2] ) );
    fi;
    
    ## Objectify:
    Objectify( TheTypeHomalgSetsOfRelations, relations );
    
    return relations;
    
end );
  
InstallGlobalFunction( CreateSetsOfRelationsForRightModule,
  function( arg )
    local relations;
    
    if Length( arg ) = 1 then
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := arg[1] );
    elif IsString( arg[1] ) and Length( arg[1] ) > 2 and LowercaseString( arg[1]{[1..3]} ) = "unk" then
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := "unknown relations" );
    else
        relations := rec( ListOfPositionsOfKnownSetsOfRelations := [ 1 ],
                          1 := HomalgRelationsForRightModule( arg[1], arg[2] ) );
    fi;
    
    ## Objectify:
    Objectify( TheTypeHomalgSetsOfRelations, relations );
    
    return relations;
    
end );
  
####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for sets of relations",
        [ IsSetsOfRelationsRep ],
        
  function( o )
    local l;
    
    l := Length( o!.ListOfPositionsOfKnownSetsOfRelations );
    
    Print( "<A set containing " );
    
    if l = 1 then
        Print( "a single set " );
    else
        Print( l, " sets " );
    fi;
    
    Print( "of relations of a homalg module>" );
    
end );

