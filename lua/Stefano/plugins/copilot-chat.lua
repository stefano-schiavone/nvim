return {
	-- <C-j>InsertAccept autocomplete suggestion
	-- <leader>ctNormalToggle autocomplete on/off
	-- <leader>ccNormalToggle chat window
	-- <leader>ceVisualExplain selected code
	-- <leader>cfVisualFix selected code
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		"github/copilot.vim",
		"nvim-lua/plenary.nvim",
	},
	opts = {
		window = {
			layout = "float",
			width = 0.30,
			border = "rounded",
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot: toggle chat" },
		{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot: explain selection", mode = "v" },
		{ "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot: fix selection", mode = "v" },
	},
}
