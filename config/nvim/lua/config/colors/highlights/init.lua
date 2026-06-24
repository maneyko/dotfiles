-- Get the full path of the current file
local current_file = debug.getinfo(1, "S").source:sub(2)
-- Extract the directory from the path
local current_dir = current_file:match("(.*[/\\])")

local names = {}
local n
for name, type in vim.fs.dir(current_dir) do
  if type == "file" and name ~= "init.lua" then
    n = name:gsub("%.lua$", "")
    table.insert(names, n)
  end
end

table.sort(names)
local funcs = {}
for _, name in ipairs(names) do
  table.insert(funcs, require("config.colors.highlights."..name))
end

return function(colors)
  local configs = {}
  for _, func in ipairs(funcs) do
    configs = vim.tbl_deep_extend("force", configs, func(colors))
  end
  return configs
end

-- -- Get the full path of the current file
-- local current_file = debug.getinfo(1, "S").source:sub(2)
-- -- Extract the directory from the path
-- local current_dir = current_file:match("(.*[/\\])")
--
-- local files = {}
-- local funcs = {}
-- for name, type in vim.fs.dir(current_dir) do
--   if type == "file" and name ~= "init.lua" then
--     table.insert(files, name)
--     table.insert(funcs, require("config.colors.highlights."..name:gsub("%.lua$", "")))
--   end
-- end
--
-- return function(colors)
--   local configs = {}
--   for _, func in ipairs(funcs) do
--     configs = vim.tbl_deep_extend("force", configs, func(colors))
--   end
--   return configs
-- end
