vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    local path = ev.data.path
    if kind ~= 'install' and kind ~= 'update' then return end

    local function run(cmd)
      local result = vim.system(cmd, { cwd = path }):wait()
      if result.code ~= 0 then
        local output = (result.stderr ~= '' and result.stderr) or result.stdout or 'no output'
        vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
      end
    end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run { 'make' }
    elseif name == 'LuaSnip' and vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
      run { 'make', 'install_jsregexp' }
    elseif name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

require 'config.options'
require 'config.keymaps'

require 'plugins.colorscheme'
require 'plugins.ui'
require 'plugins.multicursor'
require 'plugins.telescope'
require 'plugins.completion'
require 'plugins.lsp'
require 'plugins.treesitter'
require 'plugins.personal'
