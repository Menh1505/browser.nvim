local M = {}

-- Cấu hình phím tắt cho plugin
M.set_keymaps = function()
  -- Phím tắt cho tìm kiếm Google
  vim.api.nvim_set_keymap("n", "<leader>gg", ":Google <C-R><C-W><CR>", { noremap = true, silent = true })

  -- Phím tắt cho tìm kiếm Github
  vim.api.nvim_set_keymap("n", "<leader>gh", ":Github <C-R><C-W><CR>", { noremap = true, silent = true })
end

return M
