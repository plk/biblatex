-- Build script for biblatex package

module = "biblatex"

-- TDS-based installation
installfiles = {}
sourcefiles = {}
unpackfiles = {}
tdsdirs = {bibtex = "bibtex", tex = "tex"}

-- For the manual
docfiledir = "./doc/latex/biblatex"
docfiles = {"**/*.pdf", "**/*.tex"}
typesetexe = "lualatex"
typesetfiles = {"biblatex.tex"}

flatten = false
flattentds = false
packtdszip = true

checkengines = {"luatex"}
checkruns = 2

function runtest_tasks(name)
  return "biber -q " .. name
end

