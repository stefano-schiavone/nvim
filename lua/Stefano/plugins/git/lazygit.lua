return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",                 -- Command to open LazyGit
    "LazyGitConfig",           -- Command to open LazyGit config
    "LazyGitCurrentFile",      -- Command to open LazyGit for the current file
    "LazyGitFilter",           -- Command to open LazyGit with filters
    "LazyGitFilterCurrentFile",-- Command to filter LazyGit by the current file
  },
  dependencies = {
    "nvim-lua/plenary.nvim",   -- Required by LazyGit
  },
  -- No need to specify keybindings here since they're managed in snacks.lua
}
