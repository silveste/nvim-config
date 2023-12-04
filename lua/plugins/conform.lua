return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Prettier might break some stylelint rules, therefore stylelint fix is executed after
      formatters_by_ft = {
        ["css"] = { "prettier", "stylelint" },
        ["scss"] = { "prettier", "stylelint" },
        ["less"] = { "prettier", "stylelint" },
      },
    },
  },
}