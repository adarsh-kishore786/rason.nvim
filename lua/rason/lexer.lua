local LEXEME_TYPE = require("rason.lexemes")

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
    char == ';' or
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

-- Separators are just like delimeters but they leave a space before themselves
local function is_separator(char)
  return (
    char == '|' or
    char == '&' or
    char == '='
  )
end

local function handle_separator(text, char)
  local start = index
  local curr_char = char;

  while not is_at_end(text) do
    index = index + 1
    curr_char = text:sub(index, index)

    if (curr_char ~= char) then
      local str = text:sub(start, index-1)
      return { [LEXEME_TYPE.SEPARATOR] = str }
    end
  end

end

local function handle_string(text, char)
  local start = index
  local char_before = ''
  local curr_char = char

  while not is_at_end(text) do
    index = index + 1

    char_before = curr_char
    curr_char = text:sub(index, index)

    if (curr_char == char and char_before ~= '\\') then
      local str = text:sub(start, index)
      index = index + 1
      return { [LEXEME_TYPE.VAR] = str }
    end
  end

  return { [LEXEME_TYPE.VAR] = text:sub(start) }
end

local function handle_var(text, char)
  local start = index
  local curr_char = char

  while not is_at_end(text)
    and not is_delimeter(curr_char)
    and not is_left_bracket(curr_char)
    and not is_right_bracket(curr_char)
    and not is_whitespace(curr_char) do

    index = index + 1
    curr_char = text:sub(index, index)
  end

  local var = text:sub(start, index-1)
  return { [LEXEME_TYPE.VAR] = var }
end

local function get_lexeme(text)
  local char = text:sub(index, index)

  if char == ':' then
    index = index + 1
    return { [LEXEME_TYPE.COLON] = char }
  end

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

  if is_separator(char) then
    return handle_separator(text, char)
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

  reset()
  return new_text
end

return lexer
