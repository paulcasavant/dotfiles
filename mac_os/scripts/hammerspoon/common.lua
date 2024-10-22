local common = {}

function CloseCurrentWindow()
    local win = hs.window.focusedWindow()
    if win then
        win:close()
    else
        hs.alert.show("No focused window!")
    end
end

function common.Sleep(n)
  os.execute("sleep " .. tonumber(n))
end

return common