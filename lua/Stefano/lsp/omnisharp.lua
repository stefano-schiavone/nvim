return {
	name = "omnisharp",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		local find_root = opts and opts.helpers and opts.helpers.find_root

		vim.lsp.config("omnisharp", {
			capabilities = caps,
			cmd = { "omnisharp" },
			enable_editorconfig_support = true,
			enable_roslyn_analyzers = true,
			organize_imports_on_format = true,
			enable_import_completion = true,
			root_dir = function(bufnr)
				local markers = { ".git", "*.sln", "*.csproj" }
				if find_root then
					return find_root(bufnr, markers)
				end
				return vim.fn.getcwd()
			end,
		})
		vim.lsp.enable("omnisharp")
	end,
}
