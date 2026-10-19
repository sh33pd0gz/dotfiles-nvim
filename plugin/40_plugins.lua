-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now, later = Config.now, Config.later
local gh = function(pkg)
    return "https://github.com/" .. pkg
end

-- load immediately
now(function()
    add({
        gh("romus204/tree-sitter-manager.nvim"),
        gh("neovim/nvim-lspconfig"),
        gh("rafamadriz/friendly-snippets"),
        gh("stevearc/conform.nvim"),
        gh("d2lang/d2-vim"),
    })
end)

-- load eventually
later(function()
    add({
        {
            src = "https://github.com/nickjvandyke/opencode.nvim",
            version = vim.version.range("*"),
        },
    })
end)
