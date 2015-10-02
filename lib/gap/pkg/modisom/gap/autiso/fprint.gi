
CleanBasis := function( bas, wgt, d )
    local i;
    for i in [1..d-1] do
        if IsBound(bas[i]) and wgt[i] < wgt[d] then 
            AddRowVector( bas[i], bas[d], bas[i][d] );
        fi;
    od;
end;

SiftIntoBasis := function( bas, wgt, rel, b, w )
    local d, n, c, v, a;
    d := DepthVector(b);
    n := Length(b);
    while d <= n do
        if IsBool(wgt[d]) then 
            bas[d] := b;
            wgt[d] := w;
            rel[d] := true;
            CleanBasis(bas, wgt, d);
            return;
        elif wgt[d] >= w then
            AddRowVector( b, bas[d], - b[d]);
            d := DepthVector(b);
        elif wgt[d] < w then 
            c := bas[d]; bas[d] := b[d]^-1 * b; b := bas[d] - c;
            v := wgt[d]; wgt[d] := w; w := v;
            rel[d] := true;
            d := DepthVector(b);
        fi;
    od;
end;

PowerBasisWeights := function( T, U, limit )
    local n, d, bas, wgt, rel, i, w, j, b;

    # set up
    n := T.dim;
    d := Position(T.wgs, 2)-1;

    # initialize
    bas := [];
    wgt := List( [1..n], x -> false );
    rel := List( [1..n], x -> true );

    # sift elements of U into basis
    SiftIntoBasis( bas, wgt, rel, U[1], 1 );
    for i in [d+1..n] do
        w := Minimum(QuoInt(T.wgs[i],2), limit );
        SiftIntoBasis( bas, wgt, rel, U[i-d+1], w );
    od;

    # adjust relevance
    for i in [d+1..n] do rel[i] := false; od;

    # loop
    while ForAny(rel, x -> x = true) do
        for i in [1..n] do
            if IsBound(bas[i]) and rel[i]=true then
                for j in [1..n] do
                    if IsBound(bas[j]) 
                       and (wgt[i]=1 or wgt[j]=1) 
                       and (wgt[i]+wgt[j]<=limit) 
                    then
                        b := MultByTable( T, bas[i], bas[j] );
                        SiftIntoBasis( bas, wgt, rel, b, wgt[i]+wgt[j] );
                        b := MultByTable( T, bas[j], bas[i] );
                        SiftIntoBasis( bas, wgt, rel, b, wgt[i]+wgt[j] );
                    fi;
                od;
            fi;
            rel[i] := false;
        od;
    od;

    # return weights
    return SortedList(Filtered(wgt, IsInt));
end;

FPMinOverIdeals := function( T, v, limit )
    local I, d, m, i, U;
    I := IdentityMat(T.dim, T.fld);
    d := Length(Filtered(T.wgs, x -> x=1));
    m := [];
    for i in [1..Length(v)] do
        U := Concatenation([v[i]*I{[1..d]}], I{[d+1..T.dim]});
        m[i] := PowerBasisWeights(T, U, limit);
        m[i] := Collected(m[i]);
        Info( InfoModIsom, 1, "   found weights ",m[i]);
    od;
    return m;
end;

