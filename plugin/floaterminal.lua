local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	-- Get the screen width and height
	local screen_width = vim.o.columns
	local screen_height = vim.o.lines

	-- Set defaults for width and height if not provided
	opts = opts or {}
	opts.width = opts.width or math.floor(screen_width * 0.8)
	opts.height = opts.height or math.floor(screen_height * 0.8)

	-- Ensure the floating window doesn't exceed the screen size
	opts.width = math.min(opts.width, screen_width)
	opts.height = math.min(opts.height, screen_height)

	-- Calculate the top-left corner to center the window
	local col = math.floor((screen_width - opts.width) / 2)
	local row = math.floor((screen_height - opts.height) / 2)

	-- Set the border and other window options
	local border_opts = opts.border or "single"

	-- Create buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	-- Define window configuration
	local config = {
		relative = "editor", -- Relative to the entire editor window
		width = opts.width,
		height = opts.height,
		col = col,
		row = row,
		style = "minimal", -- No status line
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
		vim.cmd("startinsert")
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

-- Keymaps and User-commands
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal, { desc = "Toggle floating terminal" })
