local LEXEME_TYPE = require("jq.lexemes")

local lexer = {}
local index = 1

local function is_at_end(text)
  return index > #text
end

local function is_whitespace(char)
  return (
    char == ' ' or
    char == '\n'
  )
end

local function is_delimeter(char)
  return (
    char == ':' or
    char == ';' or
    char == '=' or
    char == ','
  )
end

local function is_left_bracket(char)
  return (
    char == '(' or
    char == '{' or
    char == '['
  )
end

local function is_right_bracket(char)
  return (
    char == ')' or
    char == '}' or
    char == ']'
  )
end

local function is_bitwise_or_logical(char)
  return (
    char == '|' or
    char == '&'
  )
end

local function peek(text)
  if index+1 <= #text then
    return text:sub(index+1, index+1)
  end
  return ''
end

local function handle_string(text, char)
  local start = index

  while not is_at_end(text) do
    index = index + 1
    local curr_char = text:sub(index, index)

    if (curr_char == char) then
      local str = text:sub(start, index)
      index = index + 1
      return { [LEXEME_TYPE.VAR] = str }
    end
  end

  return { [LEXEME_TYPE.VAR] = text:sub(start) }
end

local function handle_var(text, char)
  local start = index

  while not is_at_end(text)
    and not is_delimeter(char)
    and not is_left_bracket(char)
    and not is_right_bracket(char)
    and not is_whitespace(char) do

    index = index + 1
    char = text:sub(index, index)
  end

  local var = text:sub(start, index-1)
  return { [LEXEME_TYPE.VAR] = var }
end

local function get_lexeme(text)
  local char = text:sub(index, index)

  if is_left_bracket(char) then
    index = index + 1
    return { [LEXEME_TYPE.LEFT_BRACKET] = char }
  end

  if is_right_bracket(char) then
    index = index + 1
    return { [LEXEME_TYPE.RIGHT_BRACKET] = char }
  end

  if is_delimeter(char) then
    index = index + 1
    return { [LEXEME_TYPE.DELIM] = char }
  end

  if (char == '\'' or char == '\"') then
    return handle_string(text, char)
  end

  return handle_var(text, char)
end

local function reset()
  index = 1
end

function lexer.lex(text)
  local new_text = {}

  while not is_at_end(text) do
    local char = text:sub(index, index)

    if is_whitespace(char) then
      index = index + 1
      goto continue
    end

    table.insert(new_text, get_lexeme(text))

    ::continue::
  end
  table.insert(new_text, { [LEXEME_TYPE.EOF] = "EOF" })

  reset()
  return new_text
end

return lexer
