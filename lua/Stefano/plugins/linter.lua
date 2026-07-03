return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Configure built-in luacheck to ignore global 'vim'
		lint.linters.luacheck.args = {
			"--globals",
			"vim",
			"--codes",
			"--no-color", -- No color in output
			"--quiet", -- Suppress summary
			"--formatter",
			"plain", -- Ensure plain output
			"-", -- Read from stdin
		}

		-- Configure linters for different filetypes
		vim.list_extend(lint.linters.pylint.args, { "--disable=C,R" })

		lint.linters_by_ft = {
			python = { "pylint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			lua = { "luacheck" },
			csharp = { "csharpier" },
		}

		-- Create an augroup for auto-linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Automatically run linting on these events
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Keybinding for manual linting
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
