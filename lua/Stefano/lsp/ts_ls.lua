return {
	name = "ts_ls",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		vim.lsp.config("ts_ls", { capabilities = caps })
		vim.lsp.enable("ts_ls")
	end,
}
