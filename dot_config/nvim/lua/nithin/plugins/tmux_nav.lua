return {
  "christoomey/vim-tmux-navigator",
  lazy = false,

  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true })
    keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true })
    keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true })
    keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true })
  end,
}
