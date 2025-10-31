-- Plugin setup
--
-- Autocmd to change FineCmdlineBorder color after colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*", -- Trigger for any colorscheme
	callback = function()
		vim.api.nvim_set_hl(0, "FineCmdlineBorder", { fg = "#4f9dfc" }) -- Change the border color
	end,
})

local function set_fcl_winblend(win, blend)
	-- Set the window transparency
	vim.api.nvim_win_set_option(win, "winblend", blend)

	-- Restore border highlight to full opacity
	vim.api.nvim_set_hl(0, "FineCmdlineBorder", { fg = "#4f9dfc" })
end

return {
	"VonHeikemen/fine-cmdline.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim", -- Ensure nui.nvim is installed
	},
	event = "VeryLazy",
	opts = {
		cmdline = {
			enable_keymaps = true,
			smart_history = true,
			prompt = ": ",
		},
		popup = {
			position = {
				row = "40%",
				col = "50%",
			},
			size = {
				width = "40%",
			},
			border = {
				style = "rounded",
			},
			win_options = {
				-- Use the custom highlight group for the border color
				winhighlight = "Normal:FineCmdlineBg,FloatBorder:FineCmdlineBorder",
			},
			callbacks = {
				on_open = function(popup_win)
					set_fcl_winblend(popup_win, 100) -- 15% transparency for content only
				end,
			},
		},
	},
	keys = {
		{
			":",
			function()
				require("fine-cmdline").open()
			end,
			desc = "Open Fine Cmdline",
		},
	},
}
