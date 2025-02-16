-- Get the log file
local log_path = vim.fn.stdpath('cache') .. '/browser_nvim.log'
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

log_message("INFO", "Loading browser.browser module")
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
	log_message("DEBUG", "Attempting to open URL: " .. url)
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
	log_message("DEBUG", "Using command: " .. open_cmd)
	os.execute(open_cmd .. " " .. url .. " &")
end

-- Search on website with user settings
M.search_on_website = function(website, query)
	log_message("INFO", "Searching on " .. website .. " for: " .. query)
	local base_url = M.search_engines[website]
	if base_url then
		local search_url = base_url .. query
		M.open_url(search_url)
	else
		log_message("ERROR", "Website " .. website .. " not supported!")
	end
end

-- Create dynamic commands for each search engine
M.create_search_commands = function()
	for website, _ in pairs(M.search_engines) do
	  -- Đảm bảo lệnh bắt đầu bằng chữ cái viết hoa
	  local command_name = website:sub(1, 1):upper() .. website:sub(2)
	  vim.api.nvim_create_user_command(command_name, function(opts)
		M.search_on_website(website, opts.args)
	  end, { nargs = "*" })
	end
  end

-- User settings via setup()
M.setup = function(config)
	log_message("INFO", "Setting up browser.nvim")
	
	if config then
		-- Merge user search engine settings
		if config.search_engines then
			log_message("DEBUG", "Merging custom search engines")
			M.search_engines = vim.tbl_deep_extend("force", M.search_engines, config.search_engines)
		end

		-- Merge user keymaps settings
		if config.keymaps then
			log_message("DEBUG", "Merging custom keymaps")
			M.keymaps = vim.tbl_deep_extend("force", M.keymaps, config.keymaps)
		end
	end

	-- Create search commands after setting up search engines and keymaps
	M.create_search_commands()

	-- Set keymaps for the commands
	log_message("DEBUG", "Setting up keymaps")
	for website, keymap in pairs(M.keymaps) do
		log_message("DEBUG", "Setting keymap for " .. website .. ": " .. keymap[1])
		vim.api.nvim_set_keymap("n", keymap[1], keymap[2], { noremap = true, silent = true })
	end
	
	log_message("INFO", "browser.nvim setup completed")
end

return M
