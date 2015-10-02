#############################################################################
##
#W  transdbattr.g         GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2008,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the data for several Boolean valued database
##  attributes.
##
##  <#GAPDoc Label="transdbattr_man">
##  <Subsection Label="subsect:transdbattr">
##  <Heading>Additional Database Attributes for Transitive Groups</Heading>
##
##  Database attributes for the following &GAP; properties are defined in
##  <Ref Var="TransitiveGroupsData"/>:
##  <Ref Prop="IsAbelian" BookName="Ref"/>,
##  <Ref Prop="IsPerfectGroup" BookName="Ref"/>,
##  <Ref Prop="IsSimpleGroup" BookName="Ref"/>, and
##  <Ref Prop="IsSolvableGroup" BookName="Ref"/>.
##  The values of these database attributes are precomputed and stored in
##  the file <F>app/transdbattr.g</F> of the package.
##  <P/>
##  So the above &GAP; properties have special support as conditions in
##  <Ref Func="TransitiveGroupsData.AllTransitiveGroups"/> and
##  <Ref Func="TransitiveGroupsData.OneTransitiveGroup"/>,
##  contrary to <Ref Func="AllTransitiveGroups" BookName="Ref"/> and
##  <Ref Func="OneTransitiveGroup" BookName="Ref"/>.
##  In practice, the difference is that the former functions need not
##  construct and check those transitive groups that do not have the
##  properties in question.
##  <P/>
##  These database attributes can also be used as columns in the Browse
##  table shown by <Ref Func="BrowseTransitiveGroupsInfo"/>,
##  for example as follows.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "scrrrsc", n, n,        # categorize by solvability info
##  >        "!", n,                 # reset
##  >        "scrrrrsc", n, n,       # categorize by abelianity info
##  >        "Q" ) );;               # quit the browse table
##  gap> BrowseTransitiveGroupsInfo( rec( choice:= [ "degree", "size",
##  >      "names", "IsSolvableGroup", "IsAbelian", "IsPerfectGroup",
##  >      "IsSimpleGroup" ] ) );;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  The data in the file <F>app/transdbattr.g</F> are lists of Booleans,
##  which are encoded as strings via <C>HexStringBlistEncode</C>,
##  and these strings are decoded with <C>BlistStringDecode</C>.
##  Note that for most of the groups in the library are not abelian,
##  not perfect, not simple, but solvable;
##  Therefore in fact the inverse values of the solvability info are
##  actually stored &ndash;this yields a shorter string.
##  <P/>
##  <Example><![CDATA[
##  gap> TransitiveGroupsData.MinimalDegree;
##  2
##  gap> attrs:= TransitiveGroupsData.IdEnumerator.attributes;;
##  gap> oldlen:= SizeScreen();;  SizeScreen( [ 60 ] );;
##  gap> HexStringBlistEncode( attrs.IsAbelian.data );
##  "D88400040Es0503s0480s040406s252010s0720s0C3EsF30803s7A040\
##  5s8B20s1302s0740E0sFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFs40C\
##  0s1910s0B1AsFFs2B18sE74040sFFsFF"
##  gap> SizeScreen( oldlen );;
##  ]]></Example>
##  <P/>
##  Removing the <C>datafile</C> component from the four database attributes
##  would yield the situation that attribute values are computed at runtime.
##  Computing the values for all groups in the library
##  &ndash;for example by categorizing the Browse table by one of the columns
##  that correspond to these database attributes&ndash;
##  will require several seconds.
##  Note that if we assume that the information about solvability is already
##  known, the test for <Ref Prop="IsPerfectGroup" BookName="ref"/> is needed
##  only for the few nonsolvable groups in the library but each such test is
##  expensive;
##  on the other hand, each test for <Ref Prop="IsAbelian" BookName="ref"/>
##  is cheap but such tests are needed for the many solvable groups in the
##  library, in particular these groups must be constructed for the tests.
##  </Subsection>
##  <#/GAPDoc>
##

