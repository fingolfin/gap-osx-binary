/****************************************************************************
**
*A  print_level.c               ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "constants.h"

/* set print levels for p-quotient calculation */

void print_level (int *output, struct pcp_vars *pcp)
{
   Logical reading = TRUE;

   while (reading) {
      read_value (TRUE, "Input print level (0-3): ", output, MIN_PRINT);
      reading = (*output > MAX_PRINT);
      if (reading)
	 printf ("Print level must lie between %d and %d\n",
		 MIN_PRINT, MAX_PRINT);
   }

   pcp->diagn = (*output == MAX_PRINT);
   pcp->fullop = (*output >= INTERMEDIATE_PRINT);
}
