SiftInto := function( B, c )
    local dep, d, i;

    # catch some simple cases
    if c = 0*c then return false; fi;
    if Length(B) = 0 then B[1] := NormedRowVector(c); return true; fi;
    if Length(B) = Length(B[1]) then return false; fi;

    # sift
    dep := List(B, DepthVector);
    while true do
        d := DepthVector(c);
        if d > Length(c) then return false; fi;
        i := Position(dep,d);
        if IsBool(i) then
            B[Length(B)+1] := NormedRowVector(c);
            return true;
        fi;
        AddRowVector( c, B[i], -c[d] );
    od;

end;

OrderByDepth := function( U )
    SortParallel(List(U, DepthVector), U);
    return U;
end;

