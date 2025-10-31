return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "L3MON4D3/LuaSnip" },
	version = "1.*",
	opts = {
		keymap = {
			preset = "none", -- disable default preset

			-- Use Tab to select/accept completion or jump in snippet
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept() -- accept if snippet active
					else
						return cmp.select_and_accept() -- select+accept completion
					end
				end,
				"snippet_forward", -- jump in snippet if available
				"fallback", -- fallback to normal Tab if nothing
			},

			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
		completion = { documentation = { auto_show = true } },
	},

	config = function(_, opts)
		local blink = require("blink.cmp")

		-- Setup Blink
		blink.setup(opts)
	end,
}
