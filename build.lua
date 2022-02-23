-- Build script for biblatex package

module = "biblatex"

-- Detail how to set the version automatically
tagfiles = {"build.lua", "./tex/latex/biblatex/biblatex.sty"}
function update_tag(file,content,tagname,tagdate)
  tagname = string.gsub(tagname, "^v", "")
  tagdate = string.gsub(tagdate, "%-", "/")
  if file == "build.lua" then
    return string.gsub(content,
      'local tagname = "v%d.%d+"','local tagname = "v' .. tagname .. '"')
  else
    return string.gsub(string.gsub(content,"%{DATE%}","{" .. tagdate .. "}"),
      "VERSION",tagname)
  end
end

-- TDS-based installation
installfiles = {"./tex/latex/biblatex/biblatex.sty"}
sourcefiles = installfiles
unpackfiles = {}
tdsdirs = {bibtex = "bibtex", tex = "tex"}

-- For auto-editing
local tagname = "v3.17"
local tagdate = os.date("%Y-%m-%d")

function checkinit_hook()
  local file = unpackdir .. "/biblatex.sty"
  local filename = basename(file)
  local f = assert(io.open(file,"rb"))
  local content = f:read("*all")
  f:close()
  -- Deal with Unix/Windows line endings
  content = string.gsub(content .. (string.match(content,"\n$") and "" or "\n"),
    "\r\n", "\n")
  local updated_content = update_tag(filename,content,tagname,tagdate)
  if content == updated_content then
    return 0
  else
    local path = dirname(file)
    ren(path,filename,filename .. ".bak")
    f = assert(io.open(file,"w"))
    -- Convert line ends back if required during write
    -- Watch for the second return value!
    f:write((string.gsub(updated_content,"\n",os_newline)))
    f:close()
    rm(path,filename .. ".bak")
  end
  cp("biblatex.sty",unpackdir,testdir)
  return 0
end

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

supportdir = docfiledir .. "/examples"
checksuppfiles = {"*.bib", "*.dbx"}
testsuppdir = "./bibtex/bib/biblatex"

function runtest_tasks(name)
  return "biber -q " .. name
end
