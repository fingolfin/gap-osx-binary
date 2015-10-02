#############################################################################
##
##  PackageInfo file for the FORMAT package.   
##                                       Bettina Eick and Charles R.B. Wright
##

SetPackageInfo( rec(

PackageName := "FORMAT",
Subtitle := "Computing with formations of finite solvable groups.",
Version := "1.3",
Date := "05/26/2012",

ArchiveURL := "http://www.uoregon.edu/~wright/RESEARCH/format/format-1.3",
ArchiveFormats := ".tar.gz .tar.bz2",

Persons := [
  rec(
      LastName      := "Eick",
      FirstNames    := "Bettina",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "b.eick@tu-bs.de",
      WWWHome       := "http://www.icm.tu-bs.de/~beick",
      PostalAddress := Concatenation( [
                         "Bettina Eick\n",
                         "Institut Computational Mathematics\n",
                         "Technische Universit\"at Braunschweig\n",
                         "Pockelsstr. 14, D-38106 Braunschweig, Germany" ] ),
      Place         := "Braunschweig",
      Institution   := "T U Braunschweig"
    ),

  rec(
      LastName := "Wright",
      FirstNames := "Charles R.B.",
      IsAuthor := true,
      IsMaintainer := true,
      Email := "wright@math.uoregon.edu",
      WWWHome := "http://www.uoregon.edu/~wright",
      Place := "Eugene",
      Institution := "University of Oregon"
  )
],

Status := "accepted",
CommunicatedBy := "Joachim NeubŸser (Aachen)",
AcceptDate := "12/2000",

README_URL := "http://www.uoregon.edu/~wright/RESEARCH/format/README",
PackageInfoURL := "http://www.uoregon.edu/~wright/RESEARCH/format/PackageInfo.g",

AbstractHTML := "This package provides functions for computing with \
formations of finite solvable groups.",

PackageWWWHome := "http://www.uoregon.edu/~wright/RESEARCH/format/",

PackageDoc := rec(
  BookName := "FORMAT",
  Archive := Concatenation(~.PackageWWWHome, "format-", ~.Version,
"tar.gz" ),
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "Formations of Finite Soluble Groups",
  Autoload := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

Keywords := ["formations", "soluble", "group"]

));

