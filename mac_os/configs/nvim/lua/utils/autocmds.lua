
    -- Autocommands
    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*',
        callback = function()
            vim.cmd('echo "File saved!"')
        end,
    })
    