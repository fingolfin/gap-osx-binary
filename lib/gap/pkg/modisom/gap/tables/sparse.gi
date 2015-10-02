
SparseZeroVec := function( d, F )
    return [];
end;

SparseNullMat := function(d,n,F) 
    return List([1..d], x -> []); 
end;

SparseVecMatMult := function( w, mat, n, z )
    local v, i, e, j;
    v := [];
    for i in [1..n] do
        e := z;
        for j in [1..n] do
            if IsBound(w[j]) and IsBound(mat[i][j]) then 
                e := e+w[j]*mat[i][j];
            fi;
        od;
        if e <> z then v[i] := e; fi;
    od;
    return v;
end;

SparseAddVec := function( v, w, e, n, z )
    local i;
    if e = z then return; fi;
    for i in [1..n] do
        if IsBound(v[i]) and IsBound(w[i]) then 
            v[i] := v[i]+e*w[i];
            if v[i] = z then Unbind(v[i]); fi;
        elif IsBound(w[i]) then 
            v[i] := e*w[i];
        fi;
    od;
end;

SparseDepthVec := function( v, n )
    local i;
    for i in [1..n] do
        if IsBound(v[i]) then return i; fi;
    od;
    return n+1;
end;

SparseCutVec := function( v, l, r )
    local w, i;
    w := [];
    for i in [l..r] do
        if IsBound(v[i]) then 
            w[i] := v[i];
        fi;
    od;
    return w;
end;

SparseLimit := function( v, r )
    local w, i;
    w := [];
    for i in [1..Length(r)] do
        if IsBound(v[r[i]]) then 
            w[i] := v[r[i]];
        fi;
    od;
    return w;
end;

SparseInsert := function( v, w, r )
    local i;
    for i in [1..Length(r)] do
        if IsBound(w[i]) then 
            v[r[i]] := w[i];
        fi;
    od;
end;

SparseConcat := function( v, w, r, z )
    local i;
    for i in [1..Length(w)] do
        if w[i] <> z then
            v[r+i] := w[i];
        fi;
    od;
    return v;
end;

VecToSparseVec := function( v, n, z )
    local w, i;
    w := [];
    for i in [1..n] do
        if v[i] <> z then 
            w[i] := v[i];
        fi;
    od;
    return w;
end;

SparseVecToVec := function( w, n, z )
    local v, i;
    v := List([1..n], x -> z);
    for i in [1..n] do
        if IsBound(w[i]) then 
            v[i] := w[i];
        fi;
    od;
    return v;
end;
 

