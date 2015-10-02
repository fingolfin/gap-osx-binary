#############################################################################
##
#A  util.gi                 GUAVA library                       Reinald Baart
#A                                                        &Jasper Cramwinckel
#A                                                           &Erik Roijackers
##
##  This file contains miscellaneous functions
##
#H  @(#)$Id: util.gi,v 1.5 2003/02/12 03:49:21 gap Exp $
##
Revision.("guava/lib/util_gi") :=
    "@(#)$Id: util.gi,v 1.5 2003/02/12 03:49:21 gap Exp $";

#############################################################################
##
#F  SphereContent( <n>, <e> [, <F>] ) . . . . . . . . . . .  contents of ball
##
##  SphereContent(n, e [, F]) calculates the contents of a ball of radius e in 
##  the space (GF(q))^n
##

InstallMethod(SphereContent, "n, radius, fieldsize", true, 
	[IsInt, IsInt, IsInt], 0, 
function(n, e, q) 
	local res, num, den, i, q_1;  
	q_1 := q - 1;
    res := 0;
    num := 1;
    den := 1;
    for i in [0..e] do
        res := res + (num * den);
        num := num * q_1;
        den := (den * (n-i)) / (i+1);
    od;
    return res;
end);

InstallOtherMethod(SphereContent, "n, radius, field", true, 
	[IsInt, IsInt, IsField], 0, 
function(n,e,F) 
	return SphereContent(n, e, Size(F)); 
end); 

InstallOtherMethod(SphereContent, "n, radius", true, [IsInt, IsInt], 0, 
function(n, e) 
	return SphereContent(n, e, 2); 
end); 


#############################################################################
##
#F  Krawtchouk( <k>, <i>, <n> [, <F>] ) . . . . . .  Krwatchouk number K_k(i)
##
##  Krawtchouk(k, i, n [, F]) calculates the Krawtchouk number K_k(i) 
##  over field of size q (or 2), wordlength n.
##  Pre: 0 <= k <= n
##

InstallMethod(Krawtchouk, "k, i, wordlength, fieldsize", true, 
	[IsInt, IsInt, IsInt, IsInt], 0, 
function(k, i, n, q) 
    local q_1;
	q_1 := q - 1;
    if k > n or k < 0 then
        Error("0 <= k <= n");
    elif not IsPrimePowerInt(q+1) then
        Error("q must be a prime power");
    fi;
    return Sum([0..k],j->Binomial(i,j)*Binomial(n-i,k-j)*(-1)^j*q_1^(k-j));
end);

InstallOtherMethod(Krawtchouk, "k, i, wordlength, field", true, 
	[IsInt, IsInt, IsInt, IsField], 0, 
function(k, i, n, F) 
	return Krawtchouk(k, i, n, Size(F));
end); 

InstallOtherMethod(Krawtchouk, "k, i, wordlength", true, 
	[IsInt, IsInt, IsInt], 0, 
function(k, i, n) 
	return Krawtchouk(k, i, n, 2); 
end); 

#############################################################################
##
#F  PermutedCols( <M>, <P> )  . . . . . . . . . .  permutes columns of matrix
##

InstallMethod(PermutedCols, "matrix, permutation", true, [IsMatrix, IsPerm], 0, 
function(M, P)
    if P = () then
        return M;
    else
        return List(M, i -> Permuted(i,P));
    fi;
end);

#############################################################################
##
#F  ReciprocalPolynomial( <p> [, <n>] ) . . . . . .  reciprocal of polynomial
##

InstallMethod(ReciprocalPolynomial, "poly, wordlength", true, 
	[IsUnivariatePolynomial, IsInt], 0, 
function(p, n) 
	local cl, F, fam, w;  
	w := Codeword(p, n+1); 
	cl := VectorCodeword(w); 
	F := CoefficientsRing(DefaultRing(PolyCodeword(w))); 
	fam := ElementsFamily(FamilyObj(F)); 
	return LaurentPolynomialByCoefficients(fam, Reversed(cl), 0); 
end); 


