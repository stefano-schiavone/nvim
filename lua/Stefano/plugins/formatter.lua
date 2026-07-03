return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local f = require("conform.formatters")

		-- helper: return a configured formatter (handles multiple shapes)
		local function make(name, opts)
			local fmt = f[name]
			if not fmt then
				-- formatter not found in conform.formatters; fall back to string name
				vim.notify(
					("conform: formatter '%s' not found, using string fallback"):format(name),
					vim.log.levels.WARN
				)
				return name
			end

			-- If the formatter exposes .with(), use it
			if type(fmt) == "table" and type(fmt.with) == "function" then
				return fmt.with(opts or {})
			end

			-- If the formatter is a function, try calling it with opts (some formatters accept options this way)
			if type(fmt) == "function" then
				if opts and next(opts or {}) then
					local ok, res = pcall(fmt, opts)
					if ok and res then
						return res
					end
					-- if calling with opts failed, fall back to returning the function itself
					vim.notify(
						("conform: formatter '%s' did not accept options; using base formatter"):format(name),
						vim.log.levels.DEBUG
					)
				end
				return fmt
			end

			-- Fallback: return the string name
			return name
		end

		conform.setup({
			formatters_by_ft = {
				javascript = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				typescript = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				javascriptreact = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				typescriptreact = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				html = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				css = { make("prettier", { extra_args = { "--tab-width", "3" } }) },
				json = { make("prettier", { extra_args = { "--tab-width", "3" } }) },

				lua = { make("stylua", { extra_args = { "--indent-width", "3" } }) },

				python = { make("isort"), make("black") }, -- black enforces 4-space indent; not configurable

				-- clang-format: try to configure if possible, but we recommend using .clang-format
				c = {
					make(
						"clang_format",
						{ extra_args = { "--style", "{IndentWidth: 3, TabWidth: 3, UseTab: Never}" } }
					),
				},
				cpp = {
					make(
						"clang_format",
						{ extra_args = { "--style", "{IndentWidth: 3, TabWidth: 3, UseTab: Never}" } }
					),
				},
				arduino = {
					make(
						"clang_format",
						{ extra_args = { "--style", "{IndentWidth: 3, TabWidth: 3, UseTab: Never}" } }
					),
				},

				sh = { make("shfmt", { extra_args = { "-i", "3" } }) },

				cs = { make("csharpier") },
				-- For Java I'm using the lsp_fallback option. Find it in /Stefano/formatters/
				-- java = { make("google-java-format") },
				elm = { "elm_format" },
			},

			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>fd", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
