" Test: Completion of CamelKeyword words. 

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(121) 
edit CamelKeyword.txt

set completefunc=CamelCaseComplete#CamelCaseComplete
set iskeyword+=#

call IsMatchesInIsolatedLine('',     ['#hugo_jack', '#interLeaf', 'single#sake_dross', 'tingle#sakeDrosss', 'single#lake_dros_repatable', 'tingle#lakeDrossRepeatable', 'upeatable_mapping#fake', 'xepeatableMapping#fake', 'upeatable_mapping#take_cros', 'xepeatableMapping#takeBross', 'upeatable_mapping#make_cros_repatable', 'xepeatableMapping#makeBrossRepeatable'], 'all matches')

call IsMatchesInIsolatedLine('l',    [], 'no matches with l')
call IsMatchesInIsolatedLine('lr',   [], 'no matches with lr')
call IsMatchesInIsolatedLine('ldr',  [], 'no matches with ldr')

call IsMatchesInIsolatedLine('#',    ['#hugo_jack', '#interLeaf'], 'relaxed matches with #')
"call IsMatchesInIsolatedLine('#h',   ['#hugo_jack'], 'relaxed matches with #h')
call IsMatchesInIsolatedLine('#i',   ['#interLeaf'], 'relaxed matches with #i')
call IsMatchesInIsolatedLine('#j',   ['#hugo_jack'], 'relaxed matches with #j')
call IsMatchesInIsolatedLine('#l',   ['#interLeaf'], 'relaxed matches with #l')
call IsMatchesInIsolatedLine('#hj',  ['#hugo_jack'], 'strict matches with #hj')
call IsMatchesInIsolatedLine('#il',  ['#interLeaf'], 'strict matches with #il')

call IsMatchesInIsolatedLine('sf', ['single#fake'], 'strict keyword match with sf')

