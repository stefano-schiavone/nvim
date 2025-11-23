-- Highlights when copying text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Close unnamed buffers when closing neovim
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		if
			vim.bo.buftype == ""
			and vim.bo.modifiable
			and vim.fn.bufname("") == ""
			and vim.fn.line("$") == 1
			and vim.fn.getline(1) == ""
		then
			vim.cmd("bd!")
		end
	end,
})
