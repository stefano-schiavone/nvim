return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"mattn/emmet-vim",
	},

	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		pcall(function()
			local blink_cmp = require("blink.cmp")
			if blink_cmp and type(blink_cmp.get_lsp_capabilities) == "function" then
				capabilities = blink_cmp.get_lsp_capabilities()
			end
		end)

		-- small helper: find project root by markers (returns path or cwd)
		local function find_root(bufnr, markers)
			bufnr = bufnr or 0
			markers = markers or { ".git" }
			local name = vim.api.nvim_buf_get_name(bufnr)
			local start_dir = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
			for _, m in ipairs(markers) do
				local found = vim.fs.find(m, { path = start_dir, upward = true, type = "file" })[1]
				if found then
					return vim.fs.dirname(found)
				end
			end
			return vim.fn.getcwd()
		end

		-- base diagnostics config
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
		})

		-- ANTLR4 SETUP
		vim.filetype.add({ extension = { g4 = "antlr4" } })

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.g4",
			callback = function()
				local file = vim.fn.expand("%:p")
				local output = vim.fn.system("antlr " .. file .. " 2>&1")
				if output ~= "" then
					print(output)
				else
					print("ANTLR4: No errors")
				end
			end,
		})
		-- load every module in lua/Stefano/lsp/*.lua as Stefano.lsp.<name>
		local lsp_mod_dir = vim.fn.stdpath("config") .. "/lua/Stefano/lsp"
		local files = vim.split(vim.fn.glob(lsp_mod_dir .. "/*.lua"), "\n")
		for _, path in ipairs(files) do
			if path ~= "" then
				local name = vim.fn.fnamemodify(path, ":t:r") -- filename without ext
				local modname = "Stefano.lsp." .. name
				local ok, mod = pcall(require, modname)
				if not ok then
					vim.notify(("Failed to require %s: %s"):format(modname, mod), vim.log.levels.ERROR)
				else
					-- module may return a function or a table with setup()
					local success, err = nil, nil
					if type(mod) == "function" then
						success, err = pcall(mod, { capabilities = capabilities, helpers = { find_root = find_root } })
					elseif type(mod) == "table" and type(mod.setup) == "function" then
						success, err =
							pcall(mod.setup, { capabilities = capabilities, helpers = { find_root = find_root } })
					else
						-- ignore modules that don't match expected API
						success = true
					end
					if not success then
						vim.notify(
							("Error running LSP module %s: %s"):format(modname, tostring(err)),
							vim.log.levels.ERROR
						)
					end
				end
			end
		end

		-- shared LspAttach keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "x" }, "<F3>", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
				vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>cd", function()
					local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
					if vim.tbl_isempty(diagnostics) then
						vim.notify("No diagnostics on this line", vim.log.levels.INFO)
						return
					end
					local msg = diagnostics[1].message
					vim.fn.setreg("+", msg)
					vim.notify("Copied diagnostic: " .. msg, vim.log.levels.INFO)
				end, opts)
			end,
		})

		-- Emmet autocommand kept here
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "html", "javascriptreact", "typescriptreact", "cshtml" },
			command = "EmmetInstall",
		})
		vim.g.user_emmet_leader_key = "<C-A>"
		vim.g.user_emmet_settings = {
			html = {
				snippets = {
					["!"] = "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title></title>\n\t</head>\n\t<body>\n\t\t${child} \n\t</body>\n</html>",
				},
			},
		}
	end,
}
