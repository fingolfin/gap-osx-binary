LoadPackage("unitlib");

dir := DirectoriesPackageLibrary("unitlib","tst");
Read( Filename( dir, "testlib.g" ) );

TestMyPackage := function( pkgname )
local pkgdir, testfiles, testresult, ff, fn;
LoadPackage( pkgname );
pkgdir := DirectoriesPackageLibrary( pkgname, "tst" );

# Arrange chapters as required
testfiles := [ "unitlib02.tst", "unitlib04.tst" ];

Print("Checking UnitLib library for completeness ...\n");
testresult:=UNITLIBTestLibrary();

for ff in testfiles do
  fn := Filename( pkgdir, ff );
  Print("#I  Testing ", fn, "\n");
  if not Test( fn, rec(compareFunction := "uptowhitespace") ) then
    testresult:=false;
  fi;
od;  
if testresult then
  Print("#I  No errors detected while testing package ", pkgname, "\n");
else
  Print("#I  Errors detected while testing package ", pkgname, "\n");
fi;
end;

# Set the name of the package here
TestMyPackage( "unitlib" );
