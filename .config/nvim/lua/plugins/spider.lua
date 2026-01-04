return {
  "chrisgrieser/nvim-spider",
  event = "VeryLazy",
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-w (subword forward)",
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-e (subword end)",
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-b (subword backward)",
    },
  },
  opts = {
    skipInsignificantPunctuation = true,
    subwordMovement = true,
    customPatterns = {},
  },
}
