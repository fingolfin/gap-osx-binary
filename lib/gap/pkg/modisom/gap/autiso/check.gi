
IsAutomorphismByTable := function( T, m )
    local i, j, a, b;
    if Length(m) <> T.dim then return false; fi;
    if RankMat(m) <> T.dim then return false; fi;
    for i in [1..T.dim] do
        for j in [1..T.dim] do
            a := MultByTable( T, m[i], m[j] );
            b := GetEntryTable( T, i, j ) * m;
            if a <> b then return false; fi;
        od;
    od;
    return true;
end;

IsAutomorphismByAlgebra := function( A, m )
    local  i, j, B, l, r;
    B := Basis( A );
    for i  in [ 1 .. Length(B) ]  do
        for j  in [ i + 1 .. Length(B) ]  do
            l := (B[i]*B[j]) * m;
            r := (B[i]*m) * (B[j]*m);
            if l <> r then return false; fi;
        od;
    od;
    return true;
end;

CheckGroupByTable := function( G, T )
    local g;
    for g in G.glAutos do
        if not IsAutomorphismByTable( T, g ) then 
            return false;
        fi;
    od;
    for g in G.agAutos do
        if not IsAutomorphismByTable( T, g ) then 
            return false;
        fi;
    od;
    if not IsAutomorphismByTable( T, G.one ) then 
        return false;
    fi;
    return true;
end;

CheckGroupByAlgebra := function( G, A )
    local g, hom;
    for g in G.glAutos do
        hom := AlgebraHomomorphismByImages( A, A, Basis(A), Basis(A)*g );
        if not IsAlgebraHomomorphism(hom) then 
            return false;
        fi;
    od;
    for g in G.agAutos do
        hom := AlgebraHomomorphismByImages( A, A, Basis(A), Basis(A)*g );
        if not IsAlgebraHomomorphism(hom) then 
            return false;
        fi;
    od;
    return true;
end;

CheckIsomByTables := function( T, S, epi )
    local d, l, n, i, j, a, b; 

    # extend iso
    d := Length(epi);
    l := Length(epi[1]);
    for i in [d+1..l] do
        epi[i] := MultByTable(S, epi[T.wds[i][1]], epi[T.wds[i][2]]);
    od;

    # now check bijection
    if not RankMat(epi) = Length(epi[1]) then return false; fi;

    # now check multiplicative
    n := T.dim;
    for i in [1..n] do
        for j in [1..n] do
            a := GetEntryTable( T, i, j ) * epi;
            b := MultByTable( S, epi[i], epi[j] );
            if a <> b then Error(i,"  ",j); fi;
        od;
    od;
    return true;
end;

