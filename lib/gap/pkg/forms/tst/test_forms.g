#some forms in odd char.

f := GF(3);
gram := [[0,0,0,0,0,2],[0,0,0,0,2,0],[0,0,0,1,0,0],[0,0,1,0,0,0],
[0,2,0,0,0,0],[2,0,0,0,0,0]]*Z(3)^0;
form := BilinearFormByMatrix(gram,f);
Display(form);

f := GF(5);
gram := 
[ [ 0*Z(5), Z(5)^3, 0*Z(5), 0*Z(5), 0*Z(5) ], 
  [ Z(5)^3, 0*Z(5), 0*Z(5), 0*Z(5), 0*Z(5) ], 
  [ 0*Z(5), 0*Z(5), Z(5)^3, 0*Z(5), 0*Z(5) ], 
  [ 0*Z(5), 0*Z(5), 0*Z(5), Z(5)^0, Z(5)^2 ], 
  [ 0*Z(5), 0*Z(5), 0*Z(5), Z(5)^2, 0*Z(5) ] ];
form := BilinearFormByMatrix(gram,f);
Display(form);

f := GF(7);
gram := [[-3,0,0,0,0,0],[0,0,3,0,0,0],[0,3,0,0,0,0],[0,0,0,0,0,-1/2],
[0,0,0,0,1,0],[0,0,0,-1/2,0,0]]*Z(7)^0;
form := BilinearFormByMatrix(gram,f);
IsEllipticForm(form);
Display(form);

# some forms in even char
# parabolic example
f := GF(8);
mat := [ [ Z(8) , 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ], 
  [ 0*Z(2), Z(2)^0, Z(2^3)^5, 0*Z(2), 0*Z(2) ], 
  [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ], 
  [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0 ], 
  [ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ] ];
form := QuadraticFormByMatrix(mat,f);
iso := IsometricCanonicalForm(form);
Display(form);
Display(iso);

f := GF(8);
mat := [[Z(8),0,0,0],[0,0,Z(8)^4,0],[0,0,0,1],[0,0,0,0]]*Z(8)^0;
form := QuadraticFormByMatrix(mat,f);
iso := IsometricCanonicalForm(form);
Display(form);
Display(iso);
IsDegenerateForm(iso);
RadicalOfForm(iso);

# hermitian forms
f := GF(9);
gram := [[0,0,0,Z(9)^2],[0,0,1,0],[0,1,0,0],[-Z(9)^2,0,0,0]]*Z(9)^0;
form := HermitianFormByMatrix(gram,f);
iso := IsometricCanonicalForm(form);
Display(form);
Display(iso);

#forms by polynomials.
r := PolynomialRing( GF(11), 4);
vars := IndeterminatesOfPolynomialRing( r );
pol := vars[1]*vars[2]+vars[3]*vars[4];
form := BilinearFormByPolynomial(pol, r, 4);

r := PolynomialRing( GF(7), 6);
vars := IndeterminatesOfPolynomialRing( r );
pol := (Z(7)^4)*vars[1]^2-vars[2]*vars[3]-vars[4]*vars[6]+vars[5]^2;
form := BilinearFormByPolynomial(pol, r);
IsEllipticForm(form);
Display(form);

r := PolynomialRing( GF(8), 3);
vars := IndeterminatesOfPolynomialRing( r );
pol := vars[1]^2 + vars[3]^2 + vars[2]^2;
form := QuadraticFormByPolynomial(pol, r);
IsDegenerateForm(form);
RadicalOfForm(form);

r := PolynomialRing( GF(16), 4);
vars := IndeterminatesOfPolynomialRing( r );
z := Z(16);
pol := z^5*vars[3]^2+vars[1]*vars[3]+z^8*vars[1]^2 + vars[2]*vars[4];
form := QuadraticFormByPolynomial(pol,r);
B := BaseChangeToCanonical(form);
mat := form!.matrix;
mat2 := B*mat*TransposedMat(B);
Display(mat2);
DiscriminantOfForm(form);

#Klein's quadric in PG(5,8)
r := PolynomialRing( GF(8), 6);
vars := IndeterminatesOfPolynomialRing( r );
pol := vars[1]*vars[6]+vars[2]*vars[5]+vars[3]*vars[4];
form := QuadraticFormByPolynomial(pol,r,6);
B := BaseChangeToCanonical(form);
mat := form!.matrix;
mat2 := B*mat*TransposedMat(B);
Display(mat2);
iso := IsometricCanonicalForm(form);
Display(iso);

#hermitian
r := PolynomialRing( GF(9), 4);
vars := IndeterminatesOfPolynomialRing( r );
pol := vars[1]*vars[2]^3+vars[1]^3*vars[2]+vars[3]*vars[4]^3+vars[3]^3*vars[4];
form := HermitianFormByPolynomial(pol,r);
Display(form);
