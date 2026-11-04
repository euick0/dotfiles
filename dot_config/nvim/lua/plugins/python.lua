return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              -- same strictness as pyright, basedpyright's default is much noisier
              typeCheckingMode = "standard",
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                callArgumentNames = true,
                genericTypes = false,
              },
            },
          },
        },
      },
    },
  },
}
