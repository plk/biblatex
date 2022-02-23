-- Build script for biblatex package

module = "biblatex"

-- Detail how to set the version automatically
tagfiles = {"tex/latex/biblatex/biblatex.sty"}
function update_tag(file,content,tagname,tagdate)
  tagname = string.gsub(tagname, "^v", "")
  tagdate = string.gsub(tagdate, "%-", "/")
  return string.gsub(string.gsub(content,"%{DATE%}","{" .. tagdate .. "}"),
    "VERSION",tagname)
end

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
maxprintline = 9999

function runtest_tasks(name)
  return "biber -q " .. name
end
