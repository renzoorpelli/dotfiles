-- Colorscheme: rose-pine-moon, fondos transparentes; StatusLine conserva el color del tema.

vim.pack.add { 'https://github.com/rose-pine/neovim' }

require('rose-pine').setup {
  variant = 'moon',
  styles = { transparency = true },
  highlight_groups = {
    StatusLine = { bg = 'surface' },
    StatusLineNC = { bg = 'surface', blend = 60 },
  },
}

vim.cmd.colorscheme 'rose-pine-moon'
