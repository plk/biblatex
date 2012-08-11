#!/usr/bin/env bash

usage () {
echo "Usage:

build.sh help
build.sh install <version> <tds_root>
build.sh build <version>
build.sh test
build.sh upload <version> [ \"DEV\" ]

With the \"DEV\" argument, uploads to the SourceForge development
folder instead of the <version> numbered folder

Examples: 
/build/build.sh install 2.2 ~/texmf/
/build/build.sh build 2.2
/build/build.sh upload 2.2 DEV

\"build test\" runs all of the example files (in a temp dir) and puts errors in a log:

build/example_errs.txt

You should run the \"build.sh install\" before test as it uses the installed biblatex and biber

"
}

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

if [ "$1" = "help" ]
then
  usage
  exit 1
fi

if [ "$1" = "install" -a \( -z "$2" -o -z "$3" \) ]
then
  usage
  exit 1
fi

if [ "$1" = "build" -a -z "$2" ]
then
  usage
  exit 1
fi

if [ "$1" = "upload" -a -z "$2" ]
then
  usage
  exit 1
fi



declare VERSION=$2
declare DATE=`date '+%Y/%m/%d'`

if [ "$1" = "upload" ]
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

if [ "$1" = "build" -o "$1" = "install" ]
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

  echo "Created build trees ..."
fi

if [ "$1" = "install" ]
then
  cp -r build/tds/* $3

  echo "Installed TDS build tree ..."
fi


if [ "$1" = "build" ]
then

  cd doc/latex/biblatex
  pdflatex -interaction=batchmode biblatex.tex
  pdflatex -interaction=batchmode biblatex.tex
  pdflatex -interaction=batchmode biblatex.tex

  \rm *.{aux,bbl,bcf,blg,log,run.xml,toc,out,lot} 2>/dev/null

  cd ../../..
  echo "Created main documentation ..."

  tar zcf build/biblatex-$VERSION.tds.tgz -C build/tds bibtex doc tex
  tar zcf build/biblatex-$VERSION.tgz -C build/flat README RELEASE bibtex doc latex

  echo "Created packages (flat and TDS) ..."

fi


if [ "$1" = "test" ]
then
  [ -e build/test/examples ] || mkdir -p build/test/examples
  \rm -f build/test/example_errs.txt
  \rm -rf build/test/examples/*
  cp -r doc/latex/biblatex/examples/*.tex build/test/examples/
  cd build/test/examples
  for f in *.tex
  do
    flag=false
    echo -n "File: $f ... "
    pdflatex -interaction=batchmode ${f%.tex} > /dev/null
    biber --onlylog ${f%.tex}
    pdflatex -interaction=batchmode ${f%.tex} > /dev/null
    pdflatex -interaction=batchmode ${f%.tex} > /dev/null

    # Now look for errors and report ...
    echo "==============================
Test file: $f

PDFLaTeX errors/warnings
------------------------"  >> ../example_errs.txt
    grep -E -i "(error|warning):" ${f%.tex}.log >> ../example_errs.txt
    if [ $? -eq 0 ]; then flag=true; fi
    grep -E -A 3 '^!' ${f%.tex}.log >> ../example_errs.txt
    if [ $? -eq 0 ]; then flag=true; fi
    echo >> ../example_errs.txt
    echo "Biber errors/warnings" >> ../example_errs.txt
    echo "---------------------" >> ../example_errs.txt
    grep -E -i "(error|warn)" *.blg >> ../example_errs.txt
    if [ $? -eq 0 ]; then flag=true; fi
    echo "==============================" >> ../example_errs.txt
    echo >> ../example_errs.txt
    if $flag 
    then
      echo "ERRORS"
    else
      echo "OK"
    fi
  done
  cd ../../..
fi
