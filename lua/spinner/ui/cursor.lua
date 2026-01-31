local STATUS = require("spinner.status")

local function create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "spinner"
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  return buf
end

---@param state spinner.State
return function(state)
  local win = nil
  local buf = nil

  return function()
    local opts = state.opts

    if STATUS.STOPPED == state.status then
      if win ~= nil and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
        win = nil
        buf = nil
      end
      return
    end

    if buf == nil or not vim.api.nvim_buf_is_valid(buf) then
      buf = create_buf()
    end
    local text = state:render()
    local width = vim.fn.strdisplaywidth(text)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })

    if not win or not vim.api.nvim_win_is_valid(win) then
      win = vim.api.nvim_open_win(buf, false, {
        relative = "cursor",
        row = opts.row,
        col = opts.col,
        width = width,
        height = 1,
        style = "minimal",
        focusable = false,
        border = opts.border,
        zindex = opts.zindex,
        noautocmd = true,
      })

      vim.wo[win].winhighlight = "Normal:" .. opts.hl_group
      vim.wo[win].winblend = opts.winblend
      return
    end

    vim.api.nvim_win_set_config(win, {
      relative = "cursor",
      row = opts.row,
      col = opts.col,
      width = width,
    })
  end
end
