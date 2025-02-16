# Browser.vim

A [Neovim](https://neovim.io/) plugin to browse quickly on Google and Github in the editor

## Features

- You can search current keyword without copy then open browser and paste to the search-bar
- Search with [Github](https://github.com/)
  :Github <query>
- Search with [Google](google.com)
  :Google <query>

## Installation

- Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Menh1505/browser.nvim",
  config = function()
    require("browser.nvim")
  end
}
```

- Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'Menh1505/browser.nvim',
  config = function()
    require("browser.nvim")
  end
}
```

## Configuration

```lua
{
  "Menh1505/browser.nvim",
  config = function()
    require("browser.nvim").setup({
      search_engines = {
        youtube = "https://www.youtube.com/results?search_query=",  -- Add youtube
      },
      keymaps = {
        youtube = { "<leader>yt", ":Youtube <C-R><C-W><CR>", "Search YouTube" }, -- Add keymap for youtube
      }
    })
  end,
  keys = {
    { "<leader>gg", ":Google <C-R><C-W><CR>", desc = "Search on Google" },
    { "<leader>gh", ":Github <C-R><C-W><CR>", desc = "Search on GitHub" },
    { "<leader>yt", ":Youtube <C-R><C-W><CR>", desc = "Search on YouTube" },
  }
}
```

### Call setup

- Add more engine

```lua
local M = require("browser.nvim")

M.setup({
  search_engines = {
    youtube = "https://www.youtube.com/results?search_query=",
    stackoverflow = "https://stackoverflow.com/search?q="
    -- Add more search engine here
  },
})

return M
```

- Add keymap

```lua
local M = require("browser.nvim")

M.setup({
  keymaps = {
    youtube = { "<leader>yo", ":Youtube <C-R><C-W><CR>", "Search on YouTube" },
    -- Add more keymaps here
  }
})

return M
```
