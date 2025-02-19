vim.cmd [[
    augroup jdtls_lsp
        autocmd!
        autocmd FileType java lua require("custom.config.nvim-jdtls").setup_jdtls()
    augroup end
]]
