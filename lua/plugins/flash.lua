return {
  "folke/flash.nvim",
  opts = function(_, opts)
    vim.api.nvim_set_hl(0, "FlashCustomLabel", { bg = "#0000ff", fg = "#ffffff", bold = true })
    return vim.tbl_deep_extend("force", opts, {
      highlight = {
        groups = {
          label = "FlashCustomLabel",
        },
      },
    })
  end,
}
