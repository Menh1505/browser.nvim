local M = require("search_plugin")

-- Call configure from user
M.setup({
	search_engines = {
		stackoverflow = "https://stackoverflow.com/search?q=",
		-- Add other search engine here
	},
	keymaps = {
		youtube = { "<leader>yo", ":Youtube <C-R><C-W><CR>", "Search on YouTube" },
		-- Find other keymap here
	},
})

-- Create command to search
vim.api.nvim_create_user_command("Google", function(opts)
	local query = opts.args
	M.search_on_website("google", query)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Github", function(opts)
	local query = opts.args
	M.search_on_website("github", query)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Youtube", function(opts)
	local query = opts.args
	M.search_on_website("youtube", query)
end, { nargs = "*" })

return M
