
QuotientTableAllowableSpace := function( C, U )
    local Q, d, m, r, w, c, B, I, J, v, BB, i, j, a, b;

    # catch a special case
    if Length(U) = 0 then C.bas := IdentityMat(C.mul, C.fld); return C; fi;

    # set up
    Q := rec();
    Q.fld := C.fld;
    Q.dim := C.dim - Length(U);
    Q.rnk := C.rnk;
    Q.tab := [];
    Q.wds := [];
    Q.wgs := [];

    # catch args
    d := C.rnk;
    m := C.mul;
    c := C.dim;
    r := c - m;
    w := Length(U);

    # get bases
    B := MutableCopyMat(U);
    I := IdentityMat(C.mul, C.fld);
    J := [];
    for i in [1..C.nuc] do if SiftInto(B,I[i]) then Add( J, i ); fi; od;

    # reset B, invert and cut
    I := IdentityMat(C.mul, C.fld);
    B := Concatenation( B{[1..w]}, I{J} ); 
    BB := B^-1; BB := BB{[1..m]}{[w+1..m]};

    # determine quotient table
    for i in [1..d] do
        Q.tab[i] := [];
        for j in [1..r] do
            a := C.tab[i][j]{[1..r]};
            b := C.tab[i][j]{[r+1..c]};
            b := b * BB;
            Q.tab[i][j] := Concatenation( a, b );
        od;
        for j in [r+1..Q.dim] do
            Q.tab[i][j] := List([1..Q.dim], x -> Zero(Q.fld));
        od;
    od;
 
    if ALLOW then 
        for i in [d+1..r] do
            if IsBound(C.tab[i]) then 
                Q.tab[i] := []; 
                for j in [1..r] do
                    if IsBound(C.tab[i][j]) then 
                        a := C.tab[i][j]{[1..r]};
                        b := C.tab[i][j]{[r+1..c]};
                        b := b * BB;
                        Q.tab[i][j] := Concatenation( a, b );
                    fi;
                od;
                for j in [r+1..Q.dim] do
                    if IsBound(C.tab[i][j]) then 
                        Q.tab[i][j] := List([1..Q.dim], x -> Zero(Q.fld));
                    fi;
                od;
            fi;
        od;
    fi;

    # add words and weights
    for i in [1..d] do
        Q.wgs[i] := C.wgs[i];
    od;
    for i in [d+1..r] do
        Q.wgs[i] := C.wgs[i];
        Q.wds[i] := C.wds[i];
    od;
    for i in [1..m-w] do
        Q.wds[r+i] := C.wds[r+J[i]];
        Q.wgs[r+i] := C.wgs[r+J[i]];
    od;

    # that's it
    Q.bas := B;
    return Q;
end;

QuotientTableOfCover := function( C, W )
    local Q, z;
   
    # get quotient by space
    Q := QuotientTableAllowableSpace( C, W.cf ); Unbind(Q.bas);

    # get zero
    z := List([1..C.mul-Length(W.cf)], x -> Zero(C.fld));

    # add isom
    if IsBound(C.iso) then 
        Q.iso := List([1..C.rnk], i -> Concatenation( W.ti[1][i], z ) * C.iso );
    fi;

    # that's it
    return Q;
end;


