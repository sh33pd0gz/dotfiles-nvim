-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- line numbers (with relative)
vim.opt.number = true
vim.opt.relativenumber = true

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.hlsearch = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Person Preferences
vim.opt.wrap = true
-- vim.opt.linebreak = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true

vim.opt.cursorline = true
vim.opt.conceallevel = 0 -- show concealed characters in markdown
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000 -- 1 second
vim.opt.undofile = true -- persistent undos
vim.opt.updatetime = 100 -- quick autocompletion

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
