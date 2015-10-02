
##
## This is the new version of CoveringAlgebra which uses
## sparse vectors
##

AssocRelation1 := function( R, S, i, j, k, n )
    local a, v, r, d;

    # (ij) k  
    v := GetEntryTableSparse( R, i, j );

    # check depths
    d := SparseDepthVec( v, R.dim );
    if d > R.dim then return false; fi;
    if R.wgs[d] + R.wgs[k] > n then return false; fi;

    # otherwise compute
    a := [];
    for r in [1..R.dim] do
        if IsBound(v[r]) then 
            SparseAddVec( a, S.tab[r][k], v[r], S.dim, Zero(R.fld) );
        fi;
    od;

    return SparseVecToVec( a, S.dim, Zero(R.fld) );
end;

AssocRelation2 := function( R, S, i, j, k, n )
    local b, v, s, d, w;

    # i (jk)
    w := ProductWeight( R, j, k );
    if w + R.wgs[i] > n then return false; fi;

    # get entry 
    v := GetEntryTableSparse( R, j, k );

    # check depths
    d := SparseDepthVec( v, R.dim );
    if d > R.dim then return false; fi;
    if R.wgs[d] + R.wgs[i] > n then return false; fi;

    # compute
    b := [];
    for s in [1..R.dim] do
        if IsBound(v[s]) then 
            SparseAddVec( b, S.tab[i][s], v[s], S.dim, Zero(R.fld) );
        fi;
    od;

    return SparseVecToVec( b, S.dim, Zero(R.fld) );
end;

CheckAssoc := function( R, S, i, j, k )
    local w, v, a, b, n;

    # set up
    n := R.wgs[R.dim]+1;

    # preliminary check
    if R.wgs[i]+R.wgs[j]+R.wgs[k] > n then return false; fi;

    # compute
    a := AssocRelation1( R, S, i, j, k, n );
    b := AssocRelation2( R, S, i, j, k, n ); 

    # return 
    if not IsBool(a) and not IsBool(b) then 
        return a-b;
    elif not IsBool(a) then 
        return a;
    elif not IsBool(b) then 
        return b;
    else 
        return false;
    fi;
end;

TailsTable := function( R )
    local d, r, F, n, S, df, rl, i, j, h, k, v, s, com, l;
   
    # catch com
    if IsBound(R.com) and R.com then 
        com := true;
    else
        com := false;
    fi;

    # catch args
    d := R.rnk;
    r := R.dim;
    F := R.fld;
    n := R.wgs[R.dim]+1;

    # construct tails
    S := List([1..r], x -> List([1..r], y -> []));
    df := []; l := 0;
    rl := [];
    for i in [1..r] do
        for j in [1..r] do
            if com and not [i,j] in R.wds and not [j,i] in R.wds and 
               ProductWeight(R,i,j) <= n then
                if j < i then 
                    S[i][j] := S[j][i];
                elif R.wgs[i] = 1 then 
                    Add(df, [i,j]); l := l + 1;
                    S[i][j][l] := One(F);
                else
                    k := R.wds[i][1]; 
                    h := R.wds[i][2];
                    Add( rl, [k, h, j] );
                    v := GetEntryTableSparse(R, h, j );
                    S[i][j] := [];
                    for s in [1..r] do
                        if IsBound(v[s]) then 
                            SparseAddVec(S[i][j], S[k][s], v[s], l, Zero(F));
                        fi;
                    od; 
                fi;
            elif not [i,j] in R.wds and ProductWeight(R,i,j) <= n then
                if R.wgs[i] = 1 then 
                    Add(df, [i,j]); l := l + 1;
                    S[i][j][l] := One(F);
                else
                    k := R.wds[i][1]; 
                    h := R.wds[i][2];
                    Add( rl, [k, h, j] );
                    v := GetEntryTableSparse(R, h, j );
                    S[i][j] := [];
                    for s in [1..r] do
                        if IsBound(v[s]) then 
                            SparseAddVec(S[i][j], S[k][s], v[s], l, Zero(F));
                        fi;
                    od; 
                fi;
            fi;
        od;
    od;

    # return
    return rec( tab := S, dim := l, rl := rl, df := df );
