# p1 = Z^2

# http://en.wikipedia.org/wiki/Wallpaper_group#Group_p1

M := [ [1,2,5], [1,2,7], [1,3,4], [1,3,9], [1,4,5], [1,7,9], [2,3,6], [2,3,8], [2,5,6], [2,7,8], [3,4,6], [3,8,9], [4,5,8], [4,6,7], [4,7,8], [5,6,9], [5,8,9], [6,7,9] ];
G := Group( () );
iso := rec();
mu := [];
dim := 3;

#matrix sizes:
#[ 18, 108, 180, 135, 54, 9 ]

#the torus
# Z
# Z^(1 x 2)
# Z
