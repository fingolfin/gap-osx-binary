
CloseSubspace := function( mats, basis, new )
    return SpinnUpEchelonBase( basis, new, mats, OnRight );
end;

SubspaceByExponentLaw := function( C, M, n )
    local U, m, w, u;

    # init with radical
    U := M.ag;
    Print("    subspace has dim ",Length(U),"\n");
    if Length(U) = C.mul then return U; fi;

    # spinn up power
    w := List([1..C.dim], x -> Zero(C.fld)); w[1] := One(C.fld);
    u := PowerByTable(C, w, n){[C.dim-C.mul+1..C.dim]};
    U := CloseSubspace(M.gl, U, [u]);
    Print("    subspace has dim ",Length(U),"\n");

    return U;
end;

AutoActionOnMult := function(C, T)
    local d, F, z, g, i, j, h, n;

    # init
    d := T.rnk;
    F := T.fld;
    z := List([d+1..T.dim], x -> Zero(F));

    # GL autos
    if IsFinite(F) then 
        g := ShallowCopy(GeneratorsOfGroup(GL(d, F)));
    elif F = Rationals then
        g := ShallowCopy(GeneratorsOfGroup(GL(d,Integers)));
    fi;
    for i in [1..Length(g)] do
        g[i] := ShallowCopy(g[i]);
        for j in [1..d] do
            g[i][j] := Concatenation(g[i][j], z);
        od;
        g[i] := InduceAutoToMult(C,g[i]);
    od;

    # AG autos
    h := [];
    if C.mul > C.nuc then 
        for i in [d+1..T.dim] do
            n := MutableIdentityMat(T.dim, F){[1..d]}; n[1][i] := One(F);
            n := InduceAutoToMult(C,n);
            h := CloseSubspace(g, h, MutableCopyMat(n-n^0));
        od;
    fi;

    return rec( gl := g, ag := h );
end;

KuroshAlgebra := function(arg)
    local i, d, n, F, com, T, C, M, U;

    # get args
    d := arg[1];
    n := arg[2];
    F := arg[3];
    if Length(arg) = 4 then com := arg[4]; else com := false; fi;

    # the init step
    T := TrivialTable(d,F);

    # the first n steps are just the free algebra
    for i in [2..n-1] do
        T.com := com;
        T := CoveringTable(T);
    od;

    # the next steps are more interesting
    while true do
        Print("next step with dim ",T.dim,"\n");
        T.com := com;
        C := CoveringTable(T);
        Print("  got cover of dim ",C.dim,"\n");
        if C.nuc = 0 then return T; fi;
        M := AutoActionOnMult(C, T);
        Print("  induced autos \n");
        U := SubspaceByExponentLaw( C, M, n );
        Print("  found subspace of dim ",Length(U)," in ",C.mul,"\n");
        if Length(U) = C.mul then return T; fi;
        T := QuotientTableAllowableSpace(C,U);
    od;
end;

ExpandExponentLaw := function(T, n)
    local m, l, s, F, x, f, g, r, i, j, k, h, v;

    # get info
    m := T.dim;
    l := T.wgs[m];
    s := Position(T.wgs,l-n+2)-1;
    F := T.fld;

    # get indets
    x := List([1..s], i -> Indeterminate(F,i));
    f := List([1..m], x -> Zero(T.fld));
    for i in [1..s] do f[i] := x[i]; od; 
    Print("got setup \n");

    # get table
    for i in [1..s] do
        for h in [1..s] do
            GetEntryTable(T,i,h);
        od;
    od;
    Print("got reduced table \n");
    
    # loop
    for k in [2..n] do
        g := List([1..m], x -> Zero(T.fld));
        for i in [1..m] do
            if f[i] <> 0*f[i] then 
                for j in [1..s] do
                    v := GetEntryTable(T,i,j);
                    if v <> 0*v then 
                        r := f[i]*x[j];
                        for h in [1..m] do
                            if v[h] <> 0*v[h] then 
                                g[h] := g[h] + v[h]*r;
                            fi;
                        od;
                    fi;
                od;
            fi;
            Print("  ",i," of ",m," at power ",k," is done \n");
        od;
        f := g;
    od;
  
    return g;
end;

