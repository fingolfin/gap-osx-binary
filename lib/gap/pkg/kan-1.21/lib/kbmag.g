LoadPackage("kbmag");
F := FreeGroup("a","b","c");
G := F/ParseRelators(F,"1=[a,[a,b]]c^-1=[b,[b,c]]a^-1,[c,[c,a]]b^-1"); 
rws := KBMAGRewritingSystem(G);
SetInfoLevel(InfoRWS,1);
AutomaticStructure(rws,true);
