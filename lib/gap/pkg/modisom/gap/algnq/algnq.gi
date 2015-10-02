
ExponentSum := function(m)
    local a, i;
    a := 0;
    for i in [2, 4 .. Length(m)] do a := a+m[i]; od;
    return a;
end;

BaseMatT := function(M)
    local j;
    if Length(M)=0 then return M; fi;
    M := MutableCopyMat(M);
    TriangulizeMat(M);
    j := Position(M, 0*M[1]);
    if IsBool(j) then return M; fi;
    return M{[1..j-1]};
end;

InitNQ := function(A)
    local F, r, g, n, d, M, w, v, e, R, I, J, dep, ndp, C, i, j, B;

    # set up
    F := LeftActingDomain(A);
    r := RelatorsOfFpAlgebra(A);
    g := FreeGeneratorsOfFpAlgebra(A);
    n := Length(g);

    # create matrix
    M := [];
    for w in r do
        v := List([1..n], x -> Zero(F));
        e := ExtRepOfObj(w)[2];
        for i in [1, 3 .. Length(e)-1] do
            if Length(e[i]) = 2 and e[i][2] = 1 then 
                v[e[i][1]] := v[e[i][1]] + e[i+1];
            fi;
        od;
        Add(M, v); 
    od;

    B := BaseMatT(M);
    d := n - Length(B);

    # set up record
    R := TrivialTable(d, F);

    # get basis through M
    I := IdentityMat(n, F);
    J := IdentityMat(d, F);
    dep := List(B, PositionNonZero);
    ndp := Difference([1..n], dep);
    C := Concatenation(I{ndp},B);

    # add images and definitions
    R.img := [];
    R.def := [];
    for i in [1..n] do
        j := Position(ndp, i);
        if IsInt(j) then
            R.img[i] := J[j];
            R.def[j] := i;
        else
            R.img[i] := SolutionMat(C, I[i]){[1..d]};
        fi;
    od;

    # reduce M to the non-definitions and store it
    R.mat := M{[1..Length(M)]}{dep};

    # that's it
    return R;
end;

EvalMonomial := function( T, img, word )
    local z, l, w, v, i, k, e, j;

    # set up
    z := 0*img[1]; ConvertToVectorRepNC( z, T.fld );
    l := Length(word);

    # weights
    w := Sum( word{[2,4..l]} );
    if w > T.wgs[T.dim] then return z; fi;

    # powers
    v := [];
    for i in [1 .. l/2] do
        k := word[2*i-1];
        e := word[2*i];
        v[i] := img[k];
        for j in [1..e-1] do
            v[i] := MultByTable( T, v[i], img[k] );
        od;
        if v[i] = z then return z; fi;
    od;

    # all
    for i in [2..Length(v)] do
        v[1] := MultByTable( T, v[1], v[i] );
    od;
    return v[1];
end;

EvalRelator := function( T, img, word )
    local v, e, i, u;

    # set up
    v := 0*img[1]; ConvertToVectorRepNC(v, T.fld);
    e := ExtRepOfObj(word)[2];

    # loop over summands
    for i in [1, 3 .. Length(e)-1] do
        u := EvalMonomial( T, img, e[i] );
        AddRowVector(v, u, e[i+1]);
    od;

    return v;
end;

