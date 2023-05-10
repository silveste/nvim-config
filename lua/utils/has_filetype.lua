return function(search_filetype)
  -- Get the buffer list
  local buf_list = vim.api.nvim_list_bufs()
  -- Iterate over each buffer and check if its filetype is "NvimTree"
  for _, bufnr in ipairs(buf_list) do
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == search_filetype then
      return true
    end
  end
  return false
end
