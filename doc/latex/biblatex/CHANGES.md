# RELEASE NOTES FOR VERSION 4.0
 - This is a major update with support for multiscript entryfields
 - **INCOMPATIBLE CHANGE** Default name list and plain list formats declared
    with \DeclareNameFormat and \DeclareListFormat respectively have been
    modified to support per-item language switching via the macros:

    name:langswitchon/name:langswitchoff
    list:langswitchon/list:langswitchoff

    If you use or provide custom name/list formats, you may want to look at
    the format definitions in biblatex.def to see where to place these in
    your custom formats in order to provide multiscript support for
    per-item automatic language switching. Nothing will break if you don't
    do this but there may be a loss of some aspects of multiscript
    functionality. In general, you should place the "on" macros *after*
    name:delim/list:delim and the "off" macros at the end of the format.
- **INCOMPATIBLE CHANGE** Data annotation test macros \if*annotation,
   \has*annotation and \get*annotation now have multiscript form and
   language as optional arguments in position 1 and 2, therefore, if you
   are using these macros with any optional arguments, be sure to supply
   the first two arguments (as "[][]"). For example:

   \getitemannotation[somefield] -> \getitemannotation[][][somefield]
   \ifpartannotation[][someannotationname][2]{family}{someval} -> 
     \ifpartannotation[][][][someannotationname][2]{family}{someval}
- **INCOMPATIBLE CHANGE** Namelist-specific hashes of the form
   <namelist>namehash, <namelist>bibnamehash or <namelist>fullhash now must
   contain a multiscript form and language in order to differentiate
   between multiscript name alternates. The format is now
   <namelist><msform><mslang>namehash,
   <namelist><msform><mslang>bibnamehash or
   <namelist><msform><mslang>fullhash and biber 4.0+ always generates specific
   name hashes in this format.
# RELEASE NOTES FOR VERSION 3.18b
- Reenable `\MakeUppercase`/`\MakeLowercase` "patches" for `\bibstring`
  based on `\CaseSwitch`.

# RELEASE NOTES FOR VERSION 3.18a
- Disable `\MakeUppercase`/`\MakeLowercase` patches as emergency fix
  for LaTeX 2022-06-01-PL4 compatibility.

# RELEASE NOTES FOR VERSION 3.18
- New sorting name key generation macro `\visibility` which allows
  application of sorting name key generation to apply only to sorting
  within citati
  ons.
- New sorting macro `\intciteorder` which allows sorting by order internal
  to a cite command like \cite{a,b,c}.
- New option `pluralothers` to force "et al." to be plural (i.e. only
  replace two or more names). This is required for some styles (e.g. APA)
- Added `\localrefcontext` as a local alternative
  to the global `\newrefcontext`.
  `\localrefcontext` can be nested and is only active in the current group.

# RELEASE NOTES FOR VERSION 3.17
- **INCOMPATIBLE CHANGE**
  The behaviour of index-less granular xdata references to list fields has
  changed. Before, a reference to an XDATA list field would select the
  first element in the XDATA field list if no index was given but now this
  will splice in all elements of the XDATA list field. To ensure the
  previous behaviour, simply add "-1" (assuming the default value of "-"
  for the biber 'xdatasep' option) to the end of all granaular list
  XDATA references.
- Added helper macros to enable calculations with non-ASCII numerals.
  This is necessary to properly support languages like Marathi.
  At the moment the 'translation' is very basic and uses a one-to-one
  correspondence of US-ASCII (Arabic) digits and non-ASCII digits.
  The translation also needs additional post-processing steps.
  Use `\blx@defcomputableequivalent{<numeral digit>}{<ASCII digit>}` to
  make `<numeral digit>` an equivalent of `<ASCII digit>`
  (presumably this command will be used in `.lbx` files if the language
  requires it).
  `\hascomputableequivalent{<string>}` can be used to check if `<string>`
  is a number that can be converted to a number with ASCII digits.
  `\getcomputableequivalent{<string>}{<macro>}` does the conversion
  and saves the number in `<macro>`.
  There is `\ifiscomputable{<string>}` to check if a `<string>`
  is an ASCII number OR has a computable equivalent.
  There are analogous macros for fields instead of strings.
- Added `\textouterlang` to select the last active language that
  was not selected by `biblatex` itself.
  This may help in multilingual setups where `biblatex` also changes the
  language quite heavily.
- Added `\DeclareBibstringSet`, `\DeclareBibstringSetFormat` etc.
  to allow injecting additional formatting for a set of bibstrings.
  Sets can be defined arbitrarily. These commands are primarily
  intended for use in localisation modules.
- Changed the definition of `\bibnamedelimi` to `\isdot\addnbspace`.
  Previously the definition was just `\addnbspace`, which meant the `.`
  would be treated as a period/full stop.
- **BREAKING CHANGE**
  `\DeclareDelimFormat` no longer accepts a list of names as argument.
  It only accepts a single delimiter name.
  A list of contexts is still supported.
  Note that previously the optional argument would not work correctly
  with a list of names.
- **CRITICAL CHANGE**
  `biblatex` no longer writes tracking and refsection initialisation code
  to aux files.
  Instead the `\...cite` commands are redefined locally to do that on demand.
  This should keep the auxiliary files much cleaner of `biblatex`
  intervention.
- **CRITICAL CHANGE**
  Generalised `season` date part to `yeardivision`. It can now also
  hold quarter, quadrimester, semestral or seasons with hemisphere
  designation.
  Helper macros have been renamed accordingly. Limited backwards
  compatibility is in place.
- **(Possibly) CRITICAL CHANGE**
  `\notecite` and friends no longer issue an explicit `\nocite`.
  Since the commands are defined with `\DeclareCiteCommand`, they
  already issue a normal cite request.
  The additional `\nocite` from the loop code was superfluous
  and would result in slightly instable `.bcf` files.


# RELEASE NOTES FOR VERSION 3.16
- Fixed an infinite loop caused by excessive aliasing of the `volcitepages`
  format.
  Reverted the alias `\DeclareFieldAlias{volcitepages}{postnote}`
  and again define
  ```
  \DeclareFieldFormat{volcitepages}{\mkpageprefix[pagination][\mknormrange]{#1}}
  ```
  explicitly.
