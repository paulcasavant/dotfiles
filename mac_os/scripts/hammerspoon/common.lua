local common = {}

function common.Sleep(n)
  os.execute("sleep " .. tonumber(n))
end

return common