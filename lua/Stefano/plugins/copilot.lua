return {
	"github/copilot.vim",
	event = "InsertEnter",
	init = function()
		-- Start deactivated on startup
		vim.g.copilot_enabled = 0
	end,
	config = function()
		-- Disable default tab mapping so we can control it manually
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_hide_during_completion = false

		-- Accept suggestion with Ctrl+J
		vim.keymap.set("i", "<C-j>", function()
			return vim.fn["copilot#Accept"]("<CR>")
		end, {
			expr = true,
			replace_keycodes = false,
			desc = "Copilot: accept suggestion",
		})

		-- Toggle autocomplete on/off with <leader>ct
		vim.keymap.set("n", "<leader>ct", function()
			if vim.g.copilot_enabled == 0 then
				vim.cmd("Copilot enable")
				print("Copilot enabled")
			else
				vim.cmd("Copilot disable")
				print("Copilot disabled")
			end
		end, { desc = "Copilot: toggle autocomplete" })
	end,
}
