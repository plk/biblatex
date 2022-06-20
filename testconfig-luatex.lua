checkengines = {"luatex"}
stdengine = "luatex"
checkruns = 3

testfiledir = "testfiles/luatex"

function runtest_tasks(name, run)
  if run == 1 then
    return "biber -q " .. name
  else
    return ""
  end
end
