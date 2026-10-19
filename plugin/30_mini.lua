-- ┌────────────────────┐
-- │ MINI configuration │
-- └────────────────────┘

local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Common configuration presets. Example usage:
-- - `<C-s>` in Insert mode - save and go to Normal mode
-- - `go` / `gO` - insert empty line before/after in Normal mode
-- - `gy` / `gp` - copy / paste from system clipboard
-- - `\` + key - toggle common options. Like `\h` toggles highlighting search.
-- - `<C-hjkl>` (four combos) - navigate between windows.
-- - `<M-hjkl>` in Insert/Command mode - navigate in that mode.
--
-- See also:
-- - `:h MiniBasics.config.options` - list of adjusted options
-- - `:h MiniBasics.config.mappings` - list of created mappings
-- - `:h MiniBasics.config.autocommands` - list of created autocommands
now(function()
    require("mini.basics").setup({
        -- Manage options in 'plugin/10_options.lua' for didactic purposes
        options = { basic = false },
        mappings = {
            -- Create `<C-hjkl>` mappings for window navigation
            windows = true,
            -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
            move_with_alt = true,
        },
    })
end)

-- Session management. A thin wrapper around `:h mksession` that consistently
-- manages session files. Example usage:
-- - `<Leader>sn` - start new session
-- - `<Leader>sr` - read previously started session
-- - `<Leader>sd` - delete previously started session
now(function()
    require("mini.sessions").setup()
end)

-- Miscellaneous small but useful functions. Example usage:
-- - `<Leader>oz` - toggle between "zoomed" and regular view of current buffer
-- - `<Leader>or` - resize window to its "editable width"
-- - `:lua put_text(vim.lsp.get_clients())` - put output of a function below
--   cursor in current buffer. Useful for a detailed exploration.
-- - `:lua put(MiniMisc.stat_summary(MiniMisc.bench_time(f, 100)))` - run
--   function `f` 100 times and report statistical summary of execution times
now_if_args(function()
    -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
    require("mini.misc").setup()

    -- Change current working directory based on the current file path. It
    -- searches up the file tree until the first root marker ('.git' or 'Makefile')
    -- and sets their parent directory as a current directory.
    -- This is helpful when simultaneously dealing with files from several projects.
    MiniMisc.setup_auto_root()

    -- Restore latest cursor position on file open
    MiniMisc.setup_restore_cursor()

    -- Synchronize terminal emulator background with Neovim's background to remove
    -- possibly different color padding around Neovim instance
    MiniMisc.setup_termbg_sync()
end)

-- Extra 'mini.nvim' functionality.
--
-- See also:
-- - `:h MiniExtra.pickers` - pickers. Most are mapped in `<Leader>f` group.
--   Calling `setup()` makes 'mini.pick' respect 'mini.extra' pickers.
-- - `:h MiniExtra.gen_ai_spec` - 'mini.ai' textobject specifications
-- - `:h MiniExtra.gen_highlighter` - 'mini.hipatterns' highlighters
later(function()
    require("mini.extra").setup()
end)

-- Remove buffers. Opened files occupy space in tabline and buffer picker.
-- When not needed, they can be removed. Example usage:
-- - `<Leader>bw` - completely wipeout current buffer (see `:h :bwipeout`)
-- - `<Leader>bW` - completely wipeout current buffer even if it has changes
-- - `<Leader>bd` - delete current buffer (see `:h :bdelete`)
later(function()
    require("mini.bufremove").setup()
end)

-- Show next key clues in a bottom right window. Requires explicit opt-in for
-- keys that act as clue trigger. Example usage:
-- - Press `<Leader>` and wait for 1 second. A window with information about
--   next available keys should appear.
-- - Press one of the listed keys. Window updates immediately to show information
--   about new next available keys. You can press `<BS>` to go back in key sequence.
-- - Press keys until they resolve into some mapping.
--
-- Note: it is designed to work in buffers for normal files. It doesn't work in
-- special buffers (like for 'mini.starter' or 'mini.files') to not conflict
-- with its local mappings.
--
-- See also:
-- - `:h MiniClue-examples` - examples of common setups
-- - `:h MiniClue.ensure_buf_triggers()` - use it to enable triggers in buffer
-- - `:h MiniClue.set_mapping_desc()` - change mapping description not from config
later(function()
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
end)

-- Command line tweaks. Improves command line editing with:
-- - Autocompletion. Basically an automated `:h cmdline-completion`.
-- - Autocorrection of words as-you-type. Like `:W`->`:w`, `:lau`->`:lua`, etc.
-- - Autopeek command range (like line number at the start) as-you-type.
later(function()
    require("mini.cmdline").setup()
end)

-- Comment lines. Provides functionality to work with commented lines.
-- Uses `:h 'commentstring'` option to infer comment structure.
-- Example usage:
-- - `gcip` - toggle comment (`gc`) *i*inside *p*aragraph
-- - `vapgc` - *v*isually select *a*round *p*aragraph and toggle comment (`gc`)
-- - `gcgc` - uncomment (`gc`, operator) comment block at cursor (`gc`, textobject)
--
-- The built-in `:h commenting` is based on 'mini.comment'. Yet this module is
-- still enabled as it provides more customization opportunities.
later(function()
    require("mini.comment").setup()
end)

-- Autohighlight word under cursor with a customizable delay.
-- Word boundaries are defined based on `:h 'iskeyword'` option.
--
-- It is not enabled by default because its effects are a matter of taste.
-- Uncomment next line (use `gcc`) to enable.
-- later(function() require('mini.cursorword').setup() end)

-- Work with diff hunks that represent the difference between the buffer text and
-- some reference text set by a source. Default source uses text from Git index.
-- Also provides summary info used in developer section of 'mini.statusline'.
-- Example usage:
-- - `ghip` - apply hunks (`gh`) within *i*nside *p*aragraph
-- - `gHG` - reset hunks (`gH`) from cursor until end of buffer (`G`)
-- - `ghgh` - apply (`gh`) hunk at cursor (`gh`)
-- - `gHgh` - reset (`gH`) hunk at cursor (`gh`)
-- - `<Leader>go` - toggle overlay
--
-- See also:
-- - `:h MiniDiff-overview` - overview of how module works
-- - `:h MiniDiff-diff-summary` - available summary information
-- - `:h MiniDiff.gen_source` - available built-in sources
-- later(function()
--     require("mini.diff").setup()
-- end)

-- Git integration for more straightforward Git actions based on Neovim's state.
-- It is not meant as a fully featured Git client, only to provide helpers that
-- integrate better with Neovim. Example usage:
-- - `<Leader>gs` - show information at cursor
-- - `<Leader>gd` - show unstaged changes as a patch in separate tabpage
-- - `<Leader>gL` - show Git log of current file
-- - `:Git help git` - show output of `git help git` inside Neovim
--
-- See also:
-- - `:h MiniGit-examples` - examples of common setups
-- - `:h :Git` - more details about `:Git` user command
-- - `:h MiniGit.show_at_cursor()` - what information at cursor is shown
-- later(function()
--     require("mini.git").setup()
-- end)

-- Jump to next/previous single character. It implements "smarter `fFtT` keys"
-- (see `:h f`) that work across multiple lines, start "jumping mode", and
-- highlight all target matches. Example usage:
-- - `fxff` - move *f*orward onto next character "x", then next, and next again
-- - `dt)` - *d*elete *t*ill next closing parenthesis (`)`)
later(function()
    require("mini.jump").setup()
end)

-- Jump within visible lines to pre-defined spots via iterative label filtering.
-- Spots are computed by a configurable spotter function. Example usage:
-- - Lock eyes on desired location to jump
-- - `<CR>` - start jumping; this shows character labels over target spots
-- - Type character that appears over desired location; number of target spots
--   should be reduced
-- - Keep typing labels until target spot is unique to perform the jump
--
-- See also:
-- - `:h MiniJump2d.gen_spotter` - list of available spotters
later(function()
    require("mini.jump2d").setup()
end)

-- Special key mappings. Provides helpers to map:
-- - Multi-step actions. Apply action 1 if condition is met; else apply
--   action 2 if condition is met; etc.
-- - Combos. Sequence of keys where each acts immediately plus execute extra
--   action if all are typed fast enough. Useful for Insert mode mappings to not
--   introduce delay when typing mapping keys without intention to execute action.
--
-- See also:
-- - `:h MiniKeymap-examples` - examples of common setups
-- - `:h MiniKeymap.map_multistep()` - map multi-step action
-- - `:h MiniKeymap.map_combo()` - map combo
later(function()
    require("mini.keymap").setup()
    -- Navigate 'mini.completion' menu with `<Tab>` /  `<S-Tab>`
    MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
    MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
    -- On `<CR>` try to accept current completion item, fall back to accounting
    -- for pairs from 'mini.pairs'
    MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
    -- On `<BS>` just try to account for pairs from 'mini.pairs'
    MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

-- Window with text overview. It is displayed on the right hand side. Can be used
-- for quick overview and navigation. Hidden by default. Example usage:
-- - `<Leader>mt` - toggle map window
-- - `<Leader>mf` - focus on the map for fast navigation
-- - `<Leader>ms` - change map's side (if it covers something underneath)
--
-- See also:
-- - `:h MiniMap.gen_encode_symbols` - list of symbols to use for text encoding
-- - `:h MiniMap.gen_integration` - list of integrations to show in the map
--
-- NOTE: Might introduce lag on very big buffers (10000+ lines)
later(function()
    local map = require("mini.map")
    map.setup({
        -- Use Braille dots to encode text
        symbols = { encode = map.gen_encode_symbols.dot("4x2") },
        -- Show built-in search matches, 'mini.diff' hunks, and diagnostic entries
        integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diff(),
            map.gen_integration.diagnostic(),
        },
    })

    -- Map built-in navigation characters to force map refresh
    for _, key in ipairs({ "n", "N", "*", "#" }) do
        local rhs = key
            -- Also open enough folds when jumping to the next match
            .. "zv"
            .. "<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>"
        vim.keymap.set("n", key, rhs)
    end
end)

-- Move any selection in any direction. Example usage in Normal mode:
-- - `<M-j>`/`<M-k>` - move current line down / up
-- - `<M-h>`/`<M-l>` - decrease / increase indent of current line
--
-- Example usage in Visual mode:
-- - `<M-h>`/`<M-j>`/`<M-k>`/`<M-l>` - move selection left/down/up/right
later(function()
    require("mini.move").setup()
end)

-- Pick anything with single window layout and fast matching. This is one of
-- the main usability improvements as it powers a lot of "find things quickly"
-- workflows. How to use a picker:
-- - Start picker, usually with `:Pick <picker-name>` command. Like `:Pick files`.
--   It shows a single window in the bottom left corner filled with possible items
--   to choose from. Current item has special full line highlighting.
--   At the top there is a current query used to filter+sort items.
-- - Type characters (appear at top) to narrow down items. There is fuzzy matching:
--   characters may not match one-by-one, but they should be in correct order.
-- - Navigate down/up with `<C-n>`/`<C-p>`.
-- - Press `<Tab>` to show item's preview. `<Tab>` again goes back to items.
-- - Press `<S-Tab>` to show picker's info. `<S-Tab>` again goes back to items.
-- - Press `<CR>` to choose an item. The exact action depends on the picker: `files`
--   picker opens a selected file, `help` picker opens help page on selected tag.
--   To close picker without choosing an item, press `<Esc>`.
--
-- Example usage:
-- - `<Leader>ff` - *f*ind *f*iles; for best performance requires `ripgrep`
-- - `<Leader>fg` - *f*ind inside files (a.k.a. "to *g*rep"); requires `ripgrep`
-- - `<Leader>fh` - *f*ind *h*elp tag
-- - `<Leader>fr` - *r*esume latest picker
-- - `:h vim.ui.select()` - implemented with 'mini.pick'
--
-- See also:
-- - `:h MiniPick-overview` - overview of picker functionality
-- - `:h MiniPick-examples` - examples of common setups
-- - `:h MiniPick.builtin` and `:h MiniExtra.pickers` - available pickers;
--   Execute one either with Lua function, `:Pick <picker-name>` command, or
--   one of `<Leader>f` mappings defined in 'plugin/20_keymaps.lua'
later(function()
    require("mini.pick").setup()
end)

-- Track and reuse file system visits. Every file/directory visit is persistently
-- tracked on disk to later reuse: show in special frecency order, etc. It also
-- supports adding labels to visited paths to quickly navigate between them.
-- Example usage:
-- - `<Leader>fv` - find across all visits
-- - `<Leader>vv` / `<Leader>vV` - add/remove special "core" label to current file
-- - `<Leader>vc` / `<Leader>vC` - show files with "core" label; all or added within
--   current working directory
--
-- See also:
-- - `:h MiniVisits-overview` - overview of how module works
-- - `:h MiniVisits-examples` - examples of common setups
later(function()
    require("mini.visits").setup()
end)

-- Not mentioned here, but can be useful:
-- - 'mini.doc' - needed only for plugin developers.
-- - 'mini.fuzzy' - not really needed on a daily basis.
-- - 'mini.test' - needed only for plugin developers.
