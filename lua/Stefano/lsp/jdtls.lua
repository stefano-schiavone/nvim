return {
	name = "jdtls",
	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		local find_root = opts and opts.helpers and opts.helpers.find_root

		local function file_exists(path)
			if not path or path == "" then
				return false
			end
			return vim.fn.filereadable(path) == 1
		end

		-- Prefer project-local formatter file (named eclipse-formatter.xml or formatter.xml)
		local function find_formatter_for_root(root_dir)
			if not root_dir or root_dir == "" then
				return nil
			end
			local candidates = {
				root_dir .. "/eclipse-formatter.xml",
				root_dir .. "/formatter/eclipse-formatter.xml",
				root_dir .. "/.settings/eclipse-formatter.xml",
				root_dir .. "/.settings/formatter.xml",
				root_dir .. "/formatter.xml",
			}
			for _, p in ipairs(candidates) do
				if file_exists(p) then
					return p
				end
			end
			return nil
		end

		-- path to global fallback formatter (user-level)
		local global_fmt = vim.fn.stdpath("config") .. "/lua/Stefano/formatters/eclipse-formatter.xml"

		local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")
		local function get_jdtls_cache_dir()
			return vim.fn.stdpath("cache") .. "/jdtls"
		end
		local function get_jdtls_workspace_dir()
			return get_jdtls_cache_dir() .. "/workspace"
		end
		local function get_jdtls_jvm_args()
			local env = os.getenv("JDTLS_JVM_ARGS")
			local args = {}
			for a in string.gmatch((env or ""), "%S+") do
				local arg = string.format("--jvm-arg=%s", a)
				table.insert(args, arg)
			end
			return unpack(args)
		end

		local root_markers1 = { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" }
		local root_markers2 = { "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" }

		vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok_path

		-- Wrap the configuration so we can dynamically pick a formatter file per-project
		vim.lsp.config("jdtls", {
			cmd = function(dispatchers, config)
				local workspace_dir = get_jdtls_workspace_dir()
				local data_dir = workspace_dir

				if config.root_dir then
					data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
				end

				local config_cmd = {
					"jdtls",
					"-data",
					data_dir,
					get_jdtls_jvm_args(),
				}

				return vim.lsp.rpc.start(config_cmd, dispatchers, {
					cwd = config.cmd_cwd,
					env = config.cmd_env,
					detached = config.detached,
				})
			end,
			filetypes = { "java" },
			root_markers = { root_markers1, root_markers2 },
			init_options = {},
			capabilities = caps,
			on_attach = function(client, bufnr)
				local root_dir = client.root_dir
				local fmt_path = nil
				if root_dir then
					fmt_path = find_formatter_for_root(root_dir)
				end
				if not fmt_path and file_exists(global_fmt) then
					fmt_path = global_fmt
				end

				if fmt_path then
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
						java = {
							format = { settings = { url = "file://" .. fmt_path, profile = "My3SpaceProfile" } },
						},
					})
					client:notify("workspace/didChangeConfiguration", {})
					vim.notify(
						("jdtls: using Eclipse formatter %s"):format(fmt_path),
						vim.log.levels.INFO
					)
				end

				vim.api.nvim_buf_create_user_command(bufnr, "LspJavaFormat", function()
					vim.lsp.buf.format({ async = false, bufnr = bufnr })
				end, { desc = "Format Java buffer with jdtls (Eclipse formatter if configured)" })

				vim.api.nvim_buf_create_user_command(bufnr, "LspJavaShowSettings", function()
					local cfg = client.config and client.config.settings or {}
					vim.pretty_print(cfg)
				end, { desc = "Show jdtls settings" })
			end,
		})
		vim.lsp.enable("jdtls")
	end,
}
