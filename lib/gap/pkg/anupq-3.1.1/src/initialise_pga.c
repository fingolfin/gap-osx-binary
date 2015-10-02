/****************************************************************************
**
*A  initialise_pga.c            ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "pga_vars.h"

/* initialise the pga structure */

void initialise_pga (struct pga_vars *pga, struct pcp_vars *pcp)
{
   pga->p = pcp->p;
   pga->q = pga->r = pga->s = 0;
   pga->fixed = 0;
   pga->Degree = 0;
   pga->nmr_of_descendants = 0;
   pga->available = NULL;
   pga->list = NULL;
   pga->map = NULL;
   pga->rep = NULL;
   pga->offset = NULL;
   pga->powers = NULL;
   pga->inverse_modp = NULL;
}

/* set up values for pga structure */

void set_values (struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int *y = y_address;

   pga->multiplicator_rank = y[pcp->clend + pcp->cc] - 
      y[pcp->clend + pcp->cc - 1];
   pga->nuclear_rank = pcp->newgen;
}
