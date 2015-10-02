#############################################################################
##
##  young.gd                  The SpinSym Package                 Lukas Maas
##
##  Character tables of maximal Young subgroups of 2.Sym(n) and 2.Alt(n)
##  Copyright (C) 2012 Lukas Maas
##
#############################################################################

## Attribute: SpinSymIngredients of a (partial) SpinSym character table
## The attribute 'SpinSymIngredients' of a table <tbl> is used to store 
## some information used in the construction of <tbl> or related tables, 
## e.g. (possibly partial) character tables and a record.

## More precisely: if the type of <tbl> is "AA", "AS", or "SA", then
## SpinSymIngredients( <tbl> ) = [ CT1, CT2, inforec ] where CT1 and CT2 are
## the character tables of 
## 2.Alt(k) and 2.Alt(l), or 
## 2.Alt(k) and 2.Sym(l), or
## 2.Sym(k) and 2.Alt(l), respectively.
## If the type of <tbl> is "SS", then SpinSymIngredients( <tbl> ) = 
## [ 2.Sym(k), 2.Sym(l), inforec, 2.Alt(k), 2.Alt(l), AA, AS, SA ] 
## where the group names and types refer to the appropriate tables.

## In the construction of a modular table <modtbl> the ingredients of 
## the underlying ordinary table are used. After <modtbl> has been 
## constructed its ingredients are removed.

DeclareAttribute( "SpinSymIngredients", IsNearlyCharacterTable, "mutable" );

## internal functions
DeclareGlobalFunction( "SPINSYM_YNG_OrderOfProductOfDisjointSchurLifts" );
DeclareGlobalFunction( "SPINSYM_YNG_HEAD" );
DeclareGlobalFunction( "SPINSYM_YNG_HEADREG" );
DeclareGlobalFunction( "SPINSYM_YNG_POWERMAPS" );
DeclareGlobalFunction( "SPINSYM_YNG_TSR" );
DeclareGlobalFunction( "SPINSYM_YNG_IND" );
DeclareGlobalFunction( "SPINSYM_YNG_IRR");

## a hack...
DeclareGlobalFunction( "SPINSYM_BrauerTableFromLibrary" );

## functions the user should use

DeclareGlobalFunction( "SpinSymCharacterTableOfMaximalYoungSubgroup" );
DeclareGlobalFunction( "SpinSymBrauerTableOfMaximalYoungSubgroup" );

## Category: IsSpinSymTable
## The only purpose is to install the method `BrauerTableOp' which enables
## the usage of the `mod'-operator on ordinary character tables for tables
## constructed by the function `SpinSymCharacterTableOfMaximalYoungSubgroup'

DeclareCategory( "IsSpinSymTable", IsCharacterTable );
BindGlobal( "SpinSymFamily", NewFamily( "SpinSymFamily", IsSpinSymTable ) );

DeclareOperation( "BrauerTableOp", [ IsSpinSymTable, IsPosInt ] ); 

