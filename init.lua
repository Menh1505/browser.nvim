local M = {}

-- Hàm mở URL trong trình duyệt
M.open_url = function(url)
  local open_cmd

  if vim.fn.has("mac") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "cmd.exe /c start"
  else
    print("Không thể mở URL trên hệ điều hành này!")
    return
  end

  os.execute(open_cmd .. " " .. url .. " &")
end

-- Hàm tìm kiếm Google
M.google_search = function(query)
  local search_url = "https://www.google.com/search?q=" .. query
  M.open_url(search_url)
end

-- Hàm tìm kiếm Github
M.github_search = function(query)
  local search_url = "https://github.com/search?q=" .. query
  M.open_url(search_url)
end

-- Tạo lệnh :Google
vim.api.nvim_create_user_command("Google", function(opts)
  M.google_search(opts.args)
end, { nargs = "*" })

-- Tạo lệnh :Github
vim.api.nvim_create_user_command("Github", function(opts)
  M.github_search(opts.args)
end, { nargs = "*" })

-- Gọi cấu hình phím tắt
require("search_plugin.config").set_keymaps()

return M
