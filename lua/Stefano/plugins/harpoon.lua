return {
   {
      "theprimeagen/harpoon",
      config = function()
         local mark = require("harpoon.mark")
         local ui = require("harpoon.ui")

         -- Set keybindings for Harpoon
         vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to Harpoon" })
         vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon quick menu" })

         -- Navigation keybindings
         vim.keymap.set("n", "<C-h>", function()
            ui.nav_file(1)
         end, { desc = "Navigate to Harpoon file 1" })
         vim.keymap.set("n", "<C-t>", function()
            ui.nav_file(2)
         end, { desc = "Navigate to Harpoon file 2" })
         vim.keymap.set("n", "<C-n>", function()
            ui.nav_file(3)
         end, { desc = "Navigate to Harpoon file 3" })
         vim.keymap.set("n", "<C-s>", function()
            ui.nav_file(4)
         end, { desc = "Navigate to Harpoon file 4" })
      end,
   },
}
