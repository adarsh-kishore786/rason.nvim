local lexer = require("jq.lexer")
local rason = require("jq.rason")
local logger = require("jq.logger")

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
  local lexed = lexer.lex(text)
  logger.info(rason.stringify(lexed))
end

function M.setup()
  vim.keymap.set("x", "<leader>j", function ()
    logger.clear()
    process()
  end)
end

return M
