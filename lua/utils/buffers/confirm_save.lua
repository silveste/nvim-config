return function(bufnr)
  local is_modified = vim.api.nvim_get_option_value("modified", { scope = "local", buf = bufnr })
  if not is_modified then
    return true
  end
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local ok, choice = pcall(vim.fn.confirm, ("Save changes to %q?"):format(buffer_name), "&Yes\n&No\n&Cancel")
  if not ok or choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
    return false
  end
  vim.cmd.write()
  return true
end
