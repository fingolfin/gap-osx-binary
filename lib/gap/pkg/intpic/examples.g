## Some examples in the manual have been produced by using the code below
## The GAP session was started inside the folder "images"
##
## Note that for each case we save the tikz code into a file and and a complete latex document wich includes the tikz code. The reason for this document is that we want to produce the image in jpg format in order to include it in the html version of the manual. Using the pdf version instead of the tikz code for the pdf version of the manual also happens sometimes: the reason is that it saves processing time.  
######## primesandtwins ################
tikzfile := "tikz_primesandtwins.tex";;
file := "primesandtwins.tex";;

rg := [801..999];;
flen := 15;;
primes := Filtered(rg,IsPrime);
twins := Filtered(primes, p -> IsPrime(p+2)); #A list consisting of the first
#elements of pairs of twin primes  
rgnp := Difference(rg,primes);
arr := [primes,
[1],
Union(twins,twins+2),
# now the non primes...
Filtered(rgnp,u->(u mod 2)=0),
Filtered(rgnp,u->(u mod 3)=0),
Filtered(rgnp,u->(u mod 5)=0),
[],[], # to avoid some colors
Filtered(rgnp,u->(u mod 7)=0),
Filtered(rgnp,u->(u mod 11)=0),
Filtered(rgnp,u->(u mod 13)=0),
Filtered(rgnp,u->(u mod 17)=0),
Filtered(rgnp,u->(u mod 19)=0),
Filtered(rgnp,u->(u mod 23)=0),
Filtered(rgnp,u->(u mod 29)=0),
Filtered(rgnp,u->(u mod 31)=0),
Filtered(rgnp,u->(u mod 37)=0),
Filtered(rgnp,u->(u mod 41)=0),
Filtered(rgnp,u->(u mod 43)=0),
Filtered(rgnp,u->(u mod 47)=0),
Filtered(rgnp,u->(u mod 53)=0)];

