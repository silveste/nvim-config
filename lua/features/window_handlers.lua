local window_handlers = {}

local find_in_table = require("utils.tables.find")
local table_length = require("utils.tables.length")

local skip_buffers = { "neo-tree", "noice", "alpha" }
local win_history = {}

local function get_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  return winnr, bufnr
end

local function sync_bufs(winnr)
  local history_bufs = win_history[winnr]
  local current_bufs = vim.api.nvim_list_bufs()

  local new_bufs_table = {}
  for _, history_buf in ipairs(history_bufs) do
    for _, existing_buf in ipairs(current_bufs) do
      if history_buf == existing_buf and vim.api.nvim_buf_is_loaded(existing_buf) then
        table.insert(new_bufs_table, existing_buf)
        break
      end
    end
  end
  win_history[winnr] = new_bufs_table
end

local function set_last_buf(winnr)
  if win_history[winnr] == nil then
    return
  end
  sync_bufs(winnr)
  if table_length(win_history[winnr]) <= 1 then
    return
  end
  table.remove(win_history[winnr], 1)
  vim.api.nvim_win_set_buf(winnr, win_history[winnr][1])
end

local function should_skip(winnr, bufnr)
  local windowType = vim.api.nvim_win_get_option(winnr, "winhl")
  if windowType ~= nil and windowType ~= "" then
    return true
  end
  if bufnr ~= nil then
    local current_filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    for _, skip_filetype in ipairs(skip_buffers) do
      if skip_filetype == current_filetype then
        return true
      end
    end
  end
  return false
end

return {

  --Called by autocommand on BufEnter, BufNewFile and WinLeave
  add_buffer = function()
    local winnr, bufnr = get_current()
    if should_skip(winnr, bufnr) then
      return
    end
    local bufs_in_window = win_history[winnr]
    if bufs_in_window == nil then
      win_history[winnr] = { bufnr }
      return
    end
    local current_buffer_pos = find_in_table(bufs_in_window, bufnr)
    if current_buffer_pos ~= nil and current_buffer_pos > 1 then
      table.remove(bufs_in_window, current_buffer_pos)
    end
    if current_buffer_pos == nil or current_buffer_pos > 1 then
      table.insert(bufs_in_window, 1, bufnr)
    end
  end,

  -- Called by autocommand on WinClosed
  sync_windows = function()
    local current_windows = vim.api.nvim_list_wins()

    for history_window, _ in pairs(win_history) do
      local should_remove = true
      for _, existing_window in ipairs(current_windows) do
        if history_window == existing_window then
          should_remove = false
          break
        end
      end
      if should_remove then
        win_history[history_window] = nil
      end
    end
  end,

  split = function(split_type)
    local winnr, _ = get_current()
    local command
    if split_type == "v" then
      command = "vsplit"
    else
      command = "split"
    end
    vim.cmd(command)
    set_last_buf(winnr)
  end,
}
