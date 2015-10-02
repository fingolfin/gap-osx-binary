/****************************************************************************
**
*A  down_class.c                ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"

/* remove any class pcp->cc + 1 part on the value represented by y[ptr] */

void down_class (int ptr, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int p1;
   register int p2;
   register int count;
   register int count1;
   register int lastg = pcp->lastg;
#include "access.h"

   p1 = ptr;
   if (y[p1] >= 0) {
      if (y[p1] > lastg)
	 y[p1] = 0;
      return;
   }

   p2 = -y[p1];
   count = y[p2 + 1];
   count1 = count;
   while (FIELD2 (y[p2 + count1 + 1]) > lastg) {
      if (--count1 <= 0) {
	 y[p2] = y[p1] = 0;
	 return;
      }
   }

   if (count1 >= count)
      return;

   if (count == count1 + 1)
      /* only 1 generator of class pcp->cc + 1 found; mark 
	 it with a -1 header block */
      y[p2 + count1 + 2] = -1;
   else {
      y[p2 + count1 + 2] = 0;
      y[p2 + count1 + 3] = count - count1 - 2;
   }
   y[p2 + 1] = count1;
}
