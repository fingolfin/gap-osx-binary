#############################################################################
##  
##  PackageInfo.g for the package `modisom'                      Bettina Eick
##  
SetPackageInfo( rec(
PackageName := "ModIsom",
Subtitle := "Computing automorphisms and checking isomorphisms for modular group algebras of finite p-groups",
Version := "2.3.2",
Date := "04/07/2014",

Persons := [
  rec( 
    LastName      := "Eick",
    FirstNames    := "Bettina",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "beick@tu-bs.de",
    WWWHome       := "http://www.icm.tu-bs.de/~beick",
    PostalAddress := Concatenation( [
                       "Institut Computational Mathematics\n",
                       "Pockelsstrasse 14, 38106 Braunschweig\n",
                       "Germany" ] ),
    Place         := "Braunschweig",
    Institution   := "TU Braunschweig"
  ),
  rec(
    LastName      := "Konovalov",
    FirstNames    := "Alexander",
    IsAuthor      := false,
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
  ) ],

Status := "accepted",
CommunicatedBy := "Alexander Konovalov (St. Andrews)",
AcceptDate := "11/2013",

PackageWWWHome := "http://www.icm.tu-bs.de/~beick/soft/modisom/",

ArchiveFormats := ".tar.gz",
ArchiveURL     := Concatenation( ~.PackageWWWHome, "modisom-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML := 
  "The <span class=\"pkgname\">ModIsom</span> package contains various methods for computing with nilpotent associative algebras. In particular, it contains a method to determine the automorphism group and to test isomorphis of such algebras over finite fields and of modular group algebras of finite p-groups, and it contains a nilpotent quotient algorithm for finitely presented associative algebras and a method to determine Kurosh algebras.",

PackageDoc := rec(
  BookName  := "ModIsom",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computing with nilpotent associative algebras",
  Autoload  := true
),


Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [["Polycyclic", ">=1.0"]], 
  SuggestedOtherPackages := [],
  ExternalConditions := []
),

BannerString := Concatenation( "Loading ModIsom ", ~.Version, "... \n"),
AvailabilityTest := ReturnTrue,
Autoload := false,
TestFile := "tst/manexamples.tst",
Keywords := ["modular isomorphism problem",
             "automorphism group", 
             "isomorphism testing",
             "nilpotent algebras",
             "nilpotent quotient",
             "Kurosh algebras"]

));
