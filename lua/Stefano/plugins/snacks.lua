return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false, -- Ensure the plugin is loaded immediately
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		picker = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
	},
	keys = {
		-- Keybinding for opening LazyGit via Snacks (handled by snacks.lua)
		{
			"<leader>lg",
			function()
				require("snacks").lazygit() -- Open LazyGit using snacks.nvim
			end,
			desc = "Open LazyGit", -- Keybinding description
		},
		-- Keybinding for opening Git logs
		{
			"<leader>gl",
			function()
				require("snacks").picker.git_log({
					finder = "git_log",
					format = "git_log",
					preview = "git_show",
					confirm = "git_checkout",
					layout = "vertical",
				})
			end,
			desc = "Open Git Logs",
		},
		-- Keybinding for deleting a buffer with confirmation
		{
			"<leader>dB",
			function()
				require("snacks").bufdelete() -- Delete current buffer
			end,
			desc = "Delete Buffer (Confirm)",
		},
		-- Keybinding for picking and switching Git branches
		{
			"<leader>gbr",
			function()
				require("snacks").picker.git_branches({ layout = "select" }) -- Git branch picker
			end,
			desc = "Pick and Switch Git Branches",
		},
		-- Keybinding for opening the merge tool (lazygit or vimdiff)
		{
			"<leader>gm", -- Merge tool keybinding
			function()
				-- Here we use `lazygit`'s merge tool, or a Vim-based tool if you prefer.
				require("snacks").lazygit({
					cmd = "merge-tool", -- Invoke lazygit's merge tool
				})
			end,
			desc = "Launch Merge Tool", -- Keybinding description
		},
		-- Keybinding for invoking Vim's built-in merge tool (vimdiff)
		{
			"<leader>md", -- Vimdiff merge tool keybinding
			function()
				-- This launches Vim's built-in merge tool (vimdiff)
				vim.cmd("tabnew | Git mergetool") -- Opens a new tab for `git mergetool`
			end,
			desc = "Launch Vim Merge Tool (vimdiff)", -- Keybinding description
		},
	},
}
