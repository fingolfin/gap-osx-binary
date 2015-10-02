/****************************************************************************
**
*A  next_class.c                ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "constants.h"
#include "pcp_vars.h"
#include "pq_functions.h"
#include "exp_vars.h"
#define BOTH_TAILS 0 

#if defined (GROUP) 

/* calculate the next class of the group layer by layer */

void next_class (Logical report, int **head, int **list, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int class;
   struct exp_vars exp_flag;
   int prev = 1, new;

   /* if class 1 computation, setup has already been done -- 
      before relations are read */
   if (y[pcp->clend + 1] != 0)
      setup (pcp);

   if (pcp->overflow || (pcp->complete != 0 && !pcp->multiplicator))
      return;

   if (pcp->extra_relations != 0 || pcp->m != 0) 
      initialise_exponent (&exp_flag, pcp);

   for (class = pcp->cc; class > 1; --class) {
      tails (BOTH_TAILS, class, pcp->cc, 1, pcp);
      if (pcp->overflow)
	 return;
      if (class != 2) {
	 if (pcp->m != 0) {
	    new = pcp->lastg - pcp->ccbeg + 1;
	    exp_flag.queue = reallocate_vector (exp_flag.queue, 
						prev, new, 1, FALSE);
	    prev = new;
	 }
	 consistency (0, exp_flag.queue, &exp_flag.queue_length, class, pcp);
	 if (pcp->overflow || (pcp->complete != 0 && !pcp->multiplicator))
	    return;
      }
   }

   if (!pcp->multiplicator) {
      if (pcp->cc > 1) {
	 update_generators (pcp);
	 if (pcp->overflow)
	    return;

	 /* this call is not necessary if there are no automorphisms 
	    present -- however, it may be useful in reducing space 
	    requirements and hence improve efficiency -- this needs 
	    to be investigated further -- EO'B October 1991 */

	 if (pcp->m != 0) {
	    eliminate (0, pcp);
	    /* an elimination has been performed -- must reset queue length */
	    exp_flag.queue_length = 0;
	    if (pcp->overflow)
	       return;
	 }
      }

      collect_relations (pcp);
      if (pcp->overflow || pcp->complete != 0 || !pcp->valid)
	 return;
      if (pcp->extra_relations != 0) {
	 if (pcp->m == 0) { 
	    exp_flag.list = ALL_WORDS;
	    extra_relations (&exp_flag, pcp);
	 }
	 else {
	    exp_flag.list = REDUCED_LIST;
	    enforce_exponent (report, &exp_flag, head, list, pcp);
	    if (pcp->overflow) return;
	 }
      }

      if (pcp->overflow || pcp->complete != 0 || !pcp->valid)
	 return;
   }


   /* if the multiplicator flag is set and there are redundant
      generators, then we must be careful about elimination -- 
      update_generators has not yet been performed; see note
      in code of that procedure */

   if (pcp->multiplicator && pcp->ndgen > y[pcp->clend + 1]) 
      eliminate (TRUE, pcp); 
   else 
      eliminate (FALSE, pcp);

}

#endif


/* when automorphisms are supplied, enforce exponent law by setting
   up a queue of redundant generators and then close this queue */
   
