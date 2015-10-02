#############################################################################
##
#W  brdbattr.gd           GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the declarations for tools for database handling.
##  The GAP objects introduced for that are database id enumerators and
##  database attributes.
##


#############################################################################
##
#I  InfoDatabaseAttribute
##
DeclareInfoClass( "InfoDatabaseAttribute" );


#############################################################################
##
##  <#GAPDoc Label="subsect:dbidenum">
##  <Subsection Label="subsect:dbidenum">
##  <Heading>Database Id Enumerators</Heading>
##
##  A <E>database id enumerator</E> is a record <A>r</A> with at least
##  the following components.
##  <P/>
##  <List>
##  <Mark><C>identifiers</C></Mark>
##  <Item>
##    a list of <Q>identifiers</Q> of the database entries,
##    which provides a bijection with these entries,
##  </Item>
##  <Mark><C>entry</C></Mark>
##  <Item>
##    a function that takes <A>r</A> and an entry in the <C>identifiers</C>
##    list, and returns the corresponding database entry,
##  </Item>
##  <Mark><C>attributes</C></Mark>
##  <Item>
##    the record whose components are the database attribute records
##    (see Section <Ref Subsect="subsect:dbattr"/>) for <A>r</A>;
##    this components is automatically initialized when <A>r</A> is created
##    with <Ref Func="DatabaseIdEnumerator"/>;
##    database attributes can be entered with
##    <Ref Func="DatabaseAttributeAdd"/>.
##  </Item>
##  </List>
##  <P/>
##  If the <C>identifiers</C> list may change over the time (because the
##  database is extended or corrected) then the following components are
##  supported.
##  They are used by <Ref Func="DatabaseIdEnumeratorUpdate"/>.
##  <P/>
##  <List>
##  <Mark><C>version</C></Mark>
##  <Item>
##    a &GAP; object that describes the version of the <C>identifiers</C>
##    component, this can be for example a string describing the time of the
##    last change (this time need not coincide with the time of the last
##    update);
##    the default value (useful only for the case that the <C>identifiers</C>
##    component is never changed) is an empty string,
##  </Item>
##  <Mark><C>update</C></Mark>
##  <Item>
##    a function that takes <A>r</A> as its argument, replaces its
##    <C>identifiers</C> and <C>version</C> values by up-to-date versions
##    if necessary (for example by downloading the data),
##    and returns <K>true</K> or <K>false</K>, depending on whether the
##    update process was successful or not;
##    the default value is <Ref Func="ReturnTrue" BookName="ref"/>,
##  </Item>
##  </List>
##  <P/>
##  The following component is optional.
##  <P/>
##  <List>
##  <Mark><C>isSorted</C></Mark>
##  <Item>
##    <K>true</K> means that the <C>identifiers</C> list is sorted w.r.t.
##    &GAP;'s ordering <C>\&lt;</C>; the default is <K>false</K>.
##  </Item>
##  </List>
##  <P/>
##  The idea behind database id enumerator objects is that such an object
##  defines the set of data covered by database attributes
##  (see Section <Ref Subsect="subsect:dbattr"/>),
##  it provides the mapping between identifiers and the actual entries
##  of the database, and
##  it defines when precomputed data of database attributes are outdated.
##
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
##  <#GAPDoc Label="subsect:dbattr">
##  <Subsection Label="subsect:dbattr">
##  <Heading>Database Attributes</Heading>
##
##  A <E>database attribute</E> is a record <A>a</A> whose components
##  belong to the aspects of
##  <E>defining</E> the attribute,
##  <E>accessing</E> the attribute's data,
##  <E>computing</E> (and recomputing) data,
##  <E>storing</E> data on files, and
##  <E>checking</E> data.
##  (Additional parameters used for creating browse table columns from
##  database attributes
##  are described in Section <Ref Subsect="subsect:attr-browse-comp"/>.)
##  <P/>
##  The following components are <E>defining</E>,
##  except <C>description</C> they are mandatory.
##  <P/>
##  <List>
##  <Mark><C>idenumerator</C></Mark>
##  <Item>
##    the database id enumerator to which the attribute <A>a</A> is related,
##  </Item>
##  <Mark><C>identifier</C></Mark>
##  <Item>
##    a string that identifies <A>a</A> among all
##    database attributes for the underlying database id enumerator
##    (this is used  by <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>
##    and when the data of <A>a</A> are entered with
##    <Ref Func="DatabaseAttributeSetData"/>, for example when precomputed
##    values are read from a file),
##  </Item>
##  <Mark><C>description</C></Mark>
##  <Item>
##    a string that describes the attribute in human readable form
##    (currently just for convenience, the default is an empty string).
##  </Item>
##  </List>
##  <P/>
##  The following components are used for <E>accessing</E> data.
##  Except <C>type</C>, they are optional, but enough information must be
##  provided in order to make the database attribute meaningful.
##  If an individual <C>attributeValue</C> function is available then this
##  function decides what is needed;
##  for the default function <Ref Func="DatabaseAttributeValueDefault"/>,
##  at least one of the components <C>name</C>, <C>data</C>, <C>datafile</C>
##  must be bound (see <Ref Func="DatabaseAttributeValueDefault"/> for the
##  behaviour in this case).
##  <P/>
##  <List>
##  <Mark><C>type</C></Mark>
##  <Item>
##    one of the strings <C>"values"</C> or <C>"pairs"</C>;
##    the format of the component <C>data</C> is different for these cases,
##  </Item>
##  <Mark><C>name</C></Mark>
##  <Item>
##    if bound, a string that is the name of a &GAP; function
##    such that the database attribute encodes the values of this function
##    for the database entries;
##    besides the computation of attribute values on demand
##    (see <Ref Func="DatabaseAttributeValueDefault"/>),
##    this component can be used by selection functions such as
##    <Ref Func="OneCharacterTableName" BookName="CTblLib"/> or
##    <Ref Func="AllCharacterTableNames" BookName="CTblLib"/>,
##    which take &GAP; functions and prescribed return values as their
##    arguments
##    &ndash;of course these functions must then be prepared to deal with
##    database attributes.
##  </Item>
##  <Mark><C>data</C></Mark>
##  <Item>
##    if bound, the data for this attribute;
##    if the component <C>type</C> has the value <C>"values"</C> then
##    the value is a list, where the entry at position <A>i</A>, if bound,
##    belongs to the <A>i</A>-th entry of the <C>identifiers</C> list of
##    <C>idenumerator</C>;
##    if <C>type</C> is <C>"pairs"</C> then the value is a record
##    with the components <C>automatic</C> and <C>nonautomatic</C>,
##    and the values of these components are lists such that each entry is
##    a list of length two whose first entry occurs in the <C>identifiers</C>
##    list of <A>a</A><C>.idenumerator</C>
##    and whose second entry encodes the corresponding attribute value,
##  </Item>
##  <Mark><C>datafile</C></Mark>
##  <Item>
##    if bound, the absolute name of a file that contains the data for this
##    attribute,
##  </Item>
##  <Mark><C>attributeValue</C></Mark>
##  <Item>
##    a function that takes <A>a</A> and an
##    <C>identifiers</C> entry of its <C>idenumerator</C> value,
##    and returns the attribute value for this identifier;
##    typically this is <E>not</E> a table cell data object
##    that can be shown in a browse table,
##    cf. the <C>viewValue</C> component;
##    the default is <Ref Func="DatabaseAttributeValueDefault"/>
##    (Note that using individual <C>attributeValue</C> functions, one can
##    deal with database attributes independent of actually stored data,
##    for example without precomputed values, such that the values are
##    computed on demand and afterwards are cached.),
##  </Item>
##  <Mark><C>dataDefault</C></Mark>
##  <Item>
##    a &GAP; object that is regarded as the attribute value
##    for those database entries for which <C>data</C>, <C>datafile</C>,
##    and <C>name</C> do not provide values;
##    the default value is an empty string <C>""</C>,
##  </Item>
##  <Mark><C>eval</C></Mark>
##  <Item>
##    if this component is bound, the value is assumed to be a function
##    that takes <A>a</A> and a value from its
##    <C>data</C> component, and returns the actual attribute value;
##    this can be useful if one does not want to create all attribute values
##    in advance, because this would be space or time consuming;
##    another possible aspect of the <C>eval</C> component is that it may be
##    used to strip off comments that are perhaps contained in <C>data</C>
##    entries,
##  </Item>
##  <Mark><C>isSorted</C></Mark>
##  <Item>
##    if this component is bound to <K>true</K> and if <C>type</C> is
##    <C>"pairs"</C> then it is assumed that the two lists in the <C>data</C>
##    record of <A>a</A> are sorted w.r.t. &GAP;'s ordering <C>\&lt;</C>;
##    the default is <K>false</K>,
##  </Item>
##  </List>
##  <P/>
##  The following optional components are needed for <E>computing</E>
##  (or recomputing) data with <Ref Func="DatabaseAttributeCompute"/>.
##  This is useful mainly for databases which can change over the time.
##  <P/>
##  <List>
##  <Mark><C>version</C></Mark>
##  <Item>
##    the &GAP; object that is the <C>version</C> component of the
##    <C>idenumerator</C> component at the time when the stored data were
##    entered;
##    this value is used by <Ref Func="DatabaseIdEnumeratorUpdate"/>
##    for deciding whether the attribute values are outdated;
##    if <A>a</A><C>.datafile</C> is bound then it is assumed that the
##    <C>version</C> component is set when this file is read,
##    for example in the function <Ref Func="DatabaseAttributeSetData"/>,
##  </Item>
##  <Mark><C>update</C></Mark>
##  <Item>
##    a function that takes <A>a</A> as its argument, adjusts its data
##    components to the current values of <A>a</A><C>.dbidenum</C>
##    if necessary,
##    sets the <C>version</C> component to that of <A>a</A><C>.dbidenum</C>,
##    and returns <K>true</K> or <K>false</K>, depending on whether the
##    update process was successful or not;
##    the default value is <Ref Func="ReturnTrue" BookName="ref"/>,
##  </Item>
##  <Mark><C>neededAttributes</C></Mark>
##  <Item>
##    a list of attribute <C>identifier</C> strings such that the values of
##    these attributes are needed in the computations for the current one,
##    and therefore these should be updated/recomputed in advance;
##    <!-- this is used in <Ref Func="DatabaseIdEnumeratorUpdate"/>; -->
##    it is assumed that the <C>neededAttributes</C> components of all
##    database attributes of <A>a</A><C>.idenumerator</C> define a partial
##    ordering;
##    the default is an empty list,
##  </Item>
##  <Mark><C>prepareAttributeComputation</C></Mark>
##  <Item>
##    a function with argument <A>a</A> that must be called before
##    the computations for the current attribute are started;
##    the default value is <Ref Func="ReturnTrue" BookName="ref"/>,
##  </Item>
##  <Mark><C>cleanupAfterAttibuteComputation</C></Mark>
##  <Item>
##    a function with argument <A>a</A> that must be called after
##    the computations for the current attribute are finished;
##    the default value is <Ref Func="ReturnTrue" BookName="ref"/>, and
##  </Item>
##  <Mark><C>create</C></Mark>
##  <Item>
##    a function that takes a database attribute and an entry in the
##    <C>identifiers</C> list of its database id enumerator,
##    and returns either the entry that shall be stored in the
##    <C>data</C> component, as the value for the given identifier (if this
##    value shall be stored in the <C>data</C> component of <A>a</A>)
##    or the <C>dataDefault</C> component of <A>a</A>
##    (if this value shall <E>not</E> be stored);
##    in order to get the actual attribute value,
##    the <C>eval</C> function of <A>a</A>, if bound,
##    must be called with the return value.
##    This function may assume that the <C>prepareAttributeComputation</C>
##    function has been called in advance, and that the
##    <C>cleanupAfterAttibuteComputation</C> function will be called
##    later.
##    The <C>create</C> function is <E>not</E> intended to compute an
##    individual attribute value on demand,
##    use a <C>name</C> component for that.
##    (A stored <C>name</C> function is used to provide a default for the
##    <C>create</C> function;
##    without <C>name</C> component, there is no default for <C>create</C>.)
##  </Item>
##  </List>
##  <P/>
##  The following optional component is needed for <E>storing</E> data on
##  files.
##  <P/>
##  <P/>
##  <List>
##  <Mark><C>string</C></Mark>
##  <Item>
##    if bound, a function that takes the pair consisting of an identifier
##    and the return value of the <C>create</C> function for this identifier,
##    and returns a string that shall represent this value when the data are
##    printed to a file;
##    <!-- crossref to <Ref Func="DatabaseAttributeString"/> -->
##    the default function returns the <Ref Attr="String" BookName="ref"/>
##    value of the second argument.
##  </Item>
##  </List>
##  <P/>
##  The following optional component is needed for <E>checking</E> stored
##  data.
##  <P/>
##  <List>
##  <Mark><C>check</C></Mark>
##  <Item>
##    a function that takes a string that occurs in the <C>identifiers</C>
##    list of the <C>idenumerator</C> record,
##    and returns <K>true</K> if the attribute value stored for this string
##    is reasonable, and something different from <K>true</K> if an error was
##    detected.
##    (One could argue that these tests can be performed also when the
##    values are computed,
##    but consistency checks may involve several entries;
##    besides that, checking may be cheaper than recomputing.)
##  </Item>
##  </List>
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
##  <#GAPDoc Label="subsect:attr_browse_comp">
##  <Subsection Label="subsect:attr-browse-comp">
##  <Heading>Browse Relevant Components of Database Attributes</Heading>
##
##  The following optional components of database id enumerators and
##  database attributes are used by
##  <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>.
##  <P/>
##  <List>
##  <Mark><C>viewLabel</C></Mark>
##  <Item>
##    if bound, a table cell data object
##    (see <Ref Func="BrowseData.IsBrowseTableCellData"/>) that gives a
##    <E>short</E> description of the attribute,
##    which is used as the column label in browse tables created with
##    <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>;
##    the default for database attributes is the <C>name</C> component,
##    if bound, and otherwise the <C>identifier</C> component;
##    the default for database id enumerators is the string <C>"name"</C>,
##  </Item>
##  <Mark><C>viewValue</C></Mark>
##  <Item>
##    if bound, a function that takes the output of the <C>attributeValue</C>
##    function and returns a table cell data object
##    (see <Ref Func="BrowseData.IsBrowseTableCellData"/>)
##    that is used as the entry of the corresponding column
##    in browse tables created with
##    <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>;
##    the default is <Ref Attr="String" BookName="ref"/>,
##  </Item>
##  <Mark><C>viewSort</C></Mark>
##  <Item>
##    if bound, a comparison function that takes two database attribute
##    values and returns <K>true</K> if the first value is regarded as
##    smaller than the second when the column corresponding to the attribute
##    in the browse table constructed by
##    <Ref Func="BrowseTableFromDatabaseIdEnumerator"/> gets sorted,
##    and <K>false</K> otherwise;
##    the default is &GAP;'s <C>\&lt;</C> operation,
##  </Item>
##  <Mark><C>sortParameters</C></Mark>
##  <Item>
##    if bound, a list in the same format as the last argument of
##    <!-- <Ref Func="BrowseData.SetSortParameters"/>, -->
##    <C>BrowseData.SetSortParameters</C>,
##    which is used for the column corresponding to the attribute
##    in the browse table constructed by 
##    <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>;
##    the default is an empty list,
##  </Item>
##  <Mark><C>widthCol</C></Mark>
##  <Item>
##    if bound, the width of the column in the browse table constructed by 
##    <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>;
##    if a column width is prescribed this way then the function stored in
##    the <C>attributeValue</C> component must return either a list of
##    attribute lines that fit into the column or a plain string (which
##    then gets formatted as required);
##    there is no default for this component, meaning that the column width
##    is computed as the maximum of the widths of the column label and of
##    all entries in the column if no value is bound,
##  </Item>
##  <Mark><C>align</C></Mark>
##  <Item>
##    if bound, the alignment of the values in the column of the browse table
##    constructed by  <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>;
##    admissible values are substrings of <C>"bclt"</C>,
##    see <Ref Func="BrowseData.IsBrowseTableCellData"/>;
##    the default is right and vertically centered,
##    but note that if the <C>viewValues</C> function returns a record
##    (see <Ref Func="BrowseData.IsBrowseTableCellData"/>) then the alignment
##    prescribed by this record is preferred,
##  </Item>
##  <Mark><C>categoryValue</C></Mark>
##  <Item>
##    if bound, a function that is similar to the <C>viewValue</C>
##    component but may return a different value;
##    for example if the column in the browse table belongs to a property
##    and the <C>viewValue</C> function returns something like <C>"+"</C> or
##    <C>"-"</C>, it may be useful that the category rows show a textual
##    description of the property values;
##    the default value is the <C>viewValue</C> component;
##    if the value is a record then its <C>rows</C> component is taken for
##    forming category rows, if the value is an attribute line
##    (see <Ref Func="NCurses.IsAttributeLine"/>) then there is exactly this
##    category row, and otherwise the value is regarded as a list of
##    attribute lines, which is either concatenated to one category row or
##    turned into individual category rows, depending on the
##    <C>sortParameters</C> value.
##  </Item>
##  </List>
##
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
##  <#GAPDoc Label="subsect:db_how_to_use">
##  <Subsection Label="subsect:db-how-to-use">
##  <Heading>How to Deal with Database Id Enumerators and
##           Database Attributes</Heading>
##
##  The idea is to start with a database id enumerator
##  (see <Ref Subsect="subsect:dbidenum"/>),
##  constructed with <Ref Func="DatabaseIdEnumerator"/>,
##  and to define database attributes for it
##  (see <Ref Subsect="subsect:dbattr"/>),
##  using <Ref Func="DatabaseAttributeAdd"/>.
##  The attribute values can be precomputed and stored on files,
##  or they are computed when the attribute gets defined,
##  or they are computed on demand.
##  <P/>
##  The function <Ref Func="DatabaseAttributeCompute"/> can be used
##  to <Q>refresh</Q> the attribute values, that is, all values or selected
##  values can be recomputed; this can be necessary for example when the
##  underlying database id enumerator gets extended.
##  <P/>
##  In data files, the function <Ref Func="DatabaseAttributeSetData"/> can be
##  used to fill the <C>data</C> component of the attribute.
##  <!-- Strings for replacing the contents of data files can be produced
##  with <Ref Func="DatabaseAttributeString"/>. -->
##
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
#F  DatabaseIdEnumerator( <arec> )
##
##  <#GAPDoc Label="DatabaseIdEnumerator_man">
##  <ManSection>
##  <Func Name="DatabaseIdEnumerator" Arg='arec'/>
##
##  <Returns>
##  a shallow copy of the record <A>arec</A>, extended by default values.
##  </Returns>
##  <Description>
##  For a record <A>arec</A>, <Ref Func="DatabaseIdEnumerator"/>
##  checks whether the mandatory components of a database id enumerator
##  (see Section <Ref Subsect="subsect:dbidenum"/>) are present,
##  initializes the <C>attributes</C> component,
##  sets the defaults for unbound optional components
##  (see <Ref Subsect="subsect:attr-browse-comp"/>),
##  and returns the resulting record.
##  <P/>
##  A special database attribute
##  (see Section <Ref Subsect="subsect:dbattr"/>) with <C>identifier</C>
##  value <C>"self"</C> is constructed automatically for the returned record
##  by <Ref Func="DatabaseIdEnumerator"/>;
##  its <C>attributeValue</C> function simply returns its second argument
##  (the identifier).
##  The optional components of this attribute are derived from components of
##  the database id enumerator,
##  so these components (see <Ref Subsect="subsect:attr-browse-comp"/>)
##  are supported for <A>arec</A>.
##  A typical use of the <C>"self"</C> attribute is to provide the first
##  column in browse tables constructed by
##  <Ref Func="BrowseTableFromDatabaseIdEnumerator"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseIdEnumerator" );


