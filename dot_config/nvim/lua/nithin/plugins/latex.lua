-- lua/plugins/latex.lua

return {
  {
    "lervag/vimtex",
    lazy = false,
    tag = "v2.17",
    init = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        options = {
          "-pdf",
          "-outdir=build",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_mode = 0

      -- Disable default \ll, \lv, etc. mappings
      vim.g.vimtex_mappings_enabled = 0
    end,

    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>l", group = "LaTeX" },
      })

      local map = vim.keymap.set

      map("n", "<leader>ll", "<cmd>VimtexCompile<CR>", {
        desc = "Compile",
        silent = true,
      })

      map("n", "<leader>lv", "<cmd>VimtexView<CR>", {
        desc = "View PDF",
        silent = true,
      })

      map("n", "<leader>lk", "<cmd>VimtexStop<CR>", {
        desc = "Stop Compiler",
        silent = true,
      })

      map("n", "<leader>le", "<cmd>VimtexErrors<CR>", {
        desc = "Errors",
        silent = true,
      })

      map("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", {
        desc = "Table of Contents",
        silent = true,
      })

      map("n", "<leader>lc", "<cmd>VimtexClean<CR>", {
        desc = "Clean Aux Files",
        silent = true,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function(args)
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true

          local opts = { buffer = args.buf }

          vim.keymap.set("n", "j", "gj", opts)
          vim.keymap.set("n", "k", "gk", opts)
          vim.keymap.set("n", "<Down>", "gj", opts)
          vim.keymap.set("n", "<Up>", "gk", opts)
          vim.keymap.set("i", "<Down>", "<C-o>gj", opts)
          vim.keymap.set("i", "<Up>", "<C-o>gk", opts)
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.texlab.setup({
        settings = {
          texlab = {},
        },
      })
    end,
  },
}
