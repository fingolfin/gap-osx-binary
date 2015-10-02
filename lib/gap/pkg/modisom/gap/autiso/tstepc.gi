
TwoStepCents := function( arg )
    local T, w, d, n, cents, l, s, m, f, M, i, j, v, u, N;

    # catch arguments and set up
    T := arg[1];
    w := T.wgs;
    d := T.rnk;
    n := w[T.dim];
    if IsBound(arg[2]) then n := Minimum(n, arg[2]); fi;

    # loop
    cents := [];
    for l in [1..n-1] do
        s := Position(w, l);
        m := Position(w, l+1)-1;
        f := Position(w, l+2); 
        if f = fail then f := Length(w); else f := f-1; fi;

        M := List([1..d], x -> []);
        for i in [s..m] do
            for j in [1..d] do
                v := GetEntryTable(T, i, j);
                u := GetEntryTable(T, j, i);
                Append(M[j], v{[1..f]} - u{[1..f]});
            od;
        od;

        N := TriangulizedNullspaceMat(M);
        if Length(N)>0 and Length(N)<d then Add(cents, N); fi;
    od;

    return cents;
end;

