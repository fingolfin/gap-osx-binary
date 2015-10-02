
EvalPoly := function( C, elm, pol )
    local d, e, i, c, w;
    c := CoefficientsOfUnivariatePolynomial(pol);
    d := Length(c)-1;
    e := [elm]; for i in [2..d] do e[i] := MultByTable(C, elm, e[i-1]); od;
    w := 0*elm; for i in [2..d] do w := w + c[i+1]*e[i]; od;
    return w;
end;

SubspaceByPILaw := function(C, M, f)
    local U, w, u;

    # init with radical
    U := M.ag;
    Print("    subspace has dim ",Length(U),"\n");
    if Length(U) = C.mul then return U; fi;

    # spinn up power
    w := List([1..C.dim], x -> Zero(C.fld)); w[1] := One(C.fld);
    u := EvalPoly(C, w, f){[C.dim-C.mul+1..C.dim]};
    U := CloseSubspace(M.gl, U, [u]);
    Print("    subspace has dim ",Length(U),"\n");

    return U;
end;

PIAlgebra := function( arg )
    local d, f, F, T, C, M, U, com;

    # get args
    d := arg[1];
    f := arg[2];
    F := arg[3];
    if Length(arg) = 4 then com := arg[4]; else com := false; fi;

    # the init step
    T := TrivialTable(d,F);

    # the next steps are more interesting
    while true do
        Print("next step with dim ",T.dim,"\n");
        T.com := com;
        C := CoveringTable(T);
        Print("  got cover of dim ",C.dim,"\n");
        M := AutoActionOnMult(C, T);
        Print("  induced autos \n");
        U := SubspaceByPILaw( C, M, f );
        Print("  found subspace of dim ",Length(U)," in ",C.mul,"\n");
        if Length(U) = C.mul then return T; fi;
        T := QuotientTableAllowableSpace(C,U);
    od;

end;