ExtendNQ := function( A, B )
    local F, r, n, d, s, l, C, m, z, img, i, W, v, U, V, Q, c, I, t;

    # set up
    F := LeftActingDomain(A);
    r := RelatorsOfFpAlgebra(A);
    n := Length(FreeGeneratorsOfFpAlgebra(A));
    d := B.rnk;
    s := n - d;
    l := Length(r);

    # compute cover 
    C := CoveringTable(B);
    m := C.dim - B.dim;
    z := List([1..m], x -> Zero(F));

    # extend images
    img := List(B.img, x -> Concatenation(x, z));
    for i in [1..Length(img)] do ConvertToVectorRepNC( img, F ); od;

    # check a special case
    if Length(r) = 0 then 
        C.def := B.def;
        C.mat := B.mat;
        C.img := img;
        return C; 
    fi;

    # evaluate and extend relators
    W := [];
    for i in [1..l] do

        # evaluate 
        v := EvalRelator( C, img, r[i] );
        if CHECK_NQA and v{[1..B.dim]} <> 0 * v{[1..B.dim]} then 
            Error("rel does not evaluate to zero");
        fi;
        v := v{[B.dim+1..C.dim]};

        # extend
        if Length(B.mat)=0 then 
            W[i] := v; ConvertToVectorRepNC( W[i], F );
        else
            W[i] := Concatenation(B.mat[i], v); ConvertToVectorRepNC(W[i],F);
        fi;
    od;

    # get basis
    U := BaseMatT(W);
    V := U{[s+1..Length(U)]}{[s+1..s+m]};

    # compute quotient
    Q := QuotientTableAllowableSpace( C, V );
 
    # add defs and mat 
    Q.def := B.def;
    Q.mat := B.mat;

    # extend images 
    Q.img := [];
    z := List([1..Q.dim-B.dim], x -> Zero(F));
    c := 0;
    I := IdentityMat(s, F);
    for i in [1..n] do
        if i in Q.def then 
            Q.img[i] := Concatenation(B.img[i], z);
        else
            c := c+1;
            t := -U[c]{[s+1..s+m]};
            v := SolutionMat(Q.bas, t){[Length(V)+1..m]};
            Q.img[i] := Concatenation(B.img[i], v);
        fi;
    od;
    Unbind(Q.bas);
    return Q;
end;

NilpotentQuotientOfFpAlgebra := function( arg )
    local A, c, B, k, C, i;
    A := arg[1];
    if IsBound(arg[2]) then c := arg[2]; else c := infinity; fi;
    B := InitNQ(A);
    i := 1;
    while i <= c do 
        i := i+1;
        if HasIsCommutative(A) and IsCommutative(A) then B.com := true; fi;
        C := ExtendNQ(A,B);
        if C.dim = B.dim then 
            return B; 
        else
            B := C;
        fi;
    od;
    return B;
end;

NQOfFpAlgebra := function( A )
    local B, i, t, s;
    s := 0;
    t := Runtime();
    B := InitNQ(A);
    t := Runtime()-t;
    s := s+t;
    Print("step 1: dim = ", B.dim, " -- time: ", StringTime(s),"\n"); 
    for i in [2..100] do
        if HasIsCommutative(A) and IsCommutative(A) then B.com := true; fi;
        t := Runtime();
        B := ExtendNQ(A,B);
        t := Runtime()-t;
        s := s+t;
        Print("step ",i,":  dim = ", B.dim, " -- time: ", StringTime(s),"\n"); 
    od;
    return B;
end;

CHECK_NQ_QUOT := function( A, NA )
    local B, b, c, C, a, r, i, v;

    # get algebra
    B := AlgebraByTable(NA);
    b := BasisVectors(Basis(B));
    c := List(NA.img, x -> x*b);
    C := Subalgebra(B, c);
    if Dimension(C) < Dimension(B) then return false; fi;

    # check rels
    a := FreeGeneratorsOfFpAlgebra(A);
    r := RelatorsOfFpAlgebra(A);
    for i in [1..Length(r)] do
        v := MappedExpressionForElementOfFreeAssociativeAlgebra(r[i], a, c);
        if v <> Zero(B) then return r[i]; fi;
    od;
    return true;
end;

CHECK_EPI := function( A, T, img )
    local B, b, c, C, a, r, i, v;

    # get algebra
    B := AlgebraByTable(T);
    b := BasisVectors(Basis(B));
    c := List(img, x -> x*b);
    C := Subalgebra(B, c);
    if Dimension(C) < Dimension(B) then return false; fi;

    # check rels
    a := FreeGeneratorsOfFpAlgebra(A);
    r := RelatorsOfFpAlgebra(A);
    for i in [1..Length(r)] do
        v := MappedExpressionForElementOfFreeAssociativeAlgebra(r[i], a, c);
        if v <> Zero(B) then return r[i]; fi;
    od;
    return true;
end;


