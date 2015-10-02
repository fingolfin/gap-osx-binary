#############################################################################
##
#W  PackageInfo.g              The UnitLib package        Alexander Konovalov
#W                                                            Elena Yakimenko
##
#############################################################################

SetPackageInfo( rec(

PackageName := "UnitLib",
Subtitle := "Library of normalized unit groups of modular group algebras",
Version := "3.1.3",
Date := "01/02/2013",
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "3.1.3">
##  <!ENTITY RELEASEDATE "01 February 2013">
##  <#/GAPDoc>

PackageWWWHome := "http://www.cs.st-andrews.ac.uk/~alexk/unitlib/",

ArchiveURL := Concatenation( ~.PackageWWWHome, "unitlib-", ~.Version ),
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Konovalov",
    FirstNames    := "Alexander",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "alexk@mcs.st-andrews.ac.uk",
    WWWHome       := "http://www.cs.st-andrews.ac.uk/~alexk/",
    PostalAddress := Concatenation( [
                     "School of Computer Science\n",
                     "University of St Andrews\n",
                     "Jack Cole Building, North Haugh,\n",
                     "St Andrews, Fife, KY16 9SX, Scotland" ] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
     ),
  rec(
    LastName      := "Yakimenko",
    FirstNames    := "Elena",
    IsAuthor      := true,
    IsMaintainer  := false,
    Place         := "Zaporozhye",
    Institution   := "Zaporozhye National University"
     )
],

Status := "accepted",
CommunicatedBy := "Bettina Eick (Braunschweig)",
AcceptDate := "03/2007",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
  
AbstractHTML := "The <span class=\"pkgname\">UnitLib</span> package extends the <span class=\"pkgname\">LAGUNA</span> package and provides the library of normalized unit groups of modular group algebras of all finite p-groups of order not greater than 243 over the field of p elements.",
                  
PackageDoc := rec(
  BookName := "UnitLib",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "The library of normalized unit groups of modular group algebras",
  Autoload := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [ ["GAPDoc", ">= 1.5.1"], 
                           ["IO", "3.0"],
                           ["LAGUNA", ">= 3.6"] ],
  SuggestedOtherPackages := [ ["SCSCP", ">=2.0"] ],
  ExternalConditions := [ "gzip (only for p=128)" ]
),

AvailabilityTest := ReturnTrue,
Autoload := false,
TestFile := "tst/testall.g",

Keywords := ["group ring", "modular group algebra", "normalized unit group"]

));