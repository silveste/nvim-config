-- This module handles buffer management within windows, treating each window as a stack of buffers.
-- Buffers are linked to their respective windows, and windows close when their buffer stack is empty.
local notify = require("noice").notify
local find_in_table = require("utils.tables.find")
local table_length = require("utils.tables.length")
local confirm_save = require("utils.buffers.confirm_save")

-- This table tracks buffers opened in windows and allows for buffer management
local buffer_stacks = {}

local function get_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  return winnr, bufnr
end

local function get_valid_buffers(buf_list)
  local valid_bufs = {}
  for _, buf in ipairs(buf_list) do
    if vim.api.nvim_buf_is_valid(buf) then
      table.insert(valid_bufs, buf)
    end
  end
  return valid_bufs
end

local function list_windows_rendering_buffer(bufnr)
  local windows_buffer = {}
  for winnr, bufs in pairs(buffer_stacks) do
    if bufnr == bufs[1] then
      table.insert(windows_buffer, { window = winnr, has_single_buffer = #bufs == 1 })
    end
  end
  return windows_buffer
end

local function sync_stacks()
  local active_windows = vim.api.nvim_list_wins()

  for tracked_window, tracked_buffers_list in pairs(buffer_stacks) do
    local is_tracked_window_open = vim.tbl_contains(active_windows, tracked_window)
    if is_tracked_window_open then
      buffer_stacks[tracked_window] = get_valid_buffers(tracked_buffers_list)
    else
      buffer_stacks[tracked_window] = nil
    end
  end
end

local function set_stack_former_buf(winnr, buf_list)
  if table_length(buf_list) <= 1 then
    return buf_list
  end
  table.remove(buf_list, 1)
  vim.api.nvim_win_set_buf(winnr, buf_list[1])
  return buf_list
end

local function update_stack(winnr, buf_list)
  buffer_stacks[winnr] = buf_list
end

local function should_skip(win_id, buf_id)
  -- Skip invalid buffers or non-file buffers
  if
    not vim.api.nvim_buf_is_valid(buf_id)
    or vim.api.nvim_get_option_value("buftype", { scope = "local", buf = buf_id }) ~= ""
  then
    return true
  end

  -- Skip floating windows
  if vim.api.nvim_win_get_config(win_id).relative ~= "" then
    return true
  end

  -- Skip windows without normal buffers
  local buf_in_win = vim.api.nvim_win_get_buf(win_id)
  if vim.api.nvim_get_option_value("buftype", { scope = "local", buf = buf_in_win }) ~= "" then
    return true
  end

  return false
end

local function track_buffer()
  local winnr, bufnr = get_current()
  if should_skip(winnr, bufnr) then
    return
  end
  local bufs_in_window = buffer_stacks[winnr]
  if bufs_in_window == nil then
    buffer_stacks[winnr] = { bufnr }
    return
  end
  local current_buffer_pos = find_in_table(bufs_in_window, bufnr)
  if current_buffer_pos ~= nil and current_buffer_pos > 1 then
    table.remove(bufs_in_window, current_buffer_pos)
  end
  if current_buffer_pos == nil or current_buffer_pos > 1 then
    table.insert(bufs_in_window, 1, bufnr)
  end
end

return {

  --Called by autocommand on BufEnter, BufNewFile and WinLeave
  add_buffer = track_buffer,

  -- Called by autocommand on WinClosed
  sync_windows = sync_stacks,

  -- Split the window moving the current buffer to the new window and leaving in the current position
  -- the former buffer. If no former buffer split window and buffer
  split = function(split_type)
    local winnr, _ = get_current()
    local command
    if split_type == "v" then
      command = "vsplit"
    else
      command = "split"
    end
    vim.cmd(command)
    local new_bufs = set_stack_former_buf(winnr, get_valid_buffers(buffer_stacks[winnr]))
    update_stack(winnr, new_bufs)
  end,

  -- Deletes current buffer and closes window when there are no former buffers
  del_buf_auto_close_win = function()
    local _, bufnr = get_current()

    -- Find the windows that have only the current buffer tracked;
    local windows_rendering_buffer = list_windows_rendering_buffer(bufnr)
    local is_saved = confirm_save(bufnr)
    if is_saved then
      for _, window_with_buffer in ipairs(windows_rendering_buffer) do
        if window_with_buffer.has_single_buffer then
          -- delete the window if it has only the current buffer
          if table_length(buffer_stacks) > 1 then
            vim.api.nvim_win_close(window_with_buffer.window, true) -- `true` forces the window to close without saving
          end
        else
          -- Render former buffer if the window has more buffers
          set_stack_former_buf(window_with_buffer.window, buffer_stacks[window_with_buffer.window])
        end
      end
      vim.api.nvim_buf_delete(bufnr, {})
    else
      notify("Operation cancelled", vim.log.levels.WARN, { title = "Delete buffer" })
    end
    sync_stacks()
  end,
}
