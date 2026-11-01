vim.pack.add({ "https://github.com/nickjvandyke/opencode.nvim" })

-- TODO
-- 1. customize options
-- 2. move keymaps to `20_keymaps.lua` file
-- 3. perhaps make this a autoload plugin (??)
-- 4. docker container to isolate and limit resource usage?

-- Options
---@type opencode.Opts
vim.g.opencode_opts = {}
vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

-- Keymaps
vim.keymap.set({ "n", "x" }, "<localleader>aia", function()
    require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode…" })

vim.keymap.set({ "n", "x" }, "<localleader>ais", function()
    require("opencode").select()
end, { desc = "Select OpenCode…" })

vim.keymap.set({ "n", "x" }, "<localleader>aiO", function()
    return require("opencode").operator("@this ")
end, { desc = "Append range to OpenCode", expr = true })

vim.keymap.set("n", "<localleader>aio", function()
    return require("opencode").operator("@this ") .. "_"
end, { desc = "Append line to OpenCode", expr = true })
