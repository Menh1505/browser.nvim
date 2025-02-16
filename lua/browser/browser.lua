vim.notify("Loading browser.browser module", vim.log.levels.INFO)
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
	vim.notify("Attempting to open URL: " .. url, vim.log.levels.DEBUG)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "cmd.exe /c start"
	else
		vim.notify("Unsupported system for browser opening", vim.log.levels.ERROR)
		return
	end
	vim.notify("Using command: " .. open_cmd, vim.log.levels.DEBUG)
	os.execute(open_cmd .. " " .. url .. " &")
end

-- Search on website with user settings
M.search_on_website = function(website, query)
	vim.notify("Searching on " .. website .. " for: " .. query, vim.log.levels.INFO)
	local base_url = M.search_engines[website]
	if base_url then
		local search_url = base_url .. query
		M.open_url(search_url)
	else
		vim.notify("Website " .. website .. " not supported!", vim.log.levels.ERROR)
	end
end

-- Create dynamic commands for each search engine
M.create_search_commands = function()
	vim.notify("Creating search commands", vim.log.levels.INFO)
	for website, _ in pairs(M.search_engines) do
		vim.notify("Creating command for: " .. website, vim.log.levels.DEBUG)
		vim.api.nvim_create_user_command(website, function(opts)
			M.search_on_website(website, opts.args)
		end, { nargs = "*" })
	end
end

-- User settings via setup()
M.setup = function(config)
	vim.notify("Setting up browser.nvim", vim.log.levels.INFO)
	
	if config then
		-- Merge user search engine settings
		if config.search_engines then
			vim.notify("Merging custom search engines", vim.log.levels.DEBUG)
			M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
		end

		-- Merge user keymaps settings
		if config.keymaps then
			vim.notify("Merging custom keymaps", vim.log.levels.DEBUG)
			M.keymaps = vim.tbl_deep_extend("force", M.keymaps, config.keymaps)
		end
	end

	-- Create search commands after setting up search engines and keymaps
	M.create_search_commands()

	-- Set keymaps for the commands
	vim.notify("Setting up keymaps", vim.log.levels.DEBUG)
	for website, keymap in pairs(M.keymaps) do
		vim.notify("Setting keymap for " .. website .. ": " .. keymap[1], vim.log.levels.DEBUG)
		vim.api.nvim_set_keymap("n", keymap[1], keymap[2], { noremap = true, silent = true })
	end
	
	vim.notify("browser.nvim setup completed", vim.log.levels.INFO)
end

return M
