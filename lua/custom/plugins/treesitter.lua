return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function ()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vim",
                "vimdoc",
                "lua",
                "java",
                "json",
                "markdown",
                "markdown_inline",
                "gitignore"
            },
            hightlight = { enable = true },
        })
    end,
}
