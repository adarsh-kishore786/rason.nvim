local lexer = {}
local LEXEMES = require("jq.lexemes")
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

local function get_lexeme(text)
  local char = text:sub(index, index)

  if matches[char] ~= nil then
    index = index + 1
    return matches[char]
  end

  while matches[char] == nil do
    index = index + 1
    char = text:sub(index, index)
  end

  return LEXEMES.VAR
end

function lexer.lex(text)
  local new_text = {}

  while index <= #text do
    if text[index] == ' ' then
      goto continue
    end
    table.insert(new_text, get_lexeme(text))

    ::continue::
  end

  return table.concat(new_text)
end

return lexer
