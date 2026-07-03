vim.keymap.set("n", "<leader>pv", function()
	vim.cmd("silent! Explore")
	vim.cmd("set bufhidden=wipe")
end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
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

-- LSP remaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })

-- Quickfix list remap
vim.keymap.set("n", "<C-j>", ":cnext<CR>", { desc = "Go to next Quickfix List item" })
vim.keymap.set("n", "<C-k>", ":cprev<CR>", { desc = "Go to previous Quickfix List item" })
-- Toggle quickfix list safely
function ToggleQuickfix()
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end

-- Use leader+q to toggle quickfix
vim.keymap.set("n", "<leader>q", ToggleQuickfix, { desc = "Toggle Quickfix List" })
