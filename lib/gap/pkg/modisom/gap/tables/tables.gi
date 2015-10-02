
##
## .tab .... the table
## .wds .... i-th entry is [k,l] if b[i] = b[k]*b[l]
## .wds .... i-th entry is [k,l,t] if b[i] = b[k]*b[l]-sum_j t[j]b[j]
## .fld .... the field
## .dim .... the dimension
## .wgs .... weights
## .rnk ...  the rank
##
## .com .... commutative (optional)
## .iso .... isomorphism (optional)
## .mul .... multiplicator (optional)
## .nuc .... nucleus (optional)
##
##
## Conventions:
##   T[i] is bound for 1 <= i <= rnk.
##   wds[i] is bound for rnk+1 <= i <= dim.
##   T[i] may be bound for larger i as well.
## 

TrivialTable := function(d, fld)
   return rec(
        tab := List([1..d], x -> NullMat(d,d,fld)),
        wds := [],
        wgs := List([1..d], x -> 1),
        dim := d,
        rnk := d,
        fld := fld );
end;

GetEntryTable := function( T, i, j )
    local l, k, w, v, h;

    # out of range
    if i > T.dim or j > T.dim then return fail; fi;

    # available
    if IsBound(T.tab[i]) and IsBound(T.tab[i][j]) then return T.tab[i][j]; fi;

    # check for commutativity
    if IsBound(T.com) and T.com and i>j then return GetEntryTable(T, j, i); fi;

    # set up
    v := List([1..T.dim], x -> Zero(T.fld));

    # check if weights are out of bounds
    if T.wgs[i]+T.wgs[j]>T.wgs[T.dim] then return v; fi;

    # get ingredients
    l := T.wds[i][1];
    k := T.wds[i][2];
    w := GetEntryTable(T, k, j);

    # compute
    for h in [1..T.dim] do
        if w[h]<>Zero(T.fld) then
            AddRowVector( v, T.tab[l][h], w[h] );
        fi;
    od;

    # add to table if desired and possible
    if STORE then 
        if not IsMutable(T.tab) then Error("not mutable ..."); fi;
        if not IsBound(T.tab[i]) then T.tab[i] := []; fi;
        if not IsMutable(T.tab[i]) then Error("not mutable ..."); fi;
        T.tab[i][j] := Immutable(v);
    fi;

    # that's it
    return v;
end;

GetEntryTableSparse := function(T, i, j)
    return VecToSparseVec(GetEntryTable(T,i,j), T.dim, Zero(T.fld));
end;

MultByTable := function( T, v, w )
    local u, i, j;
    u := List([1..T.dim], x -> Zero(T.fld));
    for i in [1..T.dim] do
        if v[i] <> Zero(T.fld) then 
            for j in [1..T.dim] do
                if w[j]<>Zero(T.fld) then 
                    AddRowVector( u, GetEntryTable(T,i,j), v[i]*w[j]);
                fi;
            od;
        fi;
    od;
    return u;
end;

PowerByTable := function( T, v, n )
    local d, u, i;
    d := DepthVector(v);
    if d > T.dim or n*T.wgs[d] > T.wgs[T.dim] then 
        return List([1..T.dim], x -> Zero(T.fld));
    fi;
    u := ShallowCopy(v);
    for i in [2..n] do u := MultByTable( T, u, v ); od;
    return u;
end;

MultByTableMod := function( T, v, w, l )
    local n, u, i, j, t, g;
    u := List([1..l], x -> Zero(T.fld));
    for i in [1..l] do
        for j in [1..l] do
            if v[i] <> Zero(T.fld) and w[j]<>Zero(T.fld) then 
                t := GetEntryTable(T, i, j){[1..l]};
                AddRowVector(u, t, v[i]*w[j]);
            fi;
        od;
    od;
    return u;
end;

MatToList := function(mat)
    local l, i, j;
    l := [];
    for i in [1..Length(mat)] do
        for j in [1..Length(mat[i])] do
            if mat[i][j] <> 0 * mat[i][j] then 
                if IsFFE(mat[i][j]) then 
                    Add(l,[i,j,IntFFE(mat[i][j])]);
                else
                    Add(l,[i,j,mat[i][j]]);
                fi;
            fi;
        od;
    od;
    return l;
end;

ListToMat := function(l,dim,fld)
    local mat, i;
    mat := MutableNullMat(dim,dim,fld);
    for i in [1..Length(l)] do
        mat[l[i][1]][l[i][2]] := l[i][3]*One(fld);
    od;
    return mat;
end;

PrintCompressedTable := function( A, name, file )
    local i;

    # init
    PrintTo(file,name," := function() \n");
    AppendTo(file,"local A, i; \n");
    
    # set up
    AppendTo(file,"A := rec(); \n");
    AppendTo(file,"A.rnk := ",A.rnk,"; \n"); 
    AppendTo(file,"A.dim := ",A.dim,"; \n"); 
    AppendTo(file,"A.fld := ",A.fld,"; \n"); 
    AppendTo(file,"A.wgs := ",A.wgs,"; \n"); 
    AppendTo(file,"A.wds := ",A.wds,"; \n"); 
    if IsBound(A.com) then AppendTo(file,"A.com := ",A.com,"; \n"); fi;

    # add compressed tab
    AppendTo(file,"A.tab := ",[],"; \n"); 
    for i in [1..A.rnk] do
        AppendTo(file,"A.tab[",i,"] := ",MatToList(A.tab[i]),"; \n");
    od;

    # add uncompress
    AppendTo(file,"for i in [1..A.rnk] do \n");
    AppendTo(file,"    A.tab[i] := ListToMat(A.tab[i],A.dim,A.fld); \n");
    AppendTo(file,"od; \n");

    # finish
    AppendTo(file,"return A; \n");
    AppendTo(file,"end; \n");

end;

CompleteTable := function( T )
    local i, j;
    for i in [1..T.dim] do
        if not IsBound(T.tab[i]) then T.tab[i] := []; fi;
        for j in [1..T.dim] do
            if not IsBound(T.tab[i][j]) then
                T.tab[i][j] := GetEntryTable(T, i, j);
            fi;
        od;
    od;
end;

CompareTables := function( A, B )
    local i;
    if A.fld <> B.fld then return false; fi;
    if A.dim <> B.dim then return false; fi;
    if A.wgs <> B.wgs then return false; fi;
    if A.wds <> B.wds then return false; fi;
    for i in [1..A.rnk] do
        if A.tab[i] <> B.tab[i] then return false; fi;
    od;
    return true;
end;


