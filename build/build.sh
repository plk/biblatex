#!/usr/bin/env bash

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

if [ "$1" = "upload" ]
then
    if [ -e build/biblatex.tgz ]
    then
      scp build/biblatex.tgz philkime,biblatex@frs.sourceforge.net:/home/frs/project/biblatex/development/biblatex.tgz
    exit 0
  fi
fi

declare VERSION=$1
declare DATE=`date '+%Y/%m/%d'`

\rm -rf build/tds/*
\rm -f build/biblatex.tgz
cp -r bibtex build/tds/
cp -r doc build/tds/
cp -r tex build/tds/
# Need to generate this from processed source
\rm -f build/tds/doc/latex/biblatex/biblatex.pdf

perl -pi -e "s|\\\\abx\\@date\{[^\}]+\}|\\\\abx\\@date\{$DATE\}|;s|\\\\abx\\@version\{[^\}]+\}|\\\\abx\\@version\{$VERSION\}|;" build/tds/tex/latex/biblatex/biblatex.sty
perl -pi -e "s|\\%v.+|\\%v$VERSION|;" build/tds/tex/latex/biblatex/*.def

# Can't do in-place on windows (cygwin)
find build/tds -name \*.bak | xargs rm
find build/tds -name auto | xargs \rm -rf

if [ "$2" = "norel" ]
then
  exit 0
fi

pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
mv biblatex.pdf build/tds/doc/latex/biblatex/
\rm -f biblatex.*
tar zcf build/biblatex.tgz -C build/tds bibtex doc tex



