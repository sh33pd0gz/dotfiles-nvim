-- Quick Explorer
vim.keymap.set("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open File Explorer" })
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Source files and execute lua scripts
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR><cmd>echo 'sourced'<CR>", { desc = "Source file" })
vim.keymap.set("n", "<leader>x", ".lua<CR>")
vim.keymap.set("v", "<leader>x", "lua<CR>")

-- Window splitting
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "[w]indow split [v]ertical" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "[w]indow split [h]orizontal" })

-- exit terminal mode with <c-]><c-]> or <esc><esc>
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
