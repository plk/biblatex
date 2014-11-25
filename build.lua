#!/usr/bin/env texlua
-- Build script for biblatex package
module = "biblatex"
-- variable overwrites (if needed)
typesetexe = "lualatex"
stdengine = "luatex"
checkengines = {"luatex"}
checksuppfiles = {"*.tex"}
-- call standard script
kpse.set_program_name ("kpsewhich")
dofile (kpse.lookup ("l3build.lua"))
