---@type conform.FormatterConfig
require("conform").setup({
    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
    },
    formatters_by_ft = {
        lua = { "stylua" },
        tex = { "tex-fmt" },
        zsh = { "shfmt" },
        bash = { "shfmt" },
        sh = { "shfmt" },
    },
    formatters = {
        shfmt = { "-i", "2", "-ci", "-sr" },
    },
})
