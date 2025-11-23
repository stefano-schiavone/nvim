return {
	name = "ts_ls",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		local find_root = opts and opts.helpers and opts.helpers.find_root

		vim.lsp.config("ts_ls", {
			capabilities = caps,
			init_options = { hostInfo = "neovim" },
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_dir = function(bufnr)
				local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
				if vim.fn.has("nvim-0.11.3") == 1 then
					root_markers = { root_markers, { ".git" } }
				else
					vim.list_extend(root_markers, { ".git" })
				end
				if find_root then
					return find_root(bufnr, root_markers)
				end
				return vim.fn.getcwd()
			end,
			handlers = {
				["_typescript.rename"] = function(_, result, ctx)
					local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
					vim.lsp.util.show_document({
						uri = result.textDocument.uri,
						range = {
							start = result.position,
							["end"] = result.position,
						},
					}, client.offset_encoding)
					vim.lsp.buf.rename()
					return vim.NIL
				end,
			},
			commands = {
				["editor.action.showReferences"] = function(command, ctx)
					local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
					local file_uri, position, references = unpack(command.arguments)
					local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
					vim.fn.setqflist({}, " ", {
						title = command.title,
						items = quickfix_items,
						context = {
							command = command,
							bufnr = ctx.bufnr,
						},
					})
					vim.lsp.util.show_document({
						uri = file_uri,
						range = {
							start = position,
							["end"] = position,
						},
					}, client.offset_encoding)
					vim.cmd("botright copen")
				end,
			},
			on_attach = function(client, bufnr)
				vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
					local kinds = client.server_capabilities.codeActionProvider
							and client.server_capabilities.codeActionProvider.codeActionKinds
						or {}
					local source_actions = vim.tbl_filter(function(action)
						return vim.startswith(action, "source.")
					end, kinds)
					vim.lsp.buf.code_action({
						context = {
							only = source_actions,
						},
					})
				end, {})
			end,
		})
		vim.lsp.enable("ts_ls")
	end,
}
