return {
  "smoka7/hop.nvim",
  event = "VeryLazy",
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection

    hop.setup({})

    -- Hop to any word
    vim.keymap.set("", "<leader>hw", function()
      hop.hint_words()
    end, { desc = "Hop to word" })

    -- Hop with 2 characters
    vim.keymap.set("", "<leader>hh", function()
      hop.hint_char2({ current_line_only = false })
    end, { desc = "Hop 2 characters" })

    -- Hop to line
    vim.keymap.set("", "<leader>hl", function()
      hop.hint_lines()
    end, { desc = "Hop to line" })

    -- Enhanced f/F with hop
    vim.keymap.set("", "<leader>hf", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { desc = "Hop forward (line)" })
    
    vim.keymap.set("", "<leader>hF", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { desc = "Hop backward (line)" })
  end,
}
