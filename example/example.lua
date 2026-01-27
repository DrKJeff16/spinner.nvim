--- show spinner in statusline/tabline
local sp = require("spinner").StatuslineSpinner:new()
function lsp_sp_component()
  return tostring(sp)
end
vim.o.statusline = vim.o.statusline .. "%!v:lua.lsp_sp_component()"
vim.o.tabline = vim.o.tabline .. "%!v:lua.lsp_sp_component()"
--- subscribe LspProgress
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(event)
    local kind = event.data.params.value.kind
    if kind == "begin" then
      sp:start()
    end
    if kind == "end" then
      sp:stop()
    end
  end,
})

-- show spinner next to cursor
local sp = require("spinner").CursorSpinner:new()
sp:start()
sp:stop()
