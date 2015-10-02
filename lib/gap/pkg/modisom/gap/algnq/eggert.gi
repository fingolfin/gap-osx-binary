
PthPowers := function( T )
    local p, I, B;
    p := Characteristic(T.fld);
    I := IdentityMat(T.dim, T.fld);
    B := List(I, x -> PowerByTable( T, x, p ));
    return MyBaseMat(B);
end;

Eggert := function(d, c, p)
    local A, N, I;
    A := FreeAssociativeAlgebra(GF(p), d);
    A := A/[Zero(A)];
    SetIsCommutative(A, true);
    N := NilpotentQuotientOfFpAlgebra(A, c);
    I := PthPowers(N);
    Print(N.dim," over ",Length(I),"\n");
    return rec(alg := N, pth := I);
end;

InduceModule := function( M, B, J )
    local C, D, d, mats;
    C := Concatenation(B,J);
    D := C^-1;
    d := Length(B);
    mats := List(M.generators, x -> (D*x)*C);
    mats := List(mats, x -> x{[1..d]}{[1..d]});
    return GModuleByMats(mats, M.field);
end;

InduceIdeal := function( I, B, J )
    local C, d, K;
    C := Concatenation(B,J);
    d := Length(B);
    K := List(I, x -> SolutionMat(C,x){[1..d]});
    return K;
end;

FindIdeal := function(N, I)
    local d, M, J, B, K, L, m;
    d := RankOfTable(N);
    M := GModuleByMats( N.tab{[1..d]}, N.fld );
    J := [];
    B := IdentityMat(N.dim, N.fld);
    K := M;
    L := I;

    repeat 
        m := SMTX.BasesMinimalSubmodules(K);
        m := List(m, x -> x[1]);
        m := Filtered(m, x -> IsBool(SolutionMat(L, x)));
        m := List(m, x -> x * B);
        if Length(m) = 0 then return J; fi;
        J := MyBaseMat(Concatenation(J, m));
        B := BaseSteinitzVectors(IdentityMat(N.dim, N.fld), J).factorspace;
        K := InduceModule(M, B, J);
        L := InduceIdeal(I, B, J);
    until false;
end;
        
