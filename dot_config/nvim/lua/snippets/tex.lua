local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local WIDTH = 78

-- Returns the dashes + space that go BEFORE the title
local function left_part(args)
  local title = args[1][1] or ""
  local text = " " .. title .. " "
  local fill = WIDTH - 1 - #text
  if fill < 0 then
    fill = 0
  end
  local left = math.floor(fill / 2)
  return "%" .. string.rep("-", left) .. " "
end

-- Returns the dashes that go AFTER the title
local function right_part(args)
  local title = args[1][1] or ""
  local text = " " .. title .. " "
  local fill = WIDTH - 1 - #text
  if fill < 0 then
    fill = 0
  end
  local left = math.floor(fill / 2)
  local right = fill - left
  return " " .. string.rep("-", right)
end

return {
  s(
    "decor",
    fmt("{}{}{}", {
      f(left_part, { 1 }),
      i(1, "Abstract"),
      f(right_part, { 1 }),
    })
  ),
}
