local notify = require("notify").notify

local function is_buf_modified(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "modified") then
    return true
  end
  return false
end

return function()
  local modified_buffers = {}
  local unsaved_buffers = {}
  local saved_buffers = {}
  local nothing_done_msg = true

  -- get modified buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if is_buf_modified(bufnr) then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      table.insert(modified_buffers, { name = bufname, id = bufnr })
    end
  end

  -- save all buffers
  vim.cmd("silent wa")

  -- Check which ones were successful
  for _, buf in ipairs(modified_buffers) do
    if is_buf_modified(buf.id) then
      table.insert(unsaved_buffers, buf.name)
    else
      table.insert(saved_buffers, buf.name)
    end
  end

  -- print the result
  if next(saved_buffers) ~= nil then
    notify(saved_buffers, vim.log.levels.INFO, { title = "Buffers saved" })
    nothing_done_msg = false
  end

  if next(unsaved_buffers) ~= nil then
    notify(unsaved_buffers, vim.log.levels.ERROR, { title = "Error saving buffers" })
    nothing_done_msg = false
  end

  if nothing_done_msg then
    notify("No pending buffer changes", vim.log.levels.INFO, { title = "Saving buffers" })
  end
end
