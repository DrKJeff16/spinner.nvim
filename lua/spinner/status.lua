---@enum spinner.Status
local STATUS = {
  INIT = "init", -- Configured but never started (no API calls yet)
  DELAYED = "delayed", -- waiting for fully started
  RUNNING = "running", -- started and spin.
  PAUSED = "paused", -- paused
  STOPPED = "stopped", -- stopped
}

return STATUS
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
