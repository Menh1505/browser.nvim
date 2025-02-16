local M = {}

-- Default config for search engines
M.search_engines = {
	google = "https://www.google.com/search?q=",
	github = "https://github.com/search?q=",
	youtube = "https://www.youtube.com/results?search_query=",
}

-- Default config for keymaps
M.keymaps = {
	google = { "<leader>gg", ":Google <C-R><C-W><CR>" },
	github = { "<leader>gh", ":Github <C-R><C-W><CR>" },
	youtube = { "<leader>yt", ":Youtube <C-R><C-W><CR>" },
}

-- Config function to allow user custom
M.setup = function(config)
	-- Combine user config and default
	if config.search_engines then
		M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
	end

	if config.keymaps then
		M.keymaps = vim.tbl_deep_extend("force", M.keymaps, config.keymaps)
	end

	-- Update keymaps of plugin
	for _, keymap in pairs(M.keymaps) do
		vim.api.nvim_set_keymap("n", keymap[1], keymap[2], { noremap = true, silent = true, desc = keymap[3] })
	end
end

return M
