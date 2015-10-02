
ValInt := function(m, p)
    if m = 0 then return infinity; fi;
    if m = 1 then return 0; fi;
    return Length(Filtered(Factors(m), x -> x = p));
end;

ValEntriesSL := function(m, p)
    local v, i, j;
    v := 0*m;
    for i in [1..Length(m)] do
        for j in [1..Length(m)] do
            if i <> j then 
                v[i][j] := ValInt(m[i][j], p); 
            elif i < Length(m) then 
                v[i][j] := ValInt(m[i][j]-1, p);
            else
                v[i][j] := infinity;
            fi;
        od;
    od;
    return v;
end;

FirstEntrySL := function(v, w)
    local i, j;
    if w = 0 then 
        for i in [1..Length(v)] do
            for j in [i+1..Length(v)] do
                if v[i][j] = w then return [i,j,w]; fi;
            od;
        od;
   else
        for i in [1..Length(v)] do
            for j in [1..Length(v)] do
                if v[i][j] = w then return [i,j,w]; fi;
            od;
        od;
   fi;
end;

ExponentsByMatsSL := function( mats, desc, m, p, q )
    local e, v, w, f, l, n;
    
    # set up
    e := List(mats, x -> 0);
    n := ShallowCopy(m);
   
    # some checks
    if n = n^0 then return e; fi;
    l := Position(mats, n);
    if not IsBool(l) then e[l] := 1; return e; fi;

    # loop
    repeat

        # evaluate entries, and get first and position
        v := ValEntriesSL(n, p); 
        w := Minimum(Flat(v));
        f := FirstEntrySL(v,w); 
        l := Position(desc, f);

        # find exponent
        if f[1] <> f[2] then
            e[l] := n[f[1]][f[2]]/p^w mod p;
        else
            e[l] := (n[f[1]][f[2]] - 1)/p^w mod p;
        fi;

        # reduce
        n := mats[l]^-e[l] * n mod q;
    until n = n^0;

    return e;
end;

ProPSylowGroupOfSL := function(d, p, n)
    local a, b, q, mats, desc, i, j, k, e, m, coll, G;

    if d = 1 then return AbelianPcpGroup(1, [p^(n-1)]); fi;

    # set up
    b := d^2;
    a := d*(d-1)/2;
    q := p^n;
    
    # get matrices - 0.layer
    mats := [];
    desc := [];
    for i in [1..d] do
        for j in [i+1..d] do
            e := IdentityMat(d);
            e[i][j] := 1;
            Add(mats, e);
            Add(desc, [i,j,0]);
        od;
    od;

    # get matrices - layers 1 up to n-1
    for k in [1..n-1] do
        for i in [1..d] do
            for j in [1..d] do
                e := IdentityMat(d);
                if i <> j then 
                    e[i][j] := p^k;
                    Add(mats, e);
                    Add(desc, [i,j,k]);
                elif i < d then
                    e[i][i] := 1 + p^k;
                    e[d][d] := ((1+p^k)^-1 mod q); 
                    Add(mats, e);
                    Add(desc, [i,j,k]);
                fi;
            od;
        od;
    od;

    # set up collector
    coll := FromTheLeftCollector(Length(mats));
    for i in [1..Length(mats)] do
       
        # relative orders
        SetRelativeOrder(coll,i,p);

        # powers
        m := mats[i]^p mod q;
        e := ExponentsByMatsSL(mats, desc, m, p, q);
        SetPower(coll, i, ObjByExponents(coll, e));
        if CHECK_PROP and not MappedVector(e, mats) mod q = m then 
            Error("power ",i," wrong \n");
        fi;

        # conjugates
        for j in [1..i-1] do
            m := mats[i]^mats[j] mod q;
            e := ExponentsByMatsSL(mats, desc, m, p, q);
            SetConjugate(coll,i,j,ObjByExponents(coll, e));
            if CHECK_PROP and not MappedVector(e, mats) mod q = m then 
                Error("conjugate ",i," by ",j," wrong \n");
            fi;
        od;
    od;

    # create group
    if CHECK_PROP then 
        G := PcpGroupByCollector(coll); 
    else
        UpdatePolycyclicCollector(coll);
        G:= PcpGroupByCollectorNC(coll);
    fi;

    # add info
    G!.mats := mats;
    G!.desc := desc;

    # add series
    G!.sers := [];
    for k in [0..n-1] do
        e := Igs(G){[d*(d-1)/2 + k*(d^2-1) + 1..Length(Igs(G))]};
        Add(G!.sers, SubgroupByIgs(G, e));
    od;
   
    # return group
    return G;
end;

ProPSylowGroupOfPSL := function(d, p, n)
    local G, H, U, u, k, e, q, m, nat;

    # get SL
    G := ProPSylowGroupOfSL(d,p,n);

    # check 
    if not IsInt(d/p) then return G; fi;

    # find diagonal matrices
    u := [];
    q := p^n;
    for k in [1..p^n-1] do
        if (k mod p = 1) and (k^d mod q = 1) then
            m := k * IdentityMat(d);
            e := ExponentsByMatsSL( G!.mats, G!.desc, m, p, q );
            Add(u, MappedVector(e, Igs(G)));
        fi;
    od;
    U := Subgroup(G, u);

    # factor 
    nat := NaturalHomomorphism(G, U);
    H := Image(nat);
    H!.nat := nat;

    # series
    H!.sers := List(G!.sers, x -> Image(nat,x));

    # that's it
    return H;
end;


