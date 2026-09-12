local M = {}

-- Raiz del proyecto: git o marcadores comunes; fallback al cwd.
function M.root()
  return vim.fs.root(0, {
    '.git',
    'go.mod',
    'package.json',
    'Cargo.toml',
    'pyproject.toml',
    'Makefile',
  }) or vim.fn.getcwd()
end

return M
