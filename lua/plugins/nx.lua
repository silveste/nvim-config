return {
  {
    "Equilibris/nx.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      nx_cmd_root = "npx nx",
    },
    -- Plugin will load when you use these keys
    keys = {
      { "<leader>na", "<cmd>Telescope nx actions<CR>", desc = "Actions list" },
      { "<leader>nn", "<cmd>Telescope nx generators<CR>", desc = "Generators list" },
    },
  },
}
