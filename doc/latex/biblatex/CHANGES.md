# RELEASE NOTES FOR VERSION 3.9
## Bug fix release
- Fix `\mkpagetotal`
- Fix issue with refcontexts not appearing in some circumstances
- ** DEPRECATION NOTICE ** The coming update to the ISO8601 standard
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
- `extrayear` is called `extradate` now. Limited backwards compatibility is
  in place to allow a smooth transition, but style developers should use the new name.
- The new \DeclareExtradate command allows users to track authoryear
  disambiguation in arbitrary ways now, for example allowing disambiguation
  at month or day level instead of just year. See the PDF doc for details.
- Some bibmacros from the `authoryear` style family were renamed,
  `cite:labelyear+extrayear` becomes `cite:labeldate+extradate`,
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
- Styles which supply their own location strings in .lbx files typically
  use \DeclareLanguageMapping to map a document language to the supplied
  language files. This is not ideal because the mapping has to be done by
  the user depending on the specific language. For example, for the APA
  style, in a document using American english, this line is necessary in
  every document:

  \DeclareLanguageMapping{american}{american-apa}

  so that the style supplied america-apa.lbx file is loaded. In a document
  using the german language, the user would have to use:

  \DeclareLanguageMapping{german}{german-apa}

  A new macro \DeclareLanguageMappingSuffix is now supplied which allows
  styles to register a global localisation file suffix which is appended to
  any document language automatically. This removes the need for
  \DeclareLanguageMapping in user documents as it ensures that the correct
  localisation file will be read nomatter what the document language. For
  example, the APA style (from version v7.5) now has this in apa.bbx:

  \DeclareLanguageMappingSuffix{-apa}

  which means that for a given document language <lang>, the localisation file:

  <lang>-apa.lbx

  will be loaded. \DeclareLanguageMapping, if present, will override
  \DeclareLanguageMappingSuffix.

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