if not TransitiveGroupsData.MinimalDegree in [ 1, 2 ] then
  Error( "TransitiveGroupsData.MinimalDegree must be either 1 or 2" );
fi;


DatabaseAttributeSetData( TransitiveGroupsData.IdEnumerator,
"IsSolvableGroup","1.0",List( BlistStringDecode(
"000C005C38s04410Es0343811C0223BFFC3Cs0302s0401C0s05C0s06F8s0301C010s020E00343\
83C2FE070041A004C266FFFE10863E3s024101C1A3843FFFE0s581Cs2706s0530s1E30s153Es11\
0180s0B10s051Fs04EE000100108Cs02C802s020A3BF83Es0B80s050380s0940s0338s0CF001s0\
640s02200020s0F20s070380s06C002s067C0080s041F06s030E81E00580101F80FBFFFFFFFC0C\
0008001CC0s021F100002s037C800003FCs025Es023FFC03FFF0s030787FEEF80s0711BF2Cs096\
7E1C0s07C0FFC0D77FA0s0780001F8FEFEF7FF8s0607s03201FFFFF40s040Fs033Cs0207FF003F\
80FF01FFFF223FFE1FECBFFBFF7C71FF7FFFFFFFFFFFE00082841082003804080104006054D1BA\
6F7FFFFE001808C00FFFFFC380s1870s0908s233FE0s0F10s4E07FFD8s1720s8B7Ds221CFFF0sF\
760s0420s2937FFC0sEC1FFFFFs0905s3803s0340sE101FFFFFFFFFFFF80s065Cs3502s0901sE8\
FFFFFFF0s070Cs3207FCsAA7FFFE0s0518s4401FFFFFFE0sAE01FFC00Es4303FFF0sA107DFFFF8\
08s3A180001C0s622FFFFFFFFF0080s2A1F80s5BFFFFFFF800FF80s2119FFFFC0s5020s0403F00\
00FFFFCC0s2D7FFFFFFFFCs3518s050FFFDFs323FFFFFFF80s2501s0240s067Fs1D013Es1E0800\
FEs0601F0s2501FC03F8000370s0A10s0F3FFE4020s082FE00060s06FF80s0501DFCFF0s02FEBA\
s0210s02FFF800C0FE80s023C01FFF81801FEs0301BFF903FFC0s02E03FF00380180C0BBFFFFFF\
FFFFFFFFFFFFF80s0204002A0320802443A01C2201C79E38089C70117FFFFFFFF0s04243838400\
01FFFF0s3060s1080s0E10s1280s1708s1408s2004s0E02s0E80s0E07s0D80s0610s0704s0307s\
0506s0510s0204s0901s0310s0201C0s0207C00EC07EFFFFF0s03100640s02401F70s0310s0207\
986080s0378000618FCs04040C0330FCF002s043E02CFF148s0307FA7E5FFE70s02E000CCE3FFF\
FFB64s081F0019FDE7E00FC0s0D18063F2BFC01E780s020380s07020C0C781FFE00FFFC000D80s\
087E0630FF001Cs0801FAFC3FE00010s03100001000DE7E7F87FFCs02320001800006F9E0000F0\
124003DE0000180F1FFFE0F3FFCF018FFFFFFCC1FFF77FFFF9FFE3FC3C0245FDBFF76C3F71FFF7\
FFFFFFFFFFFFFFFFFFFC0C020012B00020014020002F71380s02400060001FDDFCs031163E0000\
2141FFCs0410000466DED839FFF804000FFCs0204s04914000087A7D1FD63FFE020113FFFFs021\
0s0432C600840007F140BF92F0DE1FFFFFF0s030800402E06620402100400401218013FA1F03FF\
FFFE0s048009EFCEFF401010080017D30Bs0304s027FFFC0000FFFs0407FFDBA01006647DEEF18\
2s0208s031FFFFFF8s0201FFC0s0215440C7F7B847F80040040F0903FFFF00003FFE4s03489008\
84FFF060808777703FFFFFFE00200020s025D37FBB8001FEBC0s028381BFFFFFC24020s03A001F\
F7FFE020370004040s03FEs027FFFF8s0410s0303D8007FF1500A0090003D4040s0201FFE0s020\
7FFFCs0E73201FFEs0208020217C1s02803FFFFFF00003FFF8s1A040FFFFFs0280s02010052F3F\
FFFF81FFFF0s1E101FFFFFC0s0540017A4FFEFFs2503FFFFF8s03430072s04020FFFFF02s1801F\
FFFF8s021EA80020s0301FFE2F8s1103FFFFFFF0s022000040443C07FFAs0A01FFFFFFFFE0s090\
77FFFE0s0407FFFFFFFFFFF0s0940FFA0s02FFFFFFFFFFFFFFC0s050C000FFFFFFFFFFFFFF0000\
4s027FFFFFFFFFFFF803FCs03FFFFFFFFFF001FFFC0000FFFC07FFFFFFFF03DFFFFFFFEFFFFFFF\
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF\
FFFC0",
40226 ), x -> not x ){[TransitiveGroupsData.MinimalDegree..40226]} );