#############################################################################
##
#F  DatabaseAttributeAdd( <dbidenum>, <arec> )
##
##  <#GAPDoc Label="DatabaseAttributeAdd_man">
##  <ManSection>
##  <Func Name="DatabaseAttributeAdd" Arg='dbidenum, arec'/>
##
##  <Description>
##  For a database id enumerator <A>dbidenum</A> and a record <A>arec</A>,
##  <Ref Func="DatabaseAttributeAdd"/> checks whether the mandatory
##  components of a database attribute, except <C>idenumerator</C>,
##  are present in <A>arec</A> (see Section <Ref Subsect="subsect:dbattr"/>),
##  sets the <C>idenumerator</C> component, and
##  sets the defaults for unbound optional components
##  (see <Ref Subsect="subsect:attr-browse-comp"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseAttributeAdd" );


#############################################################################
##
#F  DatabaseAttributeValueDefault( <attr>, <id> )
##
##  <#GAPDoc Label="DatabaseAttributeValueDefault_man">
##  <ManSection>
##  <Func Name="DatabaseAttributeValueDefault" Arg='attr, id'/>
##
##  <Returns>
##  the value of the database attribute <A>attr</A> at <A>id</A>.
##  </Returns>
##  <Description>
##  For a database attribute <A>attr</A> and an entry <A>id</A> of the
##  <C>identifiers</C> list of the underlying database id enumerator,
##  <Ref Func="DatabaseAttributeValueDefault"/> takes the <C>data</C> entry
##  for <A>id</A>, applies the <C>eval</C> function of <A>attr</A> to it
##  if available and returns the result.
##  <P/>
##  So the question is how to get the <C>data</C> entry.
##  <P/>
##  First, if the <C>data</C> component of <A>attr</A> is not bound then
##  the file given by the <C>datafile</C> component of <A>attr</A>,
##  if available, is read,
##  and otherwise <Ref Func="DatabaseAttributeCompute"/> is called;
##  afterwards it is assumed that the <C>data</C> component is bound.
##  <P/>
##  The further steps depend on the <C>type</C> value of <A>attr</A>.
##  <P/>
##  If the <C>type</C> value of <A>attr</A> is <C>"pairs"</C> then
##  the <C>data</C> entry for <A>id</A> is either contained in the
##  <C>automatic</C> or in the <C>nonautomatic</C> list
##  of <A>attr</A><C>.data</C>,
##  or it is given by the <C>dataDefault</C> value of <A>attr</A>.
##  (So a perhaps available <C>name</C> function is <E>not</E> used to
##  compute the value for a missing <C>data</C> entry.)
##  <P/>
##  If the <C>type</C> value of <A>attr</A> is <C>"values"</C> then the
##  <C>data</C> entry for <A>id</A> is computed as follows.
##  Let <M>n</M> be the position of <A>id</A> in the <C>identifiers</C>
##  component of the database id enumerator.
##  If the <M>n</M>-th entry of the <C>data</C> component of <A>attr</A>
##  is bound then take it;
##  otherwise if the <C>name</C> component is bound then apply it to
##  <A>id</A> and take the return value;
##  otherwise take the <C>dataDefault</C> value.
##  <P/>
##  If one wants to introduce a database attribute where this functionality
##  is not suitable then another &ndash;more specific&ndash; function must
##  be entered as the component <C>attributeValue</C> of such an attribute.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseAttributeValueDefault" );


