-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- map modes: https://neovim.io/doc/user/map.html#map-modes

-- MODES
-- Switch to normal
vim.keymap.set("i", "jj", "<ESC>", { silent = true, desc = "Switch to normal mode" })
vim.keymap.set("i", "JJ", "<ESC>", { silent = true, desc = "Switch to normal mode" })
vim.keymap.set("c", "jj", "<C-c>", { desc = "Switch to normal mode" })
vim.keymap.set("c", "JJ", "<C-c>", { desc = "Switch to normal mode" })

-- NAVIGATION
-- Moving cursor on insert and command modes
vim.keymap.set("i", "<M-j>", "<Down>", { silent = true, desc = "Move the cursor down" })
vim.keymap.set("i", "<M-k>", "<Up>", { silent = true, desc = "Move the cursor up" })
vim.keymap.set("i", "<M-h>", "<Left>", { silent = true, desc = "Move the cursor left" })
vim.keymap.set("i", "<M-l>", "<Right>", { silent = true, desc = "Move the cursor right" })
vim.keymap.set("c", "<M-j>", "<Down>", { desc = "Move the cursor down" })
vim.keymap.set("c", "<M-k>", "<Up>", { desc = "Move the cursor up" })
vim.keymap.set("c", "<M-h>", "<Left>", { desc = "Move the cursor left" })
vim.keymap.set("c", "<M-l>", "<Right>", { desc = "Move the cursor right" })

-- BUFFERS
local save_all_buffers = require("utils.save_all_buffers")
vim.keymap.set({ "n" }, "<C-s><C-s>", save_all_buffers, { silent = true, desc = "Save all buffers" })
vim.keymap.set({ "i" }, "<C-s><C-s>", save_all_buffers, { silent = true, desc = "Save all buffers" })

vim.keymap.set({ "n" }, "<leader>d", ":bdelete<CR>", { silent = true, desc = "Delete window and buffer" })

-- UTILS
local yank_file_path = require("utils.yank_file_path")
vim.keymap.set({ "n" }, "yp", yank_file_path, { silent = true, desc = "Path of the file" })
-- Send replaced text to blackhole register (disables cut function)
vim.keymap.set({ "n", "v" }, "c", '"_c', { silent = true, desc = "Change text" })
