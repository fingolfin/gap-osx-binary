SetPackageInfo( rec(
PackageName := "Browse",
Version := "1.8.6",
Date := "15/08/2014",
Subtitle := "browsing applications and ncurses interface",
ArchiveURL := "http://www.math.rwth-aachen.de/~Browse/Browse-1.8.6",
ArchiveFormats := ".tar.bz2",
Persons := [
  rec(
  LastName := "Breuer",
  FirstNames := "Thomas",
  IsAuthor := true,
  IsMaintainer := true,
  Email := "Thomas.Breuer@Math.RWTH-Aachen.De",
  WWWHome := "http://www.math.rwth-aachen.de/~Thomas.Breuer",
  PostalAddress := "Thomas Breuer\nLehrstuhl D für Mathematik\nRWTH Aachen\nPontdriesch 14/16\n52062 Aachen\nGERMANY\n",
  Place := "Aachen",
  Institution := "Lehrstuhl D für Mathematik, RWTH Aachen"
  ),
  rec(
  LastName := "Lübeck",
  FirstNames := "Frank",
  IsAuthor := true,
  IsMaintainer := true,
  Email := "Frank.Luebeck@Math.RWTH-Aachen.De",
  WWWHome := "http://www.math.rwth-aachen.de/~Frank.Luebeck",
  PostalAddress := "Frank Lübeck\nLehrstuhl D für Mathematik\nRWTH Aachen\nPontdriesch 14/16\n52062 Aachen\nGERMANY\n",
  Place := "Aachen",
  Institution := "Lehrstuhl D für Mathematik, RWTH Aachen"
  )
],
Status := "deposited",
README_URL := "http://www.math.rwth-aachen.de/~Browse/README",
PackageInfoURL := 
           "http://www.math.rwth-aachen.de/~Browse/PackageInfo.g",
AbstractHTML := "The <span class='pkgname'>Browse</span> package provides three levels of functionality</p><ul><li>A <span class='pkgname'>GAP</span> interface to the C-library <a href='http://www.gnu.org/software/ncurses/ncurses.html'>ncurses</a>.</li><li>A generic function for interactive browsing through two-dimensional arrays of data.</li><li>Several applications of the first two, e.g., a method for browsing character tables, browsing through the content of some data collections, or some games.</li></ul><p>",
PackageWWWHome := "http://www.math.rwth-aachen.de/~Browse",
PackageDoc := [
              rec(
  BookName := "Browse",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "ncurses interface and browsing applications",
  Autoload := true
)
],
Dependencies := rec(
  GAP := "4.6",  # because of UserPreference( "Pager" )
  NeededOtherPackages := [ ["GAPDoc", ">= 1.4"], ],
  SuggestedOtherPackages := [ ["AtlasRep",">=1.5"], [ "IO", ">=2.2" ] ],
  ExternalConditions := ["C-compiler", "ncurses development library"]
),
AvailabilityTest := function()
  if not "ncurses" in SHOW_STAT() and 
     Filename(DirectoriesPackagePrograms("Browse"), "ncurses.so") = fail then
    LogPackageLoadingMessage( PACKAGE_WARNING,
        [ "kernel functions for ncurses not available." ] );
    if UserPreference("browse", "loadwithoutncurses") = true then
      return true;
    else
      return false;
    fi;
  fi;
  return true;
end,
TestFile := "tst/test.tst",
Keywords := ["Browse", "ncurses"],

));

