vim.g.build_was_success = false
vim.g.pdf_viewer_open = false

local function buf_build(client, bufnr)
    local win = vim.api.nvim_get_current_win()
    local encoding = client.offset_coding
    local params = vim.lsp.util.make_position_params(win, encoding)
    client:request("textDocument/build", params, function(err, result)
        if err then
            error(tostring(err))
        end
        local texlab_build_status = {
            [0] = "Success",
            [1] = "Error",
            [2] = "Failure",
            [3] = "Canceled",
        }
        vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
    end, bufnr)
end

---@type vim.lsp.Config
return {
    cmd = { "texlab" },
    filetypes = { "tex" },
    settings = {
        texlab = {
            build = {
                executable = "tectonic",
                args = {
                    "-X",
                    "compile",
                    "%f",
                    "--synctex",
                    "--keep-logs",
                    "--keep-intermediates",
                    "-Z",
                    "shell-escape",
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        for _, cmd in ipairs({
            { name = "TexlabBuild", fn = buf_build, desc = "Build the current buffer" },
            -- { name = "ViewPdf", fn = view_pdf, desc = "View built file" },
        }) do
            vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. cmd.name, function()
                cmd.fn(client, bufnr)
            end, { desc = cmd.desc })
        end
    end,
}
