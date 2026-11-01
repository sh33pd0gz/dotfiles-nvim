-- Define config table to be able to pass data between scripts
_G.Config = {}

-- Autocommand/Autogroup
local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
    local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd(event, opts)
end

require("options")
require("keymaps")
