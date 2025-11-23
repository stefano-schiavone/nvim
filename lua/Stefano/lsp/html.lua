return function(opts)
	local caps = opts and opts.capabilities or vim.lsp.protocol.make_client_capabilities()
	caps.textDocument = caps.textDocument or {}
	caps.textDocument.completion = caps.textDocument.completion or {}
	caps.textDocument.completion.completionItem = caps.textDocument.completion.completionItem or {}
	caps.textDocument.completion.completionItem.snippetSupport = true

	vim.lsp.config("html", {
		capabilities = caps,
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "templ" },
		root_markers = { "package.json", ".git" },
		settings = {},
		init_options = {
			provideFormatter = true,
			embeddedLanguages = { css = true, javascript = true },
			configurationSection = { "html", "css", "javascript" },
		},
	})
	vim.lsp.enable("html")
end
