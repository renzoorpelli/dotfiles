return {
  {
    "kepano/flexoki-neovim",
    opts = {
      colorscheme = "flexoki",
    },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  { "miikanissi/modus-themes.nvim", opts = {
    colorscheme = "modus",
  } },
  {
    "datsfilipe/vesper.nvim",
    opts = {
      colorscheme = "vesper",
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
  {
    "https://github.com/WTFox/jellybeans.nvim",
    opts = {
      colorscheme = "jellybeans",
    },
  },
  {
    "https://github.com/ellisonleao/gruvbox.nvim",
    opts = {
      colorscheme = "gruvbox.nvim",
    },
  },
  {
    "https://github.com/maroozm/moegi-neovim",
    opts = {
      colorscheme = "moegi",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
