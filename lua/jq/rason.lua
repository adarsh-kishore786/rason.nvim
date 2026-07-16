local rason = {}

rason.stringify = function(o, indent)
  indent = indent or 0

  if type(o) ~= 'table' then
    return tostring(o)
  end

  local s = ''

  for _ = 0, indent do
    s = ' ' .. s
  end
  for _, v in pairs(o) do
    s = s .. rason.stringify(v, indent)
    if v == '{' then
      s = s .. '\n'
      indent = indent + 1
    elseif v == '}' then
      indent = indent - 1
    end
  end
  return s
end

return rason
