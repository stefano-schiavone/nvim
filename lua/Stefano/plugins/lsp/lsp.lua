return {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-jdtls", -- Hopefully temporary
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"L3MON4D3/LuaSnip",
		"mattn/emmet-vim",
	},

	config = function()
		-- Load required modules
		local lsp = require("lsp-zero")
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		require("lspconfig").lua_ls.setup({ capabilities = capabilities })

		-- Set diagnostic icons
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- LSP Server Configuration
		local lspconfig = require("lspconfig")

		-- Lua setup for Lua language server (lua_ls)
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT", -- Tell LuaLS to use LuaJIT (Neovim runtime)
						path = vim.split(package.path, ";"), -- Include Neovim runtime path
					},
					diagnostics = {
						globals = { "vim" }, -- Tell LuaLS that "vim" is a global variable
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim's runtime files
					},
				},
			},
		})

		-- Python
		lspconfig.pyright.setup({})

		-- C#
		lspconfig.omnisharp.setup({
			cmd = { "omnisharp" },
			enable_editorconfig_support = true,
			enable_roslyn_analyzers = true,
			organize_imports_on_format = true,
			enable_import_completion = true,
			root_dir = require("lspconfig.util").root_pattern(".git", "*.sln", "*.csproj"),
		})

		-- Java

		-- Java mine
		local lombok_path = vim.fn.expand("~/.m2/repository/org/projectlombok/lombok/")
		lspconfig.jdtls.setup({
			cmd = { "jdtls", "-javaagent:" .. lombok_path },
			root_dir = require("lspconfig.util").root_pattern(".git", "pom.xml", "build.gradle", "*.java"),
			settings = {
				java = {
					contentProvider = { preferred = "fernflower" },
					maven = { downloadSources = true },
					signatureHelp = { enabled = true },
				},
			},
		})

		-- Java 2 (minimal JDTLS setup)
		-- local lombok_path = vim.fn.expand("~/.local/share/nvim/lombok.jar")
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = "java",
		-- 	callback = function()
		-- 		local jdtls = require("jdtls")
		-- 		local config = {
		-- 			cmd = {
		-- 				vim.fn.stdpath("data") .. "/mason/bin/jdtls",
		-- 				"-javaagent:" .. lombok_path,
		-- 				"--add-opens",
		-- 				"java.base/java.lang=ALL-UNNAMED",
		-- 			},
		-- 			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git" }, { upward = true })[1]),
		-- 		}
		-- 		jdtls.start_or_attach(config)
		-- 	end,
		-- })

		-- TypeScript/React
		lspconfig.ts_ls.setup({
			root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
			settings = {
				typescript = { format = { indentSize = 2, tabSize = 2 } },
				javascript = { format = { indentSize = 2, tabSize = 2 } },
			},
		})

		-- ESLint
		lspconfig.eslint.setup({
			root_dir = require("lspconfig.util").root_pattern(".eslintrc", ".eslintrc.json", "package.json", ".git"),
		})

		-- HTML
		capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		lspconfig.html.setup({
			capabilities = capabilities,
		})
		-- CSS
		lspconfig.cssls.setup({
			capabilities = capabilities,
			settings = {
				css = { validate = true },
				less = { validate = true },
				scss = { validate = true },
			},
		})

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

		-- Finalize LSP setup
		lsp.setup()

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
}
