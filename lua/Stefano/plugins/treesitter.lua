return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- Runs `:TSUpdate` after installing/updating
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"lua",
				"c_sharp",
				"java",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"python",
				"markdown",
				"markdown_inline",
				"html",
				"css",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
