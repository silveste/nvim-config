-- @param: filetypes: table with strings that represent filetypes
-- @return: null or number with files open in neovim that match the filetypes
return function(filetypes)
  -- Get the buffer list
  local buf_list = vim.api.nvim_list_bufs()
  local found_types = 0
  -- Iterate over each buffer and check if its filetype is "NvimTree"
  for _, bufnr in ipairs(buf_list) do
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    for _, search_filetype in ipairs(filetypes) do
      if filetype == search_filetype then
        found_types = found_types + 1
      end
    end
  end
  if found_types > 0 then
    return found_types
  end
end
