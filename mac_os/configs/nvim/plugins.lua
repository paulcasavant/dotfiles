
-- plugins.lua

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself

  -- LSP (Language Server Protocol) and Completion
  use 'neovim/nvim-lspconfig'    -- LSP configurations
  use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'       -- Buffer completions
  use 'hrsh7th/cmp-path'         -- Path completions

  -- Snippets
  use 'L3MON4D3/LuaSnip'          -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'  -- Snippet completion source for cmp

  -- Treesitter for better syntax highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- File Explorer
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'  -- Icons for file explorer and status line

  -- Telescope for fuzzy finding
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }  -- FZF for better performance

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Status line
  use 'nvim-lualine/lualine.nvim'

  -- Auto pairs for brackets, quotes, etc.
  use 'windwp/nvim-autopairs'

  -- Colorscheme
  use 'folke/tokyonight.nvim'

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
