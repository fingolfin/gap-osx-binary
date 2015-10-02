
InitAutomGroup := function( Tab )
    local d, F, H, G, V, v, m, s, inv, ind, bas, h, P, i, l, w, n, I;

    # set up full GL
    d := Tab.rnk;
    F := Tab.fld;
    H := GL(d, F);
    V := F^d;
    n := Tab.dim;
    I := IdentityMat(n,F);

    # set up aut group record
    G := rec();
    G.agAutos := [];
    G.one     := One(H);
    G.field   := F;


    # use subgroup of H if desired
    if IsInt(USE_PARTI) then 
        v := List(NormedRowVectors(V), Reversed);
        m := FPMinOverIdeals( Tab, v, USE_PARTI );
        s := Set(m);
        Info( InfoModIsom, 1, "   found partition ",Collected(m));

        # translate to invariant subspaces
        inv := [1..Length(s)];
        for i in [1..Length(s)] do
            ind := Filtered([1..Length(m)], x -> m[x] = s[i]);
            inv[i] := MyBaseMat( v{ind} );
        od;

        # create a chain from invariant subspaces
        inv := Filtered(inv, x -> Length(x)<d);
        bas := BasisBySubspaces( inv, F, d );
        Info( InfoModIsom, 1, "   found basis with weights ",bas.weights);

        # compute mat group that stabilizes this chain
        H := ChainStabilizer( bas.weights, F );
        G.basis   := bas.basis;
        G.partition := Collected(m);

    elif USE_CHARS then 
        
        # get char subs
        inv := TwoStepCents( Tab );
        bas := BasisBySubspaces( inv, F, d );
        Info( InfoModIsom, 1, "   found basis with weights ",bas.weights);

        # compute mat group that stabilizes this chain
        H := ChainStabilizer( bas.weights, F );
        G.basis   := bas.basis;
        G.partition := Collected(List(inv, Length));

    else
        G.basis   := IdentityMat(d,F);
        G.partition := false;
    fi;

    # add perm action 
    v := Filtered( Elements(V), x -> x <> Zero(V) );
    h := ActionHomomorphism( H, v, OnRight, "surjective" );
    P := Image(h);
    SetSize(P, Size(H));

    # reset relevant entries in aut group record
    G.glPerms := SmallGeneratingSet(P);
    G.glAutos := List(G.glPerms, x -> PreImagesRepresentative(h,x));
    G.glOrder := Size(H);
    G.size    := Size(H);

    # that's it
    return G;
end;

