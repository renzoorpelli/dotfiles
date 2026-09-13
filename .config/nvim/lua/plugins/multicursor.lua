vim.pack.add { { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' } }

local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

set({ 'n', 'x' }, '<C-n>', function() mc.matchAddCursor(1) end, { desc = 'Multi-cursor: next match' })
set({ 'n', 'x' }, '<C-p>', function() mc.matchAddCursor(-1) end, { desc = 'Multi-cursor: previous match' })

set({ 'n', 'x' }, '<leader>mc', mc.matchAllAddCursors, { desc = 'Multi-cursor: all matches' })
set({ 'n', 'x' }, '<leader>md', mc.duplicateCursors, { desc = 'Multi-cursor: duplicate cursors' })
set({ 'n', 'x' }, '<leader>mr', mc.restoreCursors, { desc = 'Multi-cursor: restore cursors' })
set({ 'n', 'x' }, '<leader>ma', mc.alignCursors, { desc = 'Multi-cursor: align columns' })

set({ 'n', 'x' }, '<M-Down>', function() mc.lineAddCursor(1) end, { desc = 'Multi-cursor: line below' })
set({ 'n', 'x' }, '<M-Up>', function() mc.lineAddCursor(-1) end, { desc = 'Multi-cursor: line above' })

set('n', '<C-LeftMouse>', mc.handleMouse)
set('n', '<C-LeftDrag>', mc.handleMouseDrag)
set('n', '<C-LeftRelease>', mc.handleMouseRelease)

mc.addKeymapLayer(function(layerSet)
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor, { desc = 'Previous cursor' })
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor, { desc = 'Next cursor' })
  layerSet({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'Delete main cursor' })
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end, { desc = 'Clear cursors' })
end)

local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
