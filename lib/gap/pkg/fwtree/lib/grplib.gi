
FW_QUOT_LIB := [];
FW_QUOT_LIB[3]  := [,[,[],[],[]],[[]]];
FW_QUOT_LIB[5]  := [,[,[],[]],[[]]];
FW_QUOT_LIB[7]  := [,[,[],[]],[[]]];
FW_QUOT_LIB[11] := [,[,[],[]],[[]]];
FW_QUOT_LIB[13] := [,[,[],[]],[[]]];
FW_QUOT_LIB[17] := [,[,[],[]],[[]]];

ProPQuotient := function( p, dim, deg, no)
    local l, G;

    # check
    if not p in [3,5,11,13,17] then return fail; fi;
    if not IsBound(FW_QUOT_LIB[p][dim]) then return fail; fi;
    if not IsBound(FW_QUOT_LIB[p][dim][deg]) then return fail; fi;
    if not IsBound(FW_QUOT_LIB[p][dim][deg][no]) then return fail; fi;

    # get group
    l := FW_QUOT_LIB[p][dim][deg][no];
    G := PcGroupCode(l.code, l.size);

    # add info
    G!.degree := l.degree;
    G!.dimension := l.dim;
    G!.umramified := l.unramified;
    G!.ramified := l.ramified;

    # return
    return G;
end;

