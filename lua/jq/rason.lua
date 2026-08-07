local rason = {}
local logger = require('jq.logger')

local LEXEME_TYPE = require('jq.lexemes')

rason.stringify = function(o, indent)
  indent = indent or 0
  local new_line = true

  local s = ''

  -- Lexer is an array of tokens, so a table containing
  -- tables which consist of a single key-val pairs
  for _, val in pairs(o) do
    local k, v = next(val)
    logger.debug(tostring(k) .. ': ' .. tostring(v))

    if (not new_line and k ~= LEXEME_TYPE.DELIM) then
      s = s .. ' '
    end

    if k == LEXEME_TYPE.LEFT_BRACKET then
      new_line = true
      indent = indent + 2
      s = s .. tostring(v) .. '\n' .. string.rep(' ', indent)

    elseif k == LEXEME_TYPE.RIGHT_BRACKET then
      new_line = true
      indent = indent - 2
      if (indent < 0) then indent = 0 end

      s = s .. '\n' .. string.rep(' ', indent) .. tostring(v) .. '\n'

    elseif k == LEXEME_TYPE.DELIM then
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
