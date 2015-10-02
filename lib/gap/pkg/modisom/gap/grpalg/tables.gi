
TableByWeightedBasisOfRad := function(A)
    local n, F, q, N, C, m, e, b, c, T, W, i, j, d, v, w, k, l;

    # set up
    n := Dimension(A)-1;
    F := LeftActingDomain(A);
    q := Size(F);
    N := MutableNullMat(n+1,n+1,F);

    # get coeffs for basis C = {v_c | c coeff, c <> 0} of I
    C := WeightedBasisOfRad(A);
    m := C.weights[n];
    e := Position(C.weights, 2)-1;

    # precompute base change
    b := List(C.basis, x -> Coefficients(Basis(A),x)); 
    Add(b, IdentityMat(n+1, F)[n+1]);
    #ConvertToMatrixRepNC(b, q);
    c := b^-1;

    # get structure constants and words
    T := [];
    W := [];
    for i in [1..n] do
        if Sum(C.exps[i])=1 then 
            T[i] := [];
            for j in [1..n] do
                if C.weights[i]+C.weights[j] <= m then 
                    T[i][j] := Coefficients(Basis(A), C.basis[i]*C.basis[j]);
                else
                    T[i][j] := N[j];
                fi;
            od;
            T[i][n+1] := b[i];
            #ConvertToMatrixRepNC(T[i], q);
            T[i] := T[i]*c;
            T[i] := T[i]{[1..n]}{[1..n]};
            #ConvertToMatrixRepNC(T[i], q);
        else
            d := DepthVector(C.exps[i]);
            v := 0*C.exps[i]; v[d] := 1; l := Position(C.exps, v);
            w := C.exps[i]-v; k := Position(C.exps, w);
            W[i] := [l,k];
        fi;
    od;

    # return
    return rec( tab := T, 
                wds := W,
                fld := F, 
                dim := n,
                wgs := C.weights,
                rnk := RankByWeights(C.weights) );
end;

NilpotentTableOfRad := function( A )
    return TableByWeightedBasisOfRad(A);
end;

