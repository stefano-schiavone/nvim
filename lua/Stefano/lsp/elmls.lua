return {
	name = "elmls",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()

		vim.lsp.config("elmls", {
			cmd = { "elm-language-server" },
			filetypes = { "elm" },
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local filetype = vim.bo[bufnr].filetype
				if filetype == "elm" or (filetype == "json" and fname:match("elm%.json$")) then
					on_dir(vim.fs.root(fname, "elm.json"))
					return
				end
				on_dir(nil)
			end,
			init_options = {
				elmReviewDiagnostics = "off",
				skipInstallPackageConfirmation = false,
				disableElmLSDiagnostics = false,
				onlyUpdateDiagnosticsOnSave = false,
			},
			capabilities = caps,
		})
		vim.lsp.enable("elmls")
	end,
}