#############################################################################
##
#F  DatabaseAttributeCompute( <dbidenum>, <attridentifier>[, <what>] )
##
##  <#GAPDoc Label="DatabaseAttributeCompute_man">
##  <ManSection>
##  <Func Name="DatabaseAttributeCompute"
##   Arg='dbidenum, attridentifier[, what]'/>
##
##  <Returns>
##  <K>true</K> or <K>false</K>.
##  </Returns>
##  <Description>
##  This function returns <K>false</K>
##  if <A>dbidenum</A> is not a database id enumerator, or
##  if it does not have a database attribute with <C>identifier</C> value
##  <A>attridentifier</A>, or
##  if this attribute does not have a <C>create</C> function.
##  <P/>
##  Otherwise the <C>prepareAttributeComputation</C> function is called,
##  the <C>data</C> entries for the database attribute are (re)computed,
##  the <C>cleanupAfterAttibuteComputation</C> function is called,
##  and <K>true</K> is returned.
##  <P/>
##  The optional argument <A>what</A> determines which values are computed.
##  Admissible values are
##  <List>
##  <Mark><C>"all"</C></Mark>
##  <Item>
##    all <C>identifiers</C> entries of <A>dbidenum</A>,
##  </Item>
##  <Mark><C>"automatic"</C> (the default)</Mark>
##  <Item>
##    the same as <C>"all"</C> if the <C>type</C> value
##    of the database attribute is <C>"values"</C>,
##    otherwise only the values for the <C>"automatic"</C> component are
##    computed,
##  </Item>
##  <Mark><C>"new"</C></Mark>
##  <Item>
##    stored values are not recomputed.
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseAttributeCompute" );


