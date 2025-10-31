vim.keymap.set("n", "<leader>pv", function()
	vim.cmd("silent! Explore")
	vim.cmd("set bufhidden=wipe")
end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", '"_dp')

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- jumping through buffers
vim.keymap.set("n", "<leader>bp", ":bn<cr>")
vim.keymap.set("n", "<leader>bn", ":bp<cr>")

-- Markdown Preview remap
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>")

-- Commentary remap
vim.keymap.set("n", "<leader>/", "<Plug>CommentaryLine", { silent = true }) -- ⌘ + / in normal mode
vim.keymap.set("v", "<leader>/", "<Plug>Commentary", { silent = true }) -- ⌘ + / in visual mode

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
