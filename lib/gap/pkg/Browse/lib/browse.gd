#############################################################################
##
#W  browse.gd             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#V  BrowseData
##
##  <#GAPDoc Label="BrowseData_man">
##  <ManSection>
##  <Var Name="BrowseData"/>
##
##  <Description>
##  This is the record that contains the global data used by the function
##  <Ref Func="NCurses.BrowseGeneric"/>.
##  The components are <C>actions</C>, <C>defaults</C>,
##  and several capitalized names for which the values are functions.
##  <P/>
##  <C>BrowseData.actions</C> is a record containing the action records that
##  are provided by the package,
##  see Section&nbsp;<Ref Subsect="sec:actions"/>.
##  These actions are used in standard applications of
##  <Ref Func="NCurses.BrowseGeneric"/>.
##  Of course there is no problem with using actions that are not stored in
##  <C>BrowseData.actions</C>.
##  <P/>
##  <C>BrowseData.defaults</C> is a record that contains the defaults for
##  the browse table used as the first argument of
##  <Ref Func="NCurses.BrowseGeneric"/>.
##  Important components have been described above,
##  see&nbsp;<Ref Func="BrowseData.IsBrowseTable"/>,
##  in the sense that these components provide default values of <C>work</C>
##  components in browse tables.
##  Here is a list of further interesting components.
##  <P/>
##  The following components are provided in
##  <C>BrowseData.defaults.work</C>.
##  <P/>
##  <List>
##  <Mark><C>windowParameters</C></Mark>
##  <Item>
##    is a list of four nonnegative integers, denoting the arguments of
##    <C>NCurses.newwin</C> for the window in which the browse table shall be
##    shown.
##    The default is <C>[ 0, 0, 0, 0 ]</C>, i.&nbsp;e.,
##    the window for the browse table is the full screen.
##  </Item>
##  <Mark><C>minyx</C></Mark>
##  <Item>
##    is a list of length two, the entries must be either nonnegative
##    integers, denoting the minimal number of rows and columns that are
##    required by the browse table, or unary functions that return these
##    values when they are applied to the browse table;
##    this is interesting for applications that do not support scrolling,
##    or for applications that may have large row or column labels tables.
##    The default is a list with two functions, the return value of the
##    first function is the sum of the heights of the table header,
##    the column labels table, the first table row, and the table footer,
##    and the return value of the second function is the sum of widths of the
##    row labels table and the width of the first column.
##    (If the header/footer is given by a function then this part of the
##    table is ignored in the <C>minyx</C> default.)
##    Note that the conditions are checked only when
##    <Ref Func="NCurses.BrowseGeneric"/> is called, not after later changes
##    of the screen size in a running browse table application.
##  </Item>
##  <Mark><C>align</C></Mark>
##  <Item>
##    is a substring of <C>"bclt"</C>, which describes the alignment of the
##    browse table in the window.
##    The meaning and the default are the same as for
##    <Ref Func="BrowseData.IsBrowseTableCellData"/>.
##    (Of course this is relevant only if the table is smaller than the
##    window.)
##  </Item>
##  <Mark><C>headerLength</C></Mark>
##  <Item>
##    describes the lengths of the headers in the modes for which
##    <C>header</C> functions are provided.
##    The value is a record whose component names are names of modes
##    and the corresponding components are nonnegative integers.
##    This component is ignored if the <C>header</C> component is unbound
##    or bound to a list,
##    missing values are computed by calls to the corresponding
##    <C>header</C> function as soon as they are needed.
##  </Item>
##  <Mark><C>footerLength</C></Mark>
##  <Item>
##    corresponds to <C>footer</C> in the same way as <C>headerLength</C>
##    to <C>header</C>.
##  </Item>
##  <Mark><C>Main</C></Mark>
##  <Item>
##    if bound to a function then this function can be used to compute
##    missing values for the component <C>main</C>;
##    this way one can avoid computing/storing all <C>main</C> values at the
##    same time.
##    The access to the entries of the main matrix is defined as follows:
##    If <C>mainFormatted[i][j]</C> is bound then take it,
##    if <C>main[i][j]</C> is bound then take it and compute the formatted
##    version,
##    if <C>Main</C> is a function then call it with arguments
##    the browse table, <C>i</C>, and <C>j</C>,
##    and compute the formatted version,
##    otherwise compute the formatted version of <C>work.emptyCell</C>.
##    (For the condition whether entries in <C>mainFormatted</C> can be
##    bound, see below in the description of the component
##    <C>cacheEntries</C>.)
##  </Item>
##  <Mark><C>cacheEntries</C></Mark>
##  <Item>
##    describes whether formatted values of the entries in the matrices
##    given by the components <C>corner</C>, <C>labelsCol</C>,
##    <C>labelsRow</C>, <C>main</C>,
##    and of the corresponding row and column separators shall be stored
##    in the components <C>cornerFormatted</C>, <C>labelsColFormatted</C>,
##    <C>labelsRowFormatted</C>, and <C>mainFormatted</C>.
##    The value must be a Boolean, the default is <K>false</K>;
##    it should be set to <K>true</K> only if the tables are reasonably small.
##  </Item>
##  <Mark><C>cornerFormatted</C></Mark>
##  <Item>
##    is a list of lists of formatted entries corresponding to the
##    <C>corner</C> component.
##    Each entry is either an attribute line or a list of attribute lines
##    (with the same number of displayed characters),
##    the values can be computed from the input format with
##    <C>BrowseData.FormattedEntry</C>.
##    <Index Key="BrowseData.FormattedEntry">
##    <C>BrowseData.FormattedEntry</C></Index>
##    The entries are stored in this component only if the component
##    <C>cacheEntries</C> has the value <K>true</K>.
##    The default is an empty list.
##  </Item>
##  <Mark><C>labelsColFormatted</C></Mark>
##  <Item>
##    corresponds to <C>labelsCol</C> in the same way as
##    <C>cornerFormatted</C> to <C>corner</C>.
##  </Item>
##  <Mark><C>labelsRowFormatted</C></Mark>
##  <Item>
##    corresponds to <C>labelsRow</C> in the same way as
##    <C>cornerFormatted</C> to <C>corner</C>.
##  </Item>
##  <Mark><C>mainFormatted</C></Mark>
##  <Item>
##    corresponds to <C>main</C> in the same way as
##    <C>cornerFormatted</C> to <C>corner</C>.
##  </Item>
##  <Mark><C>m0</C></Mark>
##  <Item>
##    is the maximal number of rows in the column labels table.
##    If this value is not bound then it is computed from the components
##    <C>corner</C> and <C>labelsCol</C>.
##  </Item>
##  <Mark><C>n0</C></Mark>
##  <Item>
##    is the maximal number of columns in <C>corner</C> and <C>labelsRow</C>.
##  </Item>
##  <Mark><C>m</C></Mark>
##  <Item>
##    is the maximal number of rows in <C>labelsRow</C> and <C>main</C>.
##    This value <E>must</E> be set in advance if the values of <C>main</C>
##    are computed using a <C>Main</C> function, and if the number of rows
##    in <C>main</C> is larger than that in <C>labelsRow</C>.
##  </Item>
##  <Mark><C>n</C></Mark>
##  <Item>
##    is the maximal number of columns in <C>labelsCol</C> and <C>main</C>.
##    This value <E>must</E> be set in advance if the values of <C>main</C>
##    are computed using a <C>Main</C> function, and if the number of columns
##    in <C>main</C> is larger than that in <C>labelsCol</C>.
##  </Item>
##  <Mark><C>heightLabelsCol</C></Mark>
##  <Item>
##    is a list of <M>2</M> <C>m0</C><M> + 1</M> nonnegative integers,
##    the entry at position <M>i</M> is the maximal height of the entries
##    in the <M>i</M>-th row of <C>cornerFormatted</C> and
##    <C>labelsColFormatted</C>.
##    Values that are not bound are computed on demand from the table
##    entries, with the function <C>BrowseData.HeightLabelsCol</C>.
##    <Index Key="BrowseData.HeightLabelsCol">
##    <C>BrowseData.HeightLabelsCol</C></Index>
##    (So if one knows the needed heights in advance, it is advisable to
##    set the values, in order to avoid that formatted table entries are
##    computed just for computing their size.)
##    The default is an empty list.
##  </Item>
##  <Mark><C>widthLabelsRow</C></Mark>
##  <Item>
##    is the corresponding list of <M>2</M> <C>n0</C><M> + 1</M>
##    maximal widths of entries in <C>cornerFormatted</C> and
##    <C>labelsRowFormatted</C>.
##  </Item>
##  <Mark><C>heightRow</C></Mark>
##  <Item>
##    is the corresponding list of <M>2</M> <C>m</C><M> + 1</M>
##    maximal heights of entries in <C>labelsRowFormatted</C> and
##    <C>mainFormatted</C>.
##  </Item>
##  <Mark><C>widthCol</C></Mark>
##  <Item>
##    is the corresponding list of <M>2</M> <C>n</C><M> + 1</M>
##    maximal widths of entries in <C>labelsColFormatted</C> and
##    <C>mainFormatted</C>.
##  </Item>
##  <Mark><C>emptyCell</C></Mark>
##  <Item>
##    is a table cell data object to be used as the default for unbound
##    positions in the four matrices.
##    The default is the empty list.
##  </Item>
##  <Mark><C>sepCategories</C></Mark>
##  <Item>
##    is an attribute line to be used repeatedly as a separator
##    below expanded category rows.
##    The default is the string <C>"-"</C>.
##  </Item>
##  <Mark><C>startCollapsedCategory</C></Mark>
##  <Item>
##    is a list of attribute lines to be used as prefixes of unhidden but
##    collapsed category rows.
##    For category rows of level <M>i</M>, the last bound entry before the
##    <M>(i+1)</M>-th position is used.
##    The default is a list of length one, the entry is the boldface
##    variant of the string <C>"> "</C>,
##    so collapsed category rows on different levels are treated equally.
##  </Item>
##  <Mark><C>startExpandedCategory</C></Mark>
##  <Item>
##    is a list of attribute lines to be used as prefixes of expanded
##    category rows, analogously to <C>startCollapsedCategory</C>.
##    The default is a list of length one, the entry is the boldface
##    variant of the string <C>"* "</C>,
##    so expanded category rows on different levels are treated equally.
##  </Item>
##  <Mark><C>startSelect</C></Mark>
##  <Item>
##    is an attribute line to be used as a prefix of each attribute line that
##    belongs to a selected cell.
##    The default is to switch the attribute <C>NCurses.attrs.STANDOUT</C>
##    on, see Section&nbsp;<Ref Subsect="ssec:ncursesAttrs"/>.
##  </Item>
##  <Mark><C>Click</C></Mark>
##  <Item>
##    is a record whose component names are names of available modes
##    of the browse table.
##    The values are unary functions that take the browse table as their
##    argument.
##    If the action <C>Click</C> is available in the current mode and the
##    corresponding input is entered then the function in the relevant
##    component of the <C>Click</C> record is called.
##  </Item>
##  <Mark><C>availableModes</C></Mark>
##  <Item>
##    is a list whose entries are the mode records that can be used when
##    one navigates through the browse table,
##    see Section <Ref Sect="sec:modes"/>.
##  </Item>
##  <Mark><C>SpecialGrid</C></Mark>
##  <Item>
##    is a function that takes a browse table and a record as its arguments.
##    It is called by <C>BrowseData.ShowTables</C> after the current contents
##    of the window has been computed,
##    and it is intended to draw an individual grid into the table that fits
##    better than anything that can be specified in terms of row and column
##    separators.
##    (If other functions than <C>BrowseData.ShowTables</C> are used in some
##    modes of the browse table, these functions must deal with this aspect
##    themselves.)
##    The default is to do nothing.
##  </Item>
##  </List>
##  <!-- #T component CategoryValues? -->
##
##  The following components are provided in
##  <C>BrowseData.defaults.dynamic</C>.
##
##  <List>
##  <Mark><C>changed</C></Mark>
##  <Item>
##    is a Boolean that must be set to <K>true</K> by action functions
##    whenever a refresh of the window is necessary;
##    it is automatically reset to <K>false</K> after the refresh.
##  </Item>
##  <Mark><C>indexRow</C></Mark>
##  <Item>
##    is a list of positive integers.
##    The entry <M>k</M> at position <M>i</M> means that the <M>k</M>-th row
##    in the <C>mainFormatted</C> table is shown as the <M>i</M>-th row.
##    Note that depending on the current status of the browse table,
##    the rows of <C>mainFormatted</C> (and of <C>main</C>) may be permuted,
##    or it may even happen that a row in <C>mainFormatted</C> is shown
##    several times, for example under different category rows.
##    It is assumed (as a <Q>sort convention</Q>)
##    <Index>sort convention</Index>
##    that the <E>even</E> positions in <C>indexRow</C> point
##    to <E>even</E> numbers, and that the subsequent <E>odd</E> positions
##    (corresponding to the following separators) point to the subsequent
##    <E>odd</E> numbers.
##    The default value is the list <M>[ 1, 2, \ldots, m ]</M>,
##    where <M>m</M> is the number of rows in <C>mainFormatted</C>
##    (including the separator rows, so <M>m</M> is always odd).
##  </Item>
##  <Mark><C>indexCol</C></Mark>
##  <Item>
##    is the analogous list of positive integers that refers to columns.
##  </Item>
##  <Mark><C>topleft</C></Mark>
##  <Item>
##    is a list of four positive integers denoting the current topleft
##    position of the main table.
##    The value <M>[ i, j, k, l ]</M> means that the topleft entry is indexed
##    by the <M>i</M>-th entry in <C>indexRow</C>,
##    the <M>j</M>-th entry in <C>indexCol</C>,
##    and the <M>k</M>-th row and <M>l</M>-th column inside the corresponding
##    cell.
##    The default is <M>[ 1, 1, 1, 1 ]</M>.
##  </Item>
##  <Mark><C>isCollapsedRow</C></Mark>
##  <Item>
##    is a list of Booleans, of the same length as the <C>indexRow</C> value.
##    If the entry at position <M>i</M> is <K>true</K> then the <M>i</M>-th
##    row is currently not shown because it belongs to a collapsed category
##    row.
##    It is assumed (as a <Q>hide convention</Q>)
##    <Index>hide convention</Index>
##    that the value at any even position equals the value at the subsequent
##    odd position.
##    The default is that all entries are <K>false</K>.
##  </Item>
##  <Mark><C>isCollapsedCol</C></Mark>
##  <Item>
##    is the corresponding list for <C>indexCol</C>.
##  </Item>
##  <Mark><C>isRejectedRow</C></Mark>
##  <Item>
##    is a list of Booleans.
##    If the entry at position <M>i</M> is <K>true</K> then the <M>i</M>-th
##    row is currently not shown because it does not match the current
##    filtering of the table.
##    Defaults, length, and hide convention are as for <C>isCollapsedRow</C>.
##  </Item>
##  <Mark><C>isRejectedCol</C></Mark>
##  <Item>
##    is the corresponding list for <C>indexCol</C>.
##  </Item>
##  <Mark><C>isRejectedLabelsRow</C></Mark>
##  <Item>
##    is a list of Booleans.
##    If the entry at position <M>i</M> is <K>true</K> then the <M>i</M>-th
##    column of row labels is currently not shown.
##  </Item>
##  <Mark><C>isRejectedLabelsCol</C></Mark>
##  <Item>
##    is the corresponding list for the column labels.
##  </Item>
##  <Mark><C>activeModes</C></Mark>
##  <Item>
##    is a list of mode records that are contained in the
##    <C>availableModes</C> list of the <C>work</C> component
##    of the browse table.
##    The current mode is the last entry in this list.
##    The default depends on the application,
##    <C>BrowseData.defaults</C> prescribes the list containing only the mode
##    with <C>name</C> component <C>"browse"</C>.
##  </Item>
##  <Mark><C>selectedEntry</C></Mark>
##  <Item>
##    is a list <M>[ i, j ]</M>.
##    If <M>i = j = 0</M> then no table cell is selected,
##    otherwise <M>i</M> and <M>j</M> are the row and column index of the
##    selected cell.
##    (Note that <M>i</M> and <M>j</M> are always even.)
##    The default is <M>[ 0, 0 ]</M>.
##  </Item>
##  <Mark><C>selectedCategory</C></Mark>
##  <Item>
##    is a list <M>[ i, l ]</M>.
##    If <M>i = l = 0</M> then no category row is selected,
##    otherwise <M>i</M> and <M>l</M> are the row index and the level of the
##    selected category row.
##    (Note that <M>i</M> is always even.)
##    The default is <M>[ 0, 0 ]</M>.
##  </Item>
##  <Mark><C>searchString</C></Mark>
##  <Item>
##    is the last string for which the user has searched in the table.
##    The default is the empty string.
##  </Item>
##  <Mark><C>searchParameters</C></Mark>
##  <Item>
##    is a list of parameters that are modified by the function
##    <C>BrowseData.SearchStringWithStartParameters</C>.
##    <Index Key="SearchStringWithStartParameters">
##    <C>SearchStringWithStartParameters</C></Index>
##    If one sets these parameters in a search then these values hold also
##    for subsequent searches.
##    So it may make sense to set the parameters to personally preferred
##    ones.
##  </Item>
##  <Mark><C>sortFunctionForColumnsDefault</C></Mark>
##  <Item>
##    is a function with two arguments used to compare two entries in the
##    same column of the main table (or two category row values).
##    The default is the operation <C>\&lt;</C>.
##    (Note that this default may be not meaningful if some of the rows or
##    columns contain strings representing numbers.)
##  </Item>
##  <Mark><C>sortFunctionForRowsDefault</C></Mark>
##  <Item>
##    is the analogous function for comparing two entries in the same row of
##    the main table.
##  </Item>
##  <Mark><C>sortFunctionsForRows</C></Mark>
##  <Item>
##    is a list of comparison functions, if the <M>i</M>-th entry is bound
##    then it replaces the <C>sortFunctionForRowsDefault</C> value when the
##    table is sorted w.r.t. the <M>i</M>-th row.
##  </Item>
##  <Mark><C>sortFunctionsForColumns</C></Mark>
##  <Item>
##    is the analogous list of functions for the case that the table is
##    sorted w.r.t. columns.
##  </Item>
##  <Mark><C>sortParametersForRowsDefault</C></Mark>
##  <Item>
##    is a list of parameters for sorting the main table w.r.t. entries in
##    given rows, e.&nbsp;g., whether one wants to sort ascending or
##    descending.
##  </Item>
##  <Mark><C>sortParametersForColumnsDefault</C></Mark>
##  <Item>
##    is the analogous list of parameters for sorting w.r.t. given columns.
##    In addition to the parameters for rows, also parameters concerning
##    category rows are available, e.&nbsp;g., whether the data columns that
##    are transformed into category rows shall be hidden afterwards or not.
##  </Item>
##  <Mark><C>sortParametersForRows</C></Mark>
##  <Item>
##    is a list that contains ar position <M>i</M>, if bound, a list of
##    parameters that shall replace those in
##    <C>sortParametersForRowsDefault</C> when the table is sorted w.r.t.
##    the <M>i</M>-th row.
##  </Item>
##  <Mark><C>sortParametersForColumns</C></Mark>
##  <Item>
##    is the analogous list of parameters lists for sorting w.r.t. columns.
##  </Item>
##  <Mark><C>categories</C></Mark>
##  <Item>
##    describes the current category rows.
##    The value is a list <M>[ l_1, l_2, l_3 ]</M> where <M>l_1</M> is a
##    <E>sorted</E> list <M>[ i_1, i_2, ..., i_k ]</M> of positive integers,
##    <M>l_2</M> is a list of length <M>k</M> where the <M>j</M>-th entry
##    is a record with the components <C>pos</C> (with value <M>i_j</M>),
##    <C>level</C> (the level of the category row),
##    <C>value</C> (an attribute line to be shown),
##    <C>separator</C> (the separator below this category row is a repetition
##    of this string),
##    <C>isUnderCollapsedCategory</C> (<K>true</K> if the category row is
##    hidden because a category row of an outer level is collapsed; note that
##    in the <K>false</K> case, the category row itself can be collapsed),
##    <C>isRejectedCategory</C> (<K>true</K> if the category row is hidden
##    because none of th edata rows below this category match the current
##    filtering of the table);
##    the list <M>l_3</M> contains the levels for which the category rows
##    shall include the numbers of data rows under these category rows.
##    The default value is <C>[ [], [], [] ]</C>.
##    (Note that this <Q>hide convention</Q><Index>hide convention</Index>
##    makes sense mainly if together with a hidden category row,
##    also the category rows on higher levels
##    and the corresponding data rows are hidden
##    &ndash;but this property is <E>not</E> checked.)
##    Category rows are computed with the <C>CategoryValues</C> function
##    in the <C>work</C> component of the browse table.
##  </Item>
##  <Mark><C>log</C></Mark>
##  <Item>
##    describes the session log which is currently written.
##    The value is a list of positive integers, representing the user inputs
##    in the current session.
##    When &GAP; returns from a call to <Ref Func="NCurses.BrowseGeneric"/>,
##    one can access the log list of the user interactions in
##    the browse table as the value of its component <C>dynamic.log</C>.
##    <P/>
##    If <C>BrowseData.logStore</C>
##    <Index Key="BrowseData.logStore"><C>BrowseData.logStore</C></Index>
##    had been set to <K>true</K> before
##    <Ref Func="NCurses.BrowseGeneric"/> had been called then the list can
##    also be accessed as the value of <C>BrowseData.log</C>.
##    <Index Key="BrowseData.log"><C>BrowseData.log</C></Index>
##    If <C>BrowseData.logStore</C> is unbound or has a value different
##    from <K>true</K> then <C>BrowseData.log</C> is not written.
##    (This can be interesting in the case of browse table applications
##    where the user does not get access to the browse table itself.)
##  </Item>
##  <Mark><C>replay</C></Mark>
##  <Item>
##    describes the non-interactive input for the current browse table.
##    The value is a record with the components <C>logs</C> (a dense list of
##    records, the default is an empty list) and <C>pointer</C> (a positive
##    integer, the default is <M>1</M>).
##    If <C>pointer</C> is a position in <C>logs</C> then currently the
##    <C>pointer</C>-th record is processed, otherwise the browse table has
##    exhausted its non-interactive part, and requires interactive input.
##    The records in <C>log</C> have the components
##    <C>steps</C> (a list of user inputs, the default is an empty list),
##    <C>position</C> (a positive integer denoting the current position in
##    the <C>steps</C> list if the log is currently processed,
##    the default is <M>1</M>),
##    <C>replayInterval</C> (the timeout between two steps in milliseconds if
##    the log is processed, the default is <M>0</M>), and
##    <C>quiet</C> (a Boolean, <K>true</K> if the steps shall not be shown on
##    the screen until the end of the log is reached,
##    the default is <K>false</K>).
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "BrowseData", rec() );


#############################################################################
##
#O  Browse( <obj>[, <arec>] )
##
##  <#GAPDoc Label="Browse_oper_man">
##  <ManSection>
##  <Oper Name="Browse" Arg="obj[, arec]"/>
##
##  <Description>
##  This operation displays the &GAP; object <A>obj</A> in a nice, formatted
##  way, similar to the operation <Ref Oper="Display" BookName="ref"/>.
##  The difference is that <Ref Oper="Browse"/> is intended to use
##  <C>ncurses</C> facilities.
##  <P/>
##  Currently there are methods for matrices
##  (see&nbsp;<Ref Meth="Browse" Label="for a list of lists"/>),
##  for character tables
##  (see&nbsp;<Ref Meth="Browse" Label="for character tables"/>)
##  and for tables of marks
##  (see&nbsp;<Ref Meth="Browse" Label="for tables of marks"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "Browse", [ IsObject ] );
DeclareOperation( "Browse", [ IsObject, IsRecord ] );


#############################################################################
##
#E