# RELEASE NOTES FOR VERSION 3.15b
- Fixed `.lbx` file loading behaviour. All `.lbx` files are now loaded
  `\AtBeginDocument`. Languages that were not requested explicitly by packages
  are recorded in the `.aux` file and loaded on the next run.
  This may require a further LaTeX run in some situations, but now we can be
  sure when `.lbx` files are read.
- Added `label` option to `\printbibliography`.
- Added more name wrapper aliases to make name aliasing smoother.
- Deprecate `\mainlang` switch in favour of the text macro `\textmainlang`.
- Deprecate `\mkrelatedstring` (which is defined as `\mainlang`)
  in favour of `\mkrelatestringtext` (defined as `\textmainlang`).

# RELEASE NOTES FOR VERSION 3.15a
- Fixed bug with long argument for `\DeclareFieldFormat` and friends.

# RELEASE NOTES FOR VERSION 3.15
- Fixed a long-standing issue with `\intitlepunct`.
  The old definition
  ```
  \newbibmacro*{in:}{%
    \printtext{%
      \bibstring{in}\intitlepunct}}
  ```
  would print `\intitlepunct` directly and not via the punctuation
  buffer. Since the `\add...` punctuation macros guard against
  undesired double punctuation, this would usually not show as an
  issue (except in edge cases https://tex.stackexchange.com/q/175730/,
  https://github.com/plk/biblatex/issues/943).
  The new definition uses the punctuation tracker to print
  `\intitlepunct`.
  ```
  \newbibmacro*{in:}{%
    \bibstring{in}%
    \printunit{\intitlepunct}}
  ```
  `\printunit` is needed instead of `\setunit` to stop subsequent
  `\setunit`s from overriding `\intitlepunct` in case of missing
  fields.
- Define `volcitepages` and `multipostnote` as a field alias of `postnote`
  and `multiprenote` as an alias of `prenote`.
  That should make it easier to change all post- and prenote formats at once.
  A change to `postnote` will automatically apply to `multipostnote`
  and `volcitepages` as well. Similarly for `multiprenote`.
  In case that is not desired, the original definitions can be restored with
  ```
  \DeclareFieldFormat{volcitepages}{\mkpageprefix[pagination][\mknormrange]{#1}}
  \DeclareFieldFormat{multiprenote}{#1\isdot}
  \DeclareFieldFormat{multipostnote}{\mkpageprefix[pagination][\mknormrange]{#1}}
  ```
  
  **NB** The definition of `volcitepages` caused an infinite loop and was
  reverted in v3.15b.
  This means that only `multiprenote` and `multipostnote` are aliased.
- Unified DOI, eprint and URL printing across all entry types.
  The fields `doi`, `eprint`, `eprintclass`, `eprinttype` and `url`
  are now valid for all entry types.
  `@online` and `@unpublished` now also use the bibmacro
  `doi+eprint+url`.
  This means `@online` now responds to the `url` option.
  That does not mean, however, that a global `url=false,`
  suppresses URLs for `@online` entries,  since `url=true,`
  is set on a per-type level to ensure backwards compatibility
  as far as possible.
  In case eprint information should be suppressed for `@online`
  and `@unpublished`, add
  ```
  \ExecuteBibliographyOptions[online,unpublished]{eprint=false}
  ```
- Added `eid` to more entry types.
  To avoid issues with backwards compatibility of widely used bibmacros,
  the bibmacro `chapter+pages` was redefined from
  ```
  \newbibmacro*{chapter+pages}{%
    \printfield{chapter}%
    \setunit{\bibpagespunct}%
    \printfield{pages}%
    \newunit}
  ```
  to
  ```
  \newbibmacro*{chapter+pages}{%
    \printfield{chapter}%
    \setunit{\bibeidpunct}%
    \printfield{eid}%
    \setunit{\bibpagespunct}%
    \printfield{pages}%
    \newunit}
  ```
- Added `\bibeidpunct` in analogy to `\bibpagespunct`.
- Added `issuetitleaddon` and `journaltitleaddon` fields.
- Added options `backreffloats` and `trackfloats` to enable/disable
  citation tracking and back references in floats.
  Note that citation tracking in floats can lead to undesirable
  results in case the float objects floats too far from its "natural"
  position.
- **INCOMPATIBLE CHANGE** `numeric-comp` compresses subentry set
  references now.
  This behaviour can be disabled with `subentrycomp=false`.
- Added `subentrycomp` option to `numeric-comp` citation style.
  The option is only relevant with `subentry=true`.
  With `subentrycomp=true` set citations will be compressed
  to "1a-c" instead of "1a; 1b; 1c".
  The option is mainly intended for backwards compatibility;
  the behaviour of previous `biblatex` versions can be restored
  with `subentrycomp=false`.
- Added `\multiciterangedelim`, `\multicitesubentrydelim`,
  `\multicitesubentryrangedelim`, `\superciterangedelim`,
  `\supercitesubentrydelim`, and `\supercitesubentryrangedelim` for
  finer control over (compressed) subentry citations in `numeric-comp`.
- **CRITICAL CHANGE**
  The structure of the bibmacros in `numeric-comp`
  has been reworked to make it easier to customise the printed output.
  Documents that relied on patching internal bibmacros or heavily
  redefined them may have to adapt.
- **CRITICAL CHANGE**
  Implemented better `@set` support for BibTeX, `@set`s should now
  sort properly.
  This is achieved with a two-pass structure and (hidden) copies of
  the set entries.
  The two-pass structure means that the compilation sequence becomes
  LaTeX, BibTeX, LaTeX, BibTeX, LaTeX, LaTeX.
- **CRITICAL CHANGE**
  The case change functions now make use of the `expl3` module `l3text`
  if the available `expl3` version is recent enough.
  If `expl3` is too old the old LaTeX2e implementation is used.
  If desired the implementation of the case changing functions
  can be selected at load-time with the `casechanger` option, which
  accepts the values `expl3`, `latex2e` and `auto` (which selects
  `expl3` if the `expl3` version not older than 2020-04-06, this
  is the default).

  The `expl3` implementation of the case changer is slightly more
  robust than the home-grown `latex2e` code.
- The option `bibtexcaseprotection` can be used to turn off the
  case protection via curly braces. This allows for a saner approach
  to case protection where text is protected solely via a macro
  like `\NoCaseChange`, e.g.
  ```
  title = {The Story of \NoCaseChange{HMS \emph{Erebus}}
           in \emph{Really} Strong Wind},
  ```
  instead of
  ```
  title = {The Story of {HMS} \emph{Erebus}
           in {\emph{Really}} Strong Wind},
  ```
- Added `\mautocite` and `\Mautocite`.
- Added `\NumsCheckSetup` and `\PagesCheckSetup` for finer control
  of the `\ifnumerals` and `\ifpages` checks.
- Deprecate the starred `\DeclareDelimAlias*` in favour of
  `\DeclareDelimAlias` with optional arguments.
- **INCOMPATIBLE CHANGE**
  `biblatex` no longer falls back to English for unknown languages.
  Warnings will be triggered if undefined language strings or extras
  are used.
- **INCOMPATIBLE CHANGE**
  Bibliography strings and bibliography extras can now be written
  either to `\captions<language>` or to `\extras<language>`
  (this is controlled with the `langhook` option).
  Previously, they were written to `\extras<language>`, but upon
  reflection `\captions<language>` appears to be a more sensible
  place for these definitions.
  The new default is to write to `\captions<language>`
  (i.e. `langhook=captions`).
  The previous behaviour can be restored with `langhook=extras`.
- **INCOMPATIBLE CHANGE** Moved `\delimcontext{bib}` to `\AtUsedriver`,
  this makes it easier to override the delimiter context in `\usedriver`
  calls. `\AtUsedriver*` calls may have to be amended to include
  `\delimcontext{bib}`. The new default is
  ```
  \AtUsedriver{%
    \delimcontext{bib}%
    \let\finentry\blx@finentry@usedrv
    \let\newblock\relax
    \let\abx@macro@bibindex\@empty
    \let\abx@macro@pageref\@empty}
  ```
  Note that this definition is backwards compatible
  and can be used in older versions as well (down to v3.4 2016-05-10).
- `biblatex` now tests if a requested backend (re)run happened by
  comparing the MD5 hashes of the new and old `.bbl` files.
- Added file hooks `\blx@filehook@preload@<filename>`,
  `\blx@filehook@postload@<filename>`
  and `\blx@filehook@failure@<filename>`
  to execute hooks before or after a file is loaded
  or if the loading fails.
  `\blx@lbxfilehook@simple@preload@<filename>`,
  `\blx@lbxfilehook@simple@postload@<filename>`
  and `\blx@lbxfilehook@simple@failure@<filename>`
  as well as
  `\blx@lbxfilehook@once@preload@<filename>`,
  `\blx@lbxfilehook@once@postload@<filename>`
  and `\blx@lbxfilehook@once@failure@<filename>`
  are the equivalents for `.lbx` loading, where
  files may be loaded several times in some situations.
- Added limited support for 'nodate' with BibTeX.
- Improved `babel` and `polyglossia` interfacing (avoids more or less
  unsupported patches).
  This should work with `babel` at least v3.9r (2016/04/23)
  and polyglossia `polyglossia` v1.49 (2020/04/08) or later.
- **INCOMPATIBLE CHANGE** Removed list and name index wrappers
  (`\DeclareIndexNameWrapperFormat`, `\DeclareIndexListWrapperFormat`
  and friends). Those wrappers make no sense, since the indexed
  names are not printed 'together' in any useful sense of the word
  and were never working anyway.
- **CRITICAL CHANGE** Generalised some keyval macros.
  `biblatex`-related uses of `\define@key` should ideally replaced with
  `\blx@kv@defkey`.
  Style authors are advised not to rely too much on the internal
  implementation of certain keyval interfaces.
  Users who want to experiment with using a different underlying
  keyval parser need only provide replacements of the `\blx@kv@...`
  macros (which are defined via `\provide...` so that they will
  not overwrite existing definitions; in particular users can define
  those replacements before loading `biblatex`).
- Deprecate `\ifkomabibtotoc` and `\ifkomabibtotocnumbered`.
  With newer versions of KOMA-Script these tests are no longer used
  and their implementation was always a bit shifty (they would only pick
  up globally set options).


# RELEASE NOTES FOR VERSION 3.14
- biber from version 2.14 has extended, granular XDATA functionality to
  allow referencing from and to parts of fields. This makes XDATA entries into
  more general data sharing containers.
- Biber applies Perl's Unicode case folding to normalise the
  capitalisation of field names and entry types when reading from the
  `.bib` file. The output in the `.bbl` (what comes out on the
  `biblatex` side uses the capitalisation from the data model; the only
  exception are unknown entry types which are passed on *exactly*
  as they are given in the `.bib` file - of course it is strongly
  recommended to define all entry types one intends to use in the
  data model).
- `biblatex` now interfaces with `polyglossia` much better and can deal
  with language variants.
  Note that `polyglossia` v1.45 (2019/10/27) is required for this
  to work properly, it is strongly recommended to update `polyglossia`
  to this or a later (current) version.

# RELEASE NOTES FOR VERSION 3.13
- **INCOMPATIBLE CHANGE** Any custom per-entry options in datasources must
  be defined with `\DeclareEntryOption` in order for biber to recognise
  them and pass them out in the `.bbl`.
  This should not adversely affect any code using the documented
  `\Decalare...Option` interface, so should be uncritical for most users.
- Added `\DeclareBiblatexOption` as a convenient interface to declare the same
  option in different scopes. This should help avoid code duplication.
  For example
  ```
  \DeclareBibliographyOption[boolean]{noroman}[true]{%
    \settoggle{blx@noroman}{#1}}
  \DeclareTypeOption[boolean]{noroman}[true]{%
    \settoggle{blx@noroman}{#1}}
  \DeclareEntryOption[boolean]{noroman}[true]{%
    \settoggle{blx@noroman}{#1}}
  ```
  can be replaced with
  ```
  \DeclareBiblatexOption{global,type,entry}[boolean]{noroman}[true]{%
    \settoggle{blx@noroman}{#1}}
  ```
- Following the introduction of `\DeclareBiblatexOption` extend the scope
  of a few options (`abbreviate`, `citetracker`, `clearlang`, `dataonly`,
  `dateabbrev`, `<namepart>inits`, `ibidtracker`, `idemtracker`, `labelalpha`,
  `labelnumber`, `labeltitle`, `labeltitleyear`, `labeldateparts`,
  `loccittracker`, `opcittracker`, `singletitle`, `skipbib`, `skipbiblist`,
  `skipbiblab` `terseinits`, `uniquelist`, `uniquename`, `uniquetitle`,
  `uniquebaretitle`, `uniquework`, `uniqueprimaryauthor`).
- Furthermore, the standard style options `doi`, `eprint`, `isbn`, `url`,
  `related` are now available also on a per-type and per-entry level.
  The same holds for `mergedate`, `subentry` and the options of `reading.bbx`.
  This change has the potential to clash with custom styles that already define
  the standard options at these scopes.
- Promote `@software` to regular entry type and define `@dataset`.
  `@software` is aliased to the `@misc` driver,
  `@dataset` has a dedicated driver.
- Add `\ifvolcite` test to check if the current citation is in a `\volcite`
  context.
- Add the special fields `volcitevolume` and `volcitepages` for finer control
  over the `\volcite` postnote.
- Add `\AtVolcite` hook to initialise `\volcite` commands.
- Add `\mkbibcompletename` as well as `\mkbibcompletename<formatorder>`
  to format complete names.
  The commands are analogous to `\mkbibname<namepart>` but apply to
  the entire name printed in format order `<formatorder>`.
  By default the predefined macros all expand to `\mkbibcompletename`.
- Add `multiprenotedelim` and `multipostnotedelim` and make all
 `(pre|post)notedelim`-like commands context sensitive.
- Add rudimentary support for `labelprefix` with BibTeX backend.
  Biber implements `labelprefix` via `refcontext`s, but BibTeX does not
  actually support `refcontext`s. The user interface is retained, but BibTeX's
  "`refcontext`s" support only the emulation of `labelprefix` and nothing more.
  There might be subtle differences between Biber's and BibTeX's
  `labelprefix` behaviour, but it should be better than nothing.
  If you need full `labelprefix` support, please consider switching to Biber.
- Add `\thefirstlistitem`, `\strfirstlistitem` and `\usefirstlistitem` to
  grab and use the first item of a field.
- Add `\isdot` to the format for `journaltitle` so that `.`s at the end of the
  `journal(title)` field are automatically treated as abbreviation dots and not
  sentence-ending periods. To restore the old behaviour add
  ```
  \DeclareFieldFormat{journaltitle}{\mkbibemph{#1}}
  ```
  to the preamble.
- Add second optional item post processing argument to `\mkcomprange`,
  `\mknormrange` and `\mkfirstpage`. It can be used to post process
  every number item in the formatted range separately. It can for
  example turn cardinal ranges into ordinal ranges (this is done in
  the Latvian localisation module).
- Add further customisation options for strings typeset with `url`'s `\url`
  command (mainly URLs and DOIs). It is now possible to add a bit of
  stretchable space after characters with `biburlnumskip`, `biburlucskip`
  and `biburlucskip`. The previously hard-coded (stretacheble) space
  `\biburlbigskip` as well as the penalties `biburlbigbreakpenalty` and
  `biburlbreakpenalty` are also configurable now.
- Add `\DeclarePrintbibliographyDefaults` to set default values for some
  option keys to `\printbibliography` and friends.
- `\nocite` is now enabled in the bibliography (previously it was
  deactivated in the bibliography).
  Please report any issues that this may cause.
- The internals macros `\abx@aux@cite`, `\abx@aux@refcontext`
  and `\abx@aux@biblist` are now called every time an entry is cite
  (and appears in a bibliography or biblist, respectively).
  This helps to avoid unwanted side-effects when writing to aux files
  is disabled.
- `\nohyphenation` and `\textnohyphenation` now rely on a (fake)
  language without hyphenation patterns instead of `\lefthyphenmin`,
  which means that the command can now be used anywhere in a paragraph,
  see also <https://texfaq.org/FAQ-hyphoff>.
  Note that switching languages with `babel` *within* those commands
  removes the hyphenation protection.
- Allow `doi` field for `@online` entries. This field was previously
  not printed in the `@online` driver. In case DOIs appear where
  they should not appear the output of earlier versions can be
  recreated with
  ```
  \ExecuteBibliographyOptions[online]{doi=false}
  ```
  since the `doi` option is now available on a per-type level.


# RELEASE NOTES FOR VERSION 3.12
- **INCOMPATIBLE CHANGE** The syntax for defining data annotations in the
  BibLaTeXML data source format has changed to accommodate named
  annotations. Annotations are no longer attributes but are fully-fledged
  elements. It is not expected that this will impact any current users.
- **INCOMPATIBLE CHANGE** The field/fieldset argument to the `\translit`
  command is now  mandatory to allow for a new optional argument which
  restricts transliteration to entries with particular `langid` fields.
- The field `sortyear` is an integer field now and not a literal. This is
  because the `sortX` fields should be the same datatype as the `X` field
  as sorting depends on this. This fixes an issue where years were not
  sorted properly as integers. `sortyear` was sometimes used to tune date
  sorting as in "1984-1", "1984-2" etc. for multi-volume collections with
  the same year. However, this is really an abuse of the sorting template
  system since this should be done by having a semantically more granular
  sorting item to differentiate below the year level (typically, `volume`
  does this for multi-volume works and this is already part of all default
  sorting templates). The example .bib that comes with biblatex has been
  changed to remove such `sortyear` abuses and the sorting is not impacted
  as they examples using this already have either `volume` or `sorttitle`
  which made this abuse of `sortyear` unnecessary anyway.
- The field `number` is a literal field now and not an integer. This allows for
  a wider range of possible input such as "S1", "Suppl. 1", "1-3".
  If you want to sort by `number` and only have integers in there, you should
  consider using a custom data model to turn `number` back into an integer type
  field, since sorting integers as literals has performance implications and
  might lead to undesired sorting such as "1", "10", "2".
- **INCOMPATIBLE CHANGE** Removed the 'semi-hidden' option `noerroretextools`.
  If you want to load `noerroretextools` now, you need to define the macro
  `\blx@noerroretextools` instead. This can for example be done with
  ```
  \usepackage{etoolbox}
  \cslet{blx@noerroretextools}\empty
  \usepackage{biblatex}
  ```
  or
  ```
  \makeatletter
  \let\blx@noerroretextools\@empty
  \makeatother
  \usepackage{biblatex}
  ```
  You still need to make sure that all macros used by `biblatex` are restored
  to their `etoolbox` definitions before loading `biblatex`.
- New macro `\abx@missing@entry` to style missing entrykeys in citations.
- Added field format deprecation macros `\DeprecateFieldFormatWithReplacement`
  and friends.
- Add `\ifdateyearsequal` to check if two dates have the same year and era
  date part. Since `year`s are always non-negative integers and the 'sign' is
  stored as the `era`, you should use `\ifdateyearsequal` instead of a simple
  `\iffieldequals{#1year}{#2year}` to compare years. The latter can lead to
  undesired results if the years have opposite signs, but are otherwise the
  same.
- New values `part+`, `chapter+`, `section+` and `subsection+` for 'section'-
  valued options `refsection`, `refsegment` and `citereset`. These options
  are then executed at not only the specified level of sectioning, but also
  all higher levels.
- Add second optional argument to `\DeclareDelimAlias*`.
- Allow keywords for dataonly/skipped entries as well.
- Added `maxcitecounter`.
- Deprecate `\labelnamepunct` in favour of the context-sensitive
  `nametitledelim`.
  For compatibility reasons `\labelnamepunct` still pops up in the code here
  and there, but `nametitledelim` should be preferred now.
- The `xstring` package is not loaded by default any more.
  Style developers whose styles make use of that package should load it
  explicitly.
- `authoryear.bbx` now has a macro `bbx:ifmergeddate` that can be used to
  check whether the date has been printed at the beginning of an entry
  and can thus be suppressed later in the `date` and `issue+date` macros.
  The macro works like a test and expands to the `<true>` branch if the date
  has been merged and can be suppressed, it expands to `<false>` if the date
  has not been merged. In practice `\printdate` should then be issued
  if and only if the test yields false.

  This change means that the definition of the `date` macro can be the same for
  all mergedate settings and that only `bbx:ifmergeddate` is redefined for
  each different value. No backwards compatibility issues are expected,
  but style authors are encouraged to test the changes and see if the new
  macro could be useful for their styles.
- For a long time `biblatex` has defined `\enquote` if `csquotes` was not
  loaded. This behaviour was not documented, the official command intended
  for quotation marks was always `\mkbibquote`. Because `biblatex` should not
  (re)define user-level commands that are not primarily associated with
  citations or the bibliography, from this release on `\enquote` is not defined
  any more, instead the internal command `\blx@enquote` is defined and used.
  The same holds for `\initoquote`, `\initiquote`, `\textooquote`,
  `\textcoquote`, `\textoiquote`, `\textciquote`.
  `biblatex` still defines the internal commands `\@quotelevel`, `\@quotereset`
  and `\@setquotesfcodes` if `csquotes` is not loaded.

  Users are encouraged to use `csquotes` for proper quotation marks, but can
  get back the old behaviour with
  ```
  \makeatletter
  \providerobustcmd*{\enquote}{\blx@enquote}
  \makeatother
  ```
  or
  ```
  \newrobustcmd*{\enquote}{\mkbibquote}
  ```
- Add new list wrapper and name wrapper formats (`\DeclareListWrapperFormat`,
  `\DeclareNameWrapperFormat`) to style a (name) lists in its entirety.
  This is useful because name and lists formats normally style only one
  particular item of the list. The wrapper format can be used to easily format
  the entire list in italics, for example.
- `\DeclareCitePunctuationPosition` can be used to configure the punctuation
  position for citation commands similar to the optional `position` argument
  of `\DeclareAutoCiteCommand`.
- If the `\pdfmdfivesum` primitive is available (via `pdftexcmds`'
  `\pdf@mdfivesum`) the `labelprefix` value is hashed for internal use, making
  it safer for construction of macro names and the like. If you don't like
  that you can turn off the behaviour by redefining `\blx@mdfivesum`. The
  fallback in case `\pdf@mdfivesum` is unavailable is
  ```
  \let\blx@mdfivesum\@firstofone
  ```

  As before the labelprefix value is fully expanded before use. If its contents
  are unexpandable you need to avoid expansion with `\detokenize`.

# RELEASE NOTES FOR VERSION 3.11
- `\printbiblist` now supports `driver` and `biblistfilter` options
  to change the defaults set by the biblistname.
- Add `\mknormrange` to normalise page ranges without compressing them.
- **INCOMPATIBLE CHANGE** The format for `postnote` (`multipostnote`,
  `volcitepages`) normalises page ranges with `\mknormrange`.
  Since `\mknormrange` acts only on page ranges as detected by
  `\ifpages`, this does not affect text other than page ranges.
  Hyphens and dashes in page ranges will be transformed to
  `\bibrangedash`, commas and semicolons to `\bibrangesep`.
  This is analogous to Biber's treatment of page-like fields.
  If you always separated page ranges with `--` or `\bibrangedash`
  anyway, this should not change the output you get.
  If you used a single hyphen to separate page ranges (e.g., `23-27`)
  you will now get the arguably more aesthetically pleasing output
  with `\bibrangedash`.
  In case you want to restore the old behaviour where page ranges were
  not normalised add the following three lines to your preamble.
  ```
  \DeclareFieldFormat{postnote}{\mkpageprefix[pagination]{#1}}
  \DeclareFieldFormat{volcitepages}{\mkpageprefix[pagination]{#1}}
  \DeclareFieldFormat{multipostnote}{\mkpageprefix[pagination]{#1}}
  ```
  Style developers may note that the field format for `pages`
  was not changed to include `\mknormrange` because the contents
  of that field are prepared by the backend and Biber already does
  the page range normalisation out of the box.
- The standard definitions for headings were changed to be as close to the
  defaults of the standard document classes or KOMA/memoir as possible.
  **PLEASE CHECK** if your document headers relied on the behaviour of older
  versions.
- The `@unpublished` entry type now also supports `type`, `eventtitle`,
  `eventdate` and `venue`.
- A long-standing bug with punctuation before `eventdate` and `venue` was fixed.
  Originally the round brackets were supposed to be preceded only by a space,
  the addition of other fields caused this space to be replaced by new unit
  punctuation. **PLEASE CHECK** if you can accept the changed output.
- Added `\ifdateannotation`. Added optional argument for field and item to
  `\iffieldannotation`, `\ifitemannotation`, and `\ifpartannotation`.
- `\DeclareSourcemap` can now be used multiple times.
- **INCOMPATIBLE CHANGE** Language aliases are now also resolved when loading
  localisation files, only infinite recursion is avoided.
  Assuming `\DeclareLanguageMappingSuffix{-apa}`, loading `ngerman` localisation
  causes `ngerman-apa.lbx` to be read. If that file inherits from `german`,
  `german-apa.lbx` will be read. Previously only `german.lbx` would have been
  read at that point. Of course if `german-apa.lbx` inherits from `german`,
  `german.lbx` is loaded at that point, so infinite recursion is avoided.
- **CRITICAL CHANGE** The code to load localisation files was changed.
  This is a an internal change and should not influence document output,
  save for a few bug fixes. Style authors should check if the changes introduce
  any bugs for their localisation handling and report them.
- Added `\begrelateddelim` and `\begrelateddelim<relatedtype>` for punctuation
  before the related block. **PLEASE CHECK** that this change does not interfere
  with your punctuation settings. The change should be backwards compatible,
  but might give different results if `\usebibmacro{related}` is used in
  unusual positions.
- Added `locallabelwidth` option to control the label spacing in bibliographies,
  if set to true, the label width will be calculated locally for the current
  bibliography and not globally from a list of all citation.

# RELEASE NOTES FOR VERSION 3.10
- **INCOMPATIBLE CHANGE** The recent ISO8601:201x standard supersedes
  the draft EDTF (Extended Date Time Format) extensions. Biblatex therefore
  now supports the ISO8601-2 Clause 4, Level 1 Extended Format which is
  equivalent to the draft EDTF standard but with different syntax. *This
  syntax is in some cases not backwards compatible*. Biblatex will not
  support backwards compatibility for the draft EDTF syntax because it is
  too messy to do so and few people were using this anyway since it is a
  relatively new and specialised feature. Please note these syntax changes
  which effect only the formatting of DATE fields in bibliography datasources:
  - The "unspecified" marker "u" is now "X"
  - An approximate+uncertain date is now indicated with "%" rather than "?~"
  - Open dates are now marked with ".." instead of "open" or blank
    start/end dates.
  - Unknown dates are now indicated by blank start/end dates rather than
    "unknown" or "*"
- Unicode support code that is problematic for non-Unicode engines,
  but useful for XeTeX and LuaTeX now resides in `blx-unicode.def`.
  That file is only read by XeTeX and LuaTeX.
- The option `noerroretextools` demotes the incompatibility error for
  `etextools` to a mere warning if set to `true`. Users still need
  to make sure that `\forlistloop` has the definition from `etoolbox`
  and not the completely incompatible definition from `etextools`.
  This option is meant as a last resort for people who must at all
  costs load `etextools` or a package that uses it.
  `noerroretextools=true` will always cause a warning even if
  `etextools` is not loaded.

# RELEASE NOTES FOR VERSION 3.9
## Bug fix release
- Fix `\mkpagetotal`
- Fix issue with refcontexts not appearing in some circumstances
- **DEPRECATION NOTICE** The coming update to the ISO8601 standard
  supercedes the draft EDTF (Extended Date Time Format) extensions.
  When the new ISO8601 standard is public, biblatex will therefore
  support the ISO8601-2 Clause 4, Level 1 Extended Format which is
  equivalent to the draft EDTF standard but with different syntax. This
  syntax is in some cases not backwards compatible. Biblatex will not
  support backwards compatibility for the draft EDTF syntax because it is
  too messy to do so and few people were using this anyway since it is a
  relatively new and specialised feature. Please note these syntax changes
  which will effect only the formatting of DATE fields in bibliography
  datasources:
   - The "unspecified" marker `u` is now `X`
   - An approximate+uncertain date is now indicated with `%` rather than `?~`
   - Open dates are now marked with `..` instead of `open` or blank start/end dates.
   - Unknown dates are now indicated by blank start/end dates rather than `unknown` or `*`

# RELEASE NOTES FOR VERSION 3.8a
## Bug fix release
- Documentation version fix and loop fix in certain styles

# RELEASE NOTES FOR VERSION 3.8
## Requirements
Biber version 2.8 is required for biblatex 3.8

## In order to standardise terminology, some commands and options have dropped the "scheme" naming convention and switched to "template"
- `\DeclareSortingScheme` is now `\DeclareSortingTemplate`
- `\DeclareSortingNamekeyScheme` is now `\DeclareSortingNamekeyTemplate`
- The "sortingnamekeyscheme" option is now "sortingnamekeytemplate"

## `\DeclareLabelalphaNameTemplate` no longer has entrytype scope
- **INCOMPATIBLE CHANGE** The optional first argument to
  `\DeclareLabelalphaNameTemplate` was previously an entrytype but is now an
  arbitrary template name, as with `\DeclareUniquenameTemplate`. This is to
  allow multiple definitions which can be referred to at different scopes.
  It is unlikely that anyone used this with entrytype scope anyway.

## `origlanguage` is now a list instead of a field.
- **INCOMPATIBLE CHANGE** Since this is mostly used to generate localisation strings like
  'Translated from the <language>' via the internal macros `lbx@lfromlang`
  and `\lbx@sfromlang`, users and style authors should not see any
  differences. However, if your style prints `origlanguage` directly using
  `\printfield`, this will need to be changed to `\printlist`.

## Name handling enhancements
- Name handling is now fully generalised to cover arbitrary name parts.
  The final few pieces have been completed to allow fully customisable
  name handling, allowing for better internationalisation. The code for
  name uniqueness calculation and label generation for names is now fully
  abstracted: templates created with `\DeclareUniquenameTemplate` and
  `\DeclareLabelalphaNameTemplate` may now be specified at per-refcontext,
  per-entry, per-namelist and per-name scope, which allows complete
  control over all aspects of name usage. See the comments in the enhanced
  `93-nameparts.tex` example file.

## `extrayear` is now `extradate` and the information used to track this can be customised
- **INCOMPATIBLE CHANGE** `extrayear` is called `extradate` now.
  Limited backwards compatibility is
  in place to allow a smooth transition, but style developers should use the new name.
- The new `\DeclareExtradate` command allows users to track authoryear
  disambiguation in arbitrary ways now, for example allowing disambiguation
  at month or day level instead of just year. See the PDF doc for details.
- **INCOMPATIBLE CHANGE** Some bibmacros from the `authoryear` style family
  were renamed, `cite:labelyear+extrayear` becomes `cite:labeldate+extradate`,
  `cite:extrayear` is `cite:extradate` now, and `date+extrayear`
  is `date+extradate`. Some backwards compatibility code is present,
  but developers should make sure their code works as expected.

## Date formatting
- The `mergedate` output has been restored to its earlier form,
  it has also been extended to cover all EDTF date parts.
  In order to facilitate this, a few date-related tests were introduced
  `\iflabeldateisdate`, `\ifdatehasyearonlyprecision`, `\ifdatehastime`
  and `\ifdateshavedifferentprecision`.
- The `authoryear` citation styles now use `\printlabeldateextra`
  instead of `\printfield{labelyear}\printfield{extrayear}`.
  This should have no consequences for end users (except that
  dates in citations and bibliography don't differ any more -
  previously there were subtle differences when many EDTF features
  were used), but style developers should check if they assume
  anything about the bibmacros that have now changed.
  Style developers are invited to have a look at the changes and
  to get inspired to offer full EDTF format for their styles as well.

## Set handling
- Static entry sets used to have the behaviour that when citing a member of
  a set, the data for the citation came from the set parent which was in
  turn taken from the first member of the set. In most use cases, the only
  part of the set parent data that was actually used was the labels but in
  certain edge cases, other data was used which results in confusing
  citations for set members. This has been refactored so that when citing
  set members, the member data is used along with some labelling data
  injected from the set parent. This means that things like
  `\citeauthor{somesetmember}` now give the expected results.
  *PLEASE NOTE* that this means that citing sets directly in default styles *not*
  based on labels (`authoryear`, `authortitle`, `verbose` etc.) will result
  in blank citations as it is not envisaged that sets are useful in such
  styles.
- The members of a set can now be sorted according to the active
  sorting scheme, this is enabled via the `sortsets` option.
  By default the option is set to false and set members appear
  in the order given in the data source.
- The `alphabetic` style family now also supports the `subentry`
  option.

## Localisation and styles
- Styles which supply their own location strings in `.lbx` files typically
  use `\DeclareLanguageMapping` to map a document language to the supplied
  language files. This is not ideal because the mapping has to be done by
  the user depending on the specific language. For example, for the APA
  style, in a document using American English, this line is necessary in
  every document:
  ```
  \DeclareLanguageMapping{american}{american-apa}
  ```
  so that the style supplied `america-apa.lbx` file is loaded.
  In a document using the German language, the user would have to use:
  ```
  \DeclareLanguageMapping{german}{german-apa}
  ```
  A new macro `\DeclareLanguageMappingSuffix` is now supplied which allows
  styles to register a global localisation file suffix which is appended to
  any document language automatically. This removes the need for
  `\DeclareLanguageMapping` in user documents as it ensures that the
  correct localisation file will be read nomatter what the document language.
  For example, the APA style (from version v7.5) now has this
  in `apa.bbx`:
  ```
  \DeclareLanguageMappingSuffix{-apa}
  ```
  which means that for a given document language `<lang>`
  the localisation file `<lang>-apa.lbx` will be loaded.
  `\DeclareLanguageMapping`, if present, will override
  `\DeclareLanguageMappingSuffix`.

## Context-sensitive delimiters
- Several delimiter macros now use the context-sensitive delimiter interface
  introduced in version 3.4 (`\DeclareDelimFormat`). This change is fully
  backwards compatible, but style developers should feel encouraged to use the
  new commands `\DeclareDelimFormat` and `\printdelim`.
- Three new delimiters are introduced. `authortypedelim`, `editortypedelim`,
  and `translatortypedelim` control the delimiter between the respective name
  and the following `<name>` bibstring.
  This together with `\DeclareFieldFormat{<name>type}` allows one to go from
  'E. Ditor, ed.' to 'E. Ditor (ed.)' more easily without the need
  to redefine entire bibmacros.
- `\DeclareDelimAlias` allows one to alias one delimiter to another.
  E.g. `\DeclareDelimAlias{finalnamedelim}{multinamedelim}`
  will make `finalnamedelim` an alias for `multinamedelim`.
  The starred version `\DeclareDelimAlias*` is local to the
  specified contexts.

## Misc changes
- The initialisation code for `\usedriver` can now be modified via
  `\AtUsedriver`, the code can be executed with `\UseUsedriverHook`.
  The default settings retain backwards compatibility with earlier
  versions.
- The field `urlraw` contains the unencoded, raw version of the URL.
  If the URL includes Unicode characters, `urlraw` will show them
  unencoded while the standard `url` field will contain them in
  percent-encoded form.
- `\mkpagetotal` now has its own bibstrings `<pagination>total(s)`
  Previously it relied on the `<pagination>(s)` bibstrings.
- `sortyear` is now a literal field and not an integer.
- The `etextools` package is now officially incompatible.
- `bidi`-support for footnotes was improved.
- `\ifentryseen`, `\ifentryinbib`, `\ifentrycategory`
  and `\ifentrykeyword` can now be used outside of
  `biblatex` macros directly in the document.
- `\letbibmacro` can be used to create bibmacro aliases as if
  using `\let`.
- `\DeprecateFieldWithReplacement`, `\DeprecateListWithReplacement`
  and `\DeprecateNameWithReplacement` can be used to deprecate a field,
  name or list and replace it with a new one.

# RELEASE NOTES FOR VERSION 3.7
## Requirements
Biber version 2.7 is required for biblatex 3.7

Bugfix release.

# RELEASE NOTES FOR VERSION 3.6
## Requirements
Biber version 2.6 is required for biblatex 3.6

This is a minor bugfix release.

# RELEASE NOTES FOR VERSION 3.5
## Requirements
Biber version 2.6 is required for biblatex 3.5

## Name support
- **INCOMPATIBLE CHANGE** The labelling system has been generalised
  to be able to deal better with names. `\DeclareLabelalphaTemplate` no
  longer uses hard-coded name parts (prefix, family) when extracting label
  parts from name fields. Name field label extraction now obeys the new
  `\DeclareLabelalphaNameTemplate` specification which details how to extract
  label information from each namepart known to the data model. The default
  setting is backwards compatible with the old hard-coded behaviour.
  However, if you have custom `\DeclareLabelalphaTemplate` specifications,
  you should note that the "pcompound" and "pstrwidth" options to `\field`
  are now gone and replaced with the relevant settings on `\namepart` in
  `\DeclareLabelalphaNameTemplate`. The old options will generate warnings.
  It is too complex to provide backwards compat for this, sorry - please
  update your templates if necessary. This is one of the last changes
  needed to fully generalise name handling.

## Date input and output
Major enhancements to the dates parsed by biblatex and the output formats
available. Biblatex now supports [[http://www.loc.gov/standards/datetime/pre-submission.html][EDTF]] level 0 and 1. This is an enhanced
ISO8601v2004 format suitable for bibliographic data. The new support is a
superset of the previous limited ISO8601 support. Times are now fully
supported in various formats as online sources become more common and time
specifications for such sources are increasingly important. Tests and
localisation strings are provided to use EDTF information about date
uncertainty, era, approximation etc. in styles. A new example document
(96-dates.tex) is provided which demonstrates the new features. See the PDF
manual and its changelog for details of usage. The new date format
functionality is backwards compatible. The following changes are more
detailed and mostly of interest to style authors:

- The `iso8601` date output format is now called `edtf`. The old name will
  automatically use `edtf` and issue a deprecation warning.
- `\bibdatedash` is now `\bibdaterangesep` as this name is more
  informative and more descriptive of how it is actually used. A backwards
  compat alias is provided.
- Pre-biblatex 2.0 legacy sorting scheme definition macros `\name` and
  `\list` are now deprecated with warnings.
- **INCOMPATIBLE CHANGE** The `labeldate` option is renamed to
  `labeldateparts`. The `datelabel` option is renamed to `labeldate` to
  provide consistency with all other date options. Backwards compatibility
  is provided and warnings will be issued.
- The new date system necessitated changes to the default year printing
  routine for citations in the default authoryear styles. If you wish to
  take advantage of the new date features like circa, uncertainty and eras,
  when printing citations in authoryear styles, see the enhanced
  `cite:labelyear+extrayear` macros in any of the default authoryear
  styles.
- The `labelyear` field was inconsistently implemented and in fact could
  sometimes contain a date range which made handling it rather difficult.
  It is now guaranteed to contain only one year, when it is a copy of an
  existing datepart field found by `\DeclareLabeldate` (`labelyear` can
  contain a literal/bibstring or non date field too). A new field
  `labelendyear` will contain the end of the labeldate year range. The same
  applies to labelmonth and labelday.
- The internal macros `\mkbibrange*` have all been changed to
  `\mkdaterange*` to make the name more obvious (since they only deal with
  dates) and for consistency with the new `\mktimerange*` macros. These
  macros are usually only used in style .lbx files and the old names will
  generate a deprecation warning.
- The option `datezeros` was inconsistent as it did not enforce zeros when
  set to 'true', it merely preserved the field. In the new date internals,
  leading zeros are not present after date parsing as this should always be
  a formatting/style decision. Now, `datezeros` enforces leading zeros and
  also handles all date parts.
- `\mkdatezeros` has been replaced with `\mkyearzeros`, `\mkmonthzeros` and
  `\mkdayzeros` due to the date internals changes which are more consistent
  about integer formats of date parts. `\mkdatezeros` now generates a
  deprecation warning and calls `\mkmonthzeros` which is backwards compatible
  with its old behaviour.
- **INCOMPATIBLE CHANGE** The .bbl field `datelabelsource` has been renamed to
  `labeldatesource` to prevent confusion with other fields. In the unlikely
  event that you referenced this field in a style, please change the name.
- **INCOMPATIBLE CHANGE** The macro `\printdatelabel` has been renamed to
  `\printlabeldate` in line with the naming of all other date printing
  macros. Please use the new name. The old one will issue a deprecation warning.
- **INCOMPATIBLE CHANGE** The macro `\printdatelabelextra` has been renamed to
  `\printlabeldateextra` in line with the naming of all other date printing
  macros. Please use the new name. The old one will issue a deprecation warning.

## Misc changes
- The experimental RIS format support is no longer available as it was
  rarely used and made biber maintenance more complicated. RIS is a very
  primitive format and not much use anyway.
- **INCOMPATIBLE CHANGE** The `singletitle` option no longer considers the
  presence of labeltitle if labelname does not exist. This has always been
  potentially confusing. For several versions now, there has been a
  separate test and option for labeltitle called "uniquetitle".
- **INCOMPATIBLE CHANGE** The `sortgiveninits` option has been deprecated and
  the functionality generalised. It is replaced by the "inits" option to
  `\namepart` in `\DeclareSortingNamekeyScheme`. Any nameparts may now
  therefore be sorted using initials only.
- **INCOMPATIBLE CHANGE** The sorting subsystem in biber has been completely
  re-engineered to support better sorting of different datatypes.
  Previously, due to bibtex limitations, all sorting was lexical, even for
  numbers. This is why the padding options for things like volume in the
  default sorting specifications existed - so that lexical sorts for
  numbers would work. With the enhancement of the date parsing routines to
  include negative years, in order to sort these properly, it was time to
  switch to a better sorting method. As a result, the datatypes of fields
  is now a bit stricter, as it should be. Expect more changes in this
  direction but for this release, the datatype of the following fields in
  the default data model have been changed to 'integer':

  - number
  - sortyear
  - volume
  - volumes

  Integer datatypes no longer need padding or literal fallbacks in the
  sorting scheme definitions since they are now sorted properly as
  integers. Such datatype changes only effect sorting.


