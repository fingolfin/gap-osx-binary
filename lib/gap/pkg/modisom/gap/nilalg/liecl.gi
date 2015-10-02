
RingComm := function(T,a,b)
    return MultByTable(T,a,b) - MultByTable(T,b,a);
end;

EngelComm := function(T,a,b,n)
    local x, i;
    x := a;
    for i in [1..n] do
        x := RingComm(T,x,b);
    od;
    return x;
end;

CommutatorIdealByTable := function(T, B, C)
    local A, b, c;
    A := [];
    for b in B do
        for c in C do
            SiftInto(A, RingComm(T,b,c));
        od;
    od;
    return A;
end;

DerivedSeriesByTable := function(T)
    local ser, U, V;
    U := IdentityMat(T.dim,T.fld);
    ser := [U];
    while Length(U) > 0 do
        V := CommutatorIdealByTable(T, U, U);
        if Length(V) = Length(U) then return ser; fi;
        U := V;
        Add(ser, U);
    od;
    return ser;
end;

LowerCentralSeriesByTable := function(T)
    local ser, U, V, I;
    I := IdentityMat(T.dim,T.fld);
    U := IdentityMat(T.dim,T.fld);
    ser := [U];
    while Length(U) > 0 do
        V := CommutatorIdealByTable(T, I, U);
        if Length(V) = Length(U) then return ser; fi;
        U := V;
        Add(ser, U);
    od;
    return ser;
end;

LCSWf := function(w,i,j)
    #return Maximum(w[i],w[j])+1;
    return w[i]+w[j];
end;

DSWf := function(w,i,j)
    if w[i]=w[j] then 
        return w[i]+1; 
    else
        return Maximum(w[i],w[j]);
    fi;
end;

SiftIntoPlus := function(A, w, t, c, v)
    local d;
    d := DepthVector(c);
    while d <= Length(A) do
        if w[d] < v then 
            A[d] := c[d]^-1 * c;
            w[d] := v;
            t[d] := true;
            return;
        else
            c := c - c[d] * A[d];
        fi; 
        d := DepthVector(c);
    od;
end;

DSRf := function(w, t, l, i, j)

    # if nothing has changed
    if t[i] = false and t[j] = false then return false; fi;

    # consider layer
    if w[i] < l or w[j] < l then return false; fi;

    # consider antisymmetry
    return i<j; 
end;

LCSRf := function(w, t, l, i, j)

    # if nothing has changed
    if t[i] = false and t[j] = false then return false; fi;

    # consider layer
    if w[i] < l and w[j] < l then return false; fi;

    # another trivial check
    if i = j then return false; fi;

    # wait further 
    if i<j and t[j] = false then return false; fi;

    # no further ideas
    return true;
end;

MyWeightedBasis := function( T, wf, rf )
    local n, A, w, t, i, j, c, v, l;
    n := T.dim;
    A := IdentityMat(n, T.fld);
    w := List([1..n], x -> 1);
    t := List([1..n], x -> true);
    l := 0;
    while ForAny(t, x -> x = true) do
        l := l+1;
        for i in [1..n] do
            for j in [1..n] do
                if rf( w, t, l, i, j) then 
                    c := RingComm(T,A[i],A[j]);
                    if c <> 0*c then 
                         v := wf(w,i,j);
                         SiftIntoPlus(A, w, t, c, v);
                    fi;
                fi;
            od;
            t[i] := false;
        od;
    od;
                
    return rec(basis := A, weights := w);
end;

WeightVector@ := function( T, wf, rf )
    local w;
    w := MyWeightedBasis(T,wf,rf).weights;
    return List(Collected(w), x -> x[2]);
end;

WeightVectorDS := function(T)
    return WeightVector@(T, DSWf, DSRf);
end;

WeightVectorLCS := function(T)
    return WeightVector@(T, LCSWf, LCSRf);
end;

WeightVectorPS := function(T)
    return List(Collected(T.wgs), x -> x[2]);
end;

