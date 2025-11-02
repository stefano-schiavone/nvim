return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"L3MON4D3/LuaSnip",
			"mattn/emmet-vim",
		},

		config = function()
			-- Load required modules
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("lua_ls", { capabilities = capabilities })

			-- Set diagnostic icons
			vim.diagnostic.config({
				virtual_text = true,
				signs = {
					active = {
						Error = " ",
						Warn = " ",
						Hint = "󰠠 ",
						Info = " ",
					},
				},
				underline = true,
				update_in_insert = false,
			})

			-- Lua setup for Lua language server (lua_ls)
			vim.lsp.enable("lua_ls")

			-- Python
			vim.lsp.enable("pyright")

			-- C#
			vim.lsp.enable("omnisharp")

			-- Java
			vim.lsp.enable("jdtls")

			-- TypeScript/React
			vim.lsp.enable("ts_ls")

			-- ESLint
			vim.lsp.enable("eslint")

			-- HTML
			capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html")

			-- CSS
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = { validate = true },
					less = { validate = true },
					scss = { validate = true },
				},
			})
			vim.lsp.enable("cssls")

			-- Emmet setup
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html", "javascriptreact", "typescriptreact", "cshtml" },
				command = "EmmetInstall",
			})
			vim.g.user_emmet_leader_key = "<C-A>"
			vim.g.user_emmet_settings = {
				html = {
					snippets = {
						["!"] = "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title></title>\n\t</head>\n\t<body>\n\t\t${child} \n\t</body>\n</html>",
					},
				},
			}

			-- Global diagnostics configuration
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Keymaps for LSP actions
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "x" }, "<F3>", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
				end,
			})
		end,
	},
}
