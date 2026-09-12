-- Multi-cursor: editar varias ocurrencias/lineas a la vez.
-- Ver los atajos con: cheat multicursor

vim.pack.add { { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' } }

local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

-- Agregar cursor en la siguiente / anterior ocurrencia (palabra o seleccion).
set({ 'n', 'x' }, '<C-n>', function() mc.matchAddCursor(1) end, { desc = 'Multi-cursor: siguiente ocurrencia' })
set({ 'n', 'x' }, '<C-p>', function() mc.matchAddCursor(-1) end, { desc = 'Multi-cursor: ocurrencia anterior' })

-- Todas las ocurrencias, duplicar y restaurar.
set({ 'n', 'x' }, '<leader>mc', mc.matchAllAddCursors, { desc = 'Multi-cursor: todas las ocurrencias' })
set({ 'n', 'x' }, '<leader>md', mc.duplicateCursors, { desc = 'Multi-cursor: duplicar cursors' })
set({ 'n', 'x' }, '<leader>mr', mc.restoreCursors, { desc = 'Multi-cursor: restaurar cursors' })
set({ 'n', 'x' }, '<leader>ma', mc.alignCursors, { desc = 'Multi-cursor: alinear columnas' })

-- Cursor en la linea de abajo / arriba.
set({ 'n', 'x' }, '<M-Down>', function() mc.lineAddCursor(1) end, { desc = 'Multi-cursor: linea abajo' })
set({ 'n', 'x' }, '<M-Up>', function() mc.lineAddCursor(-1) end, { desc = 'Multi-cursor: linea arriba' })

-- Ctrl+click agrega/quita cursor.
set('n', '<C-LeftMouse>', mc.handleMouse)
set('n', '<C-LeftDrag>', mc.handleMouseDrag)
set('n', '<C-LeftRelease>', mc.handleMouseRelease)

-- Capa que solo aplica cuando hay varios cursors.
mc.addKeymapLayer(function(layerSet)
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor, { desc = 'Cursor anterior' })
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor, { desc = 'Cursor siguiente' })
  layerSet({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'Borrar cursor principal' })
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end, { desc = 'Limpiar cursors' })
end)

-- Colores de los cursors.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
