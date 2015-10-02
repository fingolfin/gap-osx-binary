#############################################################################
##
#W  mouse.g                GAP 4 package `browse'                Frank Lübeck
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This demonstrates how to use mouse events in some terminals (xterm and
##  related). Can also be used to see the integers returned by keyboard
##  keys.
##  
NCurses.MouseDemo := function()
    local yx, hg, wd, tm, lm,
          win1, win2, win3, win4, win5, pan1, pan2, pan3, pan4, pan5,
          status, c, ev, s, a, origstatus, info;

    yx:= NCurses.getmaxyx( 0 );
    hg:=  5;
    wd:= 10;
    tm:= QuoInt( yx[1] - 4 * hg, 2 );
    lm:= QuoInt( yx[2] - 4 * wd, 2 );

    win1:= NCurses.newwin( 0, 0, 0, 0 );
    win2:= NCurses.newwin( 2 * hg + 1, 2 * wd + 1, tm + hg, lm );
    win3:= NCurses.newwin( 2 * hg + 1, 2 * wd + 1, tm, lm + wd );
    win4:= NCurses.newwin( 2 * hg + 1, 2 * wd + 1, tm + hg + 1, lm + 2 * wd );
    win5:= NCurses.newwin( 2 * hg + 1, 2 * wd + 1, tm + 2 * hg, lm + wd + 1 );

    pan1:= NCurses.new_panel( win1 );
    pan2:= NCurses.new_panel( win2 );
    pan3:= NCurses.new_panel( win3 );
    pan4:= NCurses.new_panel( win4 );
    pan5:= NCurses.new_panel( win5 );

    NCurses.wbkgd( win2, NCurses.ColorAttr( "white", "blue" ) );
    NCurses.wbkgd( win3, NCurses.ColorAttr( "black", "green" ) );
    NCurses.wbkgd( win4, NCurses.ColorAttr( "white", "red" ) );
    NCurses.wbkgd( win5, NCurses.ColorAttr( "black", "yellow" ) );

    NCurses.wmove( win2, 1, 2 );
    NCurses.waddstr( win2, String( win2 ) );
    NCurses.wmove( win3, 1, 2 * wd - 2 );
    NCurses.waddstr( win3, String( win3 ) );
    NCurses.wmove( win4, 2 * hg - 1, 2 * wd - 2 );
    NCurses.waddstr( win4, String( win4 ) );
    NCurses.wmove( win5, 2 * hg - 1, 2 );
    NCurses.waddstr( win5, String( win5 ) );

    NCurses.noecho();
    NCurses.keypad( 0, true );
    NCurses.curs_set( 0 );

    status:= NCurses.UseMouse(false);
    origstatus := status.old;
    s:= "";
    info := "('M' to change)";
    NCurses.PutLine(win1, 0, QuoInt(NCurses.getmaxyx(win1)[2], 2) - 6, 
                    "['q' to quit]");

    repeat

      NCurses.wmove( win1, 2, 2 );
      NCurses.wclrtoeol( win1 );
      NCurses.PutLine( win1, 2, 2, [NCurses.attrs.NORMAL, 
        "Catching mouse events: ", String(status.new), "  ", info] );
      NCurses.wmove( win1, 4, 0 );
      NCurses.wclrtoeol( win1 );
      NCurses.wmove( win1, 3, 2 );
      NCurses.wclrtoeol( win1 );
      NCurses.waddstr( win1, s );
      NCurses.update_panels();
      NCurses.doupdate();

      c:= NCurses.wgetch(0);
      if c = NCurses.keys.MOUSE then
        ev := NCurses.GetMouseEvent();
        s:= ["MOUSE event \"", ev[1].event, 
             "\" on panel windows in position (y, x):\n    "];
        for a in ev do
          Append(s, [String(a.win), " (", String(a.y), ", ",
                     String(a.x), "), "]);
        od;
        s := Concatenation(s); s := s{[1..Length(s)-2]};
        ev := Filtered(ev, a-> a.win in [win2, win3, win4, win5]);
        if Length(ev) > 0 then
          NCurses.top_panel(ev[Length(ev)].win);
        fi;
      elif c = IntChar( 'M' ) then
        if status.new <> false then
          status := NCurses.UseMouse( false );
        else
          status := NCurses.UseMouse( true );
        fi;
        s:= "Trying mouse status change";
        if status.new = status.old then
          info := "(No mouse support in this terminal.)";
        else
          info := "('M' to change)";
        fi;
      elif c = IntChar( 'N' ) then
        # try to enable only BUTTON2 events
        status := NCurses.mousemask( [ 5, 6, 7, 8, 9 ] );
        if Length(status.new) = 0  then
          status.new := false;
        fi;
        s := "Trying to enable BUTTON2 events only.";
        if status.new = false then
          info := "(no success)";
        fi;
      else
        s:= Concatenation( "Keyboard input character: ", String( c ) );
      fi;

    until c = IntChar( 'q' );

    # this is to avoid strange background in non-visual state
    NCurses.top_panel( win1 );
    NCurses.update_panels();
    NCurses.doupdate();
    NCurses.UseMouse( origstatus );
    NCurses.del_panel( pan5 );
    NCurses.del_panel( pan4 );
    NCurses.del_panel( pan3 );
    NCurses.del_panel( pan2 );
    NCurses.del_panel( pan1 );
    NCurses.delwin( win5 );
    NCurses.delwin( win4 );
    NCurses.delwin( win3 );
    NCurses.delwin( win2 );
    NCurses.delwin( win1 );
    NCurses.endwin();
end;

