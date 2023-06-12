-- returns the count of keys in a table
-- @param table_data: The table where to count the keys
-- @returns: integer with the count of keys
return function(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end
