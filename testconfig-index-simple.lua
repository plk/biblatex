checkengines = {"pdftex"}
stdengine = "pdftex"
checkruns = 3

testfiledir = "testfiles/index-simple"

function runtest_tasks(name, run)
  if run == 1 then
    return "biber -q " .. name
  elseif run == 2 then
    return "makeindex " .. name
  else
    return ""
  end
end
