-- Reads FQBN from a .fqbn file in the project root, or falls back to arduino:avr:uno.
-- Create a .fqbn file in your sketch directory with the board string, e.g.:
--   arduino:avr:uno
--   arduino:avr:nano
--   esp32:esp32:esp32

local function get_fqbn()
	local fqbn_file = vim.fn.findfile(".fqbn", ".;")
	if fqbn_file ~= "" then
		local lines = vim.fn.readfile(fqbn_file)
		if lines and lines[1] then
			return vim.trim(lines[1])
		end
	end
	return vim.env.ARDUINO_FQBN or "arduino:avr:uno"
end

-- Reads upload port from a .port file in the project root.
-- Create a .port file with the device path, e.g.: /dev/cu.usbmodem1401
local function get_port()
	local port_file = vim.fn.findfile(".port", ".;")
	if port_file ~= "" then
		local lines = vim.fn.readfile(port_file)
		if lines and lines[1] then
			return vim.trim(lines[1])
		end
	end
	return nil
end

local function sketch_dir()
	local file = vim.api.nvim_buf_get_name(0)
	return file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
end

local function run_in_term(cmd, cwd)
	vim.cmd("botright 15new")
	local buf = vim.api.nvim_get_current_buf()
	vim.fn.termopen(cmd, { cwd = cwd })
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true, desc = "Close Arduino output" })
end

local function setup_commands()
	vim.api.nvim_create_user_command("ArduinoBoardList", function()
		run_in_term("arduino-cli board list", vim.uv.cwd())
	end, { desc = "List connected Arduino boards and ports" })

	vim.api.nvim_create_user_command("ArduinoCompile", function()
		local dir = sketch_dir()
		local fqbn = get_fqbn()
		run_in_term({ "arduino-cli", "compile", "--fqbn", fqbn, dir }, dir)
	end, { desc = "Compile current Arduino sketch" })

	vim.api.nvim_create_user_command("ArduinoUpload", function()
		local dir = sketch_dir()
		local fqbn = get_fqbn()
		local port = get_port()
		if not port then
			vim.notify(
				"No port set. Run :ArduinoBoardList to find your port, then create a .port file:\n  echo '/dev/cu.usbmodem1401' > .port",
				vim.log.levels.WARN
			)
			return
		end
		run_in_term({ "arduino-cli", "upload", "--fqbn", fqbn, "--port", port, dir }, dir)
	end, { desc = "Upload current Arduino sketch" })

	vim.api.nvim_create_user_command("ArduinoCompileUpload", function()
		local dir = sketch_dir()
		local fqbn = get_fqbn()
		local port = get_port()
		if not port then
			vim.notify(
				"No port set. Run :ArduinoBoardList to find your port, then create a .port file:\n  echo '/dev/cu.usbmodem1401' > .port",
				vim.log.levels.WARN
			)
			return
		end
		run_in_term({ "arduino-cli", "compile", "--fqbn", fqbn, "--upload", "--port", port, dir }, dir)
	end, { desc = "Compile and upload current Arduino sketch" })
end

return {
	name = "arduino_language_server",
	enabled = true,

	setup = function(opts)
		local caps = (opts and opts.capabilities) or vim.lsp.protocol.make_client_capabilities()

		vim.filetype.add({ extension = { ino = "arduino" } })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "arduino",
			once = true,
			callback = setup_commands,
		})

		vim.lsp.config("arduino_language_server", {
			cmd = {
				"arduino-language-server",
				"-clangd",
				vim.fn.exepath("clangd"),
				"-cli",
				vim.fn.exepath("arduino-cli"),
				"-cli-config",
				vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
				"-fqbn",
				get_fqbn(),
			},
			filetypes = { "arduino" },
			root_markers = { ".git", ".fqbn" },
			capabilities = caps,
		})

		vim.lsp.enable("arduino_language_server")
	end,
}

-- Outside Neovim:
-- # List connected boards
-- arduino-cli board list
-- or
-- :ArduinoBoardList
--
-- # Compile
-- arduino-cli compile --fqbn arduino:avr:uno .
-- or
-- :ArduinoCompile
--
-- Upload (replace /dev/cu.usbmodem* with your port from board list)
-- arduino-cli upload --fqbn arduino:avr:uno --port /dev/cu.usbmodem1401 .
-- or
-- :ArduinoUpload
