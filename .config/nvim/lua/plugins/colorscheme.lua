-- Colorscheme: vague (transparente en terminal, opaco en Neovide).

vim.pack.add { 'https://github.com/vague-theme/vague.nvim' }

require('vague').setup {
  transparent = vim.g.neovide == nil,
}

vim.cmd.colorscheme 'vague'

-- Para volver a rose-pine:
--   vim.pack.add { 'https://github.com/rose-pine/neovim' }
--   require('rose-pine').setup { variant = 'moon', styles = { transparency = vim.g.neovide == nil } }
--   vim.cmd.colorscheme 'rose-pine-moon'
