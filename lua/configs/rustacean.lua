M = {}

M.all_crates_except = function(included_crates)
  -- Run `cargo metadata` to get all workspace members
  local handle = io.popen('cargo metadata --no-deps --format-version 1')
  local result = handle:read("*a")
  handle:close()

  -- Parse the JSON result
  local metadata = vim.fn.json_decode(result)

  -- Extract the names of all workspace members
  local all_crates = {}
  for _, package in ipairs(metadata.packages) do
    table.insert(all_crates, package.name)
  end

  -- Filter out the crates that are in the excluded_crates list
  return vim.tbl_filter(function(crate)
    return not vim.tbl_contains(included_crates, crate)
  end, all_crates)
end

return M
