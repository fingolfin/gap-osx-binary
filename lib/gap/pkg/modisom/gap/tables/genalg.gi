
RankByWeights := function( list )
    local i;
    for i in [1..Length(list)] do
        if list[i] = 2 then return i-1; fi;
    od;
    return Length(list);
end;

VecToList := function(vec)
    local l, i;
    l := [];
    for i in [1..Length(vec)] do
        if vec[i] <> 0*vec[i] then
            Add( l, vec[i] );
            Add( l, i );
        fi;
    od;
    return l;
end;

InstallMethod( AlgebraByTable, [IsObject], function( T )
    local n, F, S, i, j, v;
    n := T.dim;
    F := T.fld;
    S := EmptySCTable( n, Zero(F) );
    for i in [1..n] do
        for j in [1..n] do
            v := GetEntryTable(T, i, j);
            SetEntrySCTable( S, i, j, VecToList(v));
        od;
    od;
    return AlgebraByStructureConstants(F, S);
end);

InstallMethod( TableByBasis, [IsAlgebra, IsList], function( A, B )
    local b, a, n, F, S, i, j, c;
    b := Basis(A);
    a := List(B, x -> Coefficients(b,x));
    n := Length(B);
    F := LeftActingDomain(A);
    S := rec( tab := List( [1..n], x -> MutableNullMat(n,n,F)), 
              wds := [], fld := F, dim := n );
    for i in [1..n] do
        for j in [1..n] do
            c := Coefficients(b, B[i]*B[j]);
            S.tab[i][j] := SolutionMat(a,c);
        od;
    od;
    return S;
end );

InstallMethod( ProductIdeal, [IsAlgebra, IsAlgebra], function(I,J)
    local K, b, c, k, i, j;
    K := Parent(I);
    if K <> Parent(J) then TryNextMethod(); fi;
    b := Basis(I);
    c := Basis(J);
    k := [];
    for i in [1..Length(b)] do
        for j in [1..Length(c)] do
            Add(k, b[i]*c[j]);
        od;
    od;
    return SubalgebraNC( K, k );
end );

InstallMethod( PowerSeries, [IsAlgebra], function(J)
    local s, I, K;
    s := [J];
    I := StructuralCopy(J);
    while Dimension(I) > 0 do 
        K := ProductIdeal( J, I );
        if Dimension(K) = Dimension(I) then return s; fi;
        I := K; Add( s, I );
    od;
    return s;
end );

InstallMethod( IsNilpotentAlgebra, [IsAlgebra], function(I)
    local s;
    s := PowerSeries(I);
    return Dimension(s[Length(s)]) = 0;
end );

InstallMethod( WeightedBasis, [IsAlgebra], function(J)
    local s, b, i, nat, c, w;
    s := PowerSeries(J);
    b := [];
    w := [];
    for i in [1..Length(s)-1] do
        nat := NaturalHomomorphismByIdeal(s[i],s[i+1]);
        c := Basis(Image(nat));
        Append( b, List(c, x -> PreImagesRepresentative(nat,x)));
        Append( w, List(c, x -> i));
    od;
    return rec( basis := b, weights := w);
end );

TableByWeightedBasis := function(A)
    local b, T;
    b := WeightedBasis(A);
    T := TableByBasis(A, b.basis);
    T.wgs := b.weights;
    T.rnk := RankByWeights(T.wgs);
    return T;
end;

NilpotentTable := function(A)
    return TableByWeightedBasis(A);
end;
