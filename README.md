# NeoVim Development Environment

## Plugins

* [telescope](https://github.com/nvim-telescope/telescope.nvim)
* [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [lspconfig](https://github.com/neovim/nvim-lspconfig)
* [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Lua as language for NeoVim

* Lua uses "mechanisms" over "policies"
* designed to be embedded

* functions are first-class i.e. can make them as values
* tables as lists and tables as maps ... table is a 'mechanism' to construct new 'policies' or 'data structures'

```lua
-- table (list)
local t_list = { "hello", 3, function() end }

-- table (map)
local t = {
    literal_key = "some value",
    ["an expression"] = "also works",
    [function() end] = true
}

print("literal_key   : ", t.literal_key)
print("an expression : ", t["an expression"])
print("function() end: ", t[function() end()])
```
