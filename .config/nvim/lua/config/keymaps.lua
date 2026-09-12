-- Keymaps basicos y config de diagnosticos. Ver `:help vim.keymap.set`.

-- Limpia el highlight de busqueda con <Esc>.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnosticos: sin texto virtual ni lineas virtuales (preferencia previa).
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic [Q]uickfix list' })

-- Salir del modo terminal.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Salir del modo terminal' })

-- Navegacion entre splits con CTRL+<hjkl>.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Foco a la ventana izquierda' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Foco a la ventana derecha' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Foco a la ventana inferior' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Foco a la ventana superior' })

-- Resalta al yankear.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Resaltar al yankear',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- ============================================================
-- QoL extra (aportados sobre el base de kickstart)
-- ============================================================

-- Guardar.
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Guardar archivo' })

-- Buffers.
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Buffer anterior' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Buffer siguiente' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Buffer anterior' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Buffer siguiente' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Buffer alterno' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Buffer alterno' })
vim.keymap.set('n', '<leader>bd', function()
  local bufs = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
  if #bufs <= 1 then
    vim.notify('No hay otro buffer para mostrar', vim.log.levels.WARN)
    return
  end
  vim.cmd('bprevious')
  vim.cmd('bdelete #')
end, { desc = 'Cerrar buffer' })

-- Mover lineas.
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Mover linea abajo' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Mover linea arriba' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Mover linea abajo' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Mover linea arriba' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Mover linea abajo' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Mover linea arriba' })

-- Reindentar manteniendo la seleccion.
vim.keymap.set('x', '<', '<gv', { desc = 'Indentar a la izquierda' })
vim.keymap.set('x', '>', '>gv', { desc = 'Indentar a la derecha' })

-- Redimensionar ventanas con Ctrl+flechas.
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Aumentar alto' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Reducir alto' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Reducir ancho' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Aumentar ancho' })

-- Ventanas.
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split abajo', remap = true })
vim.keymap.set('n', '<leader>\\', '<C-W>v', { desc = 'Split a la derecha', remap = true })
vim.keymap.set('n', '<Tab>', '<C-w>w', { desc = 'Siguiente ventana' })
vim.keymap.set('n', '<S-Tab>', '<C-w>W', { desc = 'Ventana anterior' })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Cerrar ventana', remap = true })
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'Archivo nuevo' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Salir de todo' })

-- Terminal en split horizontal.
local function open_terminal()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end
vim.keymap.set({ 'n', 't' }, '<C-/>', open_terminal, { desc = 'Terminal' })
vim.keymap.set({ 'n', 't' }, '<C-_>', open_terminal, { desc = 'Terminal' })
vim.keymap.set('n', '<leader>ft', open_terminal, { desc = 'Terminal' })

-- Compilar segun el lenguaje; los errores van al quickfix.
local compilers = {
  go = { cmd = 'go build', efm = 'go' },
  rust = { cmd = 'cargo build', efm = 'cargo' },
  c = { cmd = 'gcc % -o %<', efm = 'gcc' },
  cpp = { cmd = 'g++ % -o %<', efm = 'gcc' },
  typescript = { cmd = 'tsc --noEmit', efm = 'tsc' },
}
vim.keymap.set('n', '<leader>c', function()
  local spec = compilers[vim.bo.filetype]
  if not spec then
    vim.notify('Sin compilador configurado para ' .. (vim.bo.filetype ~= '' and vim.bo.filetype or 'este archivo'), vim.log.levels.WARN)
    return
  end
  vim.cmd.write()
  vim.cmd('compiler! ' .. spec.efm)
  vim.o.makeprg = spec.cmd
  vim.cmd('silent make')
  if #vim.fn.getqflist() > 0 then vim.cmd('copen') end
end, { desc = '[C]ompilar' })

-- Navegacion de diagnosticos.
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Diagnostico de la linea' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Siguiente diagnostico' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Diagnostico anterior' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Siguiente error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Error anterior' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Siguiente warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Warning anterior' })
