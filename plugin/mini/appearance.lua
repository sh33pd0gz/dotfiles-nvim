local gh_mini = "https://github.com/nvim-mini/"

vim.pack.add({
    gh_mini .. "mini.icons",
    gh_mini .. "mini.notify",
    gh_mini .. "mini.statusline",
    gh_mini .. "mini.tabline",
    gh_mini .. "mini.starter",
    gh_mini .. "mini.files",
})

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require("mini.notify").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.starter").setup()

-- file explorer
require("mini.files").setup({ windows = { preview = true } })
local add_marks = function()
    MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
    local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
    MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
    MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
end
Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")

-- require("mini.indentscope").setup()
