-- Get Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Define custom path for lazy-lock.json
local lockfile_path = vim.fn.stdpath("config") .. "/lua/Stefano/lazy/lazy-lock.json"

-- Load Lazy.nvim and setup plugins
require("lazy").setup({
	{ import = "Stefano.plugins" },
	{ import = "Stefano.plugins.lsp" },
	{ import = "Stefano.plugins.git" },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
