/****************************************************************************
**
*A  identity.c                  ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pga_vars.h"

/* set up the identity permutation */

void setup_identity_perm (int *permutation, struct pga_vars *pga)
{
   register int i;

   for (i = 1; i <= pga->Degree; ++i)
      permutation[i] = i;
}
