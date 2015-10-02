#############################################################################
##  
SetPackageInfo( rec(

PackageName := "fwtree",
Subtitle := "Computing trees related to some pro-p-groups of finite width",
Version := "1.0",
Date := "23/04/2009",

Persons := [
  rec(
    LastName      := "Eick",
    FirstNames    := "Bettina",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "beick (at) tu-bs.de",
    WWWHome       := "http://www-public.tu-bs.de:8080/~beick",
    PostalAddress := Concatenation( [
                       "Institut Computational Mathematics\n",
                       "Pockelsstrasse 14, 38106 Braunschweig\n",
                       "Germany" ] ),
    Place         := "Braunschweig",
    Institution   := "TU Braunschweig"),

  rec(
    LastName      := "Rossmann",
    FirstNames    := "Tobias",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "tobias.rossmann (at) googlemail.com",
    PostalAddress := Concatenation( [
                       "School of Mathematics, Statistics and Applied Mathematics\n",
                       "National University of Ireland, Galway\n",
                       "University Road, Galway\n",
                       "Ireland" ] ),
    Place         := "Galway",
    Institution   := "NUI Galway") ],

Status := "deposited",

PackageWWWHome := "http://www.maths.nuigalway.ie/~tobias/fwtree/",

ArchiveFormats := ".tar.gz",
ArchiveURL     := Concatenation( ~.PackageWWWHome, "fwtree-", ~.Version ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL := "http://www.maths.nuigalway.ie/~tobias/fwtree/README",

AbstractHTML :=
  "The <span class=\"pkgname\">fwtree</span> package contains some code related to the computation of trees corresponding to some groups of finite rank, width and obliquity.",

PackageDoc := rec(
  BookName  := "fwtree",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computing trees related to some pro-p-groups of finite width",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [["Polycyclic", ">=1.0"],
                          ["Autpgrp", ">=1.0"],
                          ["anupq",">=1.0"]],
  SuggestedOtherPackages := [["XGAP", ">=1.0"]],
  ExternalConditions := []
),

BannerString := "Loading fwtree 1.0... \n",
AvailabilityTest := ReturnTrue,
Autoload := false,
Keywords := ["finite width", "p-groups", "trees"]
 
));
