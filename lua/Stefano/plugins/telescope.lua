return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				initial_mode = "insert",
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--glob=!wwwroot/lib/**",
				},
				file_ignore_patterns = { "wwwroot/lib/.*", ".class" },
				winblend = 15,
			},
			pickers = {
				buffers = {
					initial_mode = "normal",
					mappings = {
						n = { ["<C-d>"] = "delete_buffer" },
						i = { ["<C-d>"] = "delete_buffer" },
					},
				},
			},
		})

		-- Telescope Key mappings
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>pg", builtin.live_grep, {}) -- uses rg with glob exclusion
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {}) -- uses fd with exclude
		vim.keymap.set("n", "<C-p>", builtin.git_files, {}) -- cannot exclude; relies on .gitignore
		vim.keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" }) -- uses rg
		vim.keymap.set("n", "<leader>pk", builtin.keymaps, {})
		vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "Search Diagnostics" }) -- uses LSP diagnostics
		vim.keymap.set("n", "<leader>pc", require("telescope.builtin").colorscheme, { desc = "Pick Colorscheme" }) -- Picks colorschemes
	end,
}
