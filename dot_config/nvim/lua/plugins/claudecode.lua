-- Open the Claude Code terminal as a vertical split on landscape screens and a
-- horizontal (bottom) split on portrait screens. Orientation is taken from the
-- Neovim UI size; terminal cells are roughly twice as tall as wide, so lines
-- are doubled before comparing.

-- claudecode.nvim keeps a reference to this table and deep-copies it every
-- time the terminal opens, so mutating it in place changes the next split.
local win_opts = {}

local function update_layout()
  if vim.o.columns >= vim.o.lines * 2 then
    win_opts.position = "right"
    win_opts.width = 0.40
    win_opts.height = 0
  else
    win_opts.position = "bottom"
    win_opts.width = 0
    win_opts.height = 0.40
  end
end

local function claude(cmd)
  return function()
    update_layout()
    vim.cmd(cmd)
  end
end

return {
  "coder/claudecode.nvim",
  opts = function(_, opts)
    update_layout()
    opts.terminal = opts.terminal or {}
    opts.terminal.snacks_win_opts = win_opts
  end,
  keys = {
    { "<leader>ac", claude("ClaudeCode"), desc = "Toggle Claude" },
    { "<leader>af", claude("ClaudeCodeFocus"), desc = "Focus Claude" },
    { "<leader>ar", claude("ClaudeCode --resume"), desc = "Resume Claude" },
    { "<leader>aC", claude("ClaudeCode --continue"), desc = "Continue Claude" },
  },
}