call IsMatchesInIsolatedLine('s',    ['single#sake_dross', 'single#lake_dros_repatable'], 'relaxed underscore matches with s')
call IsMatchesInIsolatedLine('t',    ['tingle#sakeDrosss', 'tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t')
call IsMatchesInIsolatedLine('s#',   ['single#sake_dross', 'single#lake_dros_repatable'], 'relaxed underscore matches with s#')
call IsMatchesInIsolatedLine('t#',   ['tingle#sakeDrosss', 'tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#')
call IsMatchesInIsolatedLine('ss',   ['single#sake_dross'], 'relaxed underscore matches with ss')
call IsMatchesInIsolatedLine('ts',   ['tingle#sakeDrosss'], 'relaxed Camel matches with ts')
"call IsMatchesInIsolatedLine('s#s',  ['single#sake_dross'], 'relaxed underscore matches with s#s')
call IsMatchesInIsolatedLine('t#s',  ['tingle#sakeDrosss'], 'relaxed Camel matches with t#s')
"call IsMatchesInIsolatedLine('s#d',  ['single#sake_dross', 'single#lake_dros_repatable'], 'relaxed underscore matches with s#d')
call IsMatchesInIsolatedLine('t#d',  ['tingle#sakeDrosss', 'tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#d')

" Special case: These treat "single#sake" as one underscore fragment. 
call IsMatchesInIsolatedLine('sd',   ['single#sake_dross'], 'strict underscore matches with sd')
call IsMatchesInIsolatedLine('td',   ['tingle#sakeDrosss'], 'strict Camel matches with td')

call IsMatchesInIsolatedLine('s#r',  ['single#lake_dros_repatable'], 'relaxed underscore matches with s#r')
call IsMatchesInIsolatedLine('t#r',  ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#r')
call IsMatchesInIsolatedLine('sr',   ['single#lake_dros_repatable'], 'relaxed underscore matches with sr')
call IsMatchesInIsolatedLine('tr',   ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with tr')
call IsMatchesInIsolatedLine('sdr',  ['single#lake_dros_repatable'], 'relaxed underscore matches with sdr')
call IsMatchesInIsolatedLine('tdr',  ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with tdr')
call IsMatchesInIsolatedLine('sl',   ['single#lake_dros_repatable'], 'relaxed underscore matches with sl')
call IsMatchesInIsolatedLine('tl',   ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with tl')
call IsMatchesInIsolatedLine('slr',  ['single#lake_dros_repatable'], 'relaxed underscore matches with slr')
call IsMatchesInIsolatedLine('tlr',  ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with tlr')
call IsMatchesInIsolatedLine('sld',  ['single#lake_dros_repatable'], 'relaxed underscore matches with sld')
call IsMatchesInIsolatedLine('tld',  ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with tld')
"call IsMatchesInIsolatedLine('s#l',  ['single#lake_dros_repatable'], 'relaxed underscore matches with s#l')
call IsMatchesInIsolatedLine('t#l',  ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#l')
call IsMatchesInIsolatedLine('s#lr', ['single#lake_dros_repatable'], 'relaxed underscore matches with s#lr')
call IsMatchesInIsolatedLine('t#lr', ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#lr')
call IsMatchesInIsolatedLine('s#ld', ['single#lake_dros_repatable'], 'relaxed underscore matches with s#ld')
call IsMatchesInIsolatedLine('t#ld', ['tingle#lakeDrossRepeatable'], 'relaxed Camel matches with t#ld')

call IsMatchesInIsolatedLine('sldr', ['single#lake_dros_repatable'], 'strict underscore matches with sldr')
call IsMatchesInIsolatedLine('tldr', ['tingle#lakeDrossRepeatable'], 'strict Camel matches with tldr')
call IsMatchesInIsolatedLine('s#ldr',['single#lake_dros_repatable'], 'strict underscore matches with s#ldr')
call IsMatchesInIsolatedLine('t#ldr',['tingle#lakeDrossRepeatable'], 'strict Camel matches with t#ldr')

call IsMatchesInIsolatedLine('m',    [], 'no matches with m')
call IsMatchesInIsolatedLine('m#',   [], 'no matches with m#')
call IsMatchesInIsolatedLine('m#f',  [], 'no matches with m#f')
call IsMatchesInIsolatedLine('m#t',  [], 'no matches with m#t')
call IsMatchesInIsolatedLine('m#tc', [], 'no matches with m#tc')
call IsMatchesInIsolatedLine('m#tb', [], 'no matches with m#tb')
call IsMatchesInIsolatedLine('m#mcr',[], 'no matches with m#mcr')
call IsMatchesInIsolatedLine('#mcr', [], 'no matches with #mcr')
call IsMatchesInIsolatedLine('mcr',  [], 'no matches with mcr')
call IsMatchesInIsolatedLine('cr',   [], 'no matches with cr')
call IsMatchesInIsolatedLine('r',    [], 'no matches with r')

call IsMatchesInIsolatedLine('uf',   ['upeatable_mapping#fake'], 'relaxed keyword match with uf')
call IsMatchesInIsolatedLine('xf',   ['xepeatableMapping#fake'], 'relaxed keyword match with xf')
call IsMatchesInIsolatedLine('umf',  ['upeatable_mapping#fake'], 'strict keyword match with umf')
call IsMatchesInIsolatedLine('xmf',  ['xepeatableMapping#fake'], 'strict keyword match with xmf')
call IsMatchesInIsolatedLine('mf',   [], 'no matches with mf')
call IsMatchesInIsolatedLine('#f',   [], 'no matches with #f')

call IsMatchesInIsolatedLine('u',    ['upeatable_mapping#fake', 'upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u')
call IsMatchesInIsolatedLine('x',    ['xepeatableMapping#fake', 'xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x')
call IsMatchesInIsolatedLine('um',   ['upeatable_mapping#fake'], 'relaxed underscore matches with um')
call IsMatchesInIsolatedLine('xm',   ['xepeatableMapping#fake'], 'relaxed CamelCase matches with xm')

call IsMatchesInIsolatedLine('u#',   ['upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u#')
call IsMatchesInIsolatedLine('x#',   ['xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x#')
call IsMatchesInIsolatedLine('um#',  ['upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with um#')
call IsMatchesInIsolatedLine('xm#',  ['xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xm#')
"call IsMatchesInIsolatedLine('um#c', ['upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with um#c')
call IsMatchesInIsolatedLine('xm#b', ['xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xm#b')
"call IsMatchesInIsolatedLine('u#c',  ['upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u#c')
call IsMatchesInIsolatedLine('x#b',  ['xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x#b')
call IsMatchesInIsolatedLine('uc',   ['upeatable_mapping#take_cros', 'upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with uc')
call IsMatchesInIsolatedLine('xb',   ['xepeatableMapping#takeBross', 'xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xb')

" Special case: This treats "mapping#take" as one underscore fragment. 
call IsMatchesInIsolatedLine('umc',  ['upeatable_mapping#take_cros'], 'strict underscore matches with umc')
" Special case: This treats "Mapping#take" as one CamelCase fragment. 
call IsMatchesInIsolatedLine('xmb',  ['xepeatableMapping#takeBross'], 'strict CamelCase matches with xmb')

"call IsMatchesInIsolatedLine('um#t', ['upeatable_mapping#take_cros'], 'relaxed underscore matches with um#t')
call IsMatchesInIsolatedLine('xm#t', ['xepeatableMapping#takeBross'], 'relaxed CamelCase matches with xm#t')
"call IsMatchesInIsolatedLine('u#t',  ['upeatable_mapping#take_cros'], 'relaxed underscore matches with u#t')
call IsMatchesInIsolatedLine('x#t',  ['xepeatableMapping#takeBross'], 'relaxed CamelCase matches with x#t')
call IsMatchesInIsolatedLine('ut',   ['upeatable_mapping#take_cros'], 'relaxed underscore matches with u#c')
call IsMatchesInIsolatedLine('xt',   ['xepeatableMapping#takeBross'], 'relaxed CamelCase matches with x#b')

call IsMatchesInIsolatedLine('umt',  ['upeatable_mapping#take_cros'], 'relaxed underscore matches with umt')
call IsMatchesInIsolatedLine('xmt',  ['xepeatableMapping#takeBross'], 'relaxed CamelCase matches with xmt')

call IsMatchesInIsolatedLine('umtc',  ['upeatable_mapping#take_cros'], 'strict underscore matches with umtc')
call IsMatchesInIsolatedLine('xmtb',  ['xepeatableMapping#takeBross'], 'strict CamelCase matches with xmtb')
call IsMatchesInIsolatedLine('um#tc', ['upeatable_mapping#take_cros'], 'strict underscore matches with um#tc')
call IsMatchesInIsolatedLine('xm#tb', ['xepeatableMapping#takeBross'], 'strict CamelCase matches with xm#tb')

call IsMatchesInIsolatedLine('ur',    ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with ur')
call IsMatchesInIsolatedLine('xr',    ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xr')
call IsMatchesInIsolatedLine('umr',   ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with umr')
call IsMatchesInIsolatedLine('xbr',   ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xbr')
call IsMatchesInIsolatedLine('ummr',  ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with ummr')
call IsMatchesInIsolatedLine('xmbr',  ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xmbr')
call IsMatchesInIsolatedLine('um#mr', ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with um#mr')
call IsMatchesInIsolatedLine('xm#mr', ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xm#mr')
call IsMatchesInIsolatedLine('umcr',  ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with umcr')
call IsMatchesInIsolatedLine('xmbr',  ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xmbr')
call IsMatchesInIsolatedLine('um#cr', ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with um#cr')
call IsMatchesInIsolatedLine('xm#br', ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xm#br')
call IsMatchesInIsolatedLine('ucr',   ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with ucr')
call IsMatchesInIsolatedLine('xbr',   ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with xbr')
call IsMatchesInIsolatedLine('u#mcr', ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u#mcr')
call IsMatchesInIsolatedLine('x#mbr', ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x#mbr')
call IsMatchesInIsolatedLine('u#cr',  ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u#cr')
call IsMatchesInIsolatedLine('x#br',  ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x#br')
call IsMatchesInIsolatedLine('u#r',   ['upeatable_mapping#make_cros_repatable'], 'relaxed underscore matches with u#r')
call IsMatchesInIsolatedLine('x#r',   ['xepeatableMapping#makeBrossRepeatable'], 'relaxed CamelCase matches with x#r')

call IsMatchesInIsolatedLine('ummcr', ['upeatable_mapping#make_cros_repatable'], 'strict underscore matches with ummcr')
call IsMatchesInIsolatedLine('xmmbr', ['xepeatableMapping#makeBrossRepeatable'], 'strict CamelCase matches with xmmbr')
call IsMatchesInIsolatedLine('um#mcr',['upeatable_mapping#make_cros_repatable'], 'strict underscore matches with um#mcr')
call IsMatchesInIsolatedLine('xm#mbr',['xepeatableMapping#makeBrossRepeatable'], 'strict CamelCase matches with xm#mbr')

call IsMatchesInIsolatedLine('u#k',  [], 'no matches with u#k')
call IsMatchesInIsolatedLine('x#k',  [], 'no matches with x#k')
call IsMatchesInIsolatedLine('um#k', [], 'no matches with um#k')
call IsMatchesInIsolatedLine('xm#k', [], 'no matches with xm#k')
"call IsMatchesInIsolatedLine('u#kc', [], 'no matches with u#kc')
call IsMatchesInIsolatedLine('x#kb', [], 'no matches with x#kb')
"call IsMatchesInIsolatedLine('u#kcr',[], 'no matches with u#kcr')
call IsMatchesInIsolatedLine('x#kbr',[], 'no matches with x#kbr')
call IsMatchesInIsolatedLine('um#k', [], 'no matches with um#k')
call IsMatchesInIsolatedLine('xm#k', [], 'no matches with xm#k')

call vimtest#Quit()

