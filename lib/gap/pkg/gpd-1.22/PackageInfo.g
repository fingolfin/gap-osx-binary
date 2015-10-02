#############################################################################
##
##  PackageInfo.g   file for the package Gpd version 1.22  (20/11/13)
##  Emma Moore and Chris Wensley 
##

SetPackageInfo( rec(
PackageName := "gpd",
Subtitle := "Groupoids, graphs of groups, and graphs of groupoids",

Version := "1.22",
Date := "20/11/2013", 

##  duplicate these values for inclusion in the manual: 
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "1.22">
##  <!ENTITY RELEASEDATE "20/11/2013">
##  <!ENTITY GPDTARFILE "gpd-1.22.tar.gz">
##  <!ENTITY GPDHTMLFILE "gpd122.html">
##  <!ENTITY GPDRELEASEDATE "20th November 2013">
##  <#/GAPDoc>

PackageWWWHome := 
 "http://www.maths.bangor.ac.uk/chda/gap4/gpd/",

ArchiveURL := "http://www.maths.bangor.ac.uk/chda/gap4/gpd/gpd-1.22", 
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Moore",
    FirstNames    := "Emma J.",
    IsAuthor      := true,
    IsMaintainer  := false,
    ## Email         := "",
    ## WWWHome       := "",
    ## PostalAddress := Concatenation( ["\n", "UK"] ),
    ## Place         := "",
    ## Institution   := ""
  ),
  rec(
    LastName      := "Wensley",
    FirstNames    := "Christopher D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "c.d.wensley@bangor.ac.uk",
    WWWHome       := "http://www.bangor.ac.uk/~mas023/",
    PostalAddress := Concatenation( [
                       "Dr. C.D. Wensley\n",
                       "School of Computer Science\n",
                       "Bangor University\n",
                       "Dean Street\n",
                       "Bangor\n",
                       "Gwynedd LL57 1UT\n",
                       "UK"] ),
    Place         := "Bangor",
    Institution   := "University of Wales, Bangor"
  )
],

Status := "submitted",
## CommunicatedBy := "",
## AcceptDate := "",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML :=
 "The Gpd package provides a collection of functions for computing with \
finite groupoids, graph of groups, and graphs of groupoids. \
These are based on the more basic structures of magmas with objects \
and their mappings. \
It provides functions for normal forms of elements in Free Products with \
Amalgamation and in HNN extensions.",

PackageDoc := rec(
  BookName  := "Gpd",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Finite Groupoids and Graphs of Groups",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5.1" ], 
                           [ "fga", ">= 1.2.0" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation(
    "Loading Gpd ", String( ~.Version ), " for GAP 4.7", 
    " - Emma Moore and Chris Wensley ...\n" ),

Autoload := false,

TestFile := "tst/testall.g", 

Keywords := [ "magma with objects", "groupoid", "graph of groups", 
              "free product with amalgamation", "HNN extension", 
              "automorphisms" ]

));
