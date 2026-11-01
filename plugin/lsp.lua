vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
})

-- configure autocomplete
local on_attach = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

    -- LSP Logging
    vim.api.nvim_create_user_command("LspLogs", function()
        vim.cmd("split | e " .. vim.fn.stdpath("log") .. "/lsp.log | normal G")
    end, {})
    vim.api.nvim_create_user_command("LspCleanLogs", function()
        vim.fn.system("cat /dev/null > " .. vim.lsp.log.get_filename())
    end, {})
end

vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

-- enable LSP's
vim.lsp.enable({ "lemminx", "lua_ls", "ty", "jdtls", "texlab", "terraformls", "gopls", "bashls" })
