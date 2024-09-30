
    -- Utility functions
    function ReloadConfig()
        for name,_ in pairs(package.loaded) do
            if name:match('^user') then
                package.loaded[name] = nil
            end
        end
        dofile(vim.env.MYVIMRC)
    end