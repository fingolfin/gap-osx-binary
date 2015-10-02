BindGlobal("IP_TikzDefaultOptionsForArraysOfIntegers",
        rec(
            ####colors & highlightenings####
            colors := ShuffledIP_colors,
            highlights := [[]],
                      #an array of integers (all the elements of each of the
                      #lists in the array is highlighted with a different
                      #color; in cases of elements that appear in more than
                      #one list a kind of gradient (made with 3 colors) is
                      #used for the background; the number may be printed with
                      #a fourth color and a fifth color may be used in the
                      #border. 
           shape_only := "false",
                      #an option to be used when only the shape is important
                      #when "true" is used, the nodes are empty; using a 
                      #symbol, for instance a "*", the nodes are filled 
                      #with this symbol 
           ####Tikz options####           
              ##matrix options
           colsep := "2", # column sep
           rowsep := "2", # row sep
              ##nodes options        
           cell_width := "30", # minimum width
           allow_adjust_cell_width := "10",
                      #the number of points per digit (to avoid discrepancies
                      # between the width of the cells when there are numbers
                      #with different number of digits to be printed)         
                      #When the user sets the option cell_width, then 
                      #allow_adjust_cell_width is automaticaly set to "false" 
           scale := "1", # scale
           inner_sep := "3", #inner sep
           line_width := "0", # line width
           line_color := "black", # draw (the color of the cell borders)
           #####other#####           
           other := [] 
                      #if non empty, the complete tikz code has to be written
                      #(it may be useful when several images are to be 
                      #produced - otherwise, changing the tikz code would 
                      #be enough)
                      # Example:
                      # other := ["\draw[postaction={draw,line width=1pt,red}] (-80pt,-8pt) rectangle (16pt,40pt);","\draw[postaction={draw,line width=1pt,blue}] (-16pt,8pt) rectangle (80pt,-40pt);"]; 
            ));

#####################################################################
## A possible preamble for a latex document, using preview
##
BindGlobal("IP_Preamble",
        Concatenation("\\documentclass{minimal}\n",
                "\\usepackage{amsmath}\n",
                "\\usepackage[active,tightpage]{preview}\n",
                "\\setlength\\PreviewBorder{1pt}\n",
                "\\usepackage{pgf}\n",
                "\\usepackage{tikz}\n",
                "\\usepgfmodule{plot}\n",
                "\\usepgflibrary{plothandlers}\n",
                "\\usetikzlibrary{shapes.geometric}\n",
                "\\usetikzlibrary{shadings}\n",
                "\\begin{document}\n",
                "\\begin{preview}\n"));
#########
## closing a latex document, using preview
BindGlobal("IP_Closing", "\\end{preview}\n\\end{document}"); 


#####################################################################
## the possibility of making drawings using dot is not optimized  
##
BindGlobal("DotIP_DefaultOptionsForArraysOfIntegers",
        rec(
            colors := #ColorsForViz, # requires viz to be loaded
                      ["red", "green", "blue", "cyan", "magenta", 
          "yellow", "black", "gray", "white", "darkgray", "lightgray", "brown", 
                       "lime", "olive", "orange", "pink", "purple", "teal", "violet"],
                      border := "1",
                      cellborder := "1",
                      cellspacing:="2",
                      cellpadding:="2",
                      bgcolor:="gray",
                      point_size := "12",
                      cell_width := "30",
                      allow_adjust_cell_width := "10",#the number of points per
                      #digit "false" is also a possible option 
                      highlights := [[]],#an array of
                      #integers (all the elements of each of the lists in the array
                      #is highlighted with a different color; in cases of elements
                      #that appear in more than one list are highlighted the
                      #background an the number -- the colors corresponding to the
                      #first two appearences are used)  
                      ));


