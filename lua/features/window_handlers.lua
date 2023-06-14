local notify = require("notify").notify
local find_in_table = require("utils.tables.find")
local table_length = require("utils.tables.length")
local deep_copy = require("utils.tables.deep_copy")

local window_handlers = {}

local skip_buffers = { "neo-tree", "noice", "alpha" }
local win_buf_stack = {}

local function get_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  return winnr, bufnr
end

local function sync_bufs(listed_bufs)
  local nvim_bufs = vim.api.nvim_list_bufs()

  local new_bufs_table = {}
  for _, listed_buf in ipairs(listed_bufs) do
    for _, existing_buf in ipairs(nvim_bufs) do
      if listed_buf == existing_buf and vim.api.nvim_buf_is_loaded(existing_buf) then
        table.insert(new_bufs_table, existing_buf)
        break
      end
    end
  end
  return new_bufs_table
end

local function sync_windows()
  local current_windows = vim.api.nvim_list_wins()

  for history_window, _ in pairs(win_buf_stack) do
    local should_remove = true
    for _, existing_window in ipairs(current_windows) do
      if history_window == existing_window then
        should_remove = false
        break
      end
    end
    if should_remove then
      win_buf_stack[history_window] = nil
    end
  end
end

local function set_win_former_buf(winnr, buf_list)
  if table_length(buf_list) <= 1 then
    return buf_list
  end
  table.remove(buf_list, 1)
  vim.api.nvim_win_set_buf(winnr, buf_list[1])
  return buf_list
end

local function update_win_stack(winnr, buf_list)
  win_buf_stack[winnr] = buf_list
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
    local bufs_in_window = win_buf_stack[winnr]
    if bufs_in_window == nil then
      win_buf_stack[winnr] = { bufnr }
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
  sync_windows = sync_windows,

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
    local new_bufs = set_win_former_buf(winnr, sync_bufs(win_buf_stack[winnr]))
    update_win_stack(winnr, new_bufs)
  end,

  -- Deletes current buffer and closes window when there are no former buffers
  del_buf_auto_close_win = function()
    local winnr, bufnr = get_current()
    local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")

    --Get all windows rendering the current buffer
    local windows_with_current_buffer = {}
    for win, stack in pairs(win_buf_stack) do
      if stack[1] == bufnr then
        table.insert(windows_with_current_buffer, win)
      end
    end

    -- Create vars to gather data required to restore
    local data_backup = {}
    local floating_windows = {}

    --Sync and set former buffer on the windows that render the current buffer
    for _, win in ipairs(windows_with_current_buffer) do
      --sync bufs and save restoring data
      local synced_bufs = sync_bufs(win_buf_stack[win])
      data_backup[win] = deep_copy(synced_bufs)

      -- Create a floating window with current buffer to mask that other
      -- windows have changed the buffer to the former one while prompt
      -- to save the file is on
      if is_modified then
        vim.api.nvim_set_current_win(win)
        local width = vim.api.nvim_win_get_width(win)
        local height = vim.api.nvim_win_get_height(win)
        vim.api.nvim_open_win(
          bufnr,
          true,
          { relative = "win", focusable = false, style = "minimal", row = 0, col = 0, width = width, height = height }
        )
        local float_win, _ = get_current()
        table.insert(floating_windows, float_win)
      end

      --set former buffer
      local new_bufs = set_win_former_buf(win, synced_bufs)
      update_win_stack(win, new_bufs)
    end

    vim.api.nvim_set_current_win(winnr)
    vim.api.nvim_set_current_buf(bufnr)

    --Try to delete the buffer
    vim.cmd("silent! confirm bdelete" .. bufnr)

    --If operation cancelled, restore buffers back to the windows
    if is_modified and vim.api.nvim_buf_is_loaded(bufnr) then
      notify("Operation cancelled", vim.log.levels.WARN, { title = "Delete buffer" })
      for win, buf_list in pairs(data_backup) do
        vim.api.nvim_win_set_buf(win, buf_list[1])
        update_win_stack(win, buf_list)
      end
      for _, float_win in ipairs(floating_windows) do
        vim.api.nvim_win_close(float_win, true)
      end
    end

    --If no buffers render alpha
    sync_windows()
    if table_length(win_buf_stack) == 1 then
      for _, bufs in pairs(win_buf_stack) do
        local synced_bufs = sync_bufs(bufs)
        local file_name = vim.api.nvim_buf_get_name(synced_bufs[1])
        local is_not_file = file_name == nil or file_name == ""
        local buffer_content = vim.api.nvim_buf_get_lines(synced_bufs[1], 0, -1, false)
        local is_empty = #buffer_content[1] == 0
        if table_length(synced_bufs) == 1 and is_not_file and is_empty then
          vim.cmd("Alpha")
          vim.cmd("silent! bdelete" .. synced_bufs[1])
        end
      end
    end
  end,
}
