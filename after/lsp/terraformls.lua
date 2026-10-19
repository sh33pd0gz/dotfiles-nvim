---@type vim.lsp.Config
return {
    cmd = { "terraform-ls", "serve" },
    root_markers = { ".terraform", ".git" },
    filetypes = { "terraform", "terraform-vars" },
    init_options = {
        settings = {
            terraform = {
                experimentalFeatures = {
                    validateOnSave = true,
                    prefillRequiredFields = true,
                },
            },
        },
    },
}
