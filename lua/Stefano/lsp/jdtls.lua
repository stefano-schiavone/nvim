return {
	name = "jdtls",
	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()
		local find_root = opts and opts.helpers and opts.helpers.find_root

		-- Use vim.fn.filereadable to avoid static-analysis warnings about luv/vim.loop
		-- (some Lua language servers warn about undefined fields like fs_stat).
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
				table.insert(config_cmd, "-javaagent:" .. lombok_path)

				-- Silence static analyzer warning about unknown fields if needed:
				---@diagnostic disable-next-line: undefined-field
				return vim.lsp.rpc.start(config_cmd, dispatchers, {
					cwd = config.cmd_cwd,
					env = config.cmd_env,
					detached = config.detached,
				})
			end,
			filetypes = { "java" },
			root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2 }
				or vim.list_extend(root_markers1, root_markers2),
			init_options = {},
			-- We'll set settings in on_new_config so we can look for a project-local file
			capabilities = caps,
			on_new_config = function(new_config, root_dir)
				-- Called by lspconfig when building a new server config for a workspace root.
				-- Prefer a project-local formatter, else fallback to global one if present.
				local fmt_path = nil
				if find_root and root_dir then
					fmt_path = find_formatter_for_root(root_dir)
				end
				if not fmt_path and file_exists(global_fmt) then
					fmt_path = global_fmt
				end

				if fmt_path and file_exists(fmt_path) then
					-- jdtls expects a file:// URI
					local fmt_uri = "file://" .. fmt_path
					new_config.settings = new_config.settings or {}
					new_config.settings.java = new_config.settings.java or {}
					new_config.settings.java.format = new_config.settings.java.format or {}
					new_config.settings.java.format.settings = {
						url = fmt_uri,
						profile = "My3SpaceProfile",
					}
					vim.notify(
						("jdtls: using Eclipse formatter %s for root %s"):format(fmt_path, root_dir or "<unknown>"),
						vim.log.levels.INFO
					)
				else
					vim.notify(
						("jdtls: no eclipse formatter found for root %s; not setting java.format.settings.url"):format(
							root_dir or "<unknown>"
						),
						vim.log.levels.WARN
					)
				end
			end,
			on_attach = function(client, bufnr)
				-- buffer-local format command that explicitly asks LSP to format
				vim.api.nvim_buf_create_user_command(bufnr, "LspJavaFormat", function()
					vim.lsp.buf.format({ async = false, bufnr = bufnr })
				end, { desc = "Format Java buffer with jdtls (Eclipse formatter if configured)" })

				-- Also expose a small debug command to show what settings jdtls received
				vim.api.nvim_buf_create_user_command(bufnr, "LspJavaShowSettings", function()
					local cfg = client.config and client.config.settings or {}
					vim.pretty_print(cfg)
				end, { desc = "Show jdtls settings" })
			end,
		})
		vim.lsp.enable("jdtls")
	end,
}
