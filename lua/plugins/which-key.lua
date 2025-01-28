return {
  "folke/which-key.nvim",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n" },
      ["<leader>n"] = { name = "+nx build system" },
    },
  },
}
