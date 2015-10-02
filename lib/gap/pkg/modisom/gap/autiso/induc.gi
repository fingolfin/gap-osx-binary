
InduceAutoToMult := function( C, mat )
    local m, r, d, z, i, img, new;

    # set up
    m := C.mul;
    r := C.dim - m;
    d := C.rnk;
    z := List([1..m], x -> Zero(C.fld));
    
    # start with new mat on [1..d]
    new := List([1..d], x -> Concatenation(mat[x], z));

    # enlarge to new mat on [d+1..r]
    for i in [d+1..r] do
        new[i] := MultByTable( C, new[C.wds[i][1]], new[C.wds[i][2]] );
    od;

    # compute image on M
    img := [];
    for i in [1..m] do
        img[i] := MultByTable( C, new[C.wds[r+i][1]], new[C.wds[r+i][2]] );
        if Length(C.wds[r+i]) = 3 then 
            img[i] := img[i] - C.wds[r+i][3] * new; 
        fi;
        if CHECK_AUT and not img[i]{[1..r]} = 0 * img[i]{[1..r]} then
            Error("aut does not induce");
        fi;
        img[i] := img[i]{[r+1..r+m]};
    od;

    if CHECK_AUT and RankMat(img) < C.mul then 
        Error("induced auto is not invertible"); 
    fi;

    #ConvertToMatrixRepNC(img, C.fld);
    return Immutable(img);
end;

InduceCAutoToMult := function( C, mat )
    local m, r, d, z, i, img, new;

    # set up
    m := C.mul;
    r := C.dim - m;
    d := C.rnk;
    z := List([1..m], x -> Zero(C.fld));
    
    # start with new mat on [1..d]
    new := List([1..d], x -> Concatenation(mat[x], z));

    # enlarge to new mat on [d+1..r]
    for i in [d+1..r] do
        new[i] := MultByTable( C, new[C.wds[i][1]], new[C.wds[i][2]] );
    od;

    # compute image on M
    img := [];
    for i in [1..m] do
        img[i] := MultByTable( C, new[C.wds[r+i][1]], new[C.wds[r+i][2]] );
        if Length(C.wds[r+i]) = 3 then 
            img[i] := img[i] - C.wds[r+i][3] * new; 
        fi;
        if CHECK_AUT and not img[i]{[1..r]} = 0 * img[i]{[1..r]} then
            Error("aut does not induce");
        fi;
        img[i] := img[i]{[r+1..r+m]};
    od;

    if CHECK_AUT and RankMat(img) < C.mul then 
        Error("induced auto is not invertible"); 
    fi;

    #ConvertToMatrixRepNC(img, C.fld);
    return Immutable(img);
end;

InduceAutosToMult := function( G, C, R )
    local i, m;

    for i in [1..Length(G.glAutos)] do
        m := InduceAutoToMult( C, G.glAutos[i] );
        G.glAutos[i] := Tuple( [G.glAutos[i], m] );
    od;

    for i in [1..Length(G.agAutos)] do
        m := InduceAutoToMult( C, G.agAutos[i] );
        G.agAutos[i] := Tuple( [G.agAutos[i], m] );
    od;

    G.one := Tuple( [G.one, IdentityMat(C.mul, C.fld)] );

end;

AddCentralAutos := function( G, Q )
    local d, n, q, b, i, j, v, new, mat;

    # catch info
    d := Q.rnk;
    n := Position(Q.wgs, Q.wgs[Q.dim]);
    q := Q.dim;

    # get basis
    b := Basis(Q.fld);
    
    # create autos
    new := [];
    for i in [1..d] do
        for j in [n..q] do
            for v in b do 
                mat := StructuralCopy(G.one);
                mat[i][j] := v;
                #ConvertToMatrixRepNC( mat, G.field );
                Add( new, Immutable(mat) );
            od;
        od;
    od;

    # add to G
    Append( G.agAutos, new );
end;

InduceAutoToQuot := function( Q, mat )
    local q, d, n, new, i;

    # set up
    q := Q.dim;
    d := Q.rnk;
    n := Length(mat[1]);

    # compute
    new := MutableNullMat( q, q, Q.fld );
    for i in [1..d] do new[i]{[1..n]} := mat[1][i]; od;
    for i in [d+1..q] do
        new[i] := MultByTable( Q, new[Q.wds[i][1]], new[Q.wds[i][2]] );
    od;
    #ConvertToMatrixRepNC( new, Q.fld );
    return Immutable(new);
end;

InduceAutosToQuot := function( G, Q )
    local i;

    # extend gl-autos
    for i in [1..Length(G.glAutos)] do
        G.glAutos[i] := InduceAutoToQuot( Q, G.glAutos[i] );
    od;
    
    # extend ag-autos
    for i in [1..Length(G.agAutos)] do
        G.agAutos[i] := InduceAutoToQuot( Q, G.agAutos[i] );
    od;

    # add new identity
    G.one  := IdentityMat( Q.dim, G.field );

    # add central autos
    AddCentralAutos( G, Q );

    # adjust size
    if Characteristic(G.field) = 0 then 
        G.size := infinity; 
    else
        G.size := G.glOrder * Characteristic(G.field)^Length(G.agAutos);
    fi;
end;

