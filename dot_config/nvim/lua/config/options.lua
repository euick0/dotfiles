-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.autowrite = true
vim.g.snacks_animate = false
-- spell checking in English and Portuguese (toggle with <leader>us)
-- in code, treesitter limits it to comments and strings
vim.opt.spell = true
vim.opt.spelllang = { "en", "pt" }
-- basedpyright instead of pyright, since pyright has no inlay hints (toggle with <leader>uh)
vim.g.lazyvim_python_lsp = "basedpyright"
-- steady block cursor in every mode (blinkon0 = no blinking)
vim.opt.guicursor = "a:block-blinkon0"
