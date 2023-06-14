local function deep_copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deep_copy(orig_key)] = deep_copy(orig_value)
    end
    setmetatable(copy, deep_copy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

return deep_copy
