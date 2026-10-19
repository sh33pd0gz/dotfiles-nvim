local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

now(function()
    -- Set up to not prefer extension-based icon for some extensions
    local ext3_blocklist = { scm = true, txt = true, yml = true }
    local ext4_blocklist = { json = true, yaml = true }
    require("mini.icons").setup({
        use_file_extension = function(ext, _)
            return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
        end,
    })

    -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support.
    -- Not needed for 'mini.nvim' or MiniMax, but might be useful for others.
    later(MiniIcons.mock_nvim_web_devicons)

    -- Add LSP kind icons. Useful for 'mini.completion'.
    later(MiniIcons.tweak_lsp_kind)
end)

-- Notifications provider. Shows all kinds of notifications in the upper right
-- corner (by default). Example usage:
-- - `:h vim.notify()` - show notification (hides automatically)
-- - `<Leader>en` - show notification history
--
-- See also:
-- - `:h MiniNotify.config` for some of common configuration examples.
now(function()
    require("mini.notify").setup()
end)

-- Statusline. Sets `:h 'statusline'` to show more info in a line below window.
-- Example usage:
-- - Left most section indicates current mode (text + highlighting).
-- - Second from left section shows "developer info": Git, diff, diagnostics, LSP.
-- - Center section shows the name of displayed buffer.
-- - Second to right section shows more buffer info.
-- - Right most section shows current cursor coordinates and search results.
--
-- See also:
-- - `:h MiniStatusline-example-content` - example of default content. Use it to
--   configure a custom statusline by setting `config.content.active` function.
now(function()
    require("mini.statusline").setup()
end)

-- Tabline. Sets `:h 'tabline'` to show all listed buffers in a line at the top.
-- Buffers are ordered as they were created. Navigate with `[b` and `]b`.
now(function()
    require("mini.tabline").setup()
end)

-- Start screen. This is what is shown when you open Neovim like `nvim`.
-- Example usage:
-- - Type prefix keys to limit available candidates
-- - Navigate down/up with `<C-n>` and `<C-p>`
-- - Press `<CR>` to select an entry
--
-- See also:
-- - `:h MiniStarter-example-config` - non-default config examples
-- - `:h MiniStarter-lifecycle` - how to work with Starter buffer
now(function()
    require("mini.starter").setup()
end)

now_if_args(function()
    require("mini.files").setup({ windows = { preview = true } })

    -- Add common bookmarks for every explorer. Example usage inside explorer:
    -- - `'c` to navigate into your config directory
    -- - `g?` to see available bookmarks
    local add_marks = function()
        MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
        local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
        MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
        MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end
    Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")
end)

-- Tweak and save any color scheme. Contains utility functions to work with
-- color spaces and color schemes. Example usage:
-- - `:Colorscheme default` - switch with animation to the default color scheme
--
-- See also:
-- - `:h MiniColors.interactive()` - interactively tweak color scheme
-- - `:h MiniColors-recipes` - common recipes to use during interactive tweaking
-- - `:h MiniColors.convert()` - convert between color spaces
-- - `:h MiniColors-color-spaces` - list of supported color sapces
--
-- It is not enabled by default because it is not really needed on a daily basis.
-- Uncomment next line (use `gcc`) to enable.
-- later(function() require('mini.colors').setup() end)

-- Highlight patterns in text. Like `TODO`/`NOTE` or color hex codes.
-- Example usage:
-- - `:Pick hipatterns` - pick among all highlighted patterns
--
-- See also:
-- - `:h MiniHipatterns-examples` - examples of common setups
later(function()
    local hipatterns = require("mini.hipatterns")
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            -- Highlight a fixed set of common words. Will be highlighted in any place,
            -- not like "only in comments".
            fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
            hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
            todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
            note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

            -- Highlight hex color string (#aabbcc) with that color as a background
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

-- Visualize and work with indent scope. It visualizes indent scope "at cursor"
-- with animated vertical line. Provides relevant motions and textobjects.
-- Example usage:
-- - `cii` - *c*hange *i*nside *i*ndent scope
-- - `Vaiai` - *V*isually select *a*round *i*ndent scope and then again
--   reselect *a*round new *i*indent scope
-- - `[i` / `]i` - navigate to scope's top / bottom
--
-- See also:
-- - `:h MiniIndentscope.gen_animation` - available animation rules
later(function()
    require("mini.indentscope").setup()
end)
