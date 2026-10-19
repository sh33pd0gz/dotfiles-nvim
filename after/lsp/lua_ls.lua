---@type vim.lsp.ClientConfig
return {
    cmd = { "lua-language-server" },
    root_markers = { ".stylua.toml" },
    filetypes = { "lua" },
    on_attach = function(client, buf_id)
        client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            format = {
                enable = false,
            },
            completion = {
                keywordSnippet = "Both",
                callSnippet = "Both",
            },
        },
    },
}
