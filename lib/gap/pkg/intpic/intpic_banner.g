##############################  the banner ##############################
# The code used to produce the banner and the table of the default colors. 
# It may be used as an example, provided you have the "intpic" package 
# installed. 
##
LoadPackage("intpic");

#############################################
## a file named intpic_banner.tex containing the latex code will be added 
## to the working directory
file := "intpic_banner.tex";;

row_length := 200; # the legth of each row
columns := 50; # the number of colums
n := row_length*columns;

##compute the primes less than n
# Primes is a GAP variable representing the list of primes less than 1000
mp := Maximum(Primes);
newprimes := [];;
while mp < n do
  mp := NextPrimeInt(mp);
  Add(newprimes, mp);
od;
small_primes := Union(Primes, newprimes);;
##compute the first element of each pair of twin primes less than n
twins := Filtered(small_primes, p -> IsPrime(p+2));;

rg := [1..n];

arr := [Intersection(small_primes,rg),[],[], Intersection(Union(twins,twins+2),rg),[],[],[],[],[],[],[],[],[],[],[],[],[],Difference(rg,small_primes)];;

tkz:=IP_TikzArrayOfIntegers([1..n],flen,rec(highlights:=arr,cell_width := "6",colsep:="0",rowsep:="0",inner_sep:="2",shape_only:=" ",line_width:="0",line_color:="black!20" ));;

FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

#############################################
# the table of default colors
file := "intpic_default_colors_2.tex";;

arr := [];
for i in [1..40] do
  Append(arr,[[i]]);
od;

tkz:=TikzArrayOfIntegers([1..Length(arr)],10,rec(highlights:=arr,scale := "5",cell_width := "15",colsep:="0",rowsep:="0",inner_sep:="2",line_width:="0",line_color:="black!20" ));;

FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
