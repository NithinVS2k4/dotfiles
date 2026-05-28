-- return {
--   dir = "~/.config/nvim/colors/",
--   name = "chalkboard",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("chalkboard")
--   end,
-- }

-- return {
--   "ellisonleao/gruvbox.nvim",
--   priority = 1000,
--   config = function()
--     vim.o.background = "dark"
--     vim.cmd.colorscheme("gruvbox")
--   end,
-- }
return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("kanagawa")
  end,
}
