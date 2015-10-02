#############################################################################
##
##  PackageInfo.g for Carat
##

SetPackageInfo( rec(

PackageName := "Carat",

Subtitle := "Interface to CARAT, a crystallographic groups package",

Version := "2.1.4",

Date := "29/05/2012",

ArchiveURL := 
  "http://www.math.uni-bielefeld.de/~gaehler/gap45/Carat/carat-2.1.4",

ArchiveFormats := ".tar.gz",

BinaryFiles := [ "doc/manual.pdf", "doc/manual.dvi", "carat-2.1b1.tgz" ],

Persons := [
  rec(
    LastName := "Gähler",
    FirstNames := "Franz",
    IsAuthor := true,
    IsMaintainer := true,
    Email := "gaehler@math.uni-bielefeld.de",
    WWWHome := "http://www.math.uni-bielefeld.de/~gaehler/",
    #PostalAddress := "",           
    Place := "Bielefeld",
    Institution := "Mathematik, Universität Bielefeld"
  )
],

Status := "accepted",

CommunicatedBy := "Herbert Pahlings (Aachen)",

AcceptDate := "02/2000",

README_URL := 
  "http://www.math.uni-bielefeld.de/~gaehler/gap45/Carat/README.carat",
PackageInfoURL := 
  "http://www.math.uni-bielefeld.de/~gaehler/gap45/Carat/PackageInfo.g",

AbstractHTML := 
"This package provides <span class=\"pkgname\">GAP</span> interface \
routines to some of the stand-alone programs of <a \
href=\"http://wwwb.math.rwth-aachen.de/carat\">CARAT</a>, a package \
for the computation with crystallographic groups. CARAT is to a large \
extent complementary to the <span class=\"pkgname\">GAP</span> package \
<span class=\"pkgname\">Cryst</span>. In particular, it provides \
routines for the computation of normalizers and conjugators of \
finite unimodular groups in GL(n,Z), and routines for the computation \
of Bravais groups, which are all missing in <span class=\"pkgname\">Cryst\
</span>. A catalog of Bravais groups up to dimension 6 is also provided.",

PackageWWWHome := 
  "http://www.math.uni-bielefeld.de/~gaehler/gap45/packages.php",

PackageDoc  := rec(
  BookName  := "Carat",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Interface to CARAT, a crystallographic groups package",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [ [ "Cryst", ">=4.1.9" ] ],
  ExternalConditions := []
),

AvailabilityTest := function()
  local path;
  # Carat is available only on UNIX
  if not ARCH_IS_UNIX() then
     LogPackageLoadingMessage(PACKAGE_INFO, "Carat is restricted to UNIX" );
     return false;
  fi;  
  # test the existence of a compiled binary; since there are
  # so many, we do not test for all of them, hoping for the best
  path := DirectoriesPackagePrograms( "carat" );
  if Filename( path, "Z_equiv" ) = fail then
     LogPackageLoadingMessage(PACKAGE_WARNING, "Carat binaries must be compiled" );
     return false;
  fi;
  return true;
end,

#TestFile := "tst/testall.g",

Keywords := [ "crystallographic groups", "finite unimodular groups", "GLnZ" ]

));