end;

EvalAssoc := function( R, S )
    local d, r, u, i, j, k, v;

    d := R.rnk;
    r := R.dim;
    u := [];

    # loop
    for i in [1..d] do
        for j in [1..r] do
            for k in [1..d] do
                if not [i,j,k] in S.rl then
                    v := CheckAssoc( R, S, i, j, k );
                    if not IsBool(v) then SiftInto(u, v); fi;
                fi;
            od;
        od;
    od;

    return OrderByDepth(u);
end;

SetEntryCover := function( C, R, S, BB, u, i, j )
    local a, b;

    # catch players
    a := GetEntryTable(R, i, j);
    b := S.tab[i][j];

    # adjust b
    if b <> [] then 
        b := SparseVecToVec(b, Length(BB), Zero(R.fld)) * BB;
    else
        b := List([1..S.dim-u], x -> Zero(R.fld) );
    fi;
 
    # add
    C.tab[i][j] := Immutable( Concatenation(a, b) );
end;

QuotientTableAssoc := function( R, S, U )
    local r, u, c, d, n, s, F, C, I, B, w, J, i, j, k, t, BB;

    # set up table
    C := rec();
    C.fld := R.fld;
    C.dim := R.dim+S.dim-Length(U);
    C.rnk := R.rnk;

    # catch arguments
    r := R.dim;
    u := Length(U);
    c := C.dim;
    d := R.rnk;
    n := R.wgs[R.dim];
    s := Position(R.wgs, R.wgs[r]);
    F := R.fld;

    # get basis for nucleus
    I := IdentityMat( S.dim, R.fld );
    B := U; w := []; J := [];
    for j in [s .. r] do
        for i in [1 .. d] do
            k := Position( S.df, [i,j] );
            if not IsBool(k) and not k in J and SiftInto(B, I[k]) then 
                Add(J, k); Add(w, [i,j]);
            fi;
        od;
    od;
    C.nuc := Length(w);

    # get basis for mult
    for j in Reversed([1 .. s-1]) do
        for i in [1..d] do
            k := Position( S.df, [i,j] );
            if not IsBool(k) and not k in J and SiftInto(B, I[k]) then 
                Add(J, k);
                t := GetEntryTable(R, i, j);
                if t = List([1..R.dim], x -> Zero(R.fld)) then 
                    Add(w, [i,j]);
                else
                    Add( w, [i, j, t]);
                fi;
            fi;
        od;
    od;
    C.mul := Length(w);

    # reset B, invert and cut
    I := IdentityMat( S.dim, R.fld );
    B := Concatenation(B{[1..u]}, I{J});
    BB := B^-1; BB := BB{[1..S.dim]}{[u+1..S.dim]};

    # add entries
    C.tab := [];
    for i in [1..d] do
        C.tab[i] := [];
        for j in [1..r] do
            SetEntryCover( C, R, S, BB, u, i, j );
        od;
        for j in [r+1..c] do
            C.tab[i][j] := List([1..c], x -> Zero(F));
        od;
    od;

    if COVER then 
        for i in [d+1..r] do
            if IsBound(R.tab[i]) then 
                C.tab[i] := []; 
                for j in [1..r] do
                    if IsBound(R.tab[i][j]) then 
                        SetEntryCover( C, R, S, BB, u, i, j );
                    fi;
                od;
            fi;
        od;
    fi;

    # words and weights
    C.wds := ShallowCopy(R.wds);
    for i in [r+1..c] do C.wds[i] := w[i-r]; od;
    C.wgs := ShallowCopy(R.wgs);
    for i in [r+1..c] do C.wgs[i] := R.wgs[r]+1; od;

    return C;
end;

CoveringTable := function( R )
    local S, U;

    # set up tails
    S := TailsTable( R );

    # check assoc
    U := EvalAssoc( R, S );

    # get quotient and return
    return QuotientTableAssoc( R, S, U );
end;

