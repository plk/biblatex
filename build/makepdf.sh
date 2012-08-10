#!/usr/bin/env bash

cd doc/latex/biblatex
pdflatex biblatex
pdflatex biblatex
cd examples
for f in *.tex
do
  pdflatex ${f%.tex}
  biber ${f%.tex}
  pdflatex ${f%.tex}
done
grep -E -i "(error|warn)" *.log | more
grep -E -A 3 "(^\!)" *.log | more
grep -E -i "(error|warn)" *.blg | more
cd ..
grep -E -i "(error|warn)" biblatex.log | more
grep -E -A 3 "(^\!)" biblatex.log | more