#############################################################################
##
#F  DatabaseIdEnumeratorUpdate( <dbidenum> )
##
##  <#GAPDoc Label="DatabaseIdEnumeratorUpdate_man">
##  <ManSection>
##  <Func Name="DatabaseIdEnumeratorUpdate" Arg='dbidenum'/>
##
##  <Returns>
##  <K>true</K> or <K>false</K>.
##  </Returns>
##  <Description>
##  For a database id enumerator <A>dbidenum</A>
##  (see Section <Ref Subsect="subsect:dbidenum"/>),
##  <Ref Func="DatabaseIdEnumeratorUpdate"/> first calls the <C>update</C>
##  function of <A>dbidenum</A>.
##  Afterwards,
##  the <C>update</C> components of those of its <C>attributes</C> records
##  are called for which the <C>version</C> component differs from that of
##  <A>dbidenum</A>.
##  <P/>
##  The order in which the database attributes are updates is determined by
##  the <C>neededAttributes</C> component.
##  <P/>
##  The return value is <K>true</K> if all these functions return
##  <K>true</K>, and <K>false</K> otherwise.
##  <P/>
##  When <Ref Func="DatabaseIdEnumeratorUpdate"/> has returned <K>true</K>,
##  the data described by <A>dbidenum</A> and its database attributes
##  are consistent and up to date.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseIdEnumeratorUpdate" );


