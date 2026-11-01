local gh_mini = "https://github.com/nvim-mini/"

vim.pack.add({
    gh_mini .. "mini.basics",
    gh_mini .. "mini.misc",
    gh_mini .. "mini.extra",
    gh_mini .. "mini.bufremove",
    gh_mini .. "mini.move",
    gh_mini .. "mini.pick",
    gh_mini .. "mini.cmdline",
    gh_mini .. "mini.comment",
    gh_mini .. "mini.keymap",
    gh_mini .. "mini.clue",
    gh_mini .. "mini.hipatterns",
})

require("mini.basics").setup({
    options = { basic = false }, -- managed in `lua/options.lua`
    mappings = {
        windows = true, -- <C-hjkl> to move windows
    },
})

require("mini.misc").setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

require("mini.extra").setup()
require("mini.bufremove").setup()
require("mini.move").setup()
require("mini.pick").setup()
require("mini.cmdline").setup()
require("mini.comment").setup()
require("mini.keymap").setup()
-- Navigate 'mini.completion' menu with `<Tab>` /  `<S-Tab>`
MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
-- On `<CR>` try to accept current completion item, fall back to accounting
-- for pairs from 'mini.pairs'
MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
-- On `<BS>` just try to account for pairs from 'mini.pairs'
MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })

-- TODO: mini.git
-- TODO: mini.jump & mini.jump2d

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

-- Mini Clue (keymap helper)
local miniclue = require("mini.clue")
miniclue.setup({
    -- Define which clues to show. By default shows only clues for custom mappings
    -- (uses `desc` field from the mapping; takes precedence over custom clue).
    clues = {
        -- This is defined in 'plugin/20_keymaps.lua' with Leader group descriptions
        Config.leader_group_clues,
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.square_brackets(),
        -- This creates a submode for window resize mappings. Try the following:
        -- - Press `<C-w>s` to make a window split.
        -- - Press `<C-w>+` to increase height. Clue window still shows clues as if
        --   `<C-w>` is pressed again. Keep pressing just `+` to increase height.
        --   Try pressing `-` to decrease height.
        -- - Stop submode either by `<Esc>` or by any key that is not in submode.
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
    },
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
        { mode = "n", keys = "\\" }, -- mini.basics
        { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
        { mode = { "n", "x" }, keys = "]" },
        { mode = "i", keys = "<C-x>" }, -- Built-in completion
        { mode = { "n", "x" }, keys = "g" }, -- `g` key
        { mode = { "n", "x" }, keys = "'" }, -- Marks
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' }, -- Registers
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" }, -- Window commands
        { mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
        { mode = { "n", "x" }, keys = "z" }, -- `z` key
    },
})
