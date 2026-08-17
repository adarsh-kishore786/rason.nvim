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

local function replace_visual_selection(replacement_string)
  local vmode = vim.fn.mode()
  if vmode ~= "v" and vmode ~= "V" then
    error("replace_visual_selection: only charwise ('v') and linewise ('V') selections are supported, got: " .. vim.inspect(vmode))
  end

  -- 1. Exit visual mode to save the '< and '> selection marks
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  -- 2. Get 1-indexed positions of the visual selection boundaries
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2] - 1

  local start_col, end_col

  if vmode == "V" then
    start_col = 0
    local last_line = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, true)[1] or ""
    end_col = #last_line
  else
    start_col = start_pos[3] - 1
    end_col = end_pos[3] - 1

    if vim.o.selection ~= "exclusive" then
      local line = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, true)[1]
      if line then
        local byte_index = vim.fn.byteidx(line, vim.fn.charidx(line, end_col))
        end_col = math.min(#line, byte_index + 1)
      end
    end
  end

  local lines = vim.split(replacement_string, "\n")
  vim.api.nvim_buf_set_text(0, start_line, start_col, end_line, end_col, lines)
end

local function process()
  local text = get_selected_text()
  local lexed = lexer.lex(text)
  local initial_indent = vim.fn.cindent('.')
  local rasonified_str = rason.stringify(lexed, initial_indent)

  logger.info(rasonified_str)
  replace_visual_selection(rasonified_str)
end

function M.setup()
  vim.keymap.set("x", "<leader>j", function ()
    logger.clear()
    process()
  end)
end

return M
