-- returns the index or key of the first value that matches the criteria
-- @param table_data: The table where to find the search value
-- @param value_to_find: Value to be found or function that receives  a value from the table and should
-- return true or false. When return true the value is considered found
-- @returns : index or key when found and nil if not found
return function(table_data, value_to_find)
  for k, v in pairs(table_data) do
    if type(value_to_find) == "function" then
      if value_to_find(v) then
        return k
      end
    else
      if value_to_find == v then
        return k
      end
    end
  end
end
