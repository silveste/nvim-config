return {
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinNew" },
    opts = {
      highlight = {
        bg = "#2c3441",
        fg = "#6a7e95",
      },
      -- timer refresh rate
      interval = 30,
      -- This plugin will not be activated for filetype in the following table.
      no_exec_files = { "alpha", "TelescopePrompt", "mason", "noice", "neo-tree" },
      -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      create_event = function()
        local colorful_winsep = require("colorful-winsep")
        local win_n = require("colorful-winsep.utils").calculate_number_windows()
        local has_filetypes = require("utils.buffers.is_filetypes_open")
        if win_n == 2 and has_filetypes({ "neo-tree" }) then
          colorful_winsep.NvimSeparatorDel()
        end
      end,
    },
  },
}
