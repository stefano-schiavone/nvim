return {
	name = "cssls",
	enabled = true,

	setup = function(opts)
		local caps = opts and opts.capabilities or vim.lsp.protocol.make_client_capabilities()

		vim.lsp.config("cssls", {
			capabilities = caps,
			settings = {
				css = { validate = true },
				less = { validate = true },
				scss = { validate = true },
			},
		})
		vim.lsp.enable("cssls")
	end,
}