#############################################################################
##
#F  DatabaseAttributeSetData( <dbidenum>, <attridentifier>, <version>,
#F                            <data> )
##
##  <#GAPDoc Label="DatabaseAttributeSetData_man">
##  <ManSection>
##  <Func Name="DatabaseAttributeSetData"
##   Arg='dbidenum, attridentifier, version, data'/>
##
##  <Description>
##  Let <A>dbidenum</A> be a database id enumerator
##  (see Section <Ref Subsect="subsect:dbidenum"/>),
##  <A>attridentifier</A> be a string that is the <C>identifier</C> value
##  of a database attribute of <A>dbidenum</A>,
##  <A>data</A> be the <C>data</C> list or record for the database attribute
##  (depending on its <C>type</C> value),
##  and <A>version</A> be the corresponding <C>version</C> value.
##  <P/>
##  <Ref Func="DatabaseAttributeSetData"/> sets the <C>data</C> and
##  <C>version</C> components of the attribute.
##  This function can be used for example in data files.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DatabaseAttributeSetData" );


#############################################################################
##
#F  DatabaseAttributeString( idenum, idenumname, attridentifier )
##
DeclareGlobalFunction( "DatabaseAttributeString" );


#############################################################################
##
#F  BrowseTableFromDatabaseIdEnumerator( <dbidenum>, <labelids>, <columnids>
#F      [, <header>[, <footer>[, <choice>]]] )
##
##  <#GAPDoc Label="BrowseTableFromDatabaseIdEnumerator_man">
##  <ManSection>
##  <Func Name="BrowseTableFromDatabaseIdEnumerator"
##   Arg='dbidenum, labelids, columnids[, header[, footer[, choice]]]'/>
##
##  <Returns>
##  a record that can be used as the input of
##  <Ref Func="NCurses.BrowseGeneric"/>.
##  </Returns>
##  <Description>
##  For a database id enumerator <A>dbidenum</A>
##  (see Section <Ref Subsect="subsect:dbidenum"/>) and two lists
##  <A>labelids</A> and <A>columnids</A> of <C>identifier</C> values of
##  database attributes stored in <A>dbidenum</A>,
##  <Ref Func="BrowseTableFromDatabaseIdEnumerator"/> returns a browse table
##  (see&nbsp;<Ref Func="BrowseData.IsBrowseTable"/>) whose columns are given
##  by the values of the specified database attributes.
##  The columns listed in <A>labelids</A> are used to provide row label
##  columns of the browse table, the columns listed in <A>columnids</A> yield
##  main table columns.
##  <A>columnids</A> must be nonempty.
##  <P/>
##  If the optional arguments <A>header</A> and <A>footer</A> are given
##  then they must be lists or functions or records that are
##  admissible for the <C>header</C> and <C>footer</C> components of the
##  <C>work</C> record of the browse table,
##  see <Ref Func="BrowseData.IsBrowseTable"/>.
##  <P/>
##  The optional argument <A>choice</A>, if given, must be a subset of 
##  <A>dbidenum</A><C>.identifiers</C>.
##  The rows of the returned browse table are then restricted to this subset.
##  <P/>
##  The returned browse table does not support <Q>Click</Q> events or
##  return values.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "BrowseTableFromDatabaseIdEnumerator" );


#############################################################################
##
#E

