local LEXEMES = require("jq.lexemes")

local matches = {
  [':'] = LEXEMES.COLON,
  ['='] = LEXEMES.EQUAL,
  [','] = LEXEMES.COMMA,
  ['('] = LEXEMES.LEFT_BRACE,
  [')'] = LEXEMES.RIGHT_BRACE,
  ['{'] = LEXEMES.LEFT_CURLY,
  ['}'] = LEXEMES.RIGHT_CURLY,
  ['['] = LEXEMES.LEFT_SQUARE,
  [']'] = LEXEMES.RIGHT_SQUARE,
}

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

local function handle_string(text, char)
  local start = index

  while not is_at_end(text) do
    index = index + 1
    local curr_char = text:sub(index, index)

    if (curr_char == char) then
      local str = text:sub(start, index)
      index = index + 1
      return { [LEXEMES.VAR] = str }
    end
  end

  return { [LEXEMES.VAR] = text:sub(start) }
end

local function handle_var(text, char)
  local start = index

  while not is_at_end(text)
    and matches[char] == nil
    and not is_whitespace(char) do

    index = index + 1
    char = text:sub(index, index)
  end

  local var = text:sub(start, index-1)
  return { [LEXEMES.VAR] = var }
end

local function get_lexeme(text)
  local char = text:sub(index, index)

  if (char == '\'' or char == '\"') then
    return handle_string(text, char)
  end

  if matches[char] ~= nil then
    index = index + 1
    return { [matches[char]] = char }
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
