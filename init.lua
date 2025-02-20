-- load before lazy (THIS IS A MUST)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- User Nerd Font
vim.g.have_nerd_font = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy
local opts = {
  change_detection = {
    notify = false
  },
  checker = {
    enabled = true,
    notify = false,
  },
}

require("lazy").setup("custom.plugins", opts)
