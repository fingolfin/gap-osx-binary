
LCSFactorTypes := function(G)
    local l, r, i, a;
    l := LowerCentralSeries(G);
    r := [];
    for i in [1..Length(l)-1] do
        a := AbelianInvariants(l[i]/l[i+1]);
        Add( r, a );
    od;
    return r;
end;

LCSFactorSizes := function(G)
    local l, r, i;
    l := LowerCentralSeries(G);
    r := [];
    for i in [1..Length(l)-1] do
        Add( r, Index(l[i],l[i+1]) );
    od;
    return r;
end;

WidthPGroup := function(G)
    local l;
    if not IsPGroup(G) then return fail; fi;
    l := LCSFactorSizes(G);
    l := List(l, x -> Length(Factors(x)));
    return Maximum(l);
end;

SubgroupRank := function(G)
    local grps;
    if not IsPGroup(G) then return fail; fi;
    grps := ConjugacyClassesSubgroups(G);
    grps := List(grps, Representative);
    grps := List(grps, RankPGroup);
    return Maximum(grps);
end;

MaxNormals := function(G,N)
    local C, h, m;
    C := CommutatorSubgroup(G,N);
    h := NaturalHomomorphismByNormalSubgroup(N,C);
    m := MaximalSubgroupClassReps(Image(h));
    return List(m, x -> PreImage(h,x));
end;

Obliquity := function(G)
    local l, M, m, o, i, c, U, max;

    if not IsPGroup(G) then return fail; fi;

    # set up
    l := LowerCentralSeries(G);
    M := []; M[1] := [];
    m := []; m[1] := G;
    o := []; o[1] := 0;

    # loop
    for i in [2..Length(l)-1] do

        # M[i]
        M[i] := [l[i-1]];
        c := 0;
        while c < Length(M[i]) do
            c := c+1;
            U := M[i][c];
            max := MaxNormals(G,U);
            max := Filtered(max, x -> not IsSubgroup(l[i],x));
            max := Filtered(max, x -> not x in M[i]);
            Append(M[i], max);
        od;
 
        # m[i]
        m[i] := Intersection(m[i-1], l[i]);
        for U in M[i] do
            m[i] := Intersection(m[i], U);
        od;

        # o[i]
        o[i] := Index(l[i], m[i]);
        if o[i] = 1 then 
            o[i] := 0;
        else
            o[i] := Length(Factors(o[i]));
        fi;
    od;
    return Maximum(o);
end;

HasObliquityZero := function(G)
    local l, M, m, i, c, U, max;

    if not IsPGroup(G) then return fail; fi;

    # set up
    l := LowerCentralSeries(G);
    M := []; M[1] := [];
    m := []; m[1] := G;

    # loop
    for i in [2..Length(l)-1] do

        # Mi
        M[i] := [l[i-1]];
        c := 0;
        while c < Length(M[i]) do
            c := c+1;
            U := M[i][c];
            max := MaxNormals(G,U);
            max := Filtered(max, x -> not IsSubgroup(l[i],x));
            max := Filtered(max, x -> not x in M[i]);
            Append(M[i], max);
        od;
 
        # m[i]
        m[i] := Intersection(m[i-1], l[i]);
        for U in M[i] do
            m[i] := Intersection(m[i], U);
            if Index(l[i], m[i]) > 1 then return false; fi;
        od;
    od;
    return true;
end;

HasObliquityZero2 := function( arg )
    local g, i, N, c, low, n;
    if Length( arg ) = 0 or Length( arg ) > 2 then
        Error( "Syntax: HasObliquityZero( g [, i])\n");
    fi;
    g := arg[1];

    if Length( arg ) = 2 then
        i := arg[2];
    else
        i := 1;
    fi;

    low := LowerCentralSeries( g );
    N := Filtered( NormalSubgroups( g ), n -> not IsSubset( n, low[i] ) );
    for n in N do
        c := NilpotencyClassOfGroup( g / n );
        if not IsSubset( low[c], n ) then
            return false;
        fi;
    od;
    return true;
end;

HasRank3 := function(G)
    return SubgroupRank(G) = 3;
end;
