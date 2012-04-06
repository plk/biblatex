#!/usr/bin/env bash

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

declare VERSION=`git describe --tags | cut -d '-' -f 1`
declare DATE=`date '+%Y/%m/%d'`

\rm -rf build/tds/*
\rm -f build/biblatex-i.tgz
cp -r bibtex build/tds/
cp -r doc build/tds/
cp -r tex build/tds/
# Need to generate this from processed source
\rm -f build/tds/doc/latex/biblatex/biblatex.pdf

find build/tds -type f | xargs perl -pi -e "s|\\\$Id:\\\$|\\\$Id: $DATE $VERSION \\\$|;s|\\\$Rev:\\\$|$VERSION|;s|\\\$Date:\\\$|$DATE|;"

# Can't do in-place on windows (cygwin)
find build/tds -name \*.bak | xargs rm
find build/tds -name auto | xargs \rm -rf

if [ $1='norel' ]
then
  exit 0
fi

pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
pdflatex -interaction=batchmode build/tds/doc/latex/biblatex/biblatex.tex
mv biblatex.pdf build/tds/doc/latex/biblatex/
\rm -f biblatex.*
tar zcf build/biblatex-i.tgz -C build/tds bibtex doc tex



