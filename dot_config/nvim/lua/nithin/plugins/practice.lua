return {
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  {
    "m4xshen/hardtime.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      disabled_keys = {
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Left>"] = false,
        ["<Right>"] = false,
      },
    },
  },
}
