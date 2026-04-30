return {
  {
    "LazyVim/LazyVim",
    opts = {
      python_lsp = "pylsp",
      python_ruff = "ruff",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                ruff = { enabled = true },
              },
            },
          },
        },
      },
    },
  },
}
