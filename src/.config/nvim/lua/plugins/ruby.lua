return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.local/share/mise/shims/ruby-lsp") },
        },
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
      formatters = {
        rubocop = {
          command = "bundle exec rubocop",
        },
      },
      formatters_by_ft = {
        -- Disable the eruby formatter from conform.nvim
        eruby = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = {
        enable = true,
        -- Fix indentation issues with Ruby
        disable = { "ruby" },
      },
    },
  },
}
