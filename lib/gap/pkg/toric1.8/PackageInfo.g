#############################################################################
##
#W  PackageInfo.g                toric Package                 David Joyner
##
##
#H  @(#)$Id: PackageInfo.g,v 1.2 2003/02/14 02:39:41 gap Exp $

SetPackageInfo( rec(

  PackageName := "toric",
    Subtitle  := "toric varieties and some combinatorial geometry computations",
  Version := "1.8",
  Date    := "03/05/2012",
  ArchiveURL 
          := "http://www.opensourcemath.org/toric/toric1.8",
  ArchiveFormats 
          := ".tar.gz",

##    - if no 'TextFiles' or 'BinaryFiles' are given and a .zoo archive is
##      provided, then the files in that archive with a "!TEXT!" comment are
##      taken as text files
##    - otherwise: exactly the files with names matching the regular expression
##      ".*\(\.txt\|\.gi\|\.gd\|\.g\|\.c\|\.h\|\.htm\|\.html\|\.xml\|\.tex\|\.six\|\.bib\|\.tst\|README.*\|INSTALL.*\|Makefile\)"
##      are taken as text files
##  
##  These entries are *optional*.
#TextFiles := ["init.g", ......],
#BinaryFiles := ["doc/manual.dvi", ......],


  Persons := [ 
    rec( 
      LastName      := "Joyner",
      FirstNames    := "David",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "wdjoyner@gmail.com",
      WWWHome       := "http://opensourcemath.org/toric/",
      PostalAddress := Concatenation( [
                         "W. David Joyner\n",
                         "Mathematics Department\n",
                         "U. S. Naval Academy\n",
                         "Annapolis, MD 21402\n",
                         "USA" ] ),
      Place         := "Annapolis",
      Institution   := "U. S. Naval Academy"
    )
  ],  

  Status  := "accepted",
  CommunicatedBy 
          := "Gerhard Hiss (Aachen)",
  AcceptDate 
          := "10/2005",

##  For a central overview of all packages and a collection of all package
##  archives it is necessary to have two files accessible which should be
##  contained in each package:
##     - A README file, containing a short abstract about the package
##       content and installation instructions.
##     - The file you are currently reading or editing!
##  You must specify URLs for these two files, these allow to automate 
##  the updating of package information on the GAP Website, and inclusion
##  and updating of the package in the GAP distribution.
##  

  README_URL := "http://www.opensourcemath.org/toric/README.toric",
  PackageInfoURL := "http://www.opensourcemath.org/toric/PackageInfo.g",

##  Here you  must provide a short abstract explaining the package content 
##  in HTML format (used on the package overview Web page) and an URL 
##  for a Webpage with more detailed information about the package
##  (not more than a few lines, less is ok):
##  Please, use '<span class="pkgname">GAP</span>' and
##  '<span class="pkgname">MyPKG</span>' for specifing package names.
##  

  AbstractHTML := 
    "<span class=\"pkgname\">toric</span> is a <span class=\"pkgname\">GAP</span>package for computing with toric varieties.",

  PackageWWWHome := "http://www.opensourcemath.org/toric/",
                  
##  On the GAP Website there is an online version of all manuals in the
##  GAP distribution. To handle the documentation of a package it is
##  necessary to have:
##     - an archive containing the package documentation (in at least one 
##       of HTML or PDF-format, preferably both formats)
##     - the start file of the HTML documentation (if provided), *relative to
##       package root*
##     - the PDF-file (if provided) *relative to the package root*
##  For links to other package manuals or the GAP manuals one can assume 
##  relative paths as in a standard GAP installation. 
##  Also, provide the information which is currently given in your packages 
##  init.g file in the command DeclarePackage(Auto)Documentation
##  (for future simplification of the package loading mechanism).
##  
##  Please, don't include unnecessary files (.log, .aux, .dvi, .ps, ...) in
##  the provided documentation archive.
##  
# in case of several help books give a list of such records here:

  PackageDoc := rec(
    # use same as in GAP            
    BookName  := "toric",
    ArchiveURLSubset := ["doc", "html"],
    # format/extension can be one of .zoo, .tar.gz, .tar.bz2, -win.zip
    #Archive   := "http://cadigweb.ew.usna.edu/~wdj/gap/toric/toric1.3.gz",
    HTMLStart := "html/chap0.html",
    PDFFile   := "doc/manual.pdf",
    # the path to the .six file used by GAP's help system
    SixFile   := "doc/manual.six",
    # a longer title of the book, this together with the book name should
    # fit on a single text line (appears with the '?books' command in GAP)
    LongTitle := "toric variety package",
    # Should this help book be autoloaded when GAP starts up? This should
    # usually be 'true', otherwise say 'false'. 
    Autoload := true
  ),

##  Are there restrictions on the operating system for this package? Or does
##  the package need other packages to be available?

  Dependencies := rec(
    # GAP version, use version strings for specifying exact versions,
    # prepend a '>=' for specifying a least version.
    GAP := ">= 4.5",
    # list of pairs [package name, (least) version],  package name is case
    # insensitive, least version denoted with '>=' prepended to version string.
    # without these, the package will not load
    NeededOtherPackages := [],
    # without these the package will issue a warning while loading
    SuggestedOtherPackages := [],
    # needed external conditions (programs, operating system, ...)  provide 
    # just strings as text or
    # pairs [text, URL] where URL  provides further information
    # about that point.
    # (no automatic test will be done for this, do this in your 
    # 'AvailabilityTest' function below)
    ExternalConditions := []
  ),

## Provide a test function for the availability of this package, see
## documentation of 'Declare(Auto)Package', this is the <tester> function.
## For packages which will not fully work, use 'Info(InfoWarning, 1,
## ".....")' statements. For packages containing nothing but GAP code,
## just say 'ReturnTrue' here.
## (When this is used for package loading in the future the availability
## tests of other packages, as given above, will be done automatically and
## need not be included here.)

AvailabilityTest := ReturnTrue,

#  AvailabilityTest := 
#    function()
#      local path;
#      # Test for existence of the compiled binary
#      path := DirectoriesPackagePrograms( "toric" );
#      return true;
#    end,


##  Suggest here if the package should be *automatically loaded* when GAP is 
##  started.  This should usually be 'false'. Say 'true' only if your package 
##  provides some improvements of the GAP library which are likely to enhance 
##  the overall system performance for many users.

  Autoload := false,

##  *Optional*, but recommended: path relative to package root to a file which 
##  contains as many tests of the package functionality as sensible.
#TestFile := "toric/toric_examples.test",

##  *Optional*: Here you can list some keyword related to the topic 
##  of the package.

  Keywords := [ "toric variety", "cone", "fan", "Riemann-Roch space" ]

));


