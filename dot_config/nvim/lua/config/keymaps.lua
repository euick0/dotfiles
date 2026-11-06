-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- One shared terminal for <leader>ft, <C-/> and <leader>rp
local term

local function get_term()
  if term and term:buf_valid() then
    return term, false
  end
  term = Snacks.terminal.open(nil, {
    cwd = LazyVim.root(),
    win = { position = "bottom" },
  })
  return term, true
end

local function toggle_term()
  local t, created = get_term()
  if not created then
    t:toggle()
  end
end

local function run_python()
  if vim.bo.filetype ~= "python" then
    vim.notify("Not a Python file", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")
  local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))

  local t, created = get_term()
  if not t:valid() then
    t:show()
  end

  local job = vim.b[t.buf].terminal_job_id
  local send = function()
    vim.fn.chansend(job, "clear; python3 " .. file .. "\n")
  end
  -- A brand-new shell needs a moment to start before it can receive input
  if created then
    vim.defer_fn(send, 200)
  else
    -- Ctrl-C to kill whatever is running / discard any half-typed line,
    -- then give the shell a moment to redraw its prompt
    vim.fn.chansend(job, "\x03")
    vim.defer_fn(send, 100)
  end
end

-- Set while we believe swipl is running in the shared terminal
local swipl_job

local function run_prolog()
  if vim.bo.filetype ~= "prolog" then
    vim.notify("Not a Prolog file", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")
  local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))

  local t, created = get_term()
  if not t:valid() then
    t:show()
  end

  local job = vim.b[t.buf].terminal_job_id
  local send = function()
    vim.fn.chansend(job, "clear; swipl " .. file .. "\n")
    swipl_job = job
  end
  if created then
    vim.defer_fn(send, 200)
  elseif swipl_job == job then
    -- Leave the old swipl session first (a stray "halt." at a shell prompt is harmless)
    vim.fn.chansend(job, "halt.\n")
    vim.defer_fn(send, 300)
  else
    vim.fn.chansend(job, "\x03")
    vim.defer_fn(send, 100)
  end
end
vim.keymap.set("n", "<leader>ft", toggle_term, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<C-/>", toggle_term, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_term, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>rp", run_python, { desc = "Run Python file in terminal" })
vim.keymap.set("n", "<leader>rP", run_prolog, { desc = "Run Prolog file in swipl" })

-- Resize splits with Ctrl+Up/Down, also from inside the terminal split
map({ "n", "t" }, "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map({ "n", "t" }, "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