InstallOtherMethod(ReciprocalPolynomial, "poly", true, 
	[IsUnivariatePolynomial], 0, 
function(p) 
	local cl, F, fam, w;  
	w := Codeword(p); 
	cl := VectorCodeword(w); 
	F := CoefficientsRing(DefaultRing(PolyCodeword(w))); 
	fam := ElementsFamily(FamilyObj(F)); 
	return LaurentPolynomialByCoefficients(fam, Reversed(cl), 0); 
end); 


#############################################################################
##
#F  CyclotomicCosets( [<q>, ] <n> ) . . . .  cyclotomic cosets of <q> mod <n>
##

InstallMethod(CyclotomicCosets, "cyclotomic cosets of q mod n", 
	true, [IsInt,IsInt], 0, 
function(q, n) 
    local addel, set, res, nrelements, elements, start;
    if Gcd(q,n) <> 1 then
        Error("q and n must be relative primes");
    fi;
    res := [[0]];
    nrelements := 1;
    elements := Set([1..n-1]);
    repeat
        start := elements[1];
        addel := start;
        set := [];
        repeat
            Add(set, addel);
            RemoveSet(elements, addel);
            addel := addel * q mod n;
            nrelements := nrelements + 1;
        until addel = start;
        Add(res, set);
    until nrelements >= n;
    return res;
end);

InstallOtherMethod(CyclotomicCosets, "cyclotomic cosets of 2 mod n", 
	true, [IsInt], 0, 
function(n) 
	return CyclotomicCosets(2, n); 
end); 
 

#############################################################################
##
#F  PrimitiveUnityRoot( [<q>, ] <n> ) . .  primitive n'th power root of unity
##

InstallMethod(PrimitiveUnityRoot, "method for fieldsize, n (th power)", true, 
	[IsInt, IsInt], 0, 
function(q,n)
    local qm;
    qm := q ^ OrderMod(q,n);
	if not qm in [2..65536] then
    Error("GUAVA cannot compute in a finite field of size larger than 2^16");
    fi;
    return Z(qm)^((qm - 1) / n);
end);

InstallOtherMethod(PrimitiveUnityRoot, "method for field, n (th power)", true, 
	[IsField, IsInt], 0, 
function(F, n) 
	return PrimitiveUnityRoot(Size(F), n); 
end); 

InstallOtherMethod(PrimitiveUnityRoot, "method for n (th power)", true, 
	[IsInt], 0, 
function(n) 
	return PrimitiveUnityRoot(2, n); 
end); 

#############################################################################
##
#F  RemoveFiles( <arglist> )  . . . . . . . .  removes all files in <arglist>
##
##  used for functions which use external programs (like Leons stuff)
##

InstallGlobalFunction(RemoveFiles, 
function(arg)
    local f;
    for f in arg do
        Exec(Concatenation("rm -f ",f));
    od;
end);

#############################################################################
##
#F  NullVector( <n> [, <F> ] )  . .  vector consisting of <n> coordinates <o>
##

InstallMethod(NullVector, "length", true, [IsInt], 0, 
function(n) 
	return List([1..n], i->0); 
end); 

InstallOtherMethod(NullVector, "length, field", true, [IsInt, IsField], 0, 
function(n, F) 
	return List([1..n], i->Zero(F)); 
end); 

#############################################################################
##
#F  TransposedPolynomial( <p>, <m> ) . . . . . . . . . tranpose of polynomial
##
##  Returns the transpose of polynomial px mod (x^m-1)
##
InstallMethod(TransposedPolynomial, "poly, length", true, 
	[IsUnivariatePolynomial, IsInt], 0,
function(p, m)
	local i, c, v, F, fam;

	c := CoefficientsOfLaurentPolynomial(p)[1];
	c := MutableCopyMat(c);

	if Length(c) <> m then
		Append(c, List( [1..(m-Length(c))], i->Zero(c[1]) ));
	fi;

	v := [c[1]];
	i := Length(c);
	while (i > 1) do
		v := Concatenation(v, [ c[i] ]);
		i := i-1;
	od;
	F   := CoefficientsRing(DefaultRing(PolyCodeword(Codeword(v, m))));
	fam := ElementsFamily(FamilyObj(F));
	return LaurentPolynomialByCoefficients(fam, v, 0);
end);
