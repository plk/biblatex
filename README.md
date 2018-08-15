# Overview

This package provides advanced bibliographic facilities for use with LaTeX.

The package is a complete reimplementation of the bibliographic facilities
provided by LaTeX. A custom backend Biber is used by default which
processes BibTeX format data files and them performs all sorting, label
generation (and a great deal more).

Biblatex does not use the backend to
format the bibliography information as with traditional BibTeX: instead of
being implemented in BibTeX style files, the formatting of the bibliography
is entirely controlled by TeX macros.

This package supports subdivided
bibliographies, multiple bibliographies within one document with different
sorting, separate lists of bibliographic information such as abbreviations
of various fields.
Bibliographies may be subdivided into parts and / or
segmented by topics.

Just like the bibliography styles, all citation
commands may be freely defined.

With Biber as the backend, features such
as customisable sorting, multiple bibliographies with different sorting,
customisable labels, dynamic data modification and custom data models are
available.

The package is completely localised and can interface with
the Babel and Polyglossia packages. Read below for how to
update and/or add translations.

# Copyright and Licence

## Authors
- Philipp Lehman
- Philip Kime, Joseph Wright, Audrey Boruvka (since 2011)

## Copyright
- Copyright 2006 --- 2011 Philipp Lehman
- Copyright 2011 --- ... Philip Kime

## Licence
This work may be distributed and/or modified under the conditions of the LaTeX Project Public License, either version 1.3 of this license or (at your option) any later version.

The latest version of the license is in [https://www.latex-project.org/lppl.txt](https://www.latex-project.org/lppl.txt) and version 1.3 or later is part of all distributions of LaTeX version 2003/06/01 or later.

This work has the LPPL maintenance status "maintained".

# Installation

biblatex is bundled with TeXLive and its variants as well as MikTeX.
Normally you can install and update biblatex through your TeX distribution.

biblatex starts life on Github where you can always find development
releases:

[https://github.com/plk/biblatex](https://github.com/plk/biblatex)

From here, it is packaged for general consumption to SourceForge:

[https://sourceforge.net/projects/biblatex](https://sourceforge.net/projects/biblatex)

this is where users can download the current development version.

The latest official release is then put onto CTAN, which is where users can
get the latest stable version:

[https://ctan.org/pkg/biblatex](https://ctan.org/pkg/biblatex)

## Installation from github

For this you'll need to be on a UNIX-like system (use
[https://www.cygwin.com](cygwin) on Windows) that has bash and perl.

You should only install from github if you want to check out the bleeding edge
of development or if there is absolutely no way to obtain either the official
historical releases from
[SourceForge](https://sourceforge.net/projects/biblatex/files/) 
or the current release from [CTAN](https://www.ctan.org/pkg/biblatex).
Remember that you will need a matching Biber version (the binaries are
distributed on [SourceForge](https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/)).

First clone the repo:
```
git clone https://github.com/plk/biblatex.git
```
Then from the clone root:
```
obuild/build.sh install <version> <texmf root>
```
for example, say the currently released version is 3.3 and you want to try
the 3.4 development version. Suppose your personal texmf root is at
`~/texmf`:
```
obuild/build.sh install 3.4 ~/texmf
```
If this is the first time you are installing `biblatex` into `~/texmf`, you will have
to tell TeX that it can find the files in this new location with `texhash`
or the equivalent command from your TeX distribution.

Note that the install script does not fetch and install the official biblatex
release version corresponding to the version argument supplied. It just takes
the files that are currently checked out, moves them and changes their version
identifications so that they identify as the version given in the argument.
If you want a specific version, you must check out the corresponding tag or
obtain the corresponding sources otherwise before running the script.

Obviously, its is easier to get the TDS format package from the Sourceforge
development folder and just unpack it into your `~/texmf` but this might
not be quite as recent as the git development branch (but is usually very
close).

# Translation

The language files (`*.lbx`) are located in `tex/latex/biblatex/lbx`. To add
a new translation copy `english.lbx` (or another existing translation that is
closer to your language; note that `english.lbx` and `german.lbx` are
reference translations, all other files are not guaranteed to be complete)
to `languagename.lbx`, where `languagename` is the name used by Babel
for the language.

To debug or verify that a translation is complete, copy
`doc/latex/biblatex/examples/03-localization-keys.tex` to
`tex/latex/biblatex/lbx`. Edit `03-localization-keys.tex` so Babel (and hence
Biblatex) uses the language you are translating. Compiling the file will
warn you about missing strings, and looking at the generated file will
help you to proofread your translation.

If you are translating for an upcoming release, i.e., you have cloned the
Git repository, please remember to build and install the package as described
above before trying to compile `03-localization-keys.tex`.

If your language inherits from another, you'll have to take extra care as
new strings aren't reported if they are already translated in the inherited
language.

# Help

- biblatex comes with example files in the `doc/latex/biblatex/examples`
  directory in the distribution. There are a lot of practical examples here
  along with comments in the source `.tex` files which help to explain
  details not dwelt on in the PDF manual.
- [StackExchange](https://tex.stackexchange.com/questions/tagged/biblatex)

# Debug and feature requests

Suggestions and bug reports are welcome.

- Go to the Github [issues page](https://github.com/plk/biblatex/issues).
- Open an issue.
- Add a [minimal working example](http://www.tex.ac.uk/cgi-bin/texfaq2html?label=minxampl) if
  possible. This helps a great deal facilitate a swift response.
