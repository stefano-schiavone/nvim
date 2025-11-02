return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Import Mason modules
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- Configure Mason UI icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Ensure LSP servers are installed
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls", -- Lua
				"pyright", -- Python
				"omnisharp", -- C#
				"jdtls", -- Java
				"html", -- HTML
				"cssls", -- CSS
				"ts_ls", -- TypeScript
				"eslint", -- ESlint
			},
			automatic_installation = true,
		})

		-- Ensure additional tools are installed
		mason_tool_installer.setup({
			ensure_installed = {
				"stylua", -- Lua formatter
				"black", -- Python formatter
				"isort", -- Python import sorter
				"pylint", -- Python linter
			},
		})
	end,
}
