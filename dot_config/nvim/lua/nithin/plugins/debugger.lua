return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    require("dap-python").setup("python3")

    require("dapui").setup()

    dap.adapters.codelldb = {
      type = "executable",
      command = "/Users/nithin/.vscode/extensions/vadimcn.vscode-lldb-1.12.2/adapter/codelldb",
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.loop.fs_realpath(vim.fn.getcwd()) .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue Debugging" })

    vim.keymap.set("n", "<leader>dss", dap.step_over, { desc = "Debug: Step Over Line" })

    vim.keymap.set("n", "<leader>dso", dap.step_out, { desc = "Debug: Step Out of Function" })

    vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Debug: Step Into Function" })
  end,
}
