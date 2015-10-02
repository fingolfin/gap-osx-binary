

HaveIsomorphicModularGroupAlgebras := function(G, H)
    local p, TG, TH, CG, CH;
    if Size(G) <> Size(H) then return false; fi;
    if RankPGroup(G) <> RankPGroup(H) then return false; fi;
    p := PrimePGroup(G);
    TG := TableByWeightedBasisOfRad( GroupRing(GF(p), G ) );
    TH := TableByWeightedBasisOfRad( GroupRing(GF(p), H ) );
    if TG.wgs <> TH.wgs then return false; fi;
    if CompareTables(TG, TH) then return true; fi;
    CG := CanoFormWithAutGroupOfTable(TG).cano;
    CH := CanoFormWithAutGroupOfTable(TH).cano;
    return CompareTables(CG, CH);
end;

