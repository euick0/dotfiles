return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      prolog_lsp = {
        cmd = {
          "swipl",
          "-g", "use_module(library(lsp_server))",
          -- lsp_server 3.18.1 calls lsp_utils:predicate_help/3, which is commented
          -- out upstream, so every completion request throws. Declaring it (no
          -- clauses) makes the call fail and the server falls back to plain args.
          "-g", "dynamic(lsp_utils:predicate_help/3)",
          "-g", "lsp_server:main",
          "-t", "halt",
          "--", "stdio",
        },
        filetypes = { "prolog" },
        root_markers = { "pack.pl", ".git" },
      },
    },
  },
  init = function()
    -- lsp_server's formatter reads the file from disk, not the buffer, so
    -- format-on-save replaces your unsaved text with the stale file content
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "prolog",
      callback = function(args)
        vim.b[args.buf].autoformat = false
      end,
    })
    -- .pl is otherwise detected as perl
    vim.filetype.add({ extension = { pl = "prolog", pro = "prolog" } })
  end,
}
