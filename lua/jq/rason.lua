local rason = {}
local logger = require('jq.logger')

rason.stringify = function(o, indent)
  indent = indent or 0

  if type(o) ~= 'table' then
    logger.info(tostring(o) .. ' is type ' .. type(o))
    return tostring(o)
  end

  local s = ''

  for _, v in pairs(o) do
    s = s .. rason.stringify(v, indent)
    if v == '{' then
      s = s .. '\n'
    elseif v == '}' then
    end
  end
  return s
end

return rason
