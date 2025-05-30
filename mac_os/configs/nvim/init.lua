
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
require('core.plugins')

-- General settings
vim.o.number = true                -- Enable line numbers
vim.o.relativenumber = false       -- Relative line numbers
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
vim.api.nvim_set_keymap(
  'n',
  '<leader>dw',
  '<cmd>lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)

-- Plugin configurations
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"  -- Packer can manage itself

  -- Commenting
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp_config")
    end
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("plugins.treesitter_config")
    end
  }

  -- FIXME: broken
  -- Telescope
  -- use {
  --   "nvim-telescope/telescope.nvim",
  --   requires = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("plugins.telescope_config")
  --   end
  -- }

  -- Gitsigns
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.gitsigns_config")
    end
  }

  -- Lualine
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.lualine_config")
    end
  }

  -- NvimTree
  use {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("plugins.nvimtree_config")
    end
  }

  -- Fuzzy matching
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip', -- if you're using snippets
      'saadparwaiz1/cmp_luasnip'
    }
  }

  -- Theme
  use 'folke/tokyonight.nvim'

  -- Add more plugins here as needed...
end)

-- Set colorscheme
vim.cmd [[colorscheme tokyonight]]
-- vim.cmd [[colorscheme gruvbox]]

-- Enable mouse
vim.o.mouse = 'a'

-- Automatically show diagnostics when hovering with the mouse
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
]]
