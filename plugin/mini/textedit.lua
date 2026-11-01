local gh_mini = "https://github.com/nvim-mini/"

vim.pack.add({
    gh_mini .. "mini.ai",
    gh_mini .. "mini.align",
    gh_mini .. "mini.bracketed",
    gh_mini .. "mini.operators",
    gh_mini .. "mini.pairs",
    gh_mini .. "mini.surround",
    gh_mini .. "mini.trailspace",
})

require("mini.ai").setup({ search_method = "cover" })
require("mini.align").setup()
require("mini.bracketed").setup()
require("mini.pairs").setup({ modes = { command = true } })
require("mini.surround").setup()
require("mini.trailspace").setup()
require("mini.operators").setup()
vim.keymap.set("n", "(", "gxiagxila", { remap = true, desc = "Swap arg left" })
vim.keymap.set("n", ")", "gxiagxina", { remap = true, desc = "Swap arg right" })

-- require("mini.splitjoin").setup()
