
FilterByRoots := function(grps, roots)
    local res, i, k, j;
    res := [];
    for i in [1..Length(grps)] do
        if Size(grps[i]) in List(roots, x -> x[1]) then
            k := IdGroup(grps[i]);
            if not (k in roots) then Add(res, i); fi;
        fi;
    od;
    return grps{res};
end;

GroupsByRankWidthObliquity := function(p, d, rwo, roots, limit)
    local c, grps, des, i, G;
    
    G := ElementaryAbelianGroup(p^d);
    G!.width := d;
    G!.obliq := 0;
    G!.rank  := d;
    grps := [G];

    c := 0;
    while c < Length(grps) do
        c := c+1;
     
        # descendants
        if not IsCapable(grps[c]) then 
            des := [];
        else
            des := PqDescendants(grps[c]);
        fi;

        # check limit
        des := Filtered(des, x -> Size(x) <= limit);
     
        # check roots
        des := FilterByRoots(des, roots);

        # check width
        for i in [1..Length(des)] do des[i]!.width := WidthPGroup(des[i]); od;
        des := Filtered(des, x -> x!.width <= rwo[1]);

        # check obliquity
        for i in [1..Length(des)] do des[i]!.obliq := Obliquity(des[i]); od;
        des := Filtered(des, x -> x!.obliq <= rwo[3]);

        # check rank
        for i in [1..Length(des)] do des[i]!.rank := SubgroupRank(des[i]); od;
        des := Filtered(des, x -> x!.rank <= rwo[2]);

        # info
        Print("group ",c," of ",Length(grps)," has ",Length(des), " desc \n");

        # add
        Append(grps, des);
    od;

    grps := Filtered(grps, x -> x!.width = rwo[1]);
    grps := Filtered(grps, x -> x!.obliq = rwo[3]);
    grps := Filtered(grps, x -> x!.rank  = rwo[2]);
    return grps;
end;

