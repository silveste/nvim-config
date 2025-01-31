return {
  "folke/which-key.nvim",
  opts = {
    plugins = { spelling = true },
    spec = {
      {
        mode = { "n" },
        { "<leader>n", group = "nx build system" },
        { "yp", prefix = "y", desc = "Path of the file" },
      },
    },
  },
}
