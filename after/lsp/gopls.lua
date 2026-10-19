return {
    on_attach = function(client, bufnr)
        -- formatting
    end,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}
