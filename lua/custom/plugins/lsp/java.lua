return {
	"mfussenegger/nvim-jdtls",
	config = function()
		local java_lsp = require("jdtls")
		local root_dir = vim.fs.find({ "gradlew", ".git" }, { upward = true })[1]
		java_lsp.cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") }
		java_lsp.root_dir = vim.fs.dirname(root_dir)
	end,
}
