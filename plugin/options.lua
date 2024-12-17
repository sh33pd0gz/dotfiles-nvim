-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- line numbers (with relative)
vim.opt.number = true
vim.opt.relativenumber = true

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Person Preferences
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.cursorline = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- opt.cursorline = true
--
-- -- turn on termguicolors for tokyonight colorscheme to work
-- -- (have to use iterm2 or any other true color terminal)
-- opt.termguicolors = true
-- opt.background = 'dark' -- colorschemes with both light and dark will be made dark
-- opt.signcolumn = 'yes' -- show sign column so that text does not shift
--
-- -- backspace
-- opt.backspace = 'indent,eol,start' -- allow backspace on indent, end of line insert mode start position
--
--
-- Enable mouse mode, can be useful for resizing splits for example!
-- vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
-- vim.opt.showmode = false

-- Enable break indent
-- vim.opt.breakindent = true

-- Save undo history
-- vim.opt.undofile = true

-- Keep signcolumn on by default
-- vim.opt.signcolumn = 'yes'

-- Decrease update time
-- vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
-- vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10
