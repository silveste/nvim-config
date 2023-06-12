-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

local window_handlers = require("features.window_handlers")
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "WinLeave" }, {
  group = augroup("window_handlers_add_buf"),
  callback = function()
    window_handlers.add_buffer()
  end,
})
vim.api.nvim_create_autocmd({ "WinClosed" }, {
  group = augroup("window_handlers_sync_windows"),
  callback = function()
    window_handlers.sync_windows()
  end,
})