tkz := IP_TikzArrayOfIntegers(rg,flen,rec(cell_width := "27",highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

######## 81to99 ################
tikzfile := "tikz_81to89.tex";;
file := "81to89.tex";;

rg := [81..89];;
len := 5;;
arr := [Filtered(rg,IsPrime),Filtered(rg,u->(u mod 2)=0),
        Filtered(rg,u->(u mod 3)=0)];;
tkz := IP_TikzArrayOfIntegers(rg,len,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

######## divs30 ################
tikzfile := "tikz_divs30.tex";;
file := "divs30.tex";;

d := DivisorsInt(30);
tkz := IP_SimpleTizkArrayOfIntegers(d);;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

######## divs3040 ################
tikzfile := "tikz_divs3040.tex";;
file := "divs3040.tex";;

d30 := DivisorsInt(30);
d40 := DivisorsInt(40);
tkz := IP_SimpleTizkArrayOfIntegers([d30,d40]);;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########table_axis_ground_8_19
tikzfile := "tikz_table_axis_ground_8_19.tex";;
file := "table_axis_ground_8_19.tex";;

a := 8;; b := 19;;  
ns := NumericalSemigroup(a,b);;
c := ConductorOfNumericalSemigroup(ns);;
origin := 2*c-1;
ground := [origin..origin+b-1];;

height:=2;;
depth:=8;;
  xaxis := [origin];;
  for n in [1..b-1] do
    Add(xaxis, origin+n*a);
  od;
  yaxis := [];;
  for n in [-depth..height] do
    Add(yaxis, origin+n*b);
  od;

table := TableWithModularOrder(origin,a,b,depth,height,false,false);;
arr := [xaxis,yaxis,ground];
tkz:=IP_TikzArrayOfIntegers(table,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########table_axis_ground_shape
tikzfile := "tikz_table_axis_ground_shape.tex";;
file := "table_axis_ground_shape.tex";;

tkz:=IP_TikzArrayOfIntegers(table,rec(highlights:=arr,shape_only:=" ",
             cell_width := "6",colsep:="1",rowsep:="1",inner_sep:="2",
             line_color:="black!20"));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########table_axis_ground_rep_pos
tikzfile := "tikz_table_axis_ground_8_19_rep_pos.tex";;
file := "table_axis_ground_8_19_rep_pos.tex";;

a := 8;; b := 19;;  
ns := NumericalSemigroup(a,b);;
c := ConductorOfNumericalSemigroup(ns);;
origin := 2*c-1;
ground := [origin..origin+b-1];;

height:=2;;
depth:=50;;
  xaxis := [origin];;
  for n in [1..b-1] do
    Add(xaxis, origin+n*a);
  od;
  yaxis := [];;
  for n in [-depth..height] do
    Add(yaxis, origin+n*b);
  od;

table := TableWithModularOrder(origin,a,b,depth,height,true,true);;
arr := [xaxis,yaxis,ground];
tkz:=IP_TikzArrayOfIntegers(table,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));


####################################################################
##                    Colors                                      ##
####################################################################
##########red_tones
tikzfile := "tikz_red_tones.tex";;
file := "red_tones.tex";;

cls := IP_ColorsRedTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########green_tones
tikzfile := "tikz_green_tones.tex";;
file := "green_tones.tex";;

cls := IP_ColorsGreenTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########blue_tones
tikzfile := "tikz_blue_tones.tex";;
file := "blue_tones.tex";;

cls := IP_ColorsBlueTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########comp_red_tones
tikzfile := "tikz_comp_red_tones.tex";;
file := "comp_red_tones.tex";;

cls := IP_ColorsCompRedTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########comp_green_tones
tikzfile := "tikz_comp_green_tones.tex";;
file := "comp_green_tones.tex";;

cls := IP_ColorsCompGreenTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########comp_blue_tones
tikzfile := "tikz_comp_blue_tones.tex";;
file := "comp_blue_tones.tex";;

cls := IP_ColorsCompBlueTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########dark_gray_tones
tikzfile := "tikz_dark_gray_tones.tex";;
file := "dark_gray_tones.tex";;

cls := IP_ColorsDGrayTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########light_gray_tones
tikzfile := "tikz_light_gray_tones.tex";;
file := "light_gray_tones.tex";;

cls := IP_ColorsLGrayTones;

tkz:=IP_TikzArrayOfIntegers([1..5],5,rec(highlights:=[[1],[2],[3],[4],[5]], colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));


##########intpic_default_colors
tikzfile := "tikz_intpic_default_colors.tex";;
file := "intpic_default_colors.tex";;

arr := [];
for i in [1..40] do
  Append(arr,[[i]]);
od;

tkz:=IP_TikzArrayOfIntegers([1..Length(arr)],10,rec(highlights:=arr,cell_width := "20",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########mults_3_5_7
tikzfile := "tikz_mults_3_5_7.tex";;
file := "mults_3_5_7.tex";;

m3 := Filtered([1..40],i->i mod 3=0);
m5 := Filtered([1..40],i->i mod 5=0);
m7 := Filtered([1..40],i->i mod 7=0);

arr := [[],[],m3,[],m5,[],m7];;
tkz:=IP_TikzArrayOfIntegers([1..40],10,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########shuffle_red_comp_blue
tikzfile := "tikz_shuffle_red_comp_blue.tex";;
file := "shuffle_red_comp_blue.tex";;

cls := ShuffleIP_Colors([IP_ColorsRedTones,IP_ColorsCompBlueTones]);
arr := [];
for i in [1..10] do
  Append(arr,[[i]]);
od;

tkz:=IP_TikzArrayOfIntegers([1..10],5,rec(highlights:=arr, colors := cls,
cell_width := "15",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));


####################################################################
##                    visualisation                               ##
####################################################################

##########intpic_multiple_colors
tikzfile := "tikz_intpic_multiple_colors.tex";;
file := "intpic_multiple_colors.tex";;

rg := [800..900];;
flen := 15;;
primes := Filtered(rg,IsPrime);
twins := Filtered(primes, p -> IsPrime(p+2)); #A list consisting of the first
#elements of pairs of twin primes  
rgnp := Difference(rg,primes);
arr := [primes,
[1],
Union(twins,twins+2),
# now the non primes...
Filtered(rgnp,u->(u mod 2)=0),
Filtered(rgnp,u->(u mod 3)=0),
Filtered(rgnp,u->(u mod 5)=0),
[],[], # to avoid some colors
Filtered(rgnp,u->(u mod 7)=0),
Filtered(rgnp,u->(u mod 11)=0),
Filtered(rgnp,u->(u mod 13)=0),
Filtered(rgnp,u->(u mod 17)=0),
Filtered(rgnp,u->(u mod 19)=0),
Filtered(rgnp,u->(u mod 23)=0),
Filtered(rgnp,u->(u mod 29)=0),
Filtered(rgnp,u->(u mod 31)=0),
Filtered(rgnp,u->(u mod 37)=0),
Filtered(rgnp,u->(u mod 41)=0),
Filtered(rgnp,u->(u mod 43)=0),
Filtered(rgnp,u->(u mod 47)=0),
Filtered(rgnp,u->(u mod 53)=0)];

tkz := IP_TikzArrayOfIntegers(rg,flen,rec(cell_width := "27",highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

################ pic_for_complete_document
tikzfile := "tikz_pic_for_complete_document.tex";;
file := "pic_for_complete_document.tex";;

arr := [[1,2,3,4,5,6],[1,2,3,4,5],[1,2,3,4],[1,2,3],[1,2],[1]];;
tkz := IP_TikzArrayOfIntegers([1..10],5,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

####################################################################
##                    examples                                    ##
####################################################################

##########primesandtwinsamongodd
tikzfile := "tikz_primesandtwinsamongodd.tex";
file := "primesandtwinsamongodd.tex";
  
rg := Filtered([801..889],u->(u mod 2)<>0);;
flen := 15;;
twins := Filtered(Primes, p -> p + 2 in Primes);;
arr := [Primes,Union(twins,twins+2),Filtered(rg,u->(u mod 3)=0)];;

tkz := IP_TikzArrayOfIntegers(rg,flen,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########primesandtwinsamongodd_comp_red
tikzfile := "tikz_primesandtwinsamongodd_comp_red.tex";
file := "primesandtwinsamongodd_comp_red.tex";
  
cls := IP_ColorsCompRedTones;;
rg := Filtered([801..889],u->(u mod 2)<>0);;
flen := 15;;
twins := Filtered(Primes, p -> p + 2 in Primes);;
arr := [Primes,Union(twins,twins+2),Filtered(rg,u->(u mod 3)=0)];;

tkz := IP_TikzArrayOfIntegers(rg,flen,rec(colors := cls,highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########primesandtwinsamongodd_dark_gray
tikzfile := "tikz_primesandtwinsamongodd_dark_gray.tex";
file := "primesandtwinsamongodd_dark_gray.tex";
  
cls := IP_ColorsDGrayTones;;
rg := Filtered([801..889],u->(u mod 2)<>0);;
flen := 15;;
twins := Filtered(Primes, p -> p + 2 in Primes);;
arr := [Primes,Union(twins,twins+2),Filtered(rg,u->(u mod 3)=0)];;

tkz := IP_TikzArrayOfIntegers(rg,flen,rec(colors := cls,highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########primesandtwinsamongodd_other
tikzfile := "tikz_primesandtwinsamongodd_other.tex";
file := "primesandtwinsamongodd_other.tex";
  
cls := ["blue","-blue","black"];

rg := Filtered([801..889],u->(u mod 2)<>0);;
flen := 15;;
twins := Filtered(Primes, p -> p + 2 in Primes);;
arr := [Primes,Union(twins,twins+2),Filtered(rg,u->(u mod 3)=0)];
tkz := IP_TikzArrayOfIntegers(rg,flen,rec( colors := cls,highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##########numericalsgp_notable
tikzfile := "tikz_numericalsgp_notable.tex";
file := "numericalsgp_notable.tex";

#LoadPackage("numericalsgps");

ns := NumericalSemigroup(11,19,30,42,59);;
cls := ShuffleIP_Colors([IP_ColorsGreenTones,IP_ColorsCompBlueTones]);;
flen := 20;;
#some notable elements
arr := [SmallElementsOfNumericalSemigroup(ns),
        GapsOfNumericalSemigroup(ns),
        MinimalGeneratingSystemOfNumericalSemigroup(ns),
        FundamentalGapsOfNumericalSemigroup(ns),
        [ConductorOfNumericalSemigroup(ns)],
        PseudoFrobeniusOfNumericalSemigroup(ns)];;

tkz := IP_TikzArrayOfIntegers(flen,rec(colors := cls,highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));
##########numericalsgp_notable_df_colors
tikzfile := "tikz_numericalsgp_notable_df_colors.tex";
file := "numericalsgp_notable_df_colors.tex";

#LoadPackage("numericalsgps");

ns := NumericalSemigroup(11,19,30,42,59);;
flen := 20;;
#some notable elements
arr := [SmallElementsOfNumericalSemigroup(ns),
        GapsOfNumericalSemigroup(ns),
        MinimalGeneratingSystemOfNumericalSemigroup(ns),
        FundamentalGapsOfNumericalSemigroup(ns),
        [ConductorOfNumericalSemigroup(ns)],
        PseudoFrobeniusOfNumericalSemigroup(ns)];;

tkz := IP_TikzArrayOfIntegers(flen,rec(highlights:=arr));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));



################intpic_banner
tikzfile := "tikz_intpic_banner.tex";;
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

arr := [Intersection(small_primes,rg),[],[], 
        Intersection(Union(twins,twins+2),rg),[],[],[],[],[],[],[],
        [],[],[],[],[],[],Difference(rg,small_primes)];;

tkz:=IP_TikzArrayOfIntegers([1..n],row_length,rec(highlights:=arr,
             cell_width := "6",colsep:="0",rowsep:="0",inner_sep:="2",
             shape_only:=" ",line_width:="0",line_color:="black!20" ));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));

##############################
tikzfile := "tikz_table_axis_ground_shape_other_option.tex";;
file := "table_axis_ground_shape_other_option.tex";;

a := 8;; b := 19;;  
ns := NumericalSemigroup(a,b);;
c := ConductorOfNumericalSemigroup(ns);;
origin := 2*c-1;
ground := [origin..origin+b-1];;

height:=2;;
depth:=8;;
  xaxis := [origin];;
  for n in [1..b-1] do
    Add(xaxis, origin+n*a);
  od;
  yaxis := [];;
  for n in [-depth..height] do
    Add(yaxis, origin+n*b);
  od;

table := TableWithModularOrder(origin,a,b,depth,height,false,false);;
arr := [xaxis,yaxis,ground];
tkz:=IP_TikzArrayOfIntegers(table,rec(highlights:=arr,shape_only:=" ",
             cell_width := "6",colsep:="1",rowsep:="1",inner_sep:="2",
             line_color:="black!20", other := 
  ["\\draw[postaction={draw,line width=1pt,red}] (-80pt,-8pt) rectangle (16pt,40pt);",
  "\\draw[postaction={draw,line width=1pt,blue}] (-16pt,8pt) rectangle (80pt,-40pt);"]));;

FileString(tikzfile,tkz);
FileString(file,Concatenation(IP_Preamble,tkz,IP_Closing));



