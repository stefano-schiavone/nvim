vim.g.mapleader = " "

-- Cursor
vim.opt.guicursor = "n-v-c-i:block"

-- Sets Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

-- undoTree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Yanks and pastes in the same clipboard
-- vim.opt.clipboard = "unnamedplus"
