local M = {}

local log_file = vim.fn.getcwd() .. "/nvim-debug.log"

local function timestamp()
  return os.date("%Y-%m-%d %H:%M:%S")
end

local function write(level, ...)
  local args = { ... }
  local parts = {}
  for i, v in ipairs(args) do
    parts[i] = type(v) == "string" and v or vim.inspect(v)
  end
  local msg = table.concat(parts, " ")

  local line = string.format("[%s] [%s] %s\n", timestamp(), level, msg)

  local f = io.open(log_file, "a")
  if not f then
    vim.notify("logger: could not open " .. log_file, vim.log.levels.ERROR)
    return
  end
  f:write(line)
  f:close()
end

function M.info(...)  write("INFO", ...) end
function M.warn(...)  write("WARN", ...) end
function M.error(...) write("ERROR", ...) end
function M.debug(...) write("DEBUG", ...) end

-- clear the log, useful at the top of a debugging session
function M.clear()
  local f = io.open(log_file, "w")
  if f then f:close() end
end

-- path getter, so you can :tail it from a terminal
function M.path()
  return log_file
end

return M
