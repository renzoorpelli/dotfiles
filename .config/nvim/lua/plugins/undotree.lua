return {
  "mbbill/undotree",
  keys = {
    {
      "<leader>u",
      "<cmd>UndotreeToggle<CR>",
      desc = "Toggle Undotree",
    },
  },
  config = function()
    vim.g.undotree_WindowLayout = 3 -- Right layout
    vim.g.undotree_SplitWidth = 40 -- Width of the undotree window
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus on the undotree window when toggled
  end,
}
