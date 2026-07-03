return {
	name = "eslint",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		local find_root = opts and opts.helpers and opts.helpers.find_root

		local eslint_config_files = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
		}

		vim.lsp.config("eslint", {
			capabilities = caps,
			cmd = { "vscode-eslint-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
				"svelte",
				"astro",
				"htmlangular",
			},
			workspace_required = true,
			on_attach = function(client, bufnr)
				vim.api.nvim_buf_create_user_command(0, "LspEslintFixAll", function()
					client:request_sync("workspace/executeCommand", {
						command = "eslint.applyAllFixes",
						arguments = {
							{
								uri = vim.uri_from_bufnr(bufnr),
								version = vim.lsp.util.buf_versions[bufnr],
							},
						},
					}, nil, bufnr)
				end, {})
			end,
			root_dir = function(bufnr)
				local root_markers = {
					{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
					{ ".git" },
				}
				if find_root then
					local root = find_root(bufnr, root_markers)
					-- ensure there's an ESLint config somewhere up to (and including) project root
					local filename = vim.api.nvim_buf_get_name(bufnr)
					if filename == "" then
						return root
					end
					local found = vim.fs.find(
						eslint_config_files,
						{ path = vim.fs.dirname(filename), upward = true, type = "file", limit = 1 }
					)
					if found and #found > 0 then
						-- if found path is inside node_modules and it's not inside project root, ignore (best-effort)
						local f = found[1]
						if not string.find(f, "[/\\]node_modules[/\\]") then
							return root
						end
					end
					-- fallback: if no config found treat as not using eslint
					return nil
				end
				return nil
			end,
			settings = {
				validate = "on",
				experimental = { useFlatConfig = false },
				codeActionOnSave = { enable = false, mode = "all" },
				format = true,
				problems = { shortenToSingleLine = false },
				workingDirectory = { mode = "auto" },
				codeAction = {
					disableRuleComment = { enable = true, location = "separateLine" },
					showDocumentation = { enable = true },
				},
			},
			before_init = function(_, config)
				local root_dir = config.root_dir
				if root_dir then
					config.settings = config.settings or {}
					config.settings.workspaceFolder = {
						uri = root_dir,
						name = vim.fn.fnamemodify(root_dir, ":t"),
					}

					-- detect flat config by basic glob; avoid node_modules
					for _, file in ipairs(eslint_config_files) do
						local founds = vim.fn.globpath(root_dir, file, true, true)
						for _, f in ipairs(founds) do
							if not string.find(f, "[/\\]node_modules[/\\]") then
								config.settings.experimental = config.settings.experimental or {}
								config.settings.experimental.useFlatConfig = true
								break
							end
						end
						if config.settings.experimental and config.settings.experimental.useFlatConfig then
							break
						end
					end

					local pnp_cjs = root_dir .. "/.pnp.cjs"
					local pnp_js = root_dir .. "/.pnp.js"
					if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
						local cmd = config.cmd or {}
						config.cmd = vim.list_extend({ "yarn", "exec" }, cmd)
					end
				end
			end,
			handlers = {
				["eslint/openDoc"] = function(_, result)
					if result then
						vim.ui.open(result.url)
					end
					return {}
				end,
				["eslint/confirmESLintExecution"] = function(_, result)
					if not result then
						return
					end
					return 4 -- approved
				end,
				["eslint/probeFailed"] = function()
					vim.notify("[lsp] ESLint probe failed.", vim.log.levels.WARN)
					return {}
				end,
				["eslint/noLibrary"] = function()
					vim.notify("[lsp] Unable to find ESLint library.", vim.log.levels.WARN)
					return {}
				end,
			},
		})
		vim.lsp.enable("eslint")
	end,
}
