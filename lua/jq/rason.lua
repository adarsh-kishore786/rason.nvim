local rason = {}

local lexemes = require('jq.lexemes')
local logger = require('jq.logger')

rason.stringify = function(o, indent)
  indent = indent or 0

  if type(o) ~= 'table' then
    logger.info('Token: ' .. tostring(o))
    return tostring(o)
  end

  local s = ''

  for k, v in pairs(o) do
    s = s .. rason.stringify(v, indent)

    if (
      k == lexemes.COMMA or
      k == lexemes.SEMI_COLON or
      k == lexemes.COLON
    ) then
      s = s .. '\n'
    end
  end

  s = s .. ' '

  return s
end

return rason
