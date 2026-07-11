local M = {}

local function get_selected_text()
  local mode = vim.api.nvim_get_mode().mode

  local lines = vim.fn.getregion(
    vim.fn.getpos("."),
    vim.fn.getpos("v"),
    { type = mode }
  )

  return table.concat(lines, "\n")
end

local function process()
  local text = get_selected_text()
  print(text)
end

function M.setup()
  vim.keymap.set("x", "<leader>j", function ()
    process()
  end)
end

return M
