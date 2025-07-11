return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
        },
        rubocop = {
          mason = false,
          cmd = { "bundle", "exec", "rubocop", "--lsp" },
        },
        steep = {
          mason = false,
          cmd = { "bundle", "exec", "steep", "langserver" },
        },
      },
    },
  },
}
