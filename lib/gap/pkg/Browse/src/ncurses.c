/***************************************************************************
**
*A  ncurses.c                 BROWSE package                     Frank Lübeck
**
**  Provide functions from ncurses C-library to GAP.
**  We choose a subset of functions, usually the 'w'-variants.
**  Panels can also be used.
**
*/

#define VERSION "1.8.5"

const char * Revision_ncurses_c =
   "VERSION";

/* read GAP source header files with a combined header file */

#include        "src/compiled.h"          /* GAP headers                */
#include        "src/string.h"            /* need GAP strings           */
#include        "src/bool.h"              /* and booleans               */
#include        "src/plist.h"             /* and plain lists            */
#include        "src/records.h"
#include        "src/precord.h"           /* and plain records          */
#include        <stdio.h>
#include        <unistd.h>
#include        <stdlib.h>                /* for getenv and co          */
#ifdef WIDECHARS
#define _XOPEN_SOURCE_EXTENDED
#include <locale.h>
#include <ncursesw/curses.h>
#include <ncursesw/panel.h>
#else
#include        <ncurses.h>
#include        <panel.h>
#endif

/* remember attributes at init time  XXX
static attr_t startattr;
static short startcp;
*/ 

/* We store the living WINDOW and PANEL  pointers in two strings. The
   pointer to window i (zero based counting) is stored in
   ((WINDOW**)CHARS_STRING(winlist))[i]. If this window is wrapped in
   a panel then the pointer to this panel is stored in the same position of
   panellist.  
 
   For debugging purposes the strings winlist and panellist are available in 
   GAP as record components of the same name in 'NCurses'.
*/
static Obj winlist;
static Obj panellist;

/*          the functions         */


/* get the win or panel from number (return NULL if no valid input)   */
WINDOW* winnum(Obj num) {
  Int n;
  if (!IS_INTOBJ(num))
    return (WINDOW*)0;
  n = INT_INTOBJ(num);
  if (n < 0 || n * sizeof(Obj) >= GET_LEN_STRING(winlist))
    return (WINDOW*)0;
  return ((WINDOW**)CHARS_STRING(winlist))[n];
}
PANEL* pannum(Obj num) {
  Int n;
  if (!IS_INTOBJ(num))
    return (PANEL*)0;
  n = INT_INTOBJ(num);
  /* no panel for stdscr */
  if (n < 1 || n * sizeof(Obj) >= GET_LEN_STRING(panellist))
    return (PANEL*)0;
  return ((PANEL**)CHARS_STRING(panellist))[n];
}
 
Obj IsStdinATty(Obj self) {
  if (isatty(0))
    return True;
  else
    return False;
}

Obj IsStdoutATty(Obj self) {
  if (isatty(1))
    return True;
  else
    return False;
}

/* interface to configure some basic behaviour of the ncurses screen     */
Obj Cbreak(Obj self) {
  if (cbreak() != ERR)
    return True;
  else
    return False;
}

Obj Nocbreak(Obj self) {
  if (nocbreak() != ERR)
    return True;
  else
    return False;
}

Obj Echo(Obj self) {
  if (echo() != ERR)
    return True;
  else
    return False;
}

Obj Noecho(Obj self) {
  if (noecho() != ERR)
    return True;
  else
    return False;
}

Obj Nl(Obj self) {
  if (nl() != ERR)
    return True;
  else
    return False;
}

Obj Nonl(Obj self) {
  if (nonl() != ERR)
    return True;
  else
    return False;
}

Obj Raw(Obj self) {
  if (raw() != ERR)
    return True;
  else
    return False;
}

Obj Noraw(Obj self) {
  if (noraw() != ERR)
    return True;
  else
    return False;
}

