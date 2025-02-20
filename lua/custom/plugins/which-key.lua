return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		icons = {
			mappings = vim.g.have_nerd_font,
			keys = {},
		},
		-- Document existing key chains
		spec = {
			{ "<leader>s", group = "[S]earch" },
			-- { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
			-- { '<leader>d', group = '[D]ocument' },
			-- { '<leader>r', group = '[R]ename' },
			-- { '<leader>w', group = '[W]orkspace' },
			-- { '<leader>t', group = '[T]oggle' },
			-- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
		},
	},
}
