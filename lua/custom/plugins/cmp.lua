return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		priority = 100,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			-- "onsails/lspkind.nvim",
		},
		config = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" }
			vim.opt.shortmess:append("c")

			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")

			-- vim.keymap.set({"i"}, "<C-x>", function() ls.expand() end, {silent = true})
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(-1)
			end, { silent = true })

			local cmp = require("cmp")

			cmp.setup({
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<C-space>"] = cmp.mapping.complete(),
				},
				sources = {
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "lazydev" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "buffer", keyword_length = 4 },
				},
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
			})
		end,
	},
}
