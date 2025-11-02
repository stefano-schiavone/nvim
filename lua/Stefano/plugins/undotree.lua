return {
	{
		"mbbill/undotree",
		config = function()
			-- Set keybinding to toggle UndoTree
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
		end,
	},
}
