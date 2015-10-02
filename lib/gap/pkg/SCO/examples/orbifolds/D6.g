# D6 = S3

M := [ [1] ];
G := Group( (1,2), (1,2,3) );
iso := rec( 1 := G );
mu := [];
dim := 4;

# 1: 1 x 5 matrix with rank 0 and kernel dimension 1.
# 2: 5 x 25 matrix with rank 4 and kernel dimension 1.
# 3: 25 x 125 matrix with rank 20 and kernel dimension 5.
# 4: 125 x 625 matrix with rank 104 and kernel dimension 21.
# 5: 625 x 3125 matrix with rank 520 and kernel dimension 105.
# 6:     x 15625
# 7:     x 78125
# 8:     x 390625

# Cohomology dimension at degree 0:  GF(2)^(1 x 1)
# Cohomology dimension at degree 1:  GF(2)^(1 x 1)
# Cohomology dimension at degree 2:  GF(2)^(1 x 1)
# Cohomology dimension at degree 3:  GF(2)^(1 x 1)
# Cohomology dimension at degree 4:  GF(2)^(1 x 1)
