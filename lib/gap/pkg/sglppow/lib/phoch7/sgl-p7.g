# Get the next available "layer" id (the built-in library
# consists of 11 layers, but other packages may already have
# added further layers).
layer_phoch7 := layer_3hoch8+1;

# Determine where to add our new lookup functions
pos_phoch7 := pos_3hoch8+1;

#
# hook us up on the layer level
#

# need to adjust this, as otherwise an error is produced
SMALL_AVAILABLE_FUNCS[11] := function( size )
    local  p;
    p := FactorsInt( size );
    if Length( p ) <> 7 or p[1] = 2 or p[1] > 11 or Length(Set(p)) > 1  then
        return fail;
    fi;
    return rec( func := 26, lib := 11, p := p[1] );
end;

# meta data on small groups data we provide
SMALL_AVAILABLE_FUNCS[layer_phoch7] := function( size )
    local f, p, n;
    f := Factors(size);
    p := f[1]; 
    n := Length(f);
    if Length(Set(f)) = 1 and p > 11 and n = 7 then 
        return rec (
            lib := layer_phoch7,
            func := pos_phoch7,
            p := p,
            n := n,
            number := 3 * p ^ 5 + 12 * p ^ 4 + 44 * p ^ 3 + 170 * p ^ 2 
                    + 707 * p + 2 
                    + (4 * p ^ 2 + 44 * p + 291) * Gcd((p-1), 3 ) 
                    + (p ^ 2 + 19 * p + 135) * Gcd((p-1), 4 ) 
                    + (3 * p + 31) * Gcd((p-1), 5 ) 
                    + 4 * Gcd((p-1), 7 ) 
                    + 5 * Gcd((p-1), 8 ) + Gcd((p-1), 9 ) 
           );
    fi;
    return fail;
end;

# meta data on IdGroup functionality we provide
ID_AVAILABLE_FUNCS[layer_phoch7] := function( size )
    # Three possible implementations:
    
    # 1. No IdGroup functionality at all:
    return fail;

    # 2. IdGroup provided for all groups:
    #return SMALL_AVAILABLE_FUNCS[layer_phoch7];

    # 3. IdGroup provided for a subset of order
    #if size in [ 12345, 67890 ] then
    #  return SMALL_AVAILABLE_FUNCS[layer_phoch7];
    #fi;

end;

# Method for SmallGroup(size, i):
SMALL_GROUP_FUNCS[ pos_phoch7 ] := function( size, i, inforec )
    local p, l, j, k, L, F;
    p := inforec.p;

    if i > inforec.number then 
        Error("there are just ",inforec.number," groups of order ",size );
    fi;

    if not IsBound( SMALL_GROUP_LIB_P7[p] ) then 
        SMALL_GROUP_LIB_P7[p] := [];
        SMALL_GROUP_NUM_P7[p] := [];
    fi;

    if not IsBound(SMALL_GROUP_NUM_P7[p][1]) then 
        L := LiePRingByData(7, LIE_DATA[7][1] );
        l := NumberOfLiePRingsInFamily(L);
        SMALL_GROUP_NUM_P7[p][1] := EvaluatePorcPoly(l, p);
    fi;

    j := 1;
    k := i;
    while k > SMALL_GROUP_NUM_P7[p][j] do
        k := k-SMALL_GROUP_NUM_P7[p][j];
        j := j+1;
        if not IsBound(SMALL_GROUP_NUM_P7[p][j]) then 
            L := LiePRingByData(7, LIE_DATA[7][j] );
            l := NumberOfLiePRingsInFamily(L);
            SMALL_GROUP_NUM_P7[p][j] := EvaluatePorcPoly(l, p);
        fi;
        if not IsInt(SMALL_GROUP_NUM_P7[p][j]) then 
            L := LiePRingByData(7, LIE_DATA[7][j]);
            SMALL_GROUP_LIB_P7[p][j] := LiePRingsInFamily(L, p, "code");
            SMALL_GROUP_NUM_P7[p][j] := Length(SMALL_GROUP_LIB_P7[p][j]);
        fi;
    od;

    if IsBound( SMALL_GROUP_LIB_P7[p][j] ) then 
        return PcGroupCode( SMALL_GROUP_LIB_P7[p][j][k], size );
    fi;

    if SMALL_GROUP_NUM_P7[p][j] > p then 
        Print("constructing a batch of ",SMALL_GROUP_NUM_P7[p][j]," groups ");
        Print("... this may take a while \n");
    fi;

    L := LiePRingByData(7, LIE_DATA[7][j]);
    SMALL_GROUP_LIB_P7[p][j] := LiePRingsInFamily(L, p, "code");
    return PcGroupCode( SMALL_GROUP_LIB_P7[p][j][k], size );
end;

# Method which selects a subset of all those groups with
# a certain combination of properties.
# A default method can be used; but more user friendly would be
# to install something custom which e.g. takes care of filtering
# the abelian groups, and which also knows that all groups
# of order p^n are nilpotent.
SELECT_SMALL_GROUPS_FUNCS[ pos_phoch7 ] := SELECT_SMALL_GROUPS_FUNCS[ 11 ];
#SELECT_SMALL_GROUPS_FUNCS[ pos_phoch7 ] := function( funcs, vals, inforec, all, id )
#    Error("TODO");
#end;

# Optional: Method for IdGroup(size, i).
#ID_GROUP_FUNCS[ pos_phoch7 ] := function( G, inforec )
#    Error("TODO");
#end;

# Method for SmallGroupsInformation(size):
SMALL_GROUPS_INFORMATION[ pos_phoch7 ] := function( size, inforec, num )
    Print( " \n");
    Print( "This database was created by Michael Vaughan-Lee (2014).\n");
end;

