#############################################################################
##
#F VectorCanonicalForm( pcgs, v, F, l, base )
##
## Pcgs consists of 2-tuples, component 2 acts per right multiplication.
## Computes modulo base{[l+1..n]} or mod [] if base=fail
##
VectorCanonicalForm := function( pcgs, v, F, l, base )
    local p, f, d, o, stab, tran, cano, indu, tail, B,
          i, j, k, e, ec, w, wc, b, s, t; 

    # the trivial case is not supported
    if Length(pcgs) = 0 then return fail; fi;

    # set up
    p := Characteristic(F);
    f := DegreeOverPrimeField(F);
    d := Length(v);
    o := IdentityMat(d,F);

    # get a basis of F over its prime field
    B := Basis(F);

    # init
    stab := ShallowCopy(pcgs);
    tran := pcgs[1]^0;
    cano := ShallowCopy(v);
    indu := IndVector( cano, l, base );

    # get tails
    tail := List( stab, x -> IndVector(cano*(x[2] - o), l, base));

    # use induction on natural flag
    for i in [2..l] do

        # catch relevant entry
        e := List( tail, x -> x[i] );
        ec := List(e, x -> Coefficients(B,x));
        w := indu[i];
        wc := Coefficients(B,w);

        # compute stabilizer
        b := []; 
        for j in Reversed([1..Length(e)]) do
            s := MySolutionMat(ec{b}, ec[j]);
            if IsBool(s) then 
                Add(b, j);
            else
                for k in Reversed([1..Length(s)]) do
                    if s[k]<>0 then 
                        stab[j] := stab[j]*stab[b[k]]^(-s[k] mod p);
                    fi;
                od;
            fi;
        od;

        # compute minimal element
        t := CoeffsMinimalElement(wc, ec{b});

        # get transversal element
        for k in Reversed([1..Length(t)]) do
            if t[k]<>0 then 
                tran := tran * stab[b[k]]^t[k];
            fi;
        od;

        # set up for next round
        if t <> 0*t then
            cano := v * tran[2];
            indu := IndVector( cano, l, base );
        fi;
        if Length(b)>0 then 
            stab := stab{Difference([1..Length(e)], b)};
            tail := List( stab, x -> IndVector(cano*(x[2] - o), l, base));
        fi;
    od;

    if CHECK_CNF then 
        if ForAny( stab, x -> 
            IndVector(cano*x[2],l,base) <> IndVector(cano,l,base) ) then 
            Error("stabilizer does not stabilize in vector cano form");
        fi;
    fi;

    return rec( cano := cano, stab := stab, tran := tran );
end;


#############################################################################
##
#F SubspaceCanonicalForm( pcgs, id, base, F )
##
## Assumes that base is echelonised.
## Pcgs consists of 2-tuples, component 2 acts per right multiplication.
##
SubspaceCanonicalForm := function( pcgs, id, base, F )
    local d, l, I, stab, cano, tran, n, c, b, f;

    # a preliminary check
    if Length(pcgs) = 0 or Length( base ) = 0 then 
        return rec( cano := base, stab := pcgs, tran := id );
    fi;

    # set up
    d := Length(base[1]);
    l := Length(base);
    I := IdentityMat(d,F);

    # use induction on length of base
    for n in Reversed([1..l]) do

        # the first basis vector 
        if n = l then 

            # get cano form
            c := VectorCanonicalForm( pcgs, base[n], F, d, fail );
            #Print("    ag-stab length: ",Length(pcgs)-Length(c.stab),"\n");

            stab := c.stab;
            tran := c.tran;
            cano := MyBaseMat( base * tran[2] );

        # the others 
        elif Length(stab) > 0 then 

            # get basis through cano{[n+1..l]}
            f := BaseSteinitzVectors( I, cano{[n+1..l]} ).factorspace;
            b := Concatenation( f, cano{[n+1..l]});

            # get cano form
            c := VectorCanonicalForm( stab, cano[n], F, d-l+n, b );
            #Print("    ag-stab length: ",Length(stab)-Length(c.stab),"\n");

            # translate result
            stab := c.stab;
            tran := tran * c.tran;
            cano := MyBaseMat( base * tran[2] );
        fi;

    od;

    if CHECK_CNF then 
        if not ForAll( stab, x -> cano = MyBaseMat(cano*x[2]) ) then 
            Error("stabilizer does not stabilize in subspace cano form");
        fi;
    fi;

    return rec( cano := cano, stab := stab, tran := tran );
end;
        
