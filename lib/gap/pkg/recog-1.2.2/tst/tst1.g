# Test for VeryFewPoints:
LoadPackage("recog");
Print("Test: Sym(5)\n");
g := SymmetricGroup(5);
ri := RECOG.TestGroup(g,false,120);
