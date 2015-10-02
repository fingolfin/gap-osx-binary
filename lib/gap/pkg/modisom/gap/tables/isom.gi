
AddIsomCover := function( C, R, T, l )
    local F, r, d, z, A, I, i;

    # catch arguments
    F := R.fld;
    r := R.dim;
    d := R.rnk;

    # init extension of iso R -> T to C -> S
    z := List( [1..l-r], x -> Zero(F) );
    A := List( R.iso, x -> Concatenation( x, z ) );
    I := [];

    # extend first step 
    for i in [d+1..r] do
        A[i] := MultByTableMod( T, A[C.wds[i][1]], A[C.wds[i][2]], l );
    od;

    # extend second step using defs of M
    for i in [1..C.dim-r] do
        I[i] := MultByTableMod( T, A[C.wds[r+i][1]], A[C.wds[r+i][2]], l );
        if Length(C.wds[r+i]) = 3 then I[i] := I[i] - C.wds[r+i][3]*A; fi;
    od;

    # store result
    C.iso := Concatenation( A, I );
end;

AllowableSubspace := function( C, R, T, l )
    local I;

    # get isomorphism 
    AddIsomCover( C, R, T, l );

    # get kernel
    I := C.iso{[C.dim-C.mul+1..C.dim]};

    # adjust and return
    return TriangulizedNullspaceMat(I);
end;

