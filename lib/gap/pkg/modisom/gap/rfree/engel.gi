
SubspaceByEngelLaw := function( C, M, n )
    local U, m, w, v, u;

    # init with radical
    U := M.ag;
    #Print("    subspace has dim ",Length(U),"\n");
    if Length(U) = C.mul then return U; fi;

    # spinn up power
    w := List([1..C.dim], x -> Zero(C.fld)); w[1] := One(C.fld);
    v := List([1..C.dim], x -> Zero(C.fld)); v[2] := One(C.fld);
    u := EngelComm(C,w,v,n);
    u := u{[C.dim-C.mul+1..C.dim]};
    U := CloseSubspace(M.gl, U, [u]);
    #Print("    subspace has dim ",Length(U),"\n");

    return U;
end;

EngelAlgebra := function(d, c, n, F)
    local i, T, C, M, U;

    # the init step
    T := TrivialTable(d,F);

    # loop
    for i in [2..c] do
        #Print("next step with dim ",T.dim,"\n");
        C := CoveringTable(T);
        #Print("  got cover of dim ",C.dim,"\n");
        if C.nuc = 0 then return T; fi;
        M := AutoActionOnMult(C, T);
        #Print("  induced autos \n");
        U := SubspaceByEngelLaw( C, M, n );
        #Print("  found subspace of dim ",Length(U)," in ",C.mul,"\n");
        if Length(U) = C.mul then return T; fi;
        T := QuotientTableAllowableSpace(C,U);
    od;

    return T;
end;

EngelLieClass := function(d, n, F)
    local i, T, C, M, U, w;

    # the init step
    T := TrivialTable(d,F);

    # loop
    while true do
        #Print("next step with dim ",T.dim,"\n");
        C := CoveringTable(T);
        #Print("  got cover of dim ",C.dim,"\n");
        if C.nuc = 0 then return T; fi;
        M := AutoActionOnMult(C, T);
        #Print("  induced autos \n");
        U := SubspaceByEngelLaw( C, M, n );
        #Print("  found subspace of dim ",Length(U)," in ",C.mul,"\n");
        if Length(U) = C.mul then return T; fi;
        T := QuotientTableAllowableSpace(C,U);
        #Print("  determine Lie class \n");
        w := WeightVectorLCS(T);
        Print("  got Lie weights ",w,"\n");
    od;

    return T;
end;
