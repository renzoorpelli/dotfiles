-- Fuzzy finder: telescope.nvim (archivos, grep, LSP, etc).

local telescope_plugins = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then
  table.insert(telescope_plugins, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim')
end
vim.pack.add(telescope_plugins)

require('telescope').setup {
  defaults = {
    -- Sin treesitter en el preview (fallback a regex). Evita el crash de ts_highlighter.
    preview = { treesitter = false },
  },
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
local root = require('config.util').root
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() builtin.find_files { cwd = root() } end, { desc = '[S]earch [F]iles (raiz del proyecto)' })
vim.keymap.set('n', '<leader>sF', function()
  local dir = vim.fn.expand '%:p:h'
  if dir == '' then dir = vim.fn.getcwd() end
  builtin.find_files { cwd = dir }
end, { desc = '[S]earch [F]iles (directorio actual)' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

-- Pickers de LSP cuando un server se attacha.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Document Symbols' })
    vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Workspace Symbols' })
    vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Buscar en el buffer actual' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
end, { desc = '[S]earch [/] en archivos abiertos' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true }
end, { desc = '[S]earch [N]eovim files' })

-- Git: archivos con cambios, historial.
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus (pendientes de commit)' })
vim.keymap.set('n', '<leader>gL', builtin.git_commits, { desc = '[G]it [L]og (repo)' })
vim.keymap.set('n', '<leader>gl', builtin.git_bcommits, { desc = '[G]it [l]og del archivo actual' })

-- Navegacion de proyectos grandes.
vim.keymap.set('n', '<leader>sG', builtin.git_files, { desc = '[S]earch [G]it files (solo versionados)' })
vim.keymap.set('n', '<leader>sT', builtin.treesitter, { desc = '[S]earch [T]reesitter symbols' })
