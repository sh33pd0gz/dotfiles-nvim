local snippets = require("mini.snippets")

snippets.setup({
    snippets = {
        snippets.gen_loader.from_lang({
            lang_patterns = {
                markdown_inline = { "markdown.json" },
                latex = { "latex.json" },
            },
        }),
    },
})

snippets.start_lsp_server({ match = false })
