############################################################
#
# commands to create TORIC documentation using GAPDoc 1.0
#
###########################################################


path := Directory("/Users/wdj/computer_algebra/gapfiles/toric1.8/doc");  ## edit path if needed
main:="toric.xml"; 
files:=[];
bookname:="toric";
doc := ComposedDocument("GAPDoc", path, main, files, true);;
r := ParseTreeXMLString(doc[1],doc[2]);; 
######### with break here if there is an xml compiling error #########
CheckAndCleanGapDocTree(r);
t := GAPDoc2Text(r, path);;
GAPDoc2TextPrintTextFiles(t, path);
l := GAPDoc2LaTeX(r);;
FileString(Filename(path, Concatenation(bookname, ".tex")), l);
AddPageNumbersToSix(r, Filename(path, "manual.pnr"));
PrintSixFile(Filename(path, "manual.six"), r, bookname);
h := GAPDoc2HTML(r, path);;
GAPDoc2HTMLPrintHTMLFiles(h, path);
MakeGAPDocDoc( path, main, files, bookname);
