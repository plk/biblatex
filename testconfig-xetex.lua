checkengines = {"xetex"}
stdengine = "xetex"
checkruns = 3

testfiledir = "testfiles/xetex"

function runtest_tasks(name, run)
  if run == 1 then
    return "biber -q " .. name
  else
    return ""
  end
end
