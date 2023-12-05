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
    keys = {
      { "<leader><space>", false },
    },
    opts = {
      defaults = {
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        dynamic_preview_title = true,
        path_display = { "truncate" },
        layout_config = {
          prompt_position = "top",
          scroll_speed = 1,
          width = 0.9,
          height = 0.9,
          horizontal = {
            preview_cutoff = 120,
            preview_width = 0.6,
          },
          vertical = {
            mirror = true,
            preview_height = 0.6,
          },
          flex = {
            flip_columns = 120,
            flip_lines = 30,
          },
        },
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
