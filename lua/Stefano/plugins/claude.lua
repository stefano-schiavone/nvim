return {
	"coder/claudecode.nvim",
	opts = { git_repo_cwd = true },
	keys = {
		{ "<leader>qc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>qf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>qb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" }, -- Give current file as context before prompt
		{ "<leader>qs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" }, -- After a visual selection, "Refactor this function" "Explain this block"
		{ "<leader>qa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>qd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
