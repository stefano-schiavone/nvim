return {
	name = "lua_ls",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()

		vim.lsp.config("lua_ls", {
			capabilities = caps,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end,
}
