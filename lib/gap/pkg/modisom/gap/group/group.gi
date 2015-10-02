
#
# multiplication is a*b = a+b+ab
#

GroupByTable := function(T)
    local V, v, l, p, i, n, j;
    V := T.fld^T.dim;
    v := Elements(V);
    l := Size(V);
    p := [];
    for i in [1..l] do
        n := [];
        for j in [1..l] do
            n[j] := Position(v, v[i]+v[j]+MultByTable(T,v[i],v[j]));
        od;
        n := PermList(n);
        Add(p, n);
    od;
    return Group(p);
end;