Obj Intrflush(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (intrflush(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (intrflush(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Keypad(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (keypad(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (keypad(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Idlok(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (idlok(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (idlok(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Leaveok(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (leaveok(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (leaveok(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Scrollok(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (scrollok(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (scrollok(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Clearok(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    if (clearok(win, TRUE) != ERR)
      return True;
    else
      return False;
  else
    if (clearok(win, FALSE) != ERR)
      return True;
    else
      return False;
}

Obj Immedok(Obj self, Obj num, Obj bf) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (bf == True)
    immedok(win, TRUE);
  else
    immedok(win, FALSE);
  return True;
}

Obj WTimeout(Obj self, Obj num, Obj time) {
  WINDOW *win;
  Int t;
  win = winnum(num);
  if (!win)
    return False;
  if (!IS_INTOBJ(time))
    t = 0;
  else
    t = INT_INTOBJ(time);
  wtimeout(win, (int)t);
  return True;
}

Obj Napms(Obj self, Obj time) {
  Int t;
  if (!IS_INTOBJ(time))
    t = 0;
  else
    t = INT_INTOBJ(time); 
  napms(t);
  return True;
}

Obj Curs_set(Obj self, Obj vis) {
  int res;
  if (!IS_INTOBJ(vis))
    return False;
  res = curs_set(INT_INTOBJ(vis));
  if (res == ERR)
    return False;
  return INTOBJ_INT(res);
}

Obj Savetty(Obj self) {
  savetty();
  return True;
}

Obj Resetty(Obj self) {
  resetty();
  return True;
}

static int default_curs_vis = ERR;
Obj ResetCursor(Obj self) {
  if (default_curs_vis != ERR)
    curs_set(default_curs_vis);
  return True;
}

/* set default attributes, stored during init of ncurses   XXX
Obj Attrsetdefault(Obj self) {
  attr_set(startattr, startcp, 0);
  return (Obj)0;
}*/

/* delete all windows, except stdscr, and panels; clear stdscr     */
Obj ClearAll(Obj self) {

  SET_LEN_STRING(winlist, sizeof(Obj));
  SET_LEN_STRING(panellist, sizeof(Obj));
  clear();
  return (Obj)0;
}

/* basic functions: wrefresh, endwin, doupdate    */
Obj WRefresh( Obj self, Obj num ) {
  WINDOW* win;
  win = winnum(num);
  if (win) {
    if (wrefresh(win) != ERR)
      return True;
    else
      return False;
  }
  else 
    return False;
}

Obj Doupdate( Obj self ) {
  if (doupdate() != ERR)
    return True;
  else
    return False;
}

Obj Endwin( Obj self ) {
  if (endwin() != ERR)
    return True;
  else
    return False;
}

Obj Isendwin( Obj self ) {
  if (isendwin())
    return True;
  else
    return False;
}


/* create, delete, move windows    */
Obj Newwin( Obj self, Obj nlines, Obj ncols, Obj begin_y, Obj begin_x) {
  Int nl, nc, by, bx;
  int num;
  WINDOW *win;

  if (IS_INTOBJ(nlines))
    nl = INT_INTOBJ(nlines);
  else
    nl = 0;
  if (IS_INTOBJ(ncols))
    nc = INT_INTOBJ(ncols);
  else
    nc = 0;
  if (IS_INTOBJ(begin_y))
    by = INT_INTOBJ(begin_y);
  else
    by = 0;
  if (IS_INTOBJ(begin_x))
    bx = INT_INTOBJ(begin_x);
  else
    bx = 0;
  win = newwin(nl, nc, by, bx);
  if (win) {
    num = GET_LEN_STRING(winlist)/sizeof(Obj);
    GROW_STRING(winlist, (num+1)*sizeof(Obj));
    ((WINDOW**)(CHARS_STRING(winlist)))[num] = win;
    SET_LEN_STRING(winlist, (num+1)*sizeof(Obj));
    CHANGED_BAG(winlist);
    return INTOBJ_INT(num);
  }
  else
    return False;
}

Obj Delwin( Obj self, Obj num ) {
  WINDOW* win;
  Int i, n;
  win = winnum(num);
  if (win) {
    if (delwin(win) != ERR) {
      n = INT_INTOBJ(num);
      ((WINDOW**)(CHARS_STRING(winlist)))[n] = 0;
      if ((n+1)*sizeof(Obj) == GET_LEN_STRING(winlist)) {
        for (i = GET_LEN_STRING(winlist)/sizeof(Obj);
             i > 0 && ((WINDOW**)(CHARS_STRING(winlist)))[i-1] == 0; 
             i--);
        SET_LEN_STRING(winlist, i * sizeof(Obj));
      }
      CHANGED_BAG(winlist);
      return True;
    }
    else
      return False;
  }
  else 
    return False;
}

Obj Mvwin(Obj self, Obj num, Obj y, Obj x) {
  Int iy, ix;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(y))
    iy = INT_INTOBJ(y);
  else
    iy = 0;
  if (IS_INTOBJ(x))
    ix = INT_INTOBJ(x);
  else
    ix = 0;
  if (mvwin(win, iy, ix) != ERR)
    return True;
  else
    return False;
}  

/* moving curser, writing characters and strings to terminal        */
Obj WMove(Obj self, Obj num, Obj y, Obj x) {
  WINDOW *win;
  Int iy, ix;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(y))
    iy = INT_INTOBJ(y);
  else
    iy = 0;
  if (IS_INTOBJ(x))
    ix = INT_INTOBJ(x);
  else
    ix = 0;
  if (wmove(win, iy, ix) != ERR)
    return True;
  else
    return False;
}   

/* whole window, or to EOL or to bottom of window */
Obj WClear( Obj self, Obj num ) {
  WINDOW* win;
  win = winnum(num);
  if (win) {
    if (wclear(win) != ERR)
      return True;
    else
      return False;
  }
  else 
    return False;
}

Obj WErase( Obj self, Obj num ) {
  WINDOW* win;
  win = winnum(num);
  if (win) {
    if (werase(win) != ERR)
      return True;
    else
      return False;
  }
  else 
    return False;
}

Obj WClrtoeol( Obj self, Obj num ) {
  WINDOW* win;
  win = winnum(num);
  if (win) {
    if (wclrtoeol(win) != ERR)
      return True;
    else
      return False;
  }
  else 
    return False;
}

Obj WClrtobot( Obj self, Obj num ) {
  WINDOW* win;
  win = winnum(num);
  if (win) {
    if (wclrtobot(win) != ERR)
      return True;
    else
      return False;
  }
  else 
    return False;
}

Obj WAddnstr(Obj self, Obj num, Obj str, Obj n) {
  WINDOW *win;
  Int len;
  win = winnum(num);
  if (!win)
    return False;
  if (!IS_STRING_REP(str))
    return False;
  if (!IS_INTOBJ(n))
    len = GET_LEN_STRING(str);
  else
    len = INT_INTOBJ(n);
  if (waddnstr(win, CSTR_STRING(str), len) != ERR)
    return True;
  else
    return False;
}

/* ch can be a GAP character or an INTOBJ (possibly containing
   attribute info)     */
Obj WAddch(Obj self, Obj num, Obj ch) {
  WINDOW *win;
  Int ich;
  win = winnum(num);
  if (!win)
    return False;
  if (TNUM_OBJ(ch) == T_CHAR)
    ich = *(UChar*)ADDR_OBJ(ch);
  else if (IS_INTOBJ(ch))
    ich = INT_INTOBJ(ch);
  else
    return False;
  if (waddch(win, ich) != ERR)
    return True;
  else
    return False;
}

#ifdef WIDECHARS
Obj WAddwch(Obj self, Obj num, Obj ch) {
  WINDOW *win;
  wchar_t ich[CCHARW_MAX];
  cchar_t cc;
  Obj c;
  Int i;

  win = winnum(num);
  if (!win)
    return False;
  if (TNUM_OBJ(ch) == T_CHAR){
    ich[0] = *(UChar*)ADDR_OBJ(ch);
    ich[1] = L'\0';
  }
  else if (IS_INTOBJ(ch)){
    ich[0] = INT_INTOBJ(ch);
    ich[1] = L'\0';
  }
  else if (IS_LIST(ch)){
    for (i=1, c=ELM0_LIST(ch,1); i < CCHARW_MAX && IS_INTOBJ(c); 
              i++, c=ELM0_LIST(ch,i)) {
      ich[i-1] = INT_INTOBJ(c);
    }
    ich[i-1] = L'\0';
  }
  else
    return False;
  
  if (setcchar(&cc, ich, 0, 0, NULL) == ERR)
    return False;
  

  if (wecho_wchar(win, &cc) != ERR)
    return True;
  else
    return False;
}
#endif

Obj WBorder(Obj self, Obj num, Obj chars) {
  WINDOW *win;
  Obj ls, rs, ts, bs, tl, tr, bl, br;
  Int ils, irs, its, ibs, itl, itr, ibl, ibr;
  if (IS_PLIST(chars) && LEN_PLIST(chars) > 7) {
    ls = ELM_PLIST(chars, 1);
    rs = ELM_PLIST(chars, 2);
    ts = ELM_PLIST(chars, 3);
    bs = ELM_PLIST(chars, 4);
    tl = ELM_PLIST(chars, 5);
    tr = ELM_PLIST(chars, 6);
    bl = ELM_PLIST(chars, 7);
    br = ELM_PLIST(chars, 8);
  }
  else {
    ls = Fail; rs = Fail; ts = Fail; bs = Fail; 
    tl = Fail; tr = Fail; bl = Fail; br = Fail; 
  }
  win = winnum(num);
  if (!win)
    return False;
  if (TNUM_OBJ(ls) == T_CHAR)
    ils = *(UChar*)ADDR_OBJ(ls);
  else if (IS_INTOBJ(ls))
    ils = INT_INTOBJ(ls);
  else
    ils = 0;
  if (TNUM_OBJ(rs) == T_CHAR)
    irs = *(UChar*)ADDR_OBJ(rs);
  else if (IS_INTOBJ(rs))
    irs = INT_INTOBJ(rs);
  else
    irs = 0;
  if (TNUM_OBJ(ts) == T_CHAR)
    its = *(UChar*)ADDR_OBJ(ts);
  else if (IS_INTOBJ(ts))
    its = INT_INTOBJ(ts);
  else
    its = 0;
  if (TNUM_OBJ(bs) == T_CHAR)
    ibs = *(UChar*)ADDR_OBJ(bs);
  else if (IS_INTOBJ(bs))
    ibs = INT_INTOBJ(bs);
  else
    ibs = 0;
  if (TNUM_OBJ(tl) == T_CHAR)
    itl = *(UChar*)ADDR_OBJ(tl);
  else if (IS_INTOBJ(tl))
    itl = INT_INTOBJ(tl);
  else
    itl = 0;
  if (TNUM_OBJ(tr) == T_CHAR)
    itr = *(UChar*)ADDR_OBJ(tr);
  else if (IS_INTOBJ(tr))
    itr = INT_INTOBJ(tr);
  else
    itr = 0;
  if (TNUM_OBJ(bl) == T_CHAR)
    ibl = *(UChar*)ADDR_OBJ(bl);
  else if (IS_INTOBJ(bl))
    ibl = INT_INTOBJ(bl);
  else
    ibl = 0;
  if (TNUM_OBJ(br) == T_CHAR)
    ibr = *(UChar*)ADDR_OBJ(br);
  else if (IS_INTOBJ(br))
    ibr = INT_INTOBJ(br);
  else
    ibr = 0;
  if (wborder(win, (chtype)ils, (chtype)irs, (chtype)its, (chtype)ibs,
                   (chtype)itl, (chtype)itr, (chtype)ibl, (chtype)ibr) != ERR)
    return True;
  else
    return False;
}

Obj WVline(Obj self, Obj num, Obj ch, Obj n) {
  Int x, y, ich;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (TNUM_OBJ(ch) == T_CHAR)
    ich = *(UChar*)ADDR_OBJ(ch);
  else if (IS_INTOBJ(ch))
    ich = INT_INTOBJ(ch);
  else
    ich = 0;
  if (!IS_INTOBJ(n)) 
    getmaxyx(win, y, x);
  else 
    y = INT_INTOBJ(n);
  x = wvline(win, ich, y);
  if (x != ERR) 
    return INTOBJ_INT(x);
  else
    return False;
}
    
Obj WHline(Obj self, Obj num, Obj ch, Obj n) {
  Int x, y, ich;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (TNUM_OBJ(ch) == T_CHAR)
    ich = *(UChar*)ADDR_OBJ(ch);
  else if (IS_INTOBJ(ch))
    ich = INT_INTOBJ(ch);
  else
    ich = 0;
  if (!IS_INTOBJ(n)) 
    getmaxyx(win, y, x);
  else 
    x = INT_INTOBJ(n);
  y = whline(win, ich, x);
  if (y != ERR) 
    return INTOBJ_INT(y);
  else
    return False;
}
 
/* returns integer which can be fed back in waddch   */
Obj WInch(Obj self, Obj num) {
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  return INTOBJ_INT((Int) winch(win));
}

/* get size of window and cursor position   */
Obj Getyx(Obj self, Obj num) {
  WINDOW *win;
  int x, y;
  Obj res;
  win = winnum(num);
  if (!win)
    return False;
  res = NEW_PLIST(T_PLIST, 2);
  SET_LEN_PLIST(res, 2);
  getyx(win, y, x);
  SET_ELM_PLIST(res, 1, INTOBJ_INT(y));
  SET_ELM_PLIST(res, 2, INTOBJ_INT(x));
  return res;
}

Obj Getbegyx(Obj self, Obj num) {
  WINDOW *win;
  int x, y;
  Obj res;
  win = winnum(num);
  if (!win)
    return False;
  res = NEW_PLIST(T_PLIST, 2);
  SET_LEN_PLIST(res, 2);
  getbegyx(win, y, x);
  SET_ELM_PLIST(res, 1, INTOBJ_INT(y));
  SET_ELM_PLIST(res, 2, INTOBJ_INT(x));
  return res;
}

Obj Getmaxyx(Obj self, Obj num) {
  WINDOW *win;
  int x, y;
  Obj res;
  win = winnum(num);
  if (!win)
    return False;
  res = NEW_PLIST(T_PLIST, 2);
  SET_LEN_PLIST(res, 2);
  getmaxyx(win, y, x);
  SET_ELM_PLIST(res, 1, INTOBJ_INT(y));
  SET_ELM_PLIST(res, 2, INTOBJ_INT(x));
  return res;
}


/* the win argument is used for possible echoing   */
Obj WGetch(Obj self, Obj num) {
  int c;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    win = stdscr;
  c = getch();
  if (c != ERR)
    return INTOBJ_INT(c);
  else
    return False;
}

Obj Ungetch(Obj self, Obj ch) {
  int ich;
  if (!IS_INTOBJ(ch))
    return False;
  ich = (int) INT_INTOBJ(ch);
  if (ungetch(ich) != ERR)
    return True;
  else
    return False;
}

Obj Has_key(Obj self, Obj ch) {
  int ich;
  if (!IS_INTOBJ(ch))
    return False;
  ich = (int) INT_INTOBJ(ch);
  if (has_key(ich) == TRUE)
    return True;
  else
    return False;
}



/* Keys, we give symbols of standard special keys to GAP                 */

/*  test with 'has_key' and add some more (?),
    see http://hessling-editor.sourceforge.net/doc/misc/app2.html     */
Obj InitKeys() {
  Obj tmp;
  
  tmp = NEW_PREC(0);
  AssPRec(tmp, RNamName("DOWN"), INTOBJ_INT((Int)KEY_DOWN));
  AssPRec(tmp, RNamName("UP"), INTOBJ_INT((Int)KEY_UP));
  AssPRec(tmp, RNamName("LEFT"), INTOBJ_INT((Int)KEY_LEFT));
  AssPRec(tmp, RNamName("RIGHT"), INTOBJ_INT((Int)KEY_RIGHT));
  AssPRec(tmp, RNamName("HOME"), INTOBJ_INT((Int)KEY_HOME));
  AssPRec(tmp, RNamName("END"), INTOBJ_INT((Int)KEY_END));
  AssPRec(tmp, RNamName("PPAGE"), INTOBJ_INT((Int)KEY_PPAGE));
  AssPRec(tmp, RNamName("NPAGE"), INTOBJ_INT((Int)KEY_NPAGE));
  AssPRec(tmp, RNamName("BACKSPACE"), INTOBJ_INT((Int)KEY_BACKSPACE));
  AssPRec(tmp, RNamName("DC"), INTOBJ_INT((Int)KEY_DC));
  AssPRec(tmp, RNamName("ENTER"), INTOBJ_INT((Int)KEY_ENTER));
  AssPRec(tmp, RNamName("IC"), INTOBJ_INT((Int)KEY_IC));
  AssPRec(tmp, RNamName("REPLACE"), INTOBJ_INT((Int)KEY_REPLACE));
  AssPRec(tmp, RNamName("STAB"), INTOBJ_INT((Int)KEY_STAB));
  AssPRec(tmp, RNamName("F1"), INTOBJ_INT((Int)KEY_F(1)));
  AssPRec(tmp, RNamName("F2"), INTOBJ_INT((Int)KEY_F(2)));
  AssPRec(tmp, RNamName("F3"), INTOBJ_INT((Int)KEY_F(3)));
  AssPRec(tmp, RNamName("F4"), INTOBJ_INT((Int)KEY_F(4)));
  AssPRec(tmp, RNamName("F5"), INTOBJ_INT((Int)KEY_F(5)));
  AssPRec(tmp, RNamName("F6"), INTOBJ_INT((Int)KEY_F(6)));
  AssPRec(tmp, RNamName("F7"), INTOBJ_INT((Int)KEY_F(7)));
  AssPRec(tmp, RNamName("F8"), INTOBJ_INT((Int)KEY_F(8)));
  AssPRec(tmp, RNamName("F9"), INTOBJ_INT((Int)KEY_F(9)));
  AssPRec(tmp, RNamName("F10"), INTOBJ_INT((Int)KEY_F(10)));
  AssPRec(tmp, RNamName("F11"), INTOBJ_INT((Int)KEY_F(11)));
  AssPRec(tmp, RNamName("F12"), INTOBJ_INT((Int)KEY_F(12)));
  AssPRec(tmp, RNamName("F13"), INTOBJ_INT((Int)KEY_F(13)));
  AssPRec(tmp, RNamName("F14"), INTOBJ_INT((Int)KEY_F(14)));
  AssPRec(tmp, RNamName("F15"), INTOBJ_INT((Int)KEY_F(15)));
  AssPRec(tmp, RNamName("F16"), INTOBJ_INT((Int)KEY_F(16)));
  AssPRec(tmp, RNamName("F17"), INTOBJ_INT((Int)KEY_F(17)));
  AssPRec(tmp, RNamName("F18"), INTOBJ_INT((Int)KEY_F(18)));
  AssPRec(tmp, RNamName("F19"), INTOBJ_INT((Int)KEY_F(19)));
  AssPRec(tmp, RNamName("F20"), INTOBJ_INT((Int)KEY_F(20)));
  AssPRec(tmp, RNamName("F21"), INTOBJ_INT((Int)KEY_F(21)));
  AssPRec(tmp, RNamName("F22"), INTOBJ_INT((Int)KEY_F(22)));
  AssPRec(tmp, RNamName("F23"), INTOBJ_INT((Int)KEY_F(23)));
  AssPRec(tmp, RNamName("F24"), INTOBJ_INT((Int)KEY_F(24)));
  AssPRec(tmp, RNamName("A1"), INTOBJ_INT((Int)KEY_A1));
  AssPRec(tmp, RNamName("A3"), INTOBJ_INT((Int)KEY_A3));
  AssPRec(tmp, RNamName("B2"), INTOBJ_INT((Int)KEY_B2));
  AssPRec(tmp, RNamName("C1"), INTOBJ_INT((Int)KEY_C1));
  AssPRec(tmp, RNamName("C3"), INTOBJ_INT((Int)KEY_C3));
  AssPRec(tmp, RNamName("MOUSE"), INTOBJ_INT((Int)KEY_MOUSE));
  
  return tmp; 
}

/* Line drawing characters on GAP level */
Obj InitLineDraw() {
  Obj res;
  res = NEW_PREC(0);
  AssPRec(res, RNamName("BLOCK"), INTOBJ_INT((Int)ACS_BLOCK));
  AssPRec(res, RNamName("BOARD"), INTOBJ_INT((Int)ACS_BOARD));
  AssPRec(res, RNamName("BTEE"), INTOBJ_INT((Int)ACS_BTEE));
  AssPRec(res, RNamName("BULLET"), INTOBJ_INT((Int)ACS_BULLET));
  AssPRec(res, RNamName("CKBOARD"), INTOBJ_INT((Int)ACS_CKBOARD));
  AssPRec(res, RNamName("DARROW"), INTOBJ_INT((Int)ACS_DARROW));
  AssPRec(res, RNamName("DEGREE"), INTOBJ_INT((Int)ACS_DEGREE));
  AssPRec(res, RNamName("DIAMOND"), INTOBJ_INT((Int)ACS_DIAMOND));
  AssPRec(res, RNamName("GEQUAL"), INTOBJ_INT((Int)ACS_GEQUAL));
  AssPRec(res, RNamName("HLINE"), INTOBJ_INT((Int)ACS_HLINE));
  AssPRec(res, RNamName("LANTERN"), INTOBJ_INT((Int)ACS_LANTERN));
  AssPRec(res, RNamName("LARROW"), INTOBJ_INT((Int)ACS_LARROW));
  AssPRec(res, RNamName("LEQUAL"), INTOBJ_INT((Int)ACS_LEQUAL));
  AssPRec(res, RNamName("LLCORNER"), INTOBJ_INT((Int)ACS_LLCORNER));
  AssPRec(res, RNamName("LRCORNER"), INTOBJ_INT((Int)ACS_LRCORNER));
  AssPRec(res, RNamName("LTEE"), INTOBJ_INT((Int)ACS_LTEE));
  AssPRec(res, RNamName("NEQUAL"), INTOBJ_INT((Int)ACS_NEQUAL));
  AssPRec(res, RNamName("PI"), INTOBJ_INT((Int)ACS_PI));
  AssPRec(res, RNamName("PLMINUS"), INTOBJ_INT((Int)ACS_PLMINUS));
  AssPRec(res, RNamName("PLUS"), INTOBJ_INT((Int)ACS_PLUS));
  AssPRec(res, RNamName("RARROW"), INTOBJ_INT((Int)ACS_RARROW));
  AssPRec(res, RNamName("RTEE"), INTOBJ_INT((Int)ACS_RTEE));
  AssPRec(res, RNamName("S1"), INTOBJ_INT((Int)ACS_S1));
  AssPRec(res, RNamName("S3"), INTOBJ_INT((Int)ACS_S3));
  AssPRec(res, RNamName("S7"), INTOBJ_INT((Int)ACS_S7));
  AssPRec(res, RNamName("S9"), INTOBJ_INT((Int)ACS_S9));
  AssPRec(res, RNamName("STERLING"), INTOBJ_INT((Int)ACS_STERLING));
  AssPRec(res, RNamName("TTEE"), INTOBJ_INT((Int)ACS_TTEE));
  AssPRec(res, RNamName("UARROW"), INTOBJ_INT((Int)ACS_UARROW));
  AssPRec(res, RNamName("ULCORNER"), INTOBJ_INT((Int)ACS_ULCORNER));
  AssPRec(res, RNamName("URCORNER"), INTOBJ_INT((Int)ACS_URCORNER));
  AssPRec(res, RNamName("VLINE"), INTOBJ_INT((Int)ACS_VLINE));
  
  return res;
}

/* Attributes, we handle colors and standard attributes                  */

Obj InitAttrs() {
  Obj tmp, cp;
  UInt4 i, n;
  
  tmp = NEW_PREC(0);
  if (has_colors()) {
    start_color();
    use_default_colors();
    AssPRec(tmp, RNamName("has_colors"), True);
    /* initialize color pairs 1..64 */
    cp = NEW_PLIST(T_PLIST, 64);
    for (i = 1; i <= 64 && i < COLOR_PAIRS; i++) {
      if (i < 64) 
        if (i%8 == i/8) {
          init_pair(i, i%8, -1);
        } else {
          init_pair(i, i % 8, i/8);
        }
      else 
        init_pair(i, 0, -1);
      n = COLOR_PAIR(i);
      SET_ELM_PLIST(cp, i, INTOBJ_INT(n));
      SET_LEN_PLIST(cp, (UInt)i);
    }
    AssPRec(tmp, RNamName("ColorPairs"), cp);
    /* fgcolor with default background */
    if (72 < COLOR_PAIRS) {
      cp = NEW_PLIST(T_PLIST, 8);
      SET_LEN_PLIST(cp, 8);
      for (i = 0; i <= 7; i++) {
          init_pair(65+i, i, -1);
          n = COLOR_PAIR(65+i);
          SET_ELM_PLIST(cp, i+1, INTOBJ_INT(n));
      }
      AssPRec(tmp, RNamName("ColorPairsFg"), cp);
    }
    /* bgcolor with default foreground */
    if (80 < COLOR_PAIRS) {
      cp = NEW_PLIST(T_PLIST, 8);
      SET_LEN_PLIST(cp, 8);
      for (i = 0; i <= 7; i++) {
          init_pair(73+i, -1, i);
          n = COLOR_PAIR(73+i);
          SET_ELM_PLIST(cp, i+1, INTOBJ_INT(n));
      }
      AssPRec(tmp, RNamName("ColorPairsBg"), cp);
    }
  }
  else {
    AssPRec(tmp, RNamName("has_colors"), False);
  }
  /* the other attributes  */
  AssPRec(tmp, RNamName("NORMAL"), INTOBJ_INT(A_NORMAL));
  AssPRec(tmp, RNamName("STANDOUT"), INTOBJ_INT(A_STANDOUT));
  AssPRec(tmp, RNamName("UNDERLINE"), INTOBJ_INT(A_UNDERLINE));
  AssPRec(tmp, RNamName("REVERSE"), INTOBJ_INT(A_REVERSE));
  AssPRec(tmp, RNamName("BLINK"), INTOBJ_INT(A_BLINK));
  AssPRec(tmp, RNamName("DIM"), INTOBJ_INT(A_DIM));
  AssPRec(tmp, RNamName("BOLD"), INTOBJ_INT(A_BOLD));
  
  return tmp;
}

Obj WAttrset(Obj self, Obj num, Obj attrs) {
  Int i;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(attrs))
    i = INT_INTOBJ(attrs);
  else
    i = 0;
  if (wattrset(win, i) != ERR)
    return True;
  else
    return False;
} 

Obj WAttron(Obj self, Obj num, Obj attrs) {
  Int i;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(attrs))
    i = INT_INTOBJ(attrs);
  else
    i = 0;
  if (wattron(win, i) != ERR)
    return True;
  else
    return False;
} 

Obj WAttroff(Obj self, Obj num, Obj attrs) {
  Int i;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(attrs))
    i = INT_INTOBJ(attrs);
  else
    i = 0;
  if (wattroff(win, i) != ERR)
    return True;
  else
    return False;
} 

/* wattr_get is a macro and allows NULL pointers as arguments, this is 
   checked in the code. 
   If we call it with arguments which are obviously never NULL, then 
   gcc >= 4.6 with -Wall or -Waddress issues a warning that a pointer 
   is checked for not being NULL although it is never NULL. 
   We wrap that macro in a function to avoid the warning.   */
int wattr_get_fun(WINDOW *win, attr_t * pa, short *ps, void *opts) {
  int ret;
  ret = wattr_get(win, pa, ps, opts);
  return ret;
}
Obj WAttrCPGet(Obj self, Obj num) {
  WINDOW *win;
  attr_t a;
  short cp;
  Obj res;
  win = winnum(num);
  if (!win)
    return False;
  wattr_get_fun(win, &a, &cp, NULL);
  res = NEW_PLIST(T_PLIST, 2);
  SET_LEN_PLIST(res, 2);
  SET_ELM_PLIST(res, 1, INTOBJ_INT((int)a));
  SET_ELM_PLIST(res, 2, INTOBJ_INT((int)cp));
  return res;
};
  

Obj WBkgdset(Obj self, Obj num, Obj attrs) {
  Int i;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(attrs))
    i = INT_INTOBJ(attrs);
  else
    i = 0;
  wbkgdset(win, i);
  return True;
} 

Obj WBkgd(Obj self, Obj num, Obj attrs) {
  Int i;
  WINDOW *win;
  win = winnum(num);
  if (!win)
    return False;
  if (IS_INTOBJ(attrs))
    i = INT_INTOBJ(attrs);
  else
    i = 0;
  wbkgd(win, i);
  return True;
} 


/* Panels: create, delete, update, move, stack movements, hide, show */
Obj New_panel(Obj self, Obj num) {
  WINDOW *win;
  PANEL *pan;
  int n;
  win = winnum(num);
  if (!win)
    return False;
  n = INT_INTOBJ(num);
  if (n == 0)
    /* no panel for stdscr */
    return False;
  pan = new_panel(win);
  if (!pan)
    return False;
  GROW_STRING(panellist, (n+1)*sizeof(Obj));
  ((PANEL**)(CHARS_STRING(panellist)))[n] = pan;
  if ((n+1)*sizeof(Obj) > GET_LEN_STRING(panellist)) 
    SET_LEN_STRING(panellist, (n+1)*sizeof(Obj));
  CHANGED_BAG(panellist);
  return num;
}

Obj Del_panel(Obj self, Obj pnum) {
  PANEL *pan;
  Int i, n;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (del_panel(pan) != ERR) {
    n = INT_INTOBJ(pnum);
    ((PANEL**)(CHARS_STRING(panellist)))[n] = 0;
    if ((n+1)*sizeof(Obj) == GET_LEN_STRING(panellist)) {
        for (i = GET_LEN_STRING(panellist)/sizeof(Obj);
             i > 0 && ((PANEL**)(CHARS_STRING(panellist)))[i-1] == 0; 
             i--);
        SET_LEN_STRING(panellist, i * sizeof(Obj));
    }
    CHANGED_BAG(panellist);
    return True;
  } 
  else
    return False;
}
     
Obj Update_panels(Obj self) {
  update_panels();
  return True;
}

Obj Hide_panel(Obj self, Obj pnum) {
  PANEL *pan;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (hide_panel(pan) != ERR) {
    return True;
  } 
  else
    return False;
}

Obj Show_panel(Obj self, Obj pnum) {
  PANEL *pan;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (show_panel(pan) != ERR) {
    return True;
  } 
  else
    return False;
}

Obj Bottom_panel(Obj self, Obj pnum) {
  PANEL *pan;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (bottom_panel(pan) != ERR) {
    return True;
  } 
  else
    return False;
}

Obj Top_panel(Obj self, Obj pnum) {
  PANEL *pan;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (top_panel(pan) != ERR) {
    return True;
  } 
  else
    return False;
}

Obj Panel_above(Obj self, Obj pnum) {
  PANEL *pan;
  int i;
  pan = pannum(pnum);
  pan = panel_above(pan);
  if (!pan)
    return False;
  for(i = 1; ((PANEL**)(CHARS_STRING(panellist)))[i] != pan; i++);
  return INTOBJ_INT((Int)i);
}

Obj Panel_below(Obj self, Obj pnum) {
  PANEL *pan;
  int i;
  pan = pannum(pnum);
  pan = panel_below(pan);
  if (!pan)
    return False;
  for(i = 1; ((PANEL**)(CHARS_STRING(panellist)))[i] != pan; i++);
  return INTOBJ_INT((Int)i);
}

Obj Move_panel(Obj self, Obj pnum, Obj y, Obj x) {
  Int iy, ix;
  PANEL *pan;
  pan = pannum(pnum);
  if (!pan)
    return False;
  if (IS_INTOBJ(y))
    iy = INT_INTOBJ(y);
  else
    iy = 0;
  if (IS_INTOBJ(x))
    ix = INT_INTOBJ(x);
  else
    ix = 0;
  if (move_panel(pan, iy, ix) != ERR)
    return True;
  else
    return False;
}  

/* mouse interface if available   */
#ifdef NCURSES_MOUSE_VERSION
static mmask_t mmaskbits[] = {
 BUTTON1_PRESSED, BUTTON1_RELEASED, BUTTON1_CLICKED, BUTTON1_DOUBLE_CLICKED,
 BUTTON1_TRIPLE_CLICKED,
 BUTTON2_PRESSED, BUTTON2_RELEASED, BUTTON2_CLICKED, BUTTON2_DOUBLE_CLICKED,
 BUTTON2_TRIPLE_CLICKED,
 BUTTON3_PRESSED, BUTTON3_RELEASED, BUTTON3_CLICKED, BUTTON3_DOUBLE_CLICKED,
 BUTTON3_TRIPLE_CLICKED,
 BUTTON4_PRESSED, BUTTON4_RELEASED, BUTTON4_CLICKED, BUTTON4_DOUBLE_CLICKED,
 BUTTON4_TRIPLE_CLICKED,
 BUTTON_SHIFT, BUTTON_CTRL, BUTTON_ALT, REPORT_MOUSE_POSITION
#if NCURSES_MOUSE_VERSION == 2
  , BUTTON5_PRESSED, BUTTON5_RELEASED, BUTTON5_CLICKED, BUTTON5_DOUBLE_CLICKED,
 BUTTON5_TRIPLE_CLICKED,  
#endif
};
#if NCURSES_MOUSE_VERSION == 2
  # define LENmmaskbits 29
#else
  # define LENmmaskbits 24
#endif


/* translate mmask_t to list of integers and vice versa */
Obj IntlistMmask_t(mmask_t mask) {
  Obj res;
  Int l, i;
  res = NEW_PLIST(T_PLIST, 1);
  SET_LEN_PLIST(res, 0);
  for (l=1, i=0; i<LENmmaskbits; i++) {
    if (mask & mmaskbits[i]) {AssPlist(res, l, INTOBJ_INT(i)); l++;}
  }
  return res;
}
mmask_t mmaskIntlist(Obj list) {
  mmask_t res = (mmask_t)0;
  Int l, i, n;
  while (! IS_PLIST(list)) {
    list = ErrorReturnObj("<list> must be a plain list of integers, not a %s)",
                 (Int)TNAM_OBJ(list), 0L, 
                 "you can replace <list> via 'return <list>;'" );
  }
  l = LEN_PLIST(list);
  for (i = 0; i<l; i++) {
    n = INT_INTOBJ(ELM_PLIST(list, i+1));
    if (n >= 0 && n < LENmmaskbits) {res += mmaskbits[n];}
  }
  return res;
}

Obj Mousemask(Obj self, Obj list) {
  mmask_t  new, old;
  Obj res;
  while (! IS_PLIST(list)) {
    list = ErrorReturnObj("<list> must be a plain list of integers, not a %s)",
                 (Int)TNAM_OBJ(list), 0L, 
                 "you can replace <list> via 'return <list>;'" );
  }
  new = mmaskIntlist(list);
  new = mousemask(new, &old);
  res = NEW_PREC(0);
  AssPRec(res, RNamName("new"), IntlistMmask_t(new));
  AssPRec(res, RNamName("old"), IntlistMmask_t(old));
  return res;
}

static MEVENT mev;

Obj GetMouse(Obj self) {
  int y, x;
  Obj res, mask;
  if (getmouse(&mev) == ERR) return Fail;
  mask = IntlistMmask_t(mev.bstate);
  y = mev.y;
  x = mev.x;
  /* find panels/windows from above under mouse event */
  res = NEW_PLIST(T_PLIST, 3);
  SET_LEN_PLIST(res, 3);
  SET_ELM_PLIST(res, 1, INTOBJ_INT(y));
  SET_ELM_PLIST(res, 2, INTOBJ_INT(x));
  SET_ELM_PLIST(res, 3, mask);
  return res;
}

Obj Wenclose(Obj self, Obj wnum, Obj iy, Obj ix) {
  WINDOW *win;
  int y, x;
  win = winnum(wnum);
  if (win == NULL) return False;
  if (! IS_INTOBJ(iy)) return False;
  else y = INT_INTOBJ(iy);
  if (! IS_INTOBJ(ix)) return False;
  else x = INT_INTOBJ(ix);
  if (wenclose(win, y, x) == TRUE) return True;
  else return False;
}

Obj Mouseinterval( Obj len) {
  if (! IS_INTOBJ(len)) return INTOBJ_INT(mouseinterval(200));
  return INTOBJ_INT(mouseinterval(INT_INTOBJ(len)));
}


#endif


/*F * * * * * * * * * * * initialize package * * * * * * * * * * * * * * * */



/****************************************************************************
**

*V  GVarFilts . . . . . . . . . . . . . . . . . . . list of filters to export
*/
/*static StructGVarFilt GVarFilts [] = {

    { "IS_BOOL", "obj", &IsBoolFilt,
      IsBoolHandler, "src/bool.c:IS_BOOL" },

    { 0 }

};   ?????*/

/****************************************************************************
**

*V  GVarFuncs . . . . . . . . . . . . . . . . . . list of functions to export
*/
static StructGVarFunc GVarFuncs [] = {

  /* XXX  { "attrsetdefault", 0, "", Attrsetdefault, "ncurses.c:Attrsetdefault" }, */
    { "ClearAll", 0, "", ClearAll, "ncurses.c:ClearAll" },
    { "cbreak", 0, "", Cbreak, "ncurses.c:Cbreak" },
    { "nocbreak", 0, "", Nocbreak, "ncurses.c:Nocbreak" },
    { "echo", 0, "", Echo, "ncurses.c:Echo" },
    { "noecho", 0, "", Noecho, "ncurses.c:Noecho" },
    { "intrflush", 2, "win, bool", Intrflush, "ncurses.c:Intrflush" },
    { "keypad", 2, "win, bool", Keypad, "ncurses.c:Keypad" },
    { "idlok", 2, "win, bool", Idlok, "ncurses.c:Idlok" },
    { "leaveok", 2, "win, bool", Leaveok, "ncurses.c:Leaveok" },
    { "scrollok", 2, "win, bool", Scrollok, "ncurses.c:Scrollok" },
    { "clearok", 2, "win, bool", Clearok, "ncurses.c:Clearok" },
    { "immedok", 2, "win, bool", Immedok, "ncurses.c:Immedok" },
    { "raw", 0, "", Raw, "ncurses.c:Raw" },
    { "noraw", 0, "", Noraw, "ncurses.c:Noraw" },
    { "nl", 0, "", Nl, "ncurses.c:Nl" },
    { "nonl", 0, "", Nonl, "ncurses.c:Nonl" },
    { "curs_set", 1, "vis", Curs_set, "ncurses.c:Curs_set" },
    { "ResetCursor", 0, "", ResetCursor, "ncurses.c:ResetCursor" },
    { "wtimeout", 2, "win, time", WTimeout, "ncurses.c:WTimeout" },
    { "IsStdinATty", 0, "", IsStdinATty, "ncurses.c:IsStdinATty" },
    { "IsStdoutATty", 0, "", IsStdoutATty, "ncurses.c:IsStdoutATty" },
    { "savetty", 0, "", Savetty, "ncurses.c:Savetty" },
    { "resetty", 0, "", Resetty, "ncurses.c:Resetty" },
    { "napms", 1, "time", Napms, "ncurses.c:Napms" },
    { "doupdate", 0, "", Doupdate, "ncurses.c:Doupdate" },
    { "wrefresh", 1, "win", WRefresh, "ncurses.c:WRefresh" },
    { "wclear", 1, "win", WClear, "ncurses.c:WClear" },
    { "werase", 1, "win", WErase, "ncurses.c:WErase" },
    { "wclrtoeol", 1, "win", WClrtoeol, "ncurses.c:WClrtoeol" },
    { "wclrtobot", 1, "win", WClrtobot, "ncurses.c:WClrtobot" },
    { "endwin", 0, "", Endwin, "ncurses.c:Endwin" },
    { "isendwin", 0, "", Isendwin, "ncurses.c:Isendwin" },
    { "newwin", 4, "nlines, ncols, begin_y, begin_x", 
         Newwin, "ncurses.c:Newwin" },
    { "delwin", 1, "win", Delwin, "ncurses.c:Delwin" },
    { "mvwin", 3, "win, y, x", Mvwin, "ncurses.c:Mvwin" },
    { "wmove", 3, "win, y, x", WMove, "ncurses.c:WMove" },
    { "waddnstr", 3, "win, str, len", WAddnstr, "ncurses.c:WAddnstr" },
    { "waddch", 2, "win, ch", WAddch, "ncurses.c:WAddch" },
#ifdef WIDECHARS    
    { "wecho_wchar", 2, "win, ch", WAddwch, "ncurses.c:WAddwch" },
#endif
    { "wborder", 2, "win, chars", WBorder, "ncurses.c:WBorder" },
    { "wvline", 3, "win, ch, n", WVline, "ncurses.c:WVline" },
    { "whline", 3, "win, ch, n", WHline, "ncurses.c:WHline" },
    { "winch", 1, "win", WInch, "ncurses.c:WInch" },
    { "wgetch", 1, "win", WGetch, "ncurses.c:WGetch" },
    { "ungetch", 1, "ch", Ungetch, "ncurses.c:Ungetch" },
    { "has_key", 1, "ch", Has_key, "ncurses.c:Has_key" },
    { "getyx", 1, "win", Getyx, "ncurses.c:Getyx" },
    { "getbegyx", 1, "win", Getbegyx, "ncurses.c:Getbegyx" },
    { "getmaxyx", 1, "win", Getmaxyx, "ncurses.c:Getmaxyx" },
    { "wattr_get", 1, "win", WAttrCPGet, "ncurses.c:WAttrCPGet" },
    { "wattrset", 2, "win, attr", WAttrset, "ncurses.c:WAttrset" },
    { "wattron", 2, "win, attr", WAttron, "ncurses.c:WAttron" },
    { "wattroff", 2, "win, attr", WAttroff, "ncurses.c:WAttroff" },
    { "wbkgdset", 2, "win, attr", WBkgdset, "ncurses.c:WBkgdset" },
    { "wbkgd", 2, "win, attr", WBkgd, "ncurses.c:WBkgd" },
    { "new_panel", 1, "win", New_panel, "ncurses.c:New_panel" },
    { "update_panels", 0, "", Update_panels, "ncurses.c:Update_panels" },
    { "bottom_panel", 1, "pan", Bottom_panel, "ncurses.c:Bottom_panel" },
    { "top_panel", 1, "pan", Top_panel, "ncurses.c:Top_panel" },
    { "show_panel", 1, "pan", Show_panel, "ncurses.c:Show_panel" },
    { "hide_panel", 1, "pan", Hide_panel, "ncurses.c:Hide_panel" },
    { "panel_above", 1, "pan", Panel_above, "ncurses.c:Panel_above" },
    { "panel_below", 1, "pan", Panel_below, "ncurses.c:Panel_below" },
    { "move_panel", 3, "pan, y, x", Move_panel, "ncurses.c:Move_panel" },
    { "del_panel", 1, "pan", Del_panel, "ncurses.c:Del_panel" },
#ifdef NCURSES_MOUSE_VERSION
    { "mousemask", 1, "list", Mousemask, "ncurses.c:Mousemask" },
    { "mouseinterval", 1, "len", Mouseinterval, "ncurses.c:Mouseinterval" },
    { "getmouse", 0, "", GetMouse, "ncurses.c:GetMouse" },
    { "wenclose", 3, "win, y, x", Wenclose, "ncurses.c:Wenclose" },
#endif

  { 0 }

};



/**************************************************************************

*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel (
    StructInitInfo *    module )
{

    /* return success                                                      */
    InitGlobalBag( &winlist, "src/ncurses.c:winlist" );
    InitGlobalBag( &panellist, "src/ncurses.c:panellist" );
    
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

    return 0;
}

/****************************************************************************
**
*F  PostRestore( <module> ) . . . . . . . . . . . . . after restore workspace
*/
static Int PostRestore (
    StructInitInfo *    module )
{
    Int             i, gvar;
    Obj             tmp, vers;
    char*           cvers = VERSION;

    /* setup and initialize the ncurses package */
    winlist = NEW_STRING(sizeof(Obj));
    SET_LEN_STRING(winlist, sizeof(Obj));
    panellist = NEW_STRING(sizeof(Obj));
    SET_LEN_STRING(panellist, sizeof(Obj));

#ifdef WIDECHARS
    /* set locale from environment */
    setlocale(LC_ALL,"");
#endif

    /* make sure that TERM is set to avoid exit by initscr */
    if (getenv("TERM") == NULL)
      putenv("TERM=vt102");

    /* init filters and functions 
       we assign the functions to components of a record "NCurses"         */
    /* (re)build kernel part of NCurses   */
    gvar = GVarName("NCurses");
    tmp = VAL_GVAR(gvar);
    if (!tmp) {
      tmp = NEW_PREC(0);
    }

    if (! isatty(1)) 
       putenv("TERM=dumb");
    /* initialize ncurses */
    ((WINDOW**)CHARS_STRING(winlist))[0] = initscr();
    ((PANEL**)CHARS_STRING(panellist))[0] = 0;
    endwin();
    
    for ( i = 0;  GVarFuncs[i].name != 0;  i++ ) {
      AssPRec(tmp, RNamName((Char*)GVarFuncs[i].name), 
              NewFunctionC( GVarFuncs[i].name, GVarFuncs[i].nargs, 
                 GVarFuncs[i].args, GVarFuncs[i].handler ) );
    }
    AssPRec(tmp, RNamName("keys"), InitKeys() );
    AssPRec(tmp, RNamName("attrs"), InitAttrs() );
    AssPRec(tmp, RNamName("lineDraw"), InitLineDraw() );
    AssPRec(tmp, RNamName("winlist"), winlist);
    AssPRec(tmp, RNamName("panellist"), panellist);
    vers = NEW_STRING(strlen(cvers));
    memcpy(CHARS_STRING(vers), cvers, strlen(cvers));
    AssPRec(tmp, RNamName("KernelModuleVersion"), vers);
    
    /* (re)assign   */
    MakeReadWriteGVar( gvar);
    AssGVar( gvar, tmp );
    MakeReadOnlyGVar(gvar);

    /* find and save cursor visibility */
    for(i = 0; default_curs_vis == ERR && i < 3; i++) {
      default_curs_vis = curs_set(i);
    }
    if (default_curs_vis != ERR)
      curs_set(default_curs_vis);

    /* return success                                                      */
    return 0;
}

/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary (
    StructInitInfo *    module )
{
    PostRestore( module );

    /* return success                                                      */
    return 0;
}


/****************************************************************************
**
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
/* <name> returns the description of this module */
static StructInitInfo module = {
#ifdef NCURSESSTATIC
 /* type        = */ MODULE_STATIC,
#else
 /* type        = */ MODULE_DYNAMIC,
#endif
 /* name        = */ "ncurses",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ PostRestore
};

#ifndef NCURSESSTATIC
StructInitInfo * Init__Dynamic ( void )
{
 return &module;
}
#endif

StructInitInfo * Init__ncurses ( void )
{
  return &module;
}

