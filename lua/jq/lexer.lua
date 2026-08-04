local LEXEMES = require("jq.lexemes")

local lexer = {}
local index = 1

local matches = {
  [':'] = LEXEMES.COLON,
  ['='] = LEXEMES.EQUAL,
  [','] = LEXEMES.COMMA,
  ['('] = LEXEMES.LEFT_BRACE,
  [')'] = LEXEMES.RIGHT_BRACE,
  ['{'] = LEXEMES.LEFT_CURLY,
  ['}'] = LEXEMES.RIGHT_CURLY,
  ['['] = LEXEMES.LEFT_SQUARE,
  [']'] = LEXEMES.RIGHT_SQUARE
}

local function is_at_end(text)
  return index > #text
end

local function get_lexeme(text)
  local char = text:sub(index, index)

  if matches[char] ~= nil then
    index = index + 1
    return { [matches[char]] = char }
  end

  local start = index

  while not is_at_end(text)
    and matches[char] == nil do

    index = index + 1
    char = text:sub(index, index)
  end

  local var = text:sub(start, index-1)
  return { [LEXEMES.VAR] = var }
end

function lexer.lex(text)
  local new_text = {}

  while not is_at_end(text) do
    local char = text:sub(index, index)

    if char == ' ' then
      index = index + 1
      goto continue
    end
    table.insert(new_text, get_lexeme(text))

    ::continue::
  end

  index = 1
  return new_text
end

return lexer
