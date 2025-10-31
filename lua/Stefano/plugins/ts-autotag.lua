return {
   {
      "windwp/nvim-ts-autotag",
      dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure Treesitter is installed
      config = function()
         require("nvim-ts-autotag").setup()
      end,
   },
}