void enforce_exponent (Logical report, struct exp_vars *exp_flag, int **head, int **list, struct pcp_vars *pcp)
{
   register int *y = y_address;

#if defined (TIME)
   int t;
#endif 
   int factor;
   int limit;

   int *queue, queue_length; 
   int list_length;
   char *s;

   if (pcp->m != 0) {
      read_value (TRUE, "Input queue factor: ", &factor, 0);
      limit = factor * (pcp->lastg - pcp->ccbeg + 1) / 100;
   }

#if defined (TIME)
   t = runTime ();
#endif 

   Extend_Auts (head, list, y[pcp->clend + 1] + 1, pcp);
   if (pcp->overflow) 
      return;

#if defined (TIME)
   t = runTime () - t;
   printf ("Time to extend automorphisms is %.2f seconds\n", t * CLK_SCALE);
#endif 

#if defined (TIME)
   t = runTime ();
#endif 

   list_length = pcp->lastg - pcp->ccbeg + 1;
   pcp->start_wt = 1;
   pcp->end_wt = (2 * pcp->cc) / 3;

   extra_relations (exp_flag, pcp);
   if (pcp->overflow) 
      return;
   queue = exp_flag->queue; 
   queue_length = exp_flag->queue_length;

   pcp->end_wt = 0;
#if defined (TIME)
   t = runTime () - t;
#endif

   s = (queue_length == 1) ? "y" : "ies";
   if (report || pcp->fullop || pcp->diagn)
      printf ("Exponent checks gave %d redundanc%s\n", queue_length, s);

#if defined (TIME)
   printf ("Time to check exponents is %.2f seconds\n", t * CLK_SCALE);
#endif

   close_queue (report, list_length, limit, *head, *list, 
		queue, queue_length, pcp);
}

/* close the queue of redundant generators under the action 
   of the automorphisms */

void close_queue (Logical report, int list_length, int limit,
                  int *head, int *list,
                  int *queue, int queue_length,
                  struct pcp_vars *pcp)
{
   int *long_queue, long_queue_length; 
#if defined (TIME)
   int t;
#endif 

   long_queue = allocate_vector (list_length, 1, 0);
   long_queue_length = 0;

#if defined (TIME)
   t = runTime ();
#endif

   if (!pcp->complete) {
      close_relations (report, limit, 1, head, list, queue, queue_length, 
		       long_queue, &long_queue_length, pcp);
      if (report || pcp->fullop || pcp->diagn)
	 printf ("Length of long queue after closing short queue is %d\n", 
		 long_queue_length);

   }

   if (!pcp->complete)
      close_relations (report, limit, 2, head, list, long_queue, 
		       long_queue_length, long_queue, &long_queue_length, pcp);

   if (report || pcp->fullop || pcp->diagn)
      printf ("Final long queue length is %d\n", long_queue_length);

#if defined (TIME)
   t = runTime () - t;
   printf ("Time to close under action of automorphisms is %.2f seconds\n", 
	   t * CLK_SCALE);
#endif

   free_vector (queue, 1);
   free_vector (long_queue, 1);
}

int rearrange_queues (int limit, int *queue, int *queue_length,
                      int *long_queue, int long_queue_length,
                      struct pcp_vars *pcp)
{
   register int *y = y_address;

   int gen;
   int i, p1;

   for (i = 1; i <= long_queue_length; ++i) {
      gen = long_queue[i];
      p1 = -y[pcp->structure + gen];
      if (y[p1 + 1] < limit) {
	 queue[++*queue_length] = gen;
	 long_queue[i] = 0;
      }
   }
   return 0;
}

/* sort queue of redundant generators according to increasing length 
   of those relations which imply that each generator is redundant */

void bubble_sort (int *x, int len, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int i, j, pointer, temp;
   Logical swap = TRUE; 
   register int structure = pcp->structure;
   int *length = allocate_vector (len, 1, 1);

   /* set up the length of the relations as an array */
   for (i = 1; i <= len; ++i) {
      if (x[i] != 0) {
	 pointer = -y[structure + x[i]];
	 length[i] = y[pointer + 1];
      }
   }

   /* now sort the queue of generators */
   for (i = 1; i <= len && swap; ++i) {
      swap = FALSE;
      for (j = len; j > i; --j) 
	 if (length[j] < length[j - 1]) {
	    temp = x[j];
	    x[j] = x[j - 1];
	    x[j - 1] = temp;
	    temp = length[j];
	    length[j] = length[j - 1];
	    length[j - 1] = temp;
	    swap = TRUE;
	 } 
   }

   free_vector (length, 1);
}

