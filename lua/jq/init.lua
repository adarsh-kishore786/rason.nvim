local M = {}

local function hello(opts)
  opts = opts or {}

  if opts.name then
    print("Hello " .. opts.name)
  else
    print("Hello friend")
  end

end

function M.setup(opts)
  vim.keymap.set("n", "<leader>h", function ()
    hello(opts)
  end)
end

return M
