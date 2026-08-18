return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Add next/previous match
      set({ "n", "x" }, "<C-i>", function()
        mc.matchAddCursor(1)
      end)

      -- Skip next/previous match
      set({ "n", "x" }, "<A-d>", function()
        mc.matchSkipCursor(1)
      end)

      -- Select all matches
      set({ "n", "x" }, "<C-S-d>", mc.matchAllAddCursors)

      -- Add cursors vertically
      set({ "n", "x" }, "<C-k>", function()
        mc.lineAddCursor(-1)
      end)

      set({ "n", "x" }, "<A-k>", function()
        mc.lineSkipCursor(-1)
      end)

      set({ "n", "x" }, "<C-j>", function()
        mc.lineAddCursor(1)
      end)

      set({ "n", "x" }, "<A-j>", function()
        mc.lineSkipCursor(1)
      end)
      -- Toggle multicursors
      set({ "n", "x" }, "<C-q>", mc.toggleCursor)

      -- Keymaps that are only active when multicursors exist
      mc.addKeymapLayer(function(layerSet)
        layerSet("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },
}
