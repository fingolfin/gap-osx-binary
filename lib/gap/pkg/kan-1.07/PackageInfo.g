#############################################################################
##
#W  PackageInfo.g                 GAP 4 Package `kan'           Chris Wensley
#W                                                              Anne Heyworth
##  version 1.07, 16/10/2013
##

SetPackageInfo( rec(
PackageName := "kan",
Subtitle := "including double coset rewriting systems",

Version := "1.07",
Date := "16/10/2013",

##  duplicate these values for inclusion in the manual: 
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "1.07">
##  <!ENTITY TARFILENAME "kan-1.07.tar.gz">
##  <!ENTITY HTMLFILENAME "kan107.html">
##  <!ENTITY RELEASEDATE "16/10/2013">
##  <!ENTITY LONGRELEASEDATE "16th October 2013">
##  <#/GAPDoc>

PackageWWWHome := 
  "http://www.maths.bangor.ac.uk/chda/gap4/kan/",

ArchiveURL := "http://www.maths.bangor.ac.uk/chda/gap4/kan/kan-1.07", 
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Heyworth",
    FirstNames    := "Anne",
    IsAuthor      := true,
    IsMaintainer  := false
    ## Email         := "" 
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
    Institution   := "Bangor University"
  )
],

Status := "deposited",
## CommunicatedBy := "",
## AcceptDate := "",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML :=
 "The Kan package provides a collection of functions for computing with \
  all types of Kan extension, including double coset rewriting systems.",

PackageDoc := rec(
  BookName  := "Kan",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computing with Kan extensions" 
),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [ [ "automata", ">= 1.13" ], 
                           [ "GAPDoc", ">= 1.5" ]  ],
  SuggestedOtherPackages := [ [ "kbmag", ">= 1.5" ] ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
    "Loading Kan ", String( ~.Version ), " for GAP 4.7", 
    " - Anne Heyworth and Chris Wensley ...\n" ),

Autoload := false,

TestFile := "tst/testall.g",

Keywords := [ "Kan extension", 
              "double coset rewriting system", 
              "induced action" ]

));
