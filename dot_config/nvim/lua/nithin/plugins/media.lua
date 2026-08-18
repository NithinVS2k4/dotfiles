return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,

        formats = {
          "png",
          "jpg",
          "jpeg",
          "webp",
          "gif",
          "bmp",
          "tiff",
          "heic",
          "avif",
          "icns",
        },
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].filetype == "image" then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                pcall(vim.api.nvim_buf_delete, args.buf, {
                  force = true,
                })
              end
            end)
          end
        end,
      })
    end,
  },
}
