return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- Ensure nvim-web-devicons is loaded first
	},
	version = "*",
	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
			-- Enable buffer icons
			show_buffer_icons = true,
			show_buffer_close_icons = true, -- Adjust this if necessary
			show_tab_indicators = true,

			-- Enable LSP diagnostics from nvim_lsp
			diagnostics = "nvim_lsp",

			-- Use your existing icons/colors for LSP indicators
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icons = {
					error = "",
					warn = "",
					hint = "󰠠",
					info = "",
				}

				local icon = "" -- default
				if level:match("error") then
					icon = icons.error
				elseif level:match("warn") then
					icon = icons.warn
				elseif level:match("hint") then
					icon = icons.hint
				elseif level:match("info") then
					icon = icons.info
				end

				-- Show icon with count
				return " " .. icon .. " " .. count
			end,
		},
		highlights = {
			-- keep file names normal
			buffer_selected = { fg = "#cdd6f4", bg = "#11111b", bold = true },
			buffer_visible = { fg = "#a6adc8", bg = "#11111b" },
			-- Correct
			error_diagnostic_selected = { bg = "#f38ba8", fg = "#11111b", bold = true },
			error_diagnostic_visible = { bg = "#f38ba8", fg = "#11111b" },
			warning_diagnostic_selected = { bg = "#fab387", fg = "#11111b", bold = true },
			warning_diagnostic_visible = { bg = "#fab387", fg = "#11111b" },
			info_diagnostic_selected = { bg = "#89b4fa", fg = "#11111b", bold = true },
			info_diagnostic_visible = { bg = "#89b4fa", fg = "#11111b" },
			hint_diagnostic_selected = { fg = "#11111b", bg = "#74c7ec", bold = true },
			hint_diagnostic_visible = { fg = "#11111b", bg = "#74c7ec", bold = true },
		},
	},
	config = function(_, opts)
		-- Make sure nvim-web-devicons is initialized first
		require("nvim-web-devicons").setup({
			-- Ensure devicons are enabled for bufferline and other plugins
			default = true, -- Set to 'true' to display default icons for files without specific icons
		})

		-- Now set up bufferline
		require("bufferline").setup(opts)
	end,
}
