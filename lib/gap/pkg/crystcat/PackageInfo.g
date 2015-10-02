#############################################################################
##  
##  PackageInfo.g for CrystCat
##  

SetPackageInfo( rec(

PackageName := "CrystCat",

Subtitle := "The crystallographic groups catalog",

Version := "1.1.6",

Date := "29/05/2012",

ArchiveURL := "http://www.math.uni-bielefeld.de/~gaehler/gap45/CrystCat/crystcat-1.1.6",

ArchiveFormats := ".tar.gz",

BinaryFiles := [ "doc/manual.pdf", "doc/manual.dvi" ],

Persons := [
  rec(
    LastName := "Felsch",
    FirstNames := "Volkmar",
    IsAuthor := true,
    IsMaintainer := true,
    Email := "Volkmar.Felsch@math.rwth-aachen.de",
    WWWHome := "http://www.math.rwth-aachen.de/~Volkmar.Felsch/",
    #PostalAddress := "",           
    Place := "Aachen",
    Institution := "Lehrstuhl D für Mathematik, RWTH Aachen"
  ),
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

README_URL := "http://www.math.uni-bielefeld.de/~gaehler/gap45/CrystCat/README.crystcat",
PackageInfoURL := "http://www.math.uni-bielefeld.de/~gaehler/gap45/CrystCat/PackageInfo.g",

AbstractHTML := 
"This package provides a catalog of crystallographic groups of \
dimensions 2, 3, and 4 which covers most of the data contained in \
the book <em>Crystallographic groups of four-dimensional space</em> \
by H. Brown, R. B&uuml;low, J. Neub&uuml;ser, H. Wondratschek, and \
H. Zassenhaus (John Wiley, New York, 1978). Methods for the \
computation with these groups are provided by the package \
<span class=\"pkgname\">Cryst</span>, which must be installed as well.",

PackageWWWHome := 
  "http://www.math.uni-bielefeld.de/~gaehler/gap45/packages.php",

PackageDoc  := rec(
  BookName  := "CrystCat",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "The crystallographic groups catalog",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [ [ "Cryst", ">=4.1.8" ] ],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

#TestFile := "tst/testall.g",

Keywords := [ "crystallographic groups", "space groups" ]

));
