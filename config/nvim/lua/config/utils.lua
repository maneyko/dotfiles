local M = {}

M.substr_exists = function(str, substr)
  return string.find(str, substr, 1, true) ~= nil
end

M.sleep_and_clear = function(milliseconds)
  vim.defer_fn(function() print("") end, milliseconds)
end

M.echo_info = function(message, display_timeout_ms)
  display_timeout_ms = display_timeout_ms or 2000
  vim.api.nvim_echo({{message, "MoreMsg"}}, true, {})
  M.sleep_and_clear(display_timeout_ms)
end

local state = {}
vim.g.autocmd_file_loaded_table = {}
M.autocmd_file_loaded = function(options)
  vim.api.nvim_create_autocmd({
    "BufReadPost",
    "BufNewFile",
    "BufEnter",
  }, {
    pattern = "*",
    callback = function()
      local key = options["name"]..vim.api.nvim_get_current_buf()
      if state[key] then
        return
      else
        state[key] = true
      end
      if vim.bo.filetype == "" then
        vim.cmd("filetype detect")
      end
      local pattern = options["pattern"]
      if type(pattern) ~= "table" then
        pattern = { pattern }
      end
      if options["pattern"] ~= "*" and not vim.tbl_contains(pattern, vim.bo.filetype) then
        return
      end
      options["callback"]()
    end
  })
end

-- https://github.com/neovim/neovim/discussions/37122#discussioncomment-15352797
M.stop_lsps = function(info)
-- function M.stop_lsps(info)
  local client_names = info.fargs

  -- Default to disabling all servers on current buffer
  if #client_names == 0 then
    client_names = vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :totable()
  end

  for name in vim.iter(client_names) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      vim.lsp.enable(name, false)
      if info.bang then
        vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
          client:stop(true)
        end)
      end
    end
  end
end

local system_colors = {
   [0] = {0, 0, 0},       -- Black
   [1] = {128, 0, 0},     -- Red
   [2] = {0, 128, 0},     -- Green
   [3] = {128, 128, 0},   -- Yellow
   [4] = {0, 0, 128},     -- Blue
   [5] = {128, 0, 128},   -- Magenta
   [6] = {0, 128, 128},   -- Cyan
   [7] = {192, 192, 192}, -- Light Gray
   [8] = {128, 128, 128}, -- Dark Gray
   [9] = {255, 0, 0},     -- Light Red
  [10] = {0, 255, 0},     -- Light Green
  [11] = {255, 255, 0},   -- Light Yellow
  [12] = {0, 0, 255},     -- Light Blue
  [13] = {255, 0, 255},   -- Light Magenta
  [14] = {0, 255, 255},   -- Light Cyan
  [15] = {255, 255, 255}  -- White
}

M.xterm_to_rgb = function(color)
  local r, g, b

  -- 1. System Colors (0-15)
  if color >= 0 and color <= 15 then
    local rgb = system_colors[color]
    r = rgb[1]
    b = rgb[2]
    g = rgb[3]

  -- 2. 6x6x6 Color Cube (16-231)
  elseif color >= 16 and color <= 231 then
    local rem = color - 16

    -- Extract grid coordinates (0 to 5)
    local rc = math.floor(rem / 36)
    local gc = math.floor(rem / 6) % 6
    local bc = rem % 6

    -- Scale coordinates to 8-bit values (0-255)
    r = (rc == 0) and 0 or (rc * 40 + 55)
    g = (gc == 0) and 0 or (gc * 40 + 55)
    b = (bc == 0) and 0 or (bc * 40 + 55)

  -- 3. Grayscale Ramp (232-255)
  elseif color >= 232 and color <= 255 then
    local val = (color - 232) * 10 + 8
    r, g, b = val, val, val
  end

  return string.format("#%02X%02X%02X", r, g, b)
end


return M
