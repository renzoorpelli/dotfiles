vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Reload files changed on disk',
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bd', function()
  local bufs = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
  if #bufs <= 1 then
    vim.notify('No other buffer to show', vim.log.levels.WARN)
    return
  end
  vim.cmd('bprevious')
  vim.cmd('bdelete #')
end, { desc = 'Close buffer' })

vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move line up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move line up' })

vim.keymap.set('x', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('x', '>', '>gv', { desc = 'Indent right' })

vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase width' })

vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split below', remap = true })
vim.keymap.set('n', '<leader>\\', '<C-W>v', { desc = 'Split right', remap = true })
vim.keymap.set('n', '<Tab>', '<C-w>w', { desc = 'Next window' })
vim.keymap.set('n', '<S-Tab>', '<C-w>W', { desc = 'Previous window' })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Close window', remap = true })
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New file' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

local function open_terminal(cmd, cwd)
  vim.cmd.vnew()
  if cmd then
    vim.fn.termopen(cmd, { cwd = cwd })
  else
    vim.cmd.term()
  end
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end
vim.keymap.set({ 'n', 't' }, '<C-/>', open_terminal, { desc = 'Terminal' })
vim.keymap.set({ 'n', 't' }, '<C-_>', open_terminal, { desc = 'Terminal' })
vim.keymap.set('n', '<leader>ft', open_terminal, { desc = 'Terminal' })

local runners = {
  python = function(file) return 'python3 ' .. file end,
  go = function(file) return 'go run ' .. file end,
  javascript = function(file) return 'node ' .. file end,
  sh = function(file) return 'bash ' .. file end,
  lua = function(file) return 'luajit ' .. file end,
  rust = function(file, name)
    local out = vim.fn.shellescape('/tmp/' .. name .. '.run')
    return ('rustc %s -o %s && %s'):format(file, out, out)
  end,
}
vim.keymap.set('n', '<leader>r', function()
  local runner = runners[vim.bo.filetype]
  if not runner then
    vim.notify('No runner for ' .. (vim.bo.filetype ~= '' and vim.bo.filetype or 'this file'), vim.log.levels.WARN)
    return
  end
  if vim.fn.expand '%:p' == '' then
    vim.notify('Save the file first', vim.log.levels.WARN)
    return
  end
  vim.cmd.write()
  open_terminal(runner(vim.fn.shellescape(vim.fn.expand '%:t'), vim.fn.expand '%:t:r'), vim.fn.expand '%:p:h')
end, { desc = 'Run file in terminal' })

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
    vim.notify('No compiler configured for ' .. (vim.bo.filetype ~= '' and vim.bo.filetype or 'this file'), vim.log.levels.WARN)
    return
  end
  vim.cmd.write()
  vim.cmd('compiler! ' .. spec.efm)
  vim.o.makeprg = spec.cmd
  vim.cmd('silent make')
  if #vim.fn.getqflist() > 0 then vim.cmd('copen') end
end, { desc = '[C]ompile' })

local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Previous error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Previous warning' })
