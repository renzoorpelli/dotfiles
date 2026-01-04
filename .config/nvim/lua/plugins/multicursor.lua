return {
  "jake-stewart/multicursor.nvim",
  event = "BufReadPost",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup({
      -- set to true if you want multicursor undo history
      -- to clear when clearing cursors
      shallowUndo = false,

      -- set to empty table to disable signs
      signs = { " ┆", " │", " ┃" },
    })

    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "v" }, "<C-Up>", function()
      mc.lineAddCursor(-1)
    end, { desc = "Add cursor above" })
    vim.keymap.set({ "n", "v" }, "<C-Down>", function()
      mc.lineAddCursor(1)
    end, { desc = "Add cursor below" })

    -- Add a cursor and jump to the next word under cursor.
    vim.keymap.set({ "n", "v" }, "<C-n>", function()
      mc.matchAddCursor(1)
    end, { desc = "Add cursor to next match" })

    -- Skip the next match
    vim.keymap.set({ "n", "v" }, "<C-s>", function()
      mc.matchSkipCursor(1)
    end, { desc = "Skip next match" })

    -- Add all matches
    vim.keymap.set({ "n", "v" }, "<C-a>", function()
      mc.matchAllAddCursors()
    end, { desc = "Add cursors to all matches" })

    -- Rotate the main cursor.
    vim.keymap.set({ "n", "v" }, "<left>", mc.nextCursor, { desc = "Next cursor" })
    vim.keymap.set({ "n", "v" }, "<right>", mc.prevCursor, { desc = "Previous cursor" })

    -- Delete the main cursor.
    vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor, { desc = "Delete cursor" })

    vim.keymap.set("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> handler.
      end
    end, { desc = "Clear cursors" })

    -- Align cursor columns.
    vim.keymap.set("v", "<leader>a", mc.alignCursors, { desc = "Align cursors" })

    -- Append/insert for each line of visual selections.
    vim.keymap.set("v", "I", mc.insertVisual, { desc = "Insert at cursors" })
    vim.keymap.set("v", "A", mc.appendVisual, { desc = "Append at cursors" })

    -- match new cursors within visual selections by regex.
    vim.keymap.set("v", "M", mc.matchCursors, { desc = "Match cursors by regex" })

    -- Rotate visual selection contents.
    vim.keymap.set("v", "<leader>t", function()
      mc.transposeCursors(1)
    end, { desc = "Transpose cursors forward" })
    vim.keymap.set("v", "<leader>T", function()
      mc.transposeCursors(-1)
    end, { desc = "Transpose cursors backward" })

    -- Customize how cursors look.
    vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
    vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
