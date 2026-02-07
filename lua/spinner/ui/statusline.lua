local has_lualine, lualine = pcall(require, "lualine")

if has_lualine and lualine then
  return function()
    lualine.refresh({
      place = { "statusline" },
    })
  end
end

return function()
  vim.cmd("redrawstatus")
end
