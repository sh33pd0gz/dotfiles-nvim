-- ┌──────────────────┐
-- │  Markdown Setup  │
-- └──────────────────┘
--
-- Add Markdown specific plugins
Config.now(function()
  local gh = "https://github.com/"
  vim.pack.add({ gh .. "MeanderingProgrammer/render-markdown.nvim" }, { gh .. "terrastruct/d2-vim" })
  require('render-markdown').setup()
end)

vim.cmd('setlocal spell wrap')
vim.cmd('setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()')

-- Disable built-in `gO` mapping in favor of 'mini.basics'
-- vim.keymap.del('n', 'gO', { buffer = 0 })

-- Set markdown-specific surrounding in 'mini.surround'
vim.b.minisurround_config = {
  custom_surroundings = {
    -- Markdown link. Common usage:
    -- `saiwL` + [type/paste link] + <CR> - add link
    -- `sdL` - delete link
    -- `srLL` + [type/paste link] + <CR> - replace link
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
        local link = require('mini.surround').user_input('Link: ')
        return { left = '[', right = '](' .. link .. ')' }
      end,
    },
  },
}


