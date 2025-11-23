return {
	name = "pyright",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()

		vim.lsp.config("pyright", { capabilities = caps })
		vim.lsp.enable("pyright")
	end,
}
