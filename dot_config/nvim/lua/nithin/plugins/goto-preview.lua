return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "BufEnter",
  config = true,
  opts = {
    width = 120, -- Width of the floating window
    height = 15, -- Height of the floating window
    default_mappings = false, -- We'll set our own mappings
    focus_on_open = true, -- Focus the floating window when opening
    dismiss_on_move = false, -- Keep window open when moving cursor
    force_close = true, -- Force close when needed
    stack_floating_preview_windows = true, -- Allow nested previews
    preview_window_title = { enable = true, position = "left" },
  },
}
