Config.now(function()
    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            if ev.data.kind == ("install" or "update") then
                local install = loadfile(ev.data.path .. "/lua/jupynvim/backend/install.lua")()
                install.run({ dir = ev.data.path })
            end
        end,
    })
    vim.pack.add({ "https://github.com/sheng-tse/jupynvim" })
    require("jupynvim").setup({
        image_renderer = "kitty",
    })
end)
