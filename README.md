CAMEL CASE COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin offers a keyword completion that is limited to identifiers which
adhere to either CamelCase ("anIdentifier") or underscore\_notation
("an\_identifier") naming conventions. This often results in a single (or very
few) matches and thus allows quick completion of function, class and variable
names.
The list of completion candidates can be restricted by triggering completion
on all or some of the initial letters of each word fragment; e.g. "vlcn" would
expand to "veryLongClassName" and "verbose\_latitude\_correction\_numeric".
Non-alphabetic keyword characters can be thrown in, too, to both widen the
search to word fragments joined by the keywords (e.g. "joined#words") and to
narrow down the number of CamelCase and underscore\_word matches.

### SEE ALSO

- camelcasemotion ([vimscript #1905](http://www.vim.org/scripts/script.php?script_id=1905)) provides special motions ,w ,b and ,e
  through CamelCaseWords and underscore\_notation and corresponding text
  objects.
- Loosely based on and similar to the "Custom keyword completion" from
  http://vim.wikia.com/wiki/Custom_keyword_completion
- Check out the CompleteHelper.vim plugin page ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) for a full
  list of insert mode completions powered by it.

USAGE
------------------------------------------------------------------------------

    In insert mode, type some or all first letters of the desired CamelCaseWord or
    underscore_word, then invoke the completion via CTRL-X CTRL-C.
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X CTRL-C           Find matches for CamelCaseWords and underscore_words
                            whose individual word fragments begin with the typed
                            letters in front of the cursor.

                            STRICT vs. RELAXED
                            The initial letter of the first fragment must always
                            be included; initial letters of subsequent fragments
                            can, but need not be specified. If there are matches
                            where each fragment starts with one typed letter
                                "jaev" -> "justAnExampleVar"
                            only those strict matches are offered. Otherwise, a
                            relaxed search for completions will also include
                            matches where some fragments have no representation in
                            the typed letters
                                "je" -> "justAnExampleVar"
                            In short: Type all initial letters for a precise and
                            narrow completion, or just a few initial letters (but
                            always the first!) when there are too many fragments
                                "avl" -> "aVeryLongVarWithTooManyFragments"
                            or the match is non-ambiguous, anyway
                                "xz" -> "xVariableUsedForZipping"

                            CASE SENSITIVITY
                            The search for completions honors the 'ignorecase' and
                            'smartcase' settings for underscore_words. Without
                            'ignorecase':
                                "ai" -> "an_identifier"
                                "AI" -> "AN_Identifier"
                            For CamelCaseWords, the first and each fragment after
                            a non-alphabetic keyword character must start with the
                            same case as used in the first typed letter (unless
                            'ignorecase'); all subsequent fragments must start
                            with an uppercase letter. Thus, you do not need to
                            type "aCCW"; "accw" will do, too.
                                "aCCW", "accw" -> "aCamelCaseWord"
                                "TCCW", "Tccw" -> "TheCamelCaseWord"
                            When both 'ignorecase' and 'smartcase' are set, the
                            search for completions is case-insensitive unless the
                            completion base contains uppercase characters:
                                "ai" -> "an_identifier", "AN_Identifier"
                                "AI" -> "AN_Identifier"

                            CASE-INSENSITIVE FALLBACK
                            When no (strict or relaxed) matches are found in a
                            case-sensitive ('noignorecase') search, a
                            case-insensitive search is attempted when the
                            completion base only consists of lowercase letters.
                            Therefore, you do not necessarily need to capitalize
                            the completion base when the completion candidates
                            only exist in one upper-/lower-case spelling.
                                "tccw" -> "TheCamelCaseWord"
                                (Unless "theCamelCaseWord" also exists.)
                            Cp. g:CamelCaseComplete_CaseInsensitiveFallback
                            Note that this is slightly different from setting
                            'smartcase', which offers both (upper/lower) matches
                            when a lowercase completion base is given. The
                            fallback only offers the uppercase match when no
                            such lowercase match exists (and again a lowercase
                            completion base is given).

                            NON-ALPHABETIC KEYWORD CHARACTERS
                            Each letter matches the beginning of a CamelCase or
                            underscore_word fragment. You can add non-letter
                            keyword characters (e.g. "#" after :setlocal
                            iskeyword+=#) to narrow down the number of matches:
                                "smi"  -> "specMasterIndex", "scope#myIdentifier"
                                "s#mi" -> "scope#myIdentifier"
                            When the last typed completion letter is a
                            non-alphabetic keyword, it must be followed by a full
                            CamelWord or underscore_word:
                                "Cw!"  -> "CamelWord!MoreCamel"
                                "Cw!"  -> "" -/NOT/-> "CamelWord!Word"
                            You can also use a non-alphabetic keyword character in
                            the middle to match any words that are joined by the
                            keyword character, even though they are only similar
                            to CamelWords and underscore_words:
                                "jw"   -> ""
                                "j#w"  -> "joined#words"

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-CamelCaseComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim CamelCaseComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.1 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.037 or
  higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)).

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

By default, the 'complete' option controls which buffers will be scanned for
completion candidates. You can override that either for the entire plugin, or
only for particular buffers; see CompleteHelper\_complete for supported
values.

    let g:CamelCaseComplete_complete = '.,w,b,u'

To disable the removal of the (mostly useless) completion base when there
are no matches:

    let g:CamelCaseComplete_FindStartMark = ''

You can disable the fallback to a case-insensitive search when the completion
base only contains lowercase letters. Then, (together with 'noignorecase'),
the case of the first CamelWord fragment and all underscore\_word fragments
must always match exactly:

    let g:CamelCaseComplete_CaseInsensitiveFallback = 0

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(CamelCaseComplete) mapping target _before_ sourcing the script (e.g.
in your vimrc):

    imap <C-x><C-c> <Plug>(CamelCaseComplete)<Plug>(CamelCasePostComplete)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-CamelCaseComplete/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.03    RELEASEME
-

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.037!__

##### 1.02    23-Apr-2015
- Need special case for given underscore anchor (e.g. in "f\_br" base); then,
  the assertion for alphabetic anchors (here: "b") must _not_ assert that
  there's no underscore before it.
- Remove default g:CamelCaseComplete\_complete configuration and default to
  'complete' option value instead.

##### 1.01    19-Dec-2013
- Factor out CamelCaseComplete#BuildRegexp() for re-use by the new
  InnerFragmentComplete.vim plugin.
- Add value "b" (other listed buffers) to the plugin's 'complete' option
  offered by CompleteHelper.vim 1.20.

##### 1.00    01-Feb-2012
- First published version.

##### 0.01    08-Jun-2009
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2009-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
