local rason = {}

local LEXEME_TYPE = require('rason.lexemes')

local indent_step = function ()
  return vim.fn.shiftwidth()
end

local no_space_character = function (k)
  return (
    k == LEXEME_TYPE.DELIM or
    k == LEXEME_TYPE.LEFT_BRACKET or
    k == LEXEME_TYPE.RIGHT_BRACKET
  )
end

local is_at_end = function(index, o)
  return index > #o
end

local no_newline_character = function (index, o)
  if is_at_end(index+1, o) then
    return true
  end

  local k, _ = next(o[index+1])
  return (
    k == LEXEME_TYPE.DELIM or
    k == LEXEME_TYPE.RIGHT_BRACKET
  )
end

local indentify = function (k)
  if (k < 0) then k = 0 end

  return string.rep(' ', k)
end

local is_empty_bracket = function (index, o)
  if is_at_end(index+1, o) then
    return true
  end

  local k, _ = next(o[index+1])
  return (
    k == LEXEME_TYPE.RIGHT_BRACKET
  )
end

local contains_one_lexeme = function (index, o)
  if is_at_end(index+2, o) then
    return true
  end

  local k, _ = next(o[index+2])
  return (
    k == LEXEME_TYPE.RIGHT_BRACKET
  )
end

rason.stringify = function(o, indent)
  indent = indent or 0
  local new_line = true
  local closing_bracket = false

  local s = indentify(indent)

  -- Lexer is an array of tokens, so a table containing
  -- tables which consist of a single key-val pairs
  for index, val in pairs(o) do
    local k, v = next(val)

    if (not new_line and
        not no_space_character(k) and
        not closing_bracket
      ) then
      s = s .. indentify(1)
    end

    if k == LEXEME_TYPE.LEFT_BRACKET then
      if (
        not is_empty_bracket(index, o) and
        not contains_one_lexeme(index, o)
      ) then
        new_line = true
        indent = indent + indent_step()
        s = s .. tostring(v) .. '\n' .. indentify(indent)
      else
        closing_bracket = true;
        s = s .. tostring(v)
      end

    elseif k == LEXEME_TYPE.RIGHT_BRACKET then
      new_line = true

      if (not closing_bracket) then
        indent = indent - indent_step()

        s = s .. '\n' .. indentify(indent) .. tostring(v)
      else
        s = s .. tostring(v)
        closing_bracket = false;
      end


      if (not no_newline_character(index, o)) then
        s = s .. '\n'
        s = s .. indentify(indent)
      end

    elseif k == LEXEME_TYPE.DELIM then
      new_line = true
      s = s .. tostring(v)

      if (not no_newline_character(index, o)) then
        s = s .. '\n' .. indentify(indent)
      end

    elseif k == LEXEME_TYPE.SEPARATOR then
      new_line = true
      s = s .. tostring(v) .. '\n' .. indentify(indent)

    else
      new_line = false
      s = s .. tostring(v)
    end

  end

  return s
end

return rason
