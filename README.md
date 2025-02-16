# Browser.vim

A [Neovim](https://neovim.io/) plugin to browse quickly on Google and Github in the editor

## Features

- You can search current keyword without copy then open browser and paste to the search-bar
- Search with [Github](https://github.com/)
- Search with [Google](google.com)

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

- Add more engine & keymaps

```lua
local M = require("browser.nvim")

M.setup({
  search_engines = {
    youtube = "https://www.youtube.com/results?search_query=",
    stackoverflow = "https://stackoverflow.com/search?q="
    -- Add more search engine here
  },
  keymaps = {
    youtube = { "<leader>yo", ":Youtube <C-R><C-W><CR>", "Search on YouTube" },
    -- Add more keymaps here
  }
})

return M
```

- Using lazy.nvim

```lua
{
  "Menh1505/browser.nvim",
  config = function()
    require("search_plugin").setup({
      search_engines = {
        youtube = "https://www.youtube.com/results?search_query=",  -- Thêm YouTube
        stackoverflow = "https://stackoverflow.com/search?q="  -- Thêm StackOverflow
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

## Use

- Search with Google, use command :Google then type keyword
  - Ex ":Google map" to search 'map' with Google
- Github
  - Ex ":Github lazy" to search 'lazy' in Github
- You can use keymap
  - Ex <leader>gg to search Google quickly
