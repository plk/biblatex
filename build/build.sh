#!/usr/bin/env bash

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

if [ $# -lt 2 ]
then
  echo "Usage: build.sh <version> <command> DEV"
  exit 1
fi

declare VERSION=$1
declare DATE=`date '+%Y/%m/%d'`

if [ "$2" = "upload" ]
then
    if [ -e build/biblatex-$VERSION.tds.tgz ]
    then
      if [ "$3" = "DEV" ]
      then
        scp build/biblatex-$VERSION.*tgz philkime,biblatex@frs.sourceforge.net:/home/frs/project/biblatex/development/
      else
        scp build/biblatex-$VERSION.*tgz philkime,biblatex@frs.sourceforge.net:/home/frs/project/biblatex/biblatex-$VERSION/
      fi
    exit 0
  fi
fi

if [ "$2" = "build" ]
then
  find . -name \*~ -print | xargs rm
  # tds
  [ -e build/tds ] || mkdir build/tds
  \rm -rf build/tds/*
  \rm -f build/biblatex-$VERSION.tds.tgz
  cp -r bibtex build/tds/
  cp -r doc build/tds/
  cp -r tex build/tds/

  # normal
  [ -e build/flat ] || mkdir build/flat
  \rm -rf build/flat/*
  \rm -f build/biblatex-$VERSION.tgz
  mkdir -p build/flat/bibtex/{bib,bst,csf}
  mkdir -p build/flat/bibtex/bib/biblatex
  mkdir -p build/flat/doc/examples
  mkdir -p build/flat/latex/{cbx,bbx,lbx}
  cp doc/latex/biblatex/README build/flat/
  cp doc/latex/biblatex/RELEASE build/flat/
  cp doc/latex/biblatex/examples/biblatex-examples.bib build/flat/bibtex/bib/biblatex/
  cp bibtex/bst/biblatex/biblatex.bst build/flat/bibtex/bst/
  cp bibtex/csf/biblatex/*.csf build/flat/bibtex/csf/
  cp doc/latex/biblatex/biblatex.pdf build/flat/doc/
  cp doc/latex/biblatex/biblatex.tex build/flat/doc/
  cp -r doc/latex/biblatex/examples build/flat/doc/
  cp tex/latex/biblatex/*.def build/flat/latex/
  cp tex/latex/biblatex/*.sty build/flat/latex/
  cp tex/latex/biblatex/*.cfg build/flat/latex/
  cp -r tex/latex/biblatex/cbx build/flat/latex/
  cp -r tex/latex/biblatex/bbx build/flat/latex/
  cp -r tex/latex/biblatex/lbx build/flat/latex/

  perl -pi -e "s|\\\\abx\\@date\{[^\}]+\}|\\\\abx\\@date\{$DATE\}|;s|\\\\abx\\@version\{[^\}]+\}|\\\\abx\\@version\{$VERSION\}|;" build/tds/tex/latex/biblatex/biblatex.sty build/flat/latex/biblatex.sty

  # Can't do in-place on windows (cygwin)
  find build/tds -name \*.bak | xargs \rm -rf
  find build/tds -name auto | xargs \rm -rf

  tar zcf build/biblatex-$VERSION.tds.tgz -C build/tds bibtex doc tex
  tar zcf build/biblatex-$VERSION.tgz -C build/flat README RELEASE bibtex doc latex
fi



