return {
   "windwp/nvim-autopairs", -- Plugin name
   config = function()
      -- Setup nvim-autopairs
      local npairs = require("nvim-autopairs")

      npairs.setup({
         check_ts = true, -- Enable Tree-sitter support
      })

      -- Add custom rules for auto-pairing
      local Rule = require("nvim-autopairs.rule")

      npairs.add_rules({
         -- HTML/C# tags: auto-complete `<` with `>`
         Rule("<", ">", "html, cshtml"):with_pair(function(opts)
            local ts_conds = require("nvim-autopairs.ts-conds")
            return ts_conds.is_ts_node({ "tag_name", "start_tag", "end_tag" })(opts)
         end),

         -- JavaScript/TypeScript/Vue/Svelte tags: auto-complete `<` with `>`
         Rule("<", ">", { "javascript", "typescript", "vue", "svelte" }),
      })
   end,
}
