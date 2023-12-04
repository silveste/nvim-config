return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(
      opts.ensure_installed,
      { "css-lsp", "cssmodules-language-server", "marksman", "stylelint", "stylelint-lsp" }
    )
  end,
}
