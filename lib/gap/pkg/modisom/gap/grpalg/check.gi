
RandomPcPres := function(G)
    return PcGroupCode( RandomSpecialPcgsCoded(G), Size(G) );
end;

TestCanoForm := function(F, G)
    local T, S, A, B, C, H, i, d;

    A := GroupRing(F,G);
    B := CanoFormWithAutGroupOfRad(A);
    d := B.cano.rnk;

    i := 1;
    while i <= 10 do
        H := RandomPcPres(G);
        A := GroupRing(F, H);
        C := CanoFormWithAutGroupOfRad(A);
        if B.auto.size <> C.auto.size then return false; fi;
        if B.cano.tab{[1..d]} <> C.cano.tab{[1..d]} then return false; fi;
        i := i+1;
    od;

    return true;
end;

TestCanoForms := function(n)
    local i, G, p;
    p := Factors(n)[1];
    for i in [1..NumberSmallGroups(n)] do
        G := SmallGroup(n,i);
        if not TestCanoForm(GF(p),G) then Error("wrong form"); fi;
        Print(i," done \n\n");
    od;
end;

