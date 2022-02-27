checkengines = {"pdftex"}
stdengine = "pdftex"
checkruns = 3

testfiledir = "testfiles/pdftex"

function runtest_tasks(name, run)
  if run == 1 then
    return "biber -q " .. name
  else
    return ""
  end
end
