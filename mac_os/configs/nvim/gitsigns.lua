
-- gitsigns.lua

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitGutterAdd', text = '+', numhl='GitSignsAddNr'},
    change       = {hl = 'GitGutterChange', text = '~', numhl='GitSignsChangeNr'},
    delete       = {hl = 'GitGutterDelete', text = '_', numhl='GitSignsDeleteNr'},
    topdelete    = {hl = 'GitGutterDeleteChange', text = '‾', numhl='GitSignsDeleteChangeNr'},
    changedelete = {hl = 'GitGutterChangeDelete', text = '~', numhl='GitSignsChangeNr'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
}
