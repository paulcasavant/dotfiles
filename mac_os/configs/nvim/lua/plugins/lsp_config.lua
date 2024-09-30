-- lsp_config.lua

local lspconfig = require('lspconfig')

-- Enable LSP servers (Add more as needed)
lspconfig.ts_ls.setup{}  -- TypeScript/JavaScript LSP (updated from tsserver)
lspconfig.lua_ls.setup{} -- Lua LSP (updated from sumneko_lua)

-- Automatically set up diagnostics
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline virtual text diagnostics
  signs = true,
  update_in_insert = true,
})
