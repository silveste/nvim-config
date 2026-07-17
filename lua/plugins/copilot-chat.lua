return {
  "CopilotC-Nvim/CopilotChat.nvim",
  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
    {
      "<leader>ac",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "x" },
    },
    { "<leader>aa", false },
    { "<leader>ax", false },
    { "<leader>aq", false },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "x" },
    },
  },
  opts = {
    -- model = "claude-opus-4.6",
    model = "gpt-5.4",
    auto_insert_mode = false,
    trusted_tools = { "buffers", "gitdiff", "file", "glob", "grep" },
  },
}
