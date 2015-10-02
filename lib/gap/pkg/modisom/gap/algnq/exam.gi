
Example := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 4);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^3 - g[3], g[1]^2 - g[4]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;

Example0 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 2);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[2]^2];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;

Example1 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 4);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[2]^2];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,2];
    return A;
end;

Example2 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 4);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2 - g[1]*g[2], g[2]^2 - g[4]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,2];
    return A;
end;

Example3 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 4);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2 - g[1]*g[2], g[2]^2];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,2];
    return A;
end;

Example4 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[1]*g[3], g[1]*g[4], g[4]^2, g[2]^2-g[3]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example5 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[1]*g[3], g[1]*g[4], g[4]^2, g[2]^2];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example6 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2-g[1]*g[2], g[1]*g[3], g[1]*g[4], g[2]^2-g[4],
          g[4]^2 - g[5]*g[1]*g[2] - g[5]*g[2]^2 - g[4]*g[2]^3];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example7 := function( arg )
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2-g[1]*g[2], g[1]*g[3], g[1]*g[4], g[2]^2,
          g[4]^2 - g[5]*g[1]*g[2] - g[4]*g[3]*g[2]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example8 := function( arg )
    local K, p, F, g, r, i, j, A;
    K := arg[1];
    p := arg[2];
    F := FreeAssociativeAlgebra(K, p+3);
    g := GeneratorsOfAlgebra(F);
    r := [g[p]^2, g[p+2]^2];
    for i in [1..p-1] do
        Add( r, g[i]*g[p+1] );
        Add( r, g[i]*g[p+2] );
        for j in [1..p-1] do
            Add(r, g[i]*g[j]);
        od;
    od;
    A := F/r; 
    if Length(arg)=3 and arg[3] then SetIsCommutative(A, true); fi;
    A!.grading := List([1..p-1], x -> 2*x-1); 
    Add(A!.grading, [1, 2, 2*p-1, 2*p]);
    return A;
end;

Example9 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[2]^2 - g[1]*g[2], g[2]*g[4], g[3]*g[2],
          g[4]^2 - g[1]*g[2]*g[5] - g[4]*g[3]*g[1]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example10 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 5);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^2, g[2]^2 - g[1]*g[2], g[1]*g[4], g[4]^2, g[1]*g[3]];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    A!.grading := [1,1,2,3,4];
    return A;
end;

Example11 := function(a,b,c,K,com)
    local F, g, r, A;
    F := FreeAssociativeAlgebra(K, 3);
    g := GeneratorsOfAlgebra(F);
    r := [g[1]^a - g[2]*g[3], g[2]^b - g[1]*g[3], g[3]^c - g[1]*g[2],
          g[1]*g[2]*g[3]];
    A := F/r; 
    if com then SetIsCommutative(A, true); fi;
    return A;
end;

#############################################################################
AssocComm := function( list )
    local l, a;
    l := Length(list);
    if l = 1 then return list[1]; fi;
    if l = 2 then 
        return list[1]*list[2] - list[2]*list[1];
    fi;
    if l > 2 then 
        a := AssocComm( list{[2..l]} ); 
        return AssocComm( [list[1], a] );
    fi;
end;

Paper1 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 2);
    g := GeneratorsOfAlgebra(F);
    r := [2*(g[2]*g[1]^2) - (g[2]*g[1])^2];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;

Paper2 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 2);
    g := GeneratorsOfAlgebra(F);
    r := [AssocComm([g[2], 4*g[1]]), 
          AssocComm([g[2], g[1], 4*g[2]]),
          AssocComm([g[2], 4*g[1]*g[2]]),
          AssocComm([g[2], 4*g[1]*g[2]^2])];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;

Paper3 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 2);
    g := GeneratorsOfAlgebra(F);
    r := [AssocComm([g[1], g[1], g[1], g[2]]), 
          AssocComm([g[2], g[2], g[1], g[2]])];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;

Paper4 := function(arg)
    local K, F, g, r, A;
    K := arg[1];
    F := FreeAssociativeAlgebra(K, 2);
    g := GeneratorsOfAlgebra(F);
    r := [AssocComm([g[1], g[1], g[1], g[2]]), 
          AssocComm([g[2], g[2], g[1], g[2]]),
          AssocComm([g[2], g[1], g[2], g[1], g[1], g[2]])];
    A := F/r; 
    if Length(arg)=2 and arg[2] then SetIsCommutative(A, true); fi;
    return A;
end;


