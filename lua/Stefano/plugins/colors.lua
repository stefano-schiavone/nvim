local themes = {
	{ "olivercederborg/poimandres.nvim", as = "poimandres" }, -- Poimandres
	{ "marc0246/citylights.nvim", as = "citylights" }, -- CityLights
	{ "lunarvim/synthwave84.nvim", as = "synthwave84" }, -- Synthwave '84
	{ "bluz71/vim-nightfly-colors", as = "nightfly" }, -- NightFly
	{ "catppuccin/nvim", as = "catppuccin" }, -- Catpuccin
	{ "rockerBOO/boo-colorscheme-nvim", as = "boo" }, -- Halloween
}

local function SetUnifiedBackground()
	local normalNC = vim.api.nvim_get_hl(0, { name = "NormalNC" })
	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
	-- Telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = normalNC.bg, fg = normal.fg }) -- fg is text
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = normalNC.bg, fg = "#b4befe" })

	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { fg = "none", bg = "none" })
	vim.api.nvim_set_hl(0, "Normal", { fg = "none", bg = "none" })

	vim.api.nvim_set_hl(0, "FineCmdlineBorder", { fg = "#b4befe", bg = normalNC.bg }) -- fg is border itself, bg is border bg
	vim.api.nvim_set_hl(0, "FineCmdlineBg", { fg = normal.fg, bg = normalNC.bg }) -- fg is text and bg is bg of textd

	vim.api.nvim_set_hl(0, "Comment", { bg = "none", fg = "#b4befe" }) -- Netrw Header color
	vim.api.nvim_set_hl(0, "@comment", { fg = "#f2cdcd", bg = "none" }) -- Comment color
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#A0A0A0" }) -- Line numbers
	vim.api.nvim_set_hl(0, "Conditional", { bg = "none", fg = "#cba6f7" }) -- if, then, end

	-- Tab configuration
	vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#11111b" }) -- Whole line background
	vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "#11111b", fg = "#A0A0A0" }) -- Other buffers
	vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "#1e1e2e", fg = "#ffffff", bold = true }) -- Selected buffer
	vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#11111b", bg = "#11111b" }) -- Separator between buffers
	vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = "#89b4fa", bg = "none" }) -- Colored line
end

-- Define the color-changing function
local function ColorMyPencils(color)
	color = color or "boo"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Visual", { bg = "#5c5f77" })
	SetUnifiedBackground()

	if color == "citylights" then
		vim.defer_fn(function()
			-- Apply your custom highlights only for CityLights
			-- Uncomment & customize as needed:
			vim.api.nvim_set_hl(0, "Comment", { bg = "none", fg = "#506477", italic = true })
			vim.api.nvim_set_hl(0, "@comment", { fg = "#506477", italic = true })
			vim.api.nvim_set_hl(0, "Visual", { bg = "#506477" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#A0A0A0" })
		end, 0)
	end
end

-- Auto-apply the default theme on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		ColorMyPencils() -- <- default theme here
	end,
})

-- Also auto-reapply highlights on colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		ColorMyPencils(vim.g.colors_name)
	end,
})

vim.api.nvim_create_user_command("UnifiedBackground", function()
	SetUnifiedBackground()
end, {})

-- Export function and plugin specs
return {
	ColorMyPencils = ColorMyPencils,
	unpack(themes),
}
