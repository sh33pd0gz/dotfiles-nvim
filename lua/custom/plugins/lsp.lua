return {
	-- Mason Setup
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"lua_ls",
					"jdtls",
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"isort",
					"flake8",
					"stylua",
					"java-debug-adapter",
					"java-test",
					"google-java-format",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dap = require("dap")

			-- keymaps
			vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[d]ebug [t]oggle breakpoint" })
			vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })
			-- vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug [C]lose" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						-- Load luvit types when the `vim.uv` word is found
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- customize Lua LS even further
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[c]ode [h]over documentation" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[c]ode goto [d]efinition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ctions" })
			vim.keymap.set("n", "<leader>cr", builtin.lsp_references, { desc = "[c]ode goto [r]eferences" })
			vim.keymap.set("n", "<leader>ci", builtin.lsp_implementations, { desc = "[c]ode goto [i]mplementations" })
			vim.keymap.set("n", "<space>cD", builtin.lsp_implementations, { desc = "[c]ode goto [D]eclaration" })
			vim.keymap.set("n", "<space>cR", vim.lsp.buf.rename, { desc = "[c]ode [R]ename" })
			-- Explore more keymaps
			-- vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
			-- vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					java = { "google-java-format" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
