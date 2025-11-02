return {
	vim.lsp.config("ts_ls", {
		filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
		root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
		settings = {
			typescript = { format = { indentSize = 2, tabSize = 2 } },
			javascript = { format = { indentSize = 2, tabSize = 2 } },
		},
	}),
}
