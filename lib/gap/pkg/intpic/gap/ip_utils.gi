#######################################################################
InstallGlobalFunction(IntPicMakeDoc,
function()
  SetGapDocLaTeXOptions(rec(EarlyExtraPreamble:="\\usepackage{graphicx}\n\\usepackage{pgf}\n\\usepackage{tikz}\n\\usepgfmodule{plot}\n\\usepgflibrary{plothandlers}\n\\usetikzlibrary{shapes.geometric}\n\\usetikzlibrary{shadings}"));
MakeGAPDocDoc(Concatenation(PackageInfo("intpic")[1]!.
          InstallationPath, "/doc"), "IntPic.xml",
          ["../PackageInfo.g"], "IntPic",     "MathJax");;
end);
#######################################################################
InstallGlobalFunction(IntPicCopyHTMLStyleFiles,
function()
CopyHTMLStyleFiles(Concatenation(PackageInfo("intpic")[1]!.
        InstallationPath, "/doc"));
end);
#######################################################################
#convert a dot string to tikz and save it into a file
InstallGlobalFunction(ConvertDotStringTexFile,
function(dotstring,filename)
  local  command;
  FileString(Concatenation(filename,".dot"),dotstring);    
  command := Concatenation("dot2tex -ftikz ",filename,".dot"," > ", filename,".tex");
  Exec(command);
end);
#######################################################################
InstallGlobalFunction(IntPicInfo, 
        function(n)
  SetInfoLevel(InfoIntPic, n);
  Info(InfoIntPic,0, "Info Level for InfoIntPic is set to ",n, "\n");
end);
#######################################################################
InstallGlobalFunction(IntPicTest,
        function()
  ReadTest(Concatenation(PackageInfo("intpic")[1]!.
          InstallationPath, "/tst/testall.tst"));
end);


