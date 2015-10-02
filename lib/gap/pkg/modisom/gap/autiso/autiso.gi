
InitCanoForm := function( T )
    local F, d, G, R;

    # set up
    F := T.fld;
    d := T.rnk;

    # init aut group
    G := InitAutomGroup( T );

    # init cano form
    R := TrivialTable(d, F);
    R.iso := IdentityMat(d, F);

    # add info
    T.cano := R;
    T.auto := G;
end;

ExtendCanoForm := function( T, i )
    local F, l, p, R, G, C, U, W, Q;

    # catch some arguments from  A
    F := T.fld;
    p := Characteristic(F);
    l := Length(Filtered(T.wgs, x -> x <= i));

    # catch some arguments from G
    R := T.cano;
    G := T.auto;
    Info( InfoModIsom, 1, "layer ",i, " of dim ",l, " aut group has order ",
                          G.glOrder, " * ", p,"^", Length(G.agAutos) );

    # compute cover
    C := CoveringTable( R );
    Info( InfoModIsom, 1, "   cover is determined ");

    # compute allowable subspace
    U := AllowableSubspace( C, R, T, l );
    Info( InfoModIsom, 1, "   dim(M) = ",C.mul, " and dim(U) = ",Length(U) );

    # lift autos
    InduceAutosToMult( G, C, R );
    Info( InfoModIsom, 1, "   extended autos ");

    # stabilize
    W := HybridMatrixCanoForm( G, U );
    if IsInt(W) then return W; fi;
    Info( InfoModIsom, 1, "   computed stabilizer");

    # extend quotient
    Q := QuotientTableOfCover( C, W );
    Info( InfoModIsom, 1, "   got quotient ");

    # induce autos
    InduceAutosToQuot( G, Q );
    Info( InfoModIsom, 1, "   induced autos ");

    # add info
    T.cano := Q;
    T.auto := G;
end;

CheckField := function(T)
    local F, i, j;
    F := GF(Characteristic(T.fld));
    for i in [1..Length(T.tab)] do
        if IsBound(T.tab[i]) then 
            for j in [1..T.tab[i]] do
                if IsBound(T.tab[i][j]) then
                    if ForAny(T.tab[i][j], x -> not x in F) then 
                        Error("bigger field");
                    fi;
                fi;
            od;
        fi;
    od;
end;

CanoFormWithAutGroupOfTable := function(T)
    local l, i, S, F;

    # make mutable
    if not IsMutable(T) then T := ShallowCopy(T); fi;

    # catch some args
    l := T.wgs[T.dim];

    # 1. step
    InitCanoForm(T);

    # remaining steps
    for i in [2..l] do
        ExtendCanoForm( T, i );
        if CHECK_AUT and not CheckGroupByTable( T.auto, T.cano ) then 
            Error("autos wrong");
        fi;
    od;

    # final check
    if CHECK_AUT and not CheckIsomByTables( T.cano, T, T.cano.iso ) then 
        Error("isom wrong");
    fi;

    # finally add result to group
    S := rec( cano := T.cano, auto := T.auto );
    Unbind(T.cano); Unbind(T.auto);
    return S;
end; 

CanonicalFormOfTable := function(T)
    return CanoFormWithAutGroupOfTable(T).cano;
end;

AutGroupOfTable := function(T)
    return CanoFormWithAutGroupOfTable(T).auto;
end;

CoverInfo := function(T)
    local F, l, d, R, r, i, C, U;

    # set up
    F := T.fld;
    l := T.wgs[T.dim];
    d := T.rnk;

    # init
    R := TrivialTable(d,F);

    r := [];
    for i in [2..l] do
        d := Length( Filtered( T.wgs, x -> x <= i ) );
        if d <= COVER_LIMIT then
            C := CoveringTable( R );
            U := AllowableSubspace( C, R, T, d );
            U := rec( cf := U, ti := [IdentityMat(d, F)] );
            R := QuotientTableOfCover( C, U );
            Add( r, [C.mul,C.nuc] );
        fi;
    od;

    return r;
end;


