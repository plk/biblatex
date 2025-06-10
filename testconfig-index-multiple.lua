checkengines = {"pdftex"}
stdengine = "pdftex"
checkruns = 3

testfiledir = "testfiles/index-multiple"

function runtest_tasks(name, run)
  if run == 1 then
    return "biber -q " .. name
  elseif run == 2 then
    return
         "makeindex -o " .. name .. ".ind " .. name .. ".idx" .. os_concat
      .. "makeindex -o " .. name .. ".nnd " .. name .. ".ndx" .. os_concat
      .. "makeindex -o " .. name .. ".tnd " .. name .. ".tdx"
  else
    return ""
  end
end
