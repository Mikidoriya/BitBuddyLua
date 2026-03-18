local M = {}

function M.xor(a,b)
  return (a ~ b)
end

function M.greet(name)
  return "Hello, " .. (name or "world") .. " from BitBuddy!"
end

M.version = "0.1.0"

return M
