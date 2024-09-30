
-- init.lua
local config_path = vim.fn.resolve(vim.fn.stdpath('config'))
print(config_path)
-- local config_path = vim.fn.resolve(vim.fn.stdpath('config'))
-- package.path = package.path .. ';' .. config_path .. '/lua/?.lua'

-- Automatically install packer if not installed
-- local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
-- if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
--   vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
--   vim.cmd [[packadd packer.nvim]]
-- end
-- init.lua
-- Automatically install packer if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Auto-compile when there are changes in plugins.lua
vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

-- Plugins installation and management
require('plugins')

-- General settings
vim.o.number = true                -- Enable line numbers
vim.o.relativenumber = true         -- Relative line numbers
vim.o.mouse = 'a'                  -- Enable mouse
vim.o.clipboard = 'unnamedplus'    -- System clipboard integration
vim.o.expandtab = true             -- Convert tabs to spaces
vim.o.shiftwidth = 4               -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 4                  -- Number of spaces a tab counts for
vim.o.smartindent = true           -- Smart indentation
vim.o.wrap = false                 -- Disable line wrap
vim.o.termguicolors = true         -- Enable 24-bit RGB color in the terminal
vim.o.splitright = true            -- Split windows to the right
vim.o.splitbelow = true            -- Split windows below
vim.o.ignorecase = true            -- Ignore case when searching
vim.o.smartcase = true             -- Smart case
vim.o.updatetime = 300             -- Faster completion (4000ms default)
vim.o.signcolumn = "yes"           -- Always show signcolumn to avoid text shifting

-- Leader key
vim.g.mapleader = ' '  -- Space as the leader key

-- Keybindings
vim.api.nvim_set_keymap('n', '<Leader>pv', ':Ex<CR>', { noremap = true })  -- File Explorer

-- Plugin configurations
require('lsp')       -- LSP settings
require('treesitter')  -- Treesitter settings
require('telescope')   -- Telescope settings
require('gitsigns')    -- Gitsigns settings
require('lualine')     -- Statusline settings
require('nvimtree')    -- File explorer settings

-- Autocompletion settings
require('cmp_config')

-- Auto pairs (for automatically closing brackets, etc.)
require('nvim-autopairs').setup{}

-- Set colorscheme
vim.cmd [[colorscheme tokyonight]]
