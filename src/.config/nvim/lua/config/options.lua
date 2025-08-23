-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.colorcolumn = "80" -- Colored column
opt.relativenumber = false -- Relative line numbers

vim.g.ai_cmp = false -- Disable AI completion in blink auto-complete menu
