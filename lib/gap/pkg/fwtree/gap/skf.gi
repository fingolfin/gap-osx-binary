
#############################################################################
##
#F Minpoly . . . . . . . . . . . 
##
## Find [b,a] in Z/nZ for x^2 - ax - b the minimal polynomial of a p^2-1 
## root of unity in Q_p.
##
MinpolySpecialP3 := function(n)
    local q;
    q := 3^n;
    return Flat([1, q-Filtered([1..q-1], x -> x^2 mod q = q-2)]);
end;

MinpolySpecialP5 := function(n)
    local q, b, a, c;
    q := 5^n;
    b := First([1..q-1], x -> OrderMod(x,q) = 4);
    c := (1-2*b^2) mod q;
    a := Filtered([1..q-1], x -> ((x^4 - 4*b*x^2) mod q) = c);
    return Flat([q-b, q-a]);
end;

MinpolyByRoots := function(p,n)
    local q, r, R, f, k, l, b, a, m, h;

    # the special cases
    if p = 3 then return MinpolySpecialP3(n); fi;
    if p = 5 then return MinpolySpecialP5(n); fi;

    # set up
    q := p^n;
    r := p^(n-1);
    R := ZmodnZ(q);

    # find a minimal polynomial mod p
    f := CyclotomicPolynomial(GF(p),p^2-1);
    f := Factors(f)[1];
    f := CoefficientsOfUnivariateLaurentPolynomial(-f)[1];
    f := IntVecFFE(f){[1,2]};
    Print("found ",f," mod p \n");

    # determine b (a primitive p-1 st root of unity)
    for k in [0..r-1] do
        l := f[1] + p*k;
        h := l * One(R);
        if Order(-h)=p-1 then 
            b := [l, h];
            break;
        fi;
    od;
    Print("found b = ",b," \n");

    # determine a (just try)
    for k in [0..r-1] do
        l := f[2] + p*k;
        h := [[Zero(R), b[2]], [One(R), l*One(R)]];
        if Order(h) = p^2-1 then 
            a := l;
            break;
        fi;
    od;

    return [b[1],a];
end;

#############################################################################
##
#F DivisionAlgebraSF . . . for the skew field of index 4 over Q_p
##
DivisionAlgebraSF := function(p, n)
    local q, R, r, S, s, t, i, m;
    
    # set up
    q := p^n;
    R := ZmodnZ(q);

    # get minpoly of a so that a^2 = m + r a;
    r := MinpolyByRoots(p,n);
    m := r[1]; r := r[2];

    # get coeffs of a^p and a^(p+1)
    s := [0,1];
    for i in [2..p] do
        s := [m*s[2], s[1] + r*s[2]];
    od;
    t := [m*s[2], s[1] + r*s[2]];

    # set up
    S := EmptySCTable(4, Zero(R));
    
    # fill up: b1 = 1
    SetEntrySCTable( S, 1, 1, [One(R), 1]);
    for i in [2..4] do
        SetEntrySCTable( S, 1, i, [One(R), i]);
        SetEntrySCTable( S, i, 1, [One(R), i]);
    od;

    # fill up: b2 = a
    SetEntrySCTable( S, 2, 2, [m*One(R), 1, r*One(R), 2]);
    SetEntrySCTable( S, 2, 3, [One(R), 4]);
    SetEntrySCTable( S, 3, 2, [s[1]*One(R), 3, s[2]*One(R), 4]);
    SetEntrySCTable( S, 2, 4, [m*One(R), 3, r*One(R), 4]);
    SetEntrySCTable( S, 4, 2, [t[1]*One(R), 3, t[2]*One(R), 4]);

    # fill up: b3 = pi
    SetEntrySCTable( S, 3, 3, [p*One(R), 1]);
    SetEntrySCTable( S, 3, 4, [p*s[1]*One(R), 1, p*s[2]*One(R), 2]);
    SetEntrySCTable( S, 4, 3, [p*One(R), 2]);

    # fill up: b4 = a pi
    SetEntrySCTable( S, 4, 4, [p*t[1]*One(R), 1, p*t[2]*One(R), 2]);

    # that's it
    return AlgebraByStructureConstants(R, S);
end;

#############################################################################
##
#F ExponentsByGensSF . . . find exponent vector wrt special gens
##
ExponentsByGensSF := function( B, gens, g, p )
    local b, e, n, l, v, w, f;
    
    # set up
    e := List(gens, x -> 0);
    n := ShallowCopy(g);
   
    # some checks
    if n = n^0 then return e; fi;
    l := Position(gens, n);
    if not IsBool(l) then e[l] := 1; return e; fi;

    # loop
    repeat

        # evaluate entries, get first and position
        v := List(Coefficients(B, n-n^0), x -> ValInt(ExtRepOfObj(x), p));
        w := Minimum(v);
        f := First([1..4], x -> v[x]=w);
        if w = 0 then 
            Error("should not happen");
        else
            l := 2+(w-1)*4+f;
        fi;

        # find exponent
        e[l] := ExtRepOfObj(Coefficients(B,n-n^0)[f]/p^w) mod p;

        # reduce
        n := gens[l]^-e[l] * n;

        #Print("got value ",w,"\n");
    until n = n^0;
    #Print("\n");

    return e;
end;

#############################################################################
##
#F ProPSylowGroupOfSF . . . for full skew field
##
ProPSylowGroupOfSF := function(p, n)
    local q, D, B, v, gens, k, coll, i, m, e, j, G;

    # set up
    q := p^n;
    D := DivisionAlgebraSF(p,n);
    B := Basis(D);
    v := BasisVectors(B);
    
    # get generators
    gens := [v[1]+v[3], v[1]+v[4]];
    for k in [1..n-1] do
        Add(gens, v[1]+p^k*v[1]);
        Add(gens, v[1]+p^k*v[2]);
        Add(gens, v[1]+p^k*v[3]);
        Add(gens, v[1]+p^k*v[4]);
    od;
    
#    if p = 2 then
#        Add(gens, v[1]);
#    fi;
    
    # set up collector
    coll := FromTheLeftCollector(Length(gens));

    # determine relations
    for i in [1..Length(gens)] do
       
        # relative orders
        SetRelativeOrder(coll,i,p);

        # powers
        m := gens[i]^p;
        e := ExponentsByGensSF(B, gens, m, p);
        SetPower(coll, i, ObjByExponents(coll, e));
        if CHECK_PROP and not MappedVector(e, gens) = m then 
            Error("power ",i," wrong \n");
        fi;

        # conjugates
        for j in [1..i-1] do
            m := Comm(gens[i],gens[j]);
            e := ExponentsByGensSF(B, gens, m, p);
            SetCommutator(coll,i,j,ObjByExponents(coll, e));
            if CHECK_PROP and not MappedVector(e, gens) = m then 
                Error("conmmutator ",i," by ",j," wrong \n");
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
    G!.gens := gens;

    # add series
    G!.sers := [];
    for k in [0..n-1] do
        e := Igs(G){[3 + k*4..Length(Igs(G))]};
        Add(G!.sers, SubgroupByIgs(G, e));
    od;
   
    # return group
    return G;
end;

#############################################################################
##
#F ProPSylowGroupOfPSF . . . factor mod center
##
ProPSylowGroupOfPSF := function(p, n)
    local G, H, U, u, nat;

    # get SF
    G := ProPSylowGroupOfSF(p,n);

    if n = 1 then return G; fi;

    # find central elements
    if n = 2 then 
        u := [Igs(G)[3]];
    else
        u := List([3, 7 .. Length(Igs(G))-3], x -> Igs(G)[x]);
    fi;
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


