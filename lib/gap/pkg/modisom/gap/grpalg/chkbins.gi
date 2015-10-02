
#############################################################################
##
#F RefineBins( bins, vals )
##
RefineBinByVals := function( bin, vals )
    return List(Set(vals{bin}), x -> Filtered(bin, y -> vals[y]=x));
end;
    
RefineBinsByVals := function( bins, vals )
    local refs;
    refs := Concatenation(List(bins, x -> RefineBinByVals(x, vals )));
    return Filtered(refs, x -> Length(x)>1);
end;

#############################################################################
##
#F CheckBin(p, n, k, list)
##
CheckBin := function(p, n, k, list)
    local grps, algs, tabs, bins, l, m, vals, todo, i, j, d;

    l := Length(list);

    # set up
    grps := List(list, x -> SmallGroup(p^n, x));
    algs := List(grps, x -> GroupRing(GF(p), x));
    tabs := [];
    Print("compute tables through power series \n");
    for i in [1..l] do
        tabs[i] := TableByWeightedBasisOfRad(algs[i]);
        Print("  determined table for ",i,"\n");
    od;
    Print("\n");

    # init bins
    bins := [[1..l]];
    Print("refine bin \n");

    # refine by weights
    vals := List( tabs, x -> x.wgs );
    bins := RefineBinsByVals( bins, vals );
    Print("  weights yields bins ",bins,"\n");
    todo := Flat(bins);
    if Length(todo) = 0 then return; fi;

    # start up and refine by aut group
    vals := [];
    for i in [1..l] do
        if i in todo then 
            InitCanoForm(tabs[i]); 
            vals[i] := [tabs[i].auto.size, tabs[i].auto.partition];
        fi;
    od;
    bins := RefineBinsByVals( bins, vals );
    Print("  layer 1 yields bins ",bins,"\n");
    todo := Flat(bins);
    if Length(todo) = 0 then return; fi;

    # get limit
    m := Maximum( List(tabs, x -> Maximum(x.wgs)));
    if not IsBool(k) then m := Minimum(m,k); fi;

    # loop and refine by canonical forms
    for j in [2..m] do
        vals := [];
        for i in [1..l] do
            if i in todo then 
                ExtendCanoForm(tabs[i], j); 
                vals[i] := tabs[i].cano;
            fi;
        od;
        bins := RefineBinsByVals( bins, vals );
        Print("  layer ",j," yields bins ",bins,"\n");
        todo := Flat(bins);
        if Length(todo) = 0 then return; fi;
    od;
 
    return bins;
end;

