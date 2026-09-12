-- Personalizaciones: Neovide, cursor (smear) y scroll (neoscroll).

-- smear-cursor: animacion de cursor en Neovide.
vim.pack.add { 'https://github.com/sphamba/smear-cursor.nvim' }
require('smear_cursor').setup {}

-- neoscroll: scroll suave en terminal (en Neovide ya lo maneja la GUI).
if vim.g.neovide == nil then
  vim.pack.add { 'https://github.com/karb94/neoscroll.nvim' }
  require('neoscroll').setup {}
end

if vim.g.neovide then
  vim.o.guifont = 'UbuntuSansMono Nerd Font:h16'
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_theme = 'auto'
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.7

  -- Fuerza el fondo al del terminal (ghostty) para que no lo pise el tema.
  local ghostty_bg = 0x0d0c0c
  local function apply_bg()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
    normal.bg = ghostty_bg
    vim.api.nvim_set_hl(0, 'Normal', normal)
  end
  vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_bg })
  apply_bg()

  -- Zoom con Ctrl +/-.
  local scale = 1.0
  local function zoom(factor)
    scale = math.max(0.5, math.min(3.0, scale * factor))
    vim.g.neovide_scale_factor = scale
  end
  for _, lhs in ipairs { '<C-=>', '<C-+>' } do
    vim.keymap.set({ 'n', 'v', 'i' }, lhs, function() zoom(1.1) end)
  end
  vim.keymap.set({ 'n', 'v', 'i' }, '<C-->', function() zoom(1 / 1.1) end)
end
