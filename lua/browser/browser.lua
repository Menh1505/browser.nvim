local M = {}

-- Default settings for search engines
M.search_engines = {
	google = "https://www.google.com/search?q=",
	github = "https://github.com/search?q=",
	youtube = "https://www.youtube.com/results?search_query=",
}

-- Default keymaps
M.keymaps = {
	google = { "<leader>szz", ":Google <C-R><C-W>" },
	github = { "<leader>szg", ":Github <C-R><C-W>" },
	youtube = { "<leader>szy", ":Youtube <C-R><C-W>" },
}

-- Open URL in browser function
M.open_url = function(url)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "cmd.exe /c start"
	else
		print("Can not open browser in this system!")
		return
	end
	os.execute(open_cmd .. " " .. url .. " &")
end

-- Search on website with user settings
M.search_on_website = function(website, query)
	local base_url = M.search_engines[website]
	if base_url then
		local search_url = base_url .. query
		M.open_url(search_url)
	else
		print("Website not support!")
	end
end

-- Create dynamic commands for each search engine
M.create_search_commands = function()
	for website, _ in pairs(M.search_engines) do
		vim.api.nvim_create_user_command(website, function(opts)
			M.search_on_website(website, opts.args)
		end, { nargs = "*" })
	end
end

-- User settings via setup()
M.setup = function(config)
	-- Merge user search engine settings
	if config.search_engines then
		M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
	end

	-- Merge user keymaps settings
	if config.keymaps then
		M.keymaps = vim.tbl_deep_extend("force", M.keymaps, config.keymaps)
	end

	-- Create search commands after setting up search engines and keymaps
	M.create_search_commands()

	-- Set keymaps for the commands
	for _, keymap in pairs(M.keymaps) do
		vim.api.nvim_set_keymap("n", keymap[1], keymap[2], { noremap = true, silent = true })
	end
end

return M
