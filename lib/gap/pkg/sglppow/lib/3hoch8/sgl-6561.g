# Get the next available "layer" id (the built-in library
# consists of 11 layers, but other packages may already have
# added further layers).

layer_3hoch8 := Length(SMALL_AVAILABLE_FUNCS) + 1;

# Determine where to add our new lookup functions
pos_3hoch8 := Maximum(List([
        SMALL_GROUP_FUNCS,
        SMALL_GROUPS_INFORMATION,
        NUMBER_SMALL_GROUPS_FUNCS,
        ID_GROUP_FUNCS,
        SELECT_SMALL_GROUPS_FUNCS,
    ], Length)) + 1;

#
# hook us up on the layer level
#

# meta data on small groups data we provide
SMALL_AVAILABLE_FUNCS[layer_3hoch8] := function( size )
    if size = 3^8 then
        return rec (
            lib := layer_3hoch8,
            func := pos_3hoch8,
            number := 1396077);
    fi;
    return fail;
end;

# meta data on IdGroup functionality we provide
ID_AVAILABLE_FUNCS[layer_3hoch8] := function( size )
    # Three possible implementations:
    
    # 1. No IdGroup functionality at all:
    return fail;

    # 2. IdGroup provided for all groups:
    #return SMALL_AVAILABLE_FUNCS[layer_3hoch8];

    # 3. IdGroup provided for a subset of order
    #if size in [ 12345, 67890 ] then
    #  return SMALL_AVAILABLE_FUNCS[layer_3hoch8];
    #fi;

end;

# Method for SmallGroup(size, i):
SMALL_GROUP_FUNCS[ pos_3hoch8 ] := function( size, i, inforec )
    local l, j, k;

    if i > inforec.number then 
        Error("there are just ",inforec.number," groups of order ",size );
    fi;

    l := [ 1, 58, 486, 1343, 330, 9, 4, 216747, 40521, 2163, 24, 23361, 
           494666, 22343, 51, 578478, 14796, 80, 566, 39, 10, 1 ];
  
    j := 1;
    k := i;
    while k > l[j] do
        k := k-l[j];
        j := j+1;
    od;

    if not IsBound( SMALL_GROUP_LIB[ 6561 ] ) then 
        SMALL_GROUP_LIB[ 6561 ] := [];
    fi;

    if not IsBound( SMALL_GROUP_LIB[ 6561 ][j] ) then 
        if j = 1 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank1class8" ); # 1
        elif j = 2 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank2class3" ); # 2
        elif j = 3 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank2class4" ); # 3
        elif j = 4 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank2class5" ); # 4
        elif j = 5 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank2class6" ); # 5
        elif j = 6 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank2class7" ); # 6
        elif j = 7 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank3class2" ); # 7
        elif j = 8 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank3class3" ); # 8
        elif j = 9 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank3class4" ); # 9
        elif j = 10 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank3class5" ); # 10
        elif j = 11 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank3class6" ); # 11
        elif j = 12 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank4class2" ); # 12
        elif j = 13 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank4class3" ); # 13
        elif j = 14 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank4class4" ); # 14
        elif j = 15 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank4class5" ); # 15
        elif j = 16 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank5class2" ); # 16
        elif j = 17 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank5class3" ); # 17
        elif j = 18 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank5class4" ); # 18
        elif j = 19 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank6class2" ); # 19
        elif j = 20 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank6class3" ); # 20
        elif j = 21 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank7class2" ); # 21
        elif j = 22 then 
            ReadPackage( "sglppow", "lib/3hoch8/rank8class1" ); # 22
        fi;
    fi;

    return PcGroupCode( SMALL_GROUP_LIB[6561][j][k], size );
end;

# Method which selects a subset of all those groups with
# a certain combination of properties.
# A default method can be used; but more user friendly would be
# to install something custom which e.g. takes care of filtering
# the abelian groups, and which also knows that all groups
# of order p^n are nilpotent.
SELECT_SMALL_GROUPS_FUNCS[ pos_3hoch8 ] := SELECT_SMALL_GROUPS_FUNCS[ 11 ];
#SELECT_SMALL_GROUPS_FUNCS[ pos_3hoch8 ] := function( funcs, vals, inforec, all, id )
#    Error("TODO");
#end;

# Optional: Method for IdGroup(size, i).
#ID_GROUP_FUNCS[ pos_3hoch8 ] := function( G, inforec )
#    Error("TODO");
#end;

# Method for SmallGroupsInformation(size):
SMALL_GROUPS_INFORMATION[ pos_3hoch8 ] := function( size, inforec, num )
    Print( " \n");
    Print( "This database was created by Michael Vaughan-Lee (2014).\n");
end;
