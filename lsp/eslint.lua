return {
	vim.lsp.config("eslint", {
		root_dir = require("lspconfig.util").root_pattern(".eslintrc", ".eslintrc.json", "package.json", ".git"),
	}),
}
