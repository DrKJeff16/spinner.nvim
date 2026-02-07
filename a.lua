local sp = require("spinner")
sp.config("my_spinner", {
  kind = "cursor",
})
sp.start("my_spinner")

function lsp_progress()
  local client_names = {}
  local seen = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local name = client and client.name or ""
    if name ~= "" and not seen[name] then
      table.insert(client_names, name)
      seen[name] = true
    end
  end
  local spinner = require("spinner").render("lsp_progress")

  return table.concat(client_names, " ") .. " " .. spinner
end

vim.o.statusline = vim.o.statusline .. "%!v:lua.lsp_progress()"

require("spinner").config("lsp_progress", {
  kind = "statusline",
  placeholder = "✔",
  attach = {
    lsp = {
      progress = true,
    },
  },
})

require("spinner").config("cursor", {
  kind = "cursor", -- kind cursor
  ttl_ms = 3000, -- a good option to avoid the cursor running continuously
  attach = {
    lsp = {
      -- select the methods you’re interested in. For a complete list: `:h lsp-method`
      request = {
        "textDocument/definition", -- for GoToDefinition (shortcut C-])
        "textDocument/hover", -- for hover (shortcut K)
      },
    },
  },
})

require("spinner").config("cursor", {
  kind = "cursor", -- kind
  on_update_ui = function()
    require("lualine").refresh()
  end,
})

require("spinner").config("my_spinner", {
  kind = "statusline",
  pattern = {
    interval = 80,
    frames = {
      "⠋",
      "⠙",
      "⠹",
      "⠸",
      "⠼",
      "⠴",
      "⠦",
      "⠧",
      "⠇",
      "⠏",
    },
  },
})

require("spinner").config("my_spinner", {
  kind = "custom",
  on_update_ui = function(event)
    local status = event.status
    local text = event.text

    -- do what you want
  end,
})
