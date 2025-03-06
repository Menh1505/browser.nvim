-- Get the log file
local log_path = vim.fn.stdpath("cache") .. "/browser_nvim.log"
local log_file = io.open(log_path, "a")

-- Function to log messages
local function log_message(level, msg)
	if log_file then
		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		log_file:write(string.format("[%s] [%s] %s\n", timestamp, level, msg))
		log_file:flush()
	end
	vim.notify(msg, vim.log.levels[level])
end

-- log_message("INFO", "Loading browser.browser module")
local M = {}

-- Default settings for search engines
M.search_engines = {
	google = "https://www.google.com/search?q=",
	github = "https://github.com/search?q=",
	youtube = "https://www.youtube.com/results?search_query=",
}

-- Default keymaps
M.keymaps = {
	google = {
		{
			"<M-s>s",
			function()
				vim.cmd("Google " .. vim.fn.expand("<cword>"))
			end,
			"Search word under cursor on Google",
		},
		{
			"<M-s>g",
			function()
				local saved = vim.fn.getreg("v")
				vim.cmd("normal! y")
				local selected = vim.fn.getreg('"')
				vim.fn.setreg("v", saved)
				vim.cmd("Google " .. selected)
			end,
			mode = "v",
			"Search selected text on Google",
		},
	},
	github = {
		{
			"<M-s>G",
			function()
				vim.cmd("Github " .. vim.fn.expand("<cword>"))
			end,
			"Search word under cursor on GitHub",
		},
		{
			"<M-s>G",
			function()
				local saved = vim.fn.getreg("v")
				vim.cmd("normal! y")
				local selected = vim.fn.getreg('"')
				vim.fn.setreg("v", saved)
				vim.cmd("Github " .. selected)
			end,
			mode = "v",
			"Search selected text on GitHub",
		},
	},
	youtube = {
		{
			"<M-s>y",
			function()
				vim.cmd("Youtube " .. vim.fn.expand("<cword>"))
			end,
			"Search word under cursor on YouTube",
		},
		{
			"<M-s>y",
			function()
				local saved = vim.fn.getreg("v")
				vim.cmd("normal! y")
				local selected = vim.fn.getreg('"')
				vim.fn.setreg("v", saved)
				vim.cmd("Youtube " .. selected)
			end,
			mode = "v",
			"Search selected text on YouTube",
		},
	},
}

-- Open URL in browser function
M.open_url = function(url)
	-- log_message("DEBUG", "Attempting to open URL: " .. url)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "cmd.exe /c start"
	else
		log_message("ERROR", "Unsupported system for browser opening")
		return
	end
	-- log_message("DEBUG", "Using command: " .. open_cmd)
	os.execute(open_cmd .. " " .. url .. " &")
end

-- Function to encode URL parameters
local function encode_url_param(str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		str = string.gsub(str, " ", "+")
	end
	return str
end

-- Search on website with user settings
M.search_on_website = function(website, query)
	log_message("INFO", "Searching on " .. website .. " for: " .. query)
	local base_url = M.search_engines[website]
	if base_url then
		local encoded_query = encode_url_param(query)
		local search_url = base_url .. encoded_query
		M.open_url(search_url)
	else
		log_message("ERROR", "Website " .. website .. " not supported!")
	end
end

-- Create dynamic commands for each search engine
M.create_search_commands = function()
	-- log_message("INFO", "Creating search commands")
	for website, _ in pairs(M.search_engines) do
		-- Capitalize first letter of command
		local command = website:gsub("^%l", string.upper)
		-- log_message("DEBUG", "Creating command for: " .. command)
		vim.api.nvim_create_user_command(command, function(opts)
			-- Join all arguments with spaces to support multi-word searches
			local search_term = table.concat(opts.fargs, " ")
			M.search_on_website(website:lower(), search_term)
		end, { nargs = "+" }) -- Changed from * to + to require at least one argument
	end
end

-- User settings via setup()
M.setup = function(config)
	-- log_message("INFO", "Setting up browser.nvim")

	if config then
		-- Merge user search engine settings
		if config.search_engines then
			-- log_message("DEBUG", "Merging custom search engines")
			M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
		end

		-- Merge user keymaps settings
		if config.keymaps then
			-- log_message("DEBUG", "Merging custom keymaps")
			M.keymaps = vim.tbl_deep_extend("force", M.keymaps, config.keymaps)
		end
	end

	-- Create search commands after setting up search engines and keymaps
	M.create_search_commands()

	-- Set keymaps for the commands
	-- log_message("DEBUG", "Setting up keymaps")
	for website, keymaps in pairs(M.keymaps) do
		for _, keymap in ipairs(keymaps) do
			local mode = keymap.mode or "n" -- Default to normal mode if not specified
			local opts = {
				noremap = true,
				silent = true,
				desc = keymap[3],
			}
			vim.keymap.set(mode, keymap[1], keymap[2], opts)
		end
	end

	log_message("INFO", "browser.nvim setup completed")
end

return M
