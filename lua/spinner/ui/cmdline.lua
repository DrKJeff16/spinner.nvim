local STATUS = require("spinner.status")

return function(state)
  return function()
    if state.status == STATUS.STOPPED or state.status == STATUS.PAUSED then
      vim.cmd("echo ''")
      return
    end

    local spinner_text = state:render()

    local has_highlight_marker = string.find(
      spinner_text,
      "{{SPINNER_HIGHLIGHT}}"
    ) and string.find(spinner_text, "{{END_HIGHLIGHT}}")

    if has_highlight_marker then
      local start_pos, end_pos =
        string.find(spinner_text, "{{SPINNER_HIGHLIGHT}}")
      local end_start, end_pos2 = string.find(spinner_text, "{{END_HIGHLIGHT}}")

      if start_pos and end_pos and end_start and end_pos2 then
        local actual_text = string.sub(spinner_text, end_pos + 1, end_start - 1)

        vim.cmd("echohl Spinner")
        vim.cmd("echon '" .. actual_text:gsub("'", "''") .. "'")
        vim.cmd("echohl None")
      else
        vim.cmd("echo '" .. spinner_text:gsub("'", "''") .. "'")
      end
    else
      vim.cmd("echo '" .. spinner_text:gsub("'", "''") .. "'")
    end
  end
end
