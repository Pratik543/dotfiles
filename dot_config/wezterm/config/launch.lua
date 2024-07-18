local platform = require("utils.platform")()

local options = {
  default_prog = {},
  launch_menu = {},
}

if platform.is_win then
  options.default_prog = { "pwsh" }
  options.launch_menu = {
    { label = " PowerShell v7", args = { "pwsh" } },
    { label = " Cmd", args = { "cmd" } },
    {
      label = " GitBash",
      args = { "C:\\Program Files\\Git\\bin\\bash.exe" },
    },
  }
elseif platform.is_mac then
  options.default_prog = { "/opt/homebrew/bin/fish" }
  options.launch_menu = {
    { label = " Bash", args = { "bash" } },
    { label = " Fish", args = { "/opt/homebrew/bin/fish" } },
    { label = " Nushell", args = { "/opt/homebrew/bin/nu" } },
    { label = " Zsh", args = { "zsh" } },
  }
end

return options
