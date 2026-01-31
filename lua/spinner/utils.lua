local uv = vim.uv or vim.loop

local M = {}

M.AUGROUP = vim.api.nvim_create_augroup("spinner", { clear = true })

function M.now_ms()
  return math.floor(uv.hrtime() / 1e6)
end

---
--- Split an argument string on whitespace characters into a list,
--- except if the whitespace is contained within single or double quotes.
---
--- Leading and trailing whitespace is removed.
---
--- Examples:
---
--- ```lua
--- require("dap.utils").splitstr("hello world")
--- {"hello", "world"}
--- ```
---
--- ```lua
--- require("dap.utils").splitstr('a "quoted string" is preserved')
--- {"a", "quoted string", "is, "preserved"}
--- ```
---
--- Requires nvim 0.10+
---
--- @see nvim-dap https://github.com/mfussenegger/nvim-dap
--- @param str string
--- @return string[]
function M.splitstr(str)
  local lpeg = vim.lpeg
  local P, S, C = lpeg.P, lpeg.S, lpeg.C

  ---@param quotestr string
  ---@return vim.lpeg.Pattern
  local function qtext(quotestr)
    local quote = P(quotestr)
    local escaped_quote = P("\\") * quote
    return quote * C(((1 - P(quote)) + escaped_quote) ^ 0) * quote
  end
  str = str:match("^%s*(.*%S)")
  if not str or str == "" then
    return {}
  end

  local space = S(" \t\n\r") ^ 1
  local unquoted = C((1 - space) ^ 0)
  local element = qtext('"') + qtext("'") + unquoted
  local p = lpeg.Ct(element * (space * element) ^ 0)
  return lpeg.match(p, str)
end

---@alias spinner.VimCompFn fun(ArgLead: string, CmdLine: string, CursorPos: number): string[] | nil
---
---@class spinner.CompContext
---@field words string[]
---@field cur string
---@field prev string
---@field index number
---
---@alias spinner.CompFn fun(ctx: spinner.CompContext): string[] | nil

---Build vim complete function with a bash-like complete function {fn}, which
---accept a `spinner.CompContext` object as completion context.
---@param fn spinner.CompFn
---@return spinner.VimCompFn
function M.create_comp(fn)
  return function(_, cmdline, cursorpos)
    local ctx = {}
    local before = cmdline:sub(1, cursorpos)

    local words = M.splitstr(before)
    ctx.words = words
    ctx.cur = ""
    ctx.prev = ""

    if before:match("%s$") then
      ctx.cur = ""
      ctx.prev = words[#words] or ""
    else
      ctx.cur = words[#words] or ""
      ctx.prev = words[#words - 1] or ""
    end

    local items = fn(ctx)

    if ctx.cur == "" or not items then
      return items
    end

    return vim
      .iter(items)
      :filter(function(v)
        return vim.startswith(v, ctx.cur)
      end)
      :totable()
  end
end

---Deduplicate a list while preserving order
---@param list table
---@return table
function M.deduplicate_list(list)
  local seen = {}
  local result = {}
  for _, item in ipairs(list) do
    if not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end
  return result
end

return M
