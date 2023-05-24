local notify = require("notify").notify

return function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == nil or bufname == "" then
    notify("I could not get the path and file name", vim.log.levels.WARN, { title = "File path not copied" })
    return
  end
  vim.fn.setreg("*", bufname)
  notify(bufname, vim.log.levels.INFO, { title = "File path copied" })
end
