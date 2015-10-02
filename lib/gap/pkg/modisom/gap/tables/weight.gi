
ProductWeight := function( R, i, j )
    local l, a, d, b, c;

    # swap if commutative
    if IsBound(R.com) and R.com and i>j then 
        return ProductWeight(R,j,i); 
    fi;

    # class limit of the cover
    l := R.wgs[R.dim]+1;
 
    # the easy check
    a := R.wgs[i]+R.wgs[j];
    if a > l then return a; fi;
    
    # look up table if available
    if IsBound(R.tab[i]) and IsBound(R.tab[i][j]) then 
        d := DepthVector(R.tab[i][j]);
        if d > R.dim then 
            a := l; 
        else
            return R.wgs[d];
        fi;
    fi;

    # try defs
    if IsBound(R.wds[i]) then 
        b := ProductWeight(R, R.wds[i][1], R.wds[i][2]) + R.wgs[j];
        a := Maximum(a,b);
        #c := R.wgs[R.wds[i][1]] + ProductWeight(R, R.wds[i][2], j);
        #a := Maximum(a,c);
    fi;

    # that's it
    return a;
end;

