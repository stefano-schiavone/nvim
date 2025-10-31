return {
   {
      "tpope/vim-fugitive",
      config = function()
         -- Git keybinding
         vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Git status" })
      end,
   },
}
