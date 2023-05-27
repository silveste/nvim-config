local actions = require("telescope.actions")

local function paste_in_one_line()
  local register_content = vim.fn.getreg("+")
  -- Replace line breaks, tabs, and sequences of spaces with a single space
  local line = register_content:gsub("[\n\t]+", " "):gsub("%s%s+", " ")
  vim.api.nvim_feedkeys(line, "i", true)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = {
            ["<C-q>"] = actions.close,
            ["<C-v>"] = paste_in_one_line,
            ["<D-v>"] = paste_in_one_line,
            ["<C-->"] = actions.select_horizontal,
            ["<C-\\>"] = actions.select_vertical,
            ["<C-t>"] = false, -- Removes default option to open in other TAB
          },
          n = {
            ["<C-v>"] = paste_in_one_line,
            ["<D-v>"] = paste_in_one_line,
            ["<C-->"] = actions.select_horizontal,
            ["<C-|>"] = actions.select_vertical,
            ["<C-t>"] = false, -- Removes default option to open in other TAB
          },
        },
      },
    },
  },
}
