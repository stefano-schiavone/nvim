return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" }, -- Ensure it only loads for markdown files
		build = function()
			if vim.bo.filetype == "markdown" then
				vim.fn["mkdp#util#install"]()
			end
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},
}
