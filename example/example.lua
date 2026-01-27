--- show spinner in statusline/tabline
local sp = require("spinner").statusline_spinner()
function lsp_sp_component()
  return tostring(sp)
end
vim.o.statusline = vim.o.statusline .. "%!v:lua.lsp_sp_component()"
vim.o.tabline = vim.o.tabline .. "%!v:lua.lsp_sp_component()"

sp:start()
sp:stop()

-- show spinner next to cursor
local sp = require("spinner").cursor_spinner()
sp:start()
sp:stop()
