
CheckAssociativity := function(T)
    local i, j, k, a, b, l, c;

    for i in [1..T.dim] do
        for j in [1..T.dim] do
            for k in [1..T.dim] do
                a := GetEntryTable(T,i,j);
                b := List([1..T.dim], x -> Zero(T.fld));
                for l in [1..T.dim] do
                    if a[l] <> Zero(T.fld) then 
                        AddRowVector(b, GetEntryTable(T,l,k), a[l]);
                    fi;
                od;
 
                a := GetEntryTable(T,j,k);
                c := List([1..T.dim], x -> Zero(T.fld));
                for l in [1..T.dim] do
                    if a[l] <> Zero(T.fld) then 
                        AddRowVector(c, GetEntryTable(T,i,l), a[l]);
                    fi;
                od;
      
                if b <> c then return [i,j,k]; fi;
            od;
        od;
    od;

    return true;
end;

CheckConsistency := function( T )
    local i, w, j;
    for i in [1..T.dim] do
        if IsBound(T.wds[i]) then 
            w := T.tab[T.wds[i][1]][T.wds[i][2]];
            for j in [1..T.dim] do
                if i <> j and w[j] <> Zero(T.fld) then return false; fi;
                if i = j and w[j] <> One(T.fld) then return false; fi;
            od;
        fi;
    od;
    return true;
end;

CheckCommutativity := function( T )
    local i, j;
    for i in [1..T.rnk] do
        for j in [1..T.rnk] do
            if T.tab[i][j] <> T.tab[j][i] then 
                T.com := false;
                return false; 
            fi;
        od;
    od;
    T.com := true;
    return true;
end;


