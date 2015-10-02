
AnnihilatorByTable := function( T )
    local d, n, M, j, m, i;

    d := T.rnk;
    n := T.dim;
    M := [];

    for j in [1..n] do
        m := [];
        for i in [1..d] do
            Append(m, GetEntryTable(T,j,i));
            Append(m, GetEntryTable(T,i,j));
        od;
        Add(M, m);
    od;

    return TriangulizedNullspaceMat(M);
end;

AnnihilatorByLayer := function( T, s, l )
    local a, b, M, i, j, m;

    a := Position(T.wgs, s);
    if l = T.wgs[T.dim] then 
        b := T.dim;
    else
        b := Position(T.wgs, l+1)-1;
    fi;

    M := [];
    for j in [a..b] do
        m := [];
        for i in [a..b] do
            Append(m, GetEntryTable(T,j,i){[a..b]});
            Append(m, GetEntryTable(T,i,j){[a..b]});
        od;
        Add(M, m);
    od;

    return TriangulizedNullspaceMat(M);
end;

CenterByTable := function( T )
    local d, n, M, j, m, i;

    d := T.rnk;
    n := T.dim;
    M := [];

    for j in [1..n] do
        m := [];
        for i in [1..d] do
            Append(m, GetEntryTable(T,j,i)-GetEntryTable(T,i,j));
        od;
        Add(M, m);
    od;

    return TriangulizedNullspaceMat(M);
end;

CenterByLayer := function( T, s, l )
    local a, b, M, i, j, m;

    a := Position(T.wgs, s);
    if l = T.wgs[T.dim] then 
        b := T.dim;
    else
        b := Position(T.wgs, l+1)-1;
    fi;

    M := [];
    for j in [a..b] do
        m := [];
        for i in [a..b] do
            Append(m, 
            GetEntryTable(T,j,i){[a..b]}-GetEntryTable(T,i,j){[a..b]});
        od;
        Add(M, m);
    od;

    return TriangulizedNullspaceMat(M);
end;


