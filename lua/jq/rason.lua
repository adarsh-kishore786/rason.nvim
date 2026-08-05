local rason = {}

local lexemes = require('jq.lexemes')
local logger = require('jq.logger')

local check_indent_left = function(key)
  return (
    key == lexemes.LEFT_BRACE or
    key == lexemes.LEFT_CURLY or
    key == lexemes.LEFT_SQUARE
  )
end

local check_indent_right = function(key)
  return (
    key == lexemes.RIGHT_BRACE or
    key == lexemes.RIGHT_CURLY or
    key == lexemes.RIGHT_SQUARE
  )
end

local check_delimeter = function(key)
  return (
    key == lexemes.COMMA or
    key == lexemes.SEMI_COLON
  )
end

rason.stringify = function(o, indent)
  indent = indent or 0
  local new_line = true

  local s = ''

  -- Lexer is an array of tokens, so a table containing
  -- tables which consist of a single key-val pairs
  for _, val in pairs(o) do
    local k, v = next(val)

    if (not new_line and not check_delimeter(k)) then
      s = s .. ' '
    end

    if check_indent_left(k) then
      new_line = true
      indent = indent + 2
      s = s .. tostring(v) .. '\n' .. string.rep(' ', indent)

    elseif check_indent_right(k) then
      new_line = true
      indent = indent - 2
      if (indent < 0) then indent = 0 end

      s = s .. '\n' .. string.rep(' ', indent) .. tostring(v)

    elseif check_delimeter(k) then
      new_line = true
      s = s .. tostring(v) .. '\n' .. string.rep(' ', indent)

    else
      new_line = false
      s = s .. tostring(v)
    end

  end

  return s
end

return rason
