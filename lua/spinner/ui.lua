local cmdline = require("spinner.ui.cmdline")
local cursor = require("spinner.ui.cursor")
local extmark = require("spinner.ui.extmark")
local statusline = require("spinner.ui.statusline")
local tabline = require("spinner.ui.tabline")
local winbar = require("spinner.ui.winbar")

local M = {}

---@alias spinner.UIUpdater fun()

---Get UIUpdater.
---@param state spinner.State
---@return spinner.UIScope
---@return spinner.UIUpdater
local function get_ui_updater(state)
  local opts = state.opts
  local kind = opts.kind or "custom"

  local ui_scope, ui_updater
  if kind == "statusline" then
    ui_scope = "statusline"
    ui_updater = statusline
  elseif kind == "winbar" then
    ui_scope = "winbar"
    ui_updater = winbar
  elseif kind == "tabline" then
    ui_scope = "tabline"
    ui_updater = tabline
  elseif kind == "cursor" then
    ui_scope = "cursor"
    ui_scope = string.format(
      "cursor:%d:%s",
      opts and opts.row or 0,
      opts and opts.col or 0
    )
    ui_updater = cursor(state)
  elseif kind == "extmark" then
    ui_scope = string.format(
      "extmark:%d:%d:%d",
      opts and opts.bufnr or 0,
      opts and opts.row or 0,
      opts and opts.col or 0
    )
    ui_updater = extmark(state)
  elseif kind == "cmdline" then
    ui_scope = "cmdline"
    ui_updater = cmdline(state)
  else
    ui_scope = "custom"
    ui_updater = function() end -- will use opts.on_update_ui later
  end

  return ui_scope, ui_updater
end

---Get UIUpdater
---@param state spinner.State
---@return spinner.UIScope
---@return spinner.UIUpdater
function M.get_ui_updater(state)
  local ui_scope, ui_updater = get_ui_updater(state)

  -- if provided a on_change method, call that instead.
  if state.opts.on_update_ui then
    return ui_scope,
      function()
        state.opts.on_update_ui({
          text = state:render(),
          status = state.status,
        })
      end
  end

  return ui_scope, ui_updater
end

return M
