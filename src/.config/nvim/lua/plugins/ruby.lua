return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ruby_lsp = {},
        rubocop = {
          mason = false,
          cmd = { "bundle", "exec", "rubocop", "--lsp" },
        },
        steep = {
          mason = false,
          cmd = { "bundle", "exec", "steep", "langserver" },
          root_dir = require("lspconfig.util").root_pattern("Steepfile"),
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Disable the eruby formatter from conform.nvim
        eruby = {},
      },
    },
  },
}