DatabaseAttributeSetData( TransitiveGroupsData.IdEnumerator,
"IsAbelian","1.0",BlistStringDecode(
"EC42000207s050180s0340s040203s251008s0710s0C1FsF3040180s79020280s8A10s1301s07\
2070sFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFs4060s1908s0B0DsFFs2B0CsE72020sFFsFF",
40226 ){[TransitiveGroupsData.MinimalDegree..40226]} );


DatabaseAttributeSetData( TransitiveGroupsData.IdEnumerator,
"IsPerfectGroup","1.0",BlistStringDecode(
"8008004830s04400Cs034101s0220200838s0302s1280s0510s0404200008406004s024C00048\
0410002s0341s022000200040s5804s2D30s340Cs1280s1107s0420s0788s0308001024s2008s0\
D01s1B20s0F40s07040080s0F02s0210400008080008s0802s0A4Es0640s0404s164000C0s0B01\
s0F08s1302s0920s0A80s0640s0240004000800010s0304s042010118000120004s0208000C410\
083s1940s0908sFFs4D10sF960sFFs2040s4640sFFsFFsFFsFFs08C002sE81310s3F80s931CsFF\
s1240s4108s3204s2C40s0604s720340s0A10s1B20s0A80s0C1As0528s0380s0401s0D40s08040\
01040s0202s0401s0924s0302s05800001s02800420s0424s04104020s7B08s3504s4110s2C40s\
0340s03100020s0310s0440s0510s031860s1302s04200200F140s0408s0D60s0B05E060s10022\
8s1A0180s0D1Cs09023830s0210s0C04s0D20003DE0s1410s04044000010043s0408040008s058\
08020s0940s0E1160s1904s0540s080201100009s0A84s1140s091008s0320s0A08s104000C0s0\
E20s0202s0208s05C0s1AA004s030880s0703s240402s034040s140220s0A01s1714s0A80s0608\
s1D08s3840s02080080s2818s0B04s1C50s0720s1910s0B10s0E50s0C04s1740s04C00001s0E02\
s0C02s0304s0A02s0A24s0302s0A20s060Cs0A80s0504004000028000C0s0280",
40226 ){[TransitiveGroupsData.MinimalDegree..40226]} );


DatabaseAttributeSetData( TransitiveGroupsData.IdEnumerator,
"IsSimpleGroup","1.0",BlistStringDecode(
"6048004A30s044004s034101s0220000A38s0302s1280s0A04s0208506004s0240s03410002s0\
340s0220s0340sF31424s2E01s4B0A080008s0802s1604s694000800010s0304s0B04s02080008\
s02A3s2308sFFsFFsFFsB040sFFsFFsFFsFFsFFsFFsFFsFFs4380s2601s1A20s0424s0620s7B08\
sAE20s0310s0440s0510s1802s0420s0808s6610s4AA08020s0940s5940sFFsFFs6680",
40226 ){[TransitiveGroupsData.MinimalDegree..40226]} );


#############################################################################
##
#E

