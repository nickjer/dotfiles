-- VIM options
vim.opt.background = "dark"
vim.opt.spell = true
vim.opt.spelloptions = "camel"
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.scrolljump = 5
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.list = true
vim.opt.listchars:append({
  extends = "▶",
  nbsp = "‿",
  precedes = "◀",
  tab = "·┈",
  trail = "•",
})
vim.opt.colorcolumn = { 80 }
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Visual shifting (does not exit visual mode)
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Custom file types
vim.filetype.add({ filename = { ["Steepfile"] = "ruby" } })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd([[colorscheme gruvbox]])
    end
  },
  {
    "pocke/rbs.vim",
  },
  { "ruifm/gitlinker.nvim", config = true },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":Neotree toggle reveal_force_cwd<cr>", {})
    end
  },
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit"
        },
        lastplace_open_folds = true
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end
  },
  {
    "mihyaeru21/nvim-lspconfig-bundler",
    dependencies = { "neovim/nvim-lspconfig" },
    config = true,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    }
  },
  { "andymass/vim-matchup" },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true, },
  { "nvim-treesitter/nvim-treesitter-context", config = true, },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "ruby", "rust" },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "ruby" },
        },
        indent = {
          enable = true,
          disable = { "ruby" },
        },
        endwise = { enable = true, },
        matchup = { enable = true, }
      })
    end
  },
  { "numToStr/Comment.nvim", lazy = false, config = true, },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = true,
  },
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim", config = true, },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        panel = {
          auto_refresh = true,
          layout = { position = "right", },
        },
        suggestion = { auto_trigger = true, },
      })
    end
  },
})

-- lsp-zero
local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- mason
local mason = require("mason")
mason.setup({})

-- mason-lspconfig
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  automatic_installation = true,
  ensure_installed = { "rust_analyzer", "solargraph", "steep" },
  handlers = {
    lsp_zero.default_setup,
    rust_analyzer = function()
      require("lspconfig").rust_analyzer.setup({
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ["rust-analyzer"] = {},
        },
      })
    end,
    solargraph = function()
      require("lspconfig").solargraph.setup({})
    end,
    steep = function()
      require("lspconfig").steep.setup({})
    end,
  },
})

-- cmp
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = require("lsp-zero").cmp_format({details = true})

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "nvim_lua" },
    { name = "luasnip" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  preselect = "item",
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  --- (Optional) Show source name in completion menu
  formatting = cmp_format,
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
