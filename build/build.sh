#!/usr/bin/env bash

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

if [ $# -lt 2 ]
then
  echo "Usage: build.sh <version> <command>"
  exit 1
fi

declare VERSION=$1
declare DATE=`date '+%Y/%m/%d'`

if [ "$2" = "upload" ]
then
    if [ -e build/biblatex-$VERSION.tds.tgz ]
    then
      scp build/biblatex-$VERSION.tds.tgz philkime,biblatex@frs.sourceforge.net:/home/frs/project/biblatex/biblatex-$VERSION/biblatex-$VERSION.tds.tgz
    exit 0
  fi
fi

if [ "$2" = "build" ]
then
  \rm -rf build/tds/*
  \rm -f build/biblatex*.tds.tgz
  cp -r bibtex build/tds/
  cp -r doc build/tds/
  cp -r tex build/tds/

  perl -pi -e "s|\\\\abx\\@date\{[^\}]+\}|\\\\abx\\@date\{$DATE\}|;s|\\\\abx\\@version\{[^\}]+\}|\\\\abx\\@version\{$VERSION\}|;" build/tds/tex/latex/biblatex/biblatex.sty
  perl -pi -e "s|\\%v.+|\\%v$VERSION|;" build/tds/tex/latex/biblatex/*.def

  # Can't do in-place on windows (cygwin)
  find build/tds -name \*.bak | xargs rm
  find build/tds -name auto | xargs \rm -rf

  tar zcf build/biblatex-$VERSION.tds.tgz -C build/tds bibtex doc tex
fi



