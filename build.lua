#!/usr/bin/env texlua
-- Build script for biblatex package
module = "biblatex"
-- variable overwrites (if needed)
typesetexe = "lualatex"
stdengine = "luatex"
-- call standard script
kpse.set_program_name ("kpsewhich")
dofile (kpse.lookup ("l3build.lua"))
