#!/bin/bash

# testlang.sh <lang>
# $1 -> lang


usage () {
echo "Usage:

testlang.sh help
testlang.sh <language»

This command generates a big document with examples of the localized 
strings for the language <language>.  The result is a pdf
file 'build/test/examples-<language>.pdf'" 
}


update_local_install () {
    declare VERSION="TestVersion"
    declare DATE=`date '+%Y/%m/%d'`
    
    find . -name \*~ -print | xargs rm >/dev/null 2>&1

    [[ -e build/flat ]] || mkdir build/flat
    \rm -rf build/flat/*
    \rm -f build/biblatex-$VERSION.tgz
    mkdir -p build/flat/bibtex/{bib,bst,csf}
    mkdir -p build/flat/bibtex/bib/biblatex
    mkdir -p build/flat/doc/examples
    mkdir -p build/flat/latex/{cbx,bbx,lbx}
    cp doc/latex/biblatex/README build/flat/
    cp doc/latex/biblatex/RELEASE build/flat/
    cp bibtex/bib/biblatex/biblatex-examples.bib build/flat/bibtex/bib/biblatex/
    cp bibtex/bib/biblatex/biblatex-examples.bib build/flat/doc/examples/
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

    perl -pi -e "s|\\\\abx\\@date\{[^\}]+\}|\\\\abx\\@date\{$DATE\}|;s|\\\\abx\\@version\{[^\}]+\}|\\\\abx\\@version\{$VERSION\}|;" build/flat/latex/biblatex.sty

}

if [[ ! -e build/build.sh ]]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

if [[ "$1" = "help" ]]
then
  usage
  exit 1
fi

if [[ -z "$1" ]]
then
  usage
  exit 1
fi

# setup environment to use current development version during test
update_local_install
export BIBINPUTS=.:$PWD/build/flat/bibtex/bib/biblatex//:
export TEXINPUTS=.:$PWD/build/flat//:$TEXINPUTS:
export BSTINPUTS=.:$PWD/build/flat/bibtex/bst//:

# do the test using bibtex
[[ -e build/test/examples-$1 ]] || mkdir -p build/test/examples-$1
\rm -f build/test/example_$1_errs_bibtex.txt
\rm -f build/test/$1-results.pdf
\rm -rf build/test/examples-$1/*
cp -r doc/latex/biblatex/examples/*.tex build/test/examples-$1/
cd build/test/examples-$1

for f in *.tex
do
    sed "s/american/$1/g" $f |  \
	sed 's/backend=biber/backend=bibtex/g' > ${f%.tex}-bibtex.tex
    bibtexflag=false
    biberflag=false
    if [[ "$f" < 9* ]] # 9+*.tex examples require biber
    then
	echo -n "File (bibtex): $f ... "
	exec 4>&1 7>&2 # save stdout/stderr
	exec 1>/dev/null 2>&1 # redirect them from here
	pdflatex -interaction=batchmode ${f%.tex}-bibtex
	bibtex ${f%.tex}-bibtex
      # Any refsections? If so, need extra bibtex runs
	for sec in ${f%.tex}-bibtex*-blx.aux
	do
            bibtex $sec
	done
	pdflatex -interaction=batchmode ${f%.tex}-bibtex
      # Need a second bibtex run to pick up set members
	bibtex ${f%.tex}-bibtex
	pdflatex -interaction=batchmode ${f%.tex}-bibtex
	exec 1>&4 4>&- # restore stdout
	exec 7>&2 7>&- # restore stderr
      # Now look for latex/bibtex errors and report ...
	echo "==============================
Test file: $f

PDFLaTeX errors/warnings
------------------------"  >> ../example_$1_errs_bibtex.txt
	grep -E -i "(error|warning):" ${f%.tex}-bibtex.log >> ../example_$1_errs_bibtex.txt
	if [[ $? -eq 0 ]]; then bibtexflag=true; fi
	grep -E -A 3 '^!' ${f%.tex}-bibtex.log >> ../example_$1_errs_bibtex.txt
	if [[ $? -eq 0 ]]; then bibtexflag=true; fi
	echo >> ../example_$1_errs_bibtex.txt
	echo "BibTeX errors/warnings" >> ../example_$1_errs_bibtex.txt
	echo "---------------------" >> ../example_$1_errs_bibtex.txt
      # Glob as we need to check all .blgs in case of refsections
	grep -E -i -e "(error|warning)[^\$]" ${f%.tex}-bibtex*.blg >> ../example_$1_errs_bibtex.txt
	if [[ $? -eq 0 ]]; then bibtexflag=true; fi
	echo "==============================" >> ../example_$1_errs_bibtex.txt
	echo >> ../example_$1_errs_bibtex.txt
	if $bibtexflag 
	then
            echo "ERRORS"
	else
            echo "OK"
	fi
    fi
done

pdfjoin build/test/examples-$1/*.pdf -o build/test/examples-$1.pdf