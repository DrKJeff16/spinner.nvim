local M = {}
local utils = require("spinner.utils")

-- Completion function for Spinner command
local function spinner_completion(engine)
  return utils.create_comp(function(ctx)
    if ctx.prev == "Spinner" then
      return { "start", "stop", "pause" }
    end

    local ids = {}
    for id, _ in pairs(engine.state_map) do
      if rawget(engine.state_map, id) then
        table.insert(ids, id)
      end
    end

    local entered_ids = {}
    local words = ctx.words
    for i = 3, #words do
      local id = words[i]
      entered_ids[id] = true
    end

    local available_ids = {}
    for _, id in ipairs(ids) do
      if not entered_ids[id] then
        table.insert(available_ids, id)
      end
    end

    return available_ids
  end)
end

local function spinner_cmd(engine)
  vim.api.nvim_create_user_command("Spinner", function(opts)
    if #opts.fargs == 0 then
      vim.notify(
        "[spinner.nvim]: Missing subcommand. Use one of: start, stop, pause",
        vim.log.levels.WARN
      )
      return
    end

    local subcmd = opts.fargs[1]
    local spinner_ids = { unpack(opts.fargs, 2) } -- All remaining arguments are spinner IDs

    -- Deduplicate spinner IDs while preserving order
    local unique_spinner_ids = utils.deduplicate_list(spinner_ids)

    for _, spinner_id in ipairs(unique_spinner_ids) do
      if not rawget(engine.state_map, spinner_id) then
        vim.notify(
          string.format("[spinner.nvim]: spinner %s not setup yet", spinner_id),
          vim.log.levels.WARN
        )
        -- Continue to next spinner instead of returning
      else
        if subcmd == "start" then
          engine:start(spinner_id)
        elseif subcmd == "stop" then
          engine:stop(spinner_id, true)
        elseif subcmd == "pause" then
          engine:pause(spinner_id)
        else
          vim.notify(
            "[spinner.nvim]: Unknown subcommand '"
              .. subcmd
              .. "'. Use one of: start, stop, pause",
            vim.log.levels.WARN
          )
          return
        end
      end
    end
  end, {
    nargs = "+",
    desc = "Control spinners (start, stop, pause)",
    complete = spinner_completion(engine),
    force = true,
  })
end

function M.setup(engine)
  spinner_cmd(engine)
end

return M
